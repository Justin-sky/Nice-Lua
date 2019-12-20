
local HallConnector = require "Net.Connector.HallConnector"
local Messenger = require "Framework.Common.Messenger"
local NetManager = BaseClass("NetManager", Singleton)

local function __init(self)
    self.gameConnector = HallConnector.New()
    self.chatConnector = HallConnector.New()

    self.net_message_center = Messenger.New()
end

--连接游戏服
local function ConnectGameServer(self, host_ip, host_port, callback)
    if self.gameConnector then
        self.gameConnector:Connect(host_ip, host_port,callback)
    end
end

--连接聊天服
local function ConnectChatServer(self, host_ip, host_port,callback)
    if self.chatConnector then
        self.chatConnector:Connect(host_ip, host_port,callback)
    end
end

local function SendGameMsg(self, msg_id, msg_obj, show_mask, need_resend)
    show_mask = show_mask == nil and true or show_mask
    --处理 mask

    if(self.gameConnector) then
        self.gameConnector:SendMessage(msg_id, msg_obj,need_resend)
    end
end

local function SendChatMsg(self, msg_id, msg_obj, show_mask, need_resend)

end

-- 注册消息
local function AddListener(self, e_type, e_listener, ...)
    if(self.net_message_center) then
        self.net_message_center:AddListener(e_type, e_listener, ...)
    end
end

-- 发送消息
local function Broadcast(self, e_type, ...)
    if(self.net_message_center) then
        self.net_message_center:Broadcast(e_type, ...)
    end
end

-- 注销消息
local function RemoveListener(self, e_type, e_listener)
    if(self.net_message_center) then
        self.net_message_center:RemoveListener(e_type, e_listener)
    end
end

local function Update(self)
    if self.gameConnector then
        self.gameConnector:Update()
    end

    if self.chatConnector then
        self.chatConnector:Update()
    end
end


local function Dispose(self)
    if self.gameConnector then
        self.gameConnector:Dispose()
    end
    self.gameConnector = nil

    if self.chatConnector then
        self.chatConnector:Dispose()
    end
    self.chatConnector = nil

    self.net_message_center = nil
end

NetManager.__init = __init
NetManager.ConnectGameServer = ConnectGameServer
NetManager.ConnectChatServer = ConnectChatServer
NetManager.SendGameMsg = SendGameMsg
NetManager.SendChatMsg = SendChatMsg
NetManager.Update = Update
NetManager.Dispose = Dispose
NetManager.AddListener = AddListener
NetManager.Broadcast = Broadcast
NetManager.RemoveListener = RemoveListener

return NetManager
