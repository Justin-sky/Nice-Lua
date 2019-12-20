--[[
-- added by wsh @ 2017-01-09
-- 大厅网络连接器
--]]

local HallConnector = BaseClass("HallConnector")
local SendMsgDefine = require "Net.Config.SendMsgDefine"
local NetUtil = require "Net.Util.NetUtil"

local ConnStatus = {
	Init = 0,          --初始化
	Connecting = 1,    --连接中
	Closed = 2,        --连接关闭
	Done = 3,          --连接成功
	Disconnected = 4   --客户端断开连接，跳到登录页面时
}

local function __init(self)
	self.hallSocket = nil
	self.globalSeq = 0
	self.connStatus = ConnStatus.Init
	self.reconnTimes = 0  --重连次数

	--开启心跳包发送器
	self.timer_action = function(self)
		if self.connStatus == ConnStatus.Done then
			print("send heart beat")
			self:SendMessage(MsgIDDefine.COMMON_HEART_BEAT, {uid=1}, false)
		end
	end
	self.timer = TimerManager:GetInstance():GetTimer(15, self.timer_action , self, false)
	-- 启动定时器
	self.timer:Start()
end

local function OnReceivePackage(self, receive_bytes)
	local  receiveMessage = NetUtil.DeserializeMessage(receive_bytes)

	NetManager:GetInstance():Broadcast(tonumber(receiveMessage.MsgId), receiveMessage)
end

local function _on_close(self, socket, code, msg)

	--处理重连
	if code ~= -5 and self.connStatus ~= ConnStatus.Disconnected then
		self.connStatus = ConnStatus.Closed
		self.reconnTimes = self.reconnTimes+1

		if self.reconnTimes >3 then
			UIManager:GetInstance():OpenOneButtonTip("网络错误", "无法连接服务器", "确定", function ()
				-- 重试3次
				SceneManager:GetInstance():SwitchScene(SceneConfig.LoginScene)
			end)
		else
			self.timer_action = function(self)
				self:ReConnect()
			end
			self.timer = TimerManager:GetInstance():GetTimer(self.reconnTimes * 5, self.timer_action , self, true)
			-- 启动定时器
			self.timer:Start()

		end
	end

end

local function Connect(self, host_ip, host_port,callback)
	if not self.hallSocket then
		self.hallSocket = CS.Networks.HjTcpNetwork()
		self.hallSocket.ReceivePkgHandle = Bind(self, OnReceivePackage)
	end
	self.hostIP = host_ip
	self.hostPort = host_port

	self.hallSocket.OnConnect = function(socket, code, msg)
		self.connStatus = ConnStatus.Done
		if(callback ~= nil) then
			callback(socket, code, msg)
		end
	end
	self.hallSocket.OnClosed = Bind(self, _on_close)
	self.hallSocket:SetHostPort(host_ip, host_port)
	self.hallSocket:Connect()
	self.connStatus = ConnStatus.Connecting
	Logger.Log("Connect to "..host_ip..", port : "..host_port)
	return self.hallSocket
end

local function ReConnect(self)
	self:Connect(self.hostIP, self.hostPort, function (socket, code, msg)
		--重连成功
		Logger.Log("Reconnect success  "..host_ip..", port : "..host_port)
		self.connStatus = ConnStatus.Done
		self.reconnTimes = 0
	end)
end

local function SendMessage(self, msg_id, msg_obj, need_resend)
	--处理消息重发
	need_resend = need_resend == nil and true or need_resend
	
	local request_seq = 0
	local send_msg = SendMsgDefine.New(self.globalSeq, msg_id, msg_obj)
	local msg_bytes = NetUtil.SerializeMessage(send_msg)
	Logger.Log(tostring(send_msg))
	self.hallSocket:SendMessage(msg_bytes)
	self.globalSeq = self.globalSeq + 1
end

local function Update(self)
	if self.hallSocket then
		self.hallSocket:UpdateNetwork()
	end
end

--断开网络
local function Close(self)
	self.connStatus = ConnStatus.Disconnected
	self.reconnTimes = 0

	if self.hallSocket then
		self.hallSocket:Close()
	end
end

local function Dispose(self)
	if self.hallSocket then
		self.hallSocket:Dispose()
	end
	self.hallSocket = nil
end

HallConnector.__init = __init
HallConnector.Connect = Connect
HallConnector.ReConnect = ReConnect
HallConnector.SendMessage = SendMessage
HallConnector.Update = Update
HallConnector.Close = Close
HallConnector.Dispose = Dispose

return HallConnector
