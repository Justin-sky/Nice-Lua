--[[
-- added by wsh @ 2017-01-09
-- 大厅网络连接器
--]]

local HallConnector = BaseClass("HallConnector")
local SendMsgDefine = require "Net.Config.SendMsgDefine"
local NetUtil = require "Net.Util.NetUtil"

local ConnStatus = {
	Init = 0,
	Connecting = 1,
	Closed = 2,
	Done = 3,
}

local function __init(self)
	self.hallSocket = nil
	self.globalSeq = 0
	self.connStatus = ConnStatus.Init
end

local function OnReceivePackage(self, receive_bytes)
	local  receiveMessage = NetUtil.DeserializeMessage(receive_bytes)

	NetManager:GetInstance():Broadcast(tonumber(receiveMessage.MsgId), receiveMessage)
end

local function _on_close(self, socket, code, msg)
	self.connStatus = ConnStatus.Closed

	print("Connect close ===============================================")
	--处理重连

end

local function Connect(self, host_ip, host_port,callback)
	if not self.hallSocket then
		self.hallSocket = CS.Networks.HjTcpNetwork()
		self.hallSocket.ReceivePkgHandle = Bind(self, OnReceivePackage)
	end
	self.hallSocket.OnConnect = callback
	self.hallSocket.OnClosed = Bind(self, _on_close)
	self.hallSocket:SetHostPort(host_ip, host_port)
	self.hallSocket:Connect()
	self.connStatus = ConnStatus.Connecting
	Logger.Log("Connect to "..host_ip..", port : "..host_port)
	return self.hallSocket
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

local function Disconnect(self)
	if self.hallSocket then
		self.hallSocket:Disconnect()
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
HallConnector.SendMessage = SendMessage
HallConnector.Update = Update
HallConnector.Disconnect = Disconnect
HallConnector.Dispose = Dispose

return HallConnector
