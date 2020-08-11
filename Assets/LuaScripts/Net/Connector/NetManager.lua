
local HallConnector = require "Net.Connector.HallConnector"
local Messenger = require "Framework.Common.Messenger"
local NetManager = BaseClass("NetManager", Singleton)

local function __init(self)
    self.realmConnector = HallConnector.New();
    self.gateConnector = HallConnector.New()
    self.chatConnector = HallConnector.New()

    self.net_message_center = Messenger.New()
end

--连接验证服
local function ConnectRealmServer(self, host_ip, host_port, callback)
    if self.realmConnector then
        self.realmConnector:Connect(host_ip, host_port, callback)
    end
end

--连接游戏服
local function ConnectGateServer(self, host_ip, host_port, callback)
    if self.gateConnector then
        self.gateConnector:Connect(host_ip, host_port,callback)
    end
end

--连接聊天服
local function ConnectChatServer(self, host_ip, host_port,callback)
    if self.chatConnector then
        self.chatConnector:Connect(host_ip, host_port,callback)
    end
end

local function CloseRealmServer(self)
    if self.realmConnector then
        self.realmConnector:Close()
    end
end

local function CloseGateServer(self)
    if self.gateConnector then
        self.gateConnector:Close()
    end
end

local function CloseChatServer(self)
    if self.chatConnector then
        self.chatConnector:Close()
    end
end

local function SendRealmMsg(self, msg_id, msg_obj,callback,show_mask,need_resend)

    if self.realmConnector then
        self.realmConnector:SendMessage(msg_id, msg_obj,callback,need_resend)
    end
end

local function SendGameMsg(self, msg_id, msg_obj, callback,show_mask, need_resend)
    show_mask = show_mask == nil and true or show_mask
    --处理 mask

    if(self.gateConnector) then
        self.gateConnector:SendMessage(msg_id, msg_obj,callback,need_resend)
    end
end

local function SendChatMsg(self, msg_id, msg_obj, callback, show_mask, need_resend)

    if self.chatConnector then
        self.chatConnector:SendMessage(msg_id, msg_obj,callback, need_resend)
    end
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
local function RemoveListener(self, e_type)
    if(self.net_message_center) then
        self.net_message_center:RemoveListenerByType(e_type)
    end
end

local function Update(self)

    if self.realmConnector then
        self.realmConnector:Update()
    end

    if self.gateConnector then
        self.gateConnector:Update()
    end

    if self.chatConnector then
        self.chatConnector:Update()
    end
end


local function Dispose(self)
    if self.realmConnector then
        self.realmConnector:Close()
        self.realmConnector:Dispose()
    end
    self.realmConnector = nil;

    if self.gateConnector then
        self.gateConnector:Close()
        self.gateConnector:Dispose()
    end
    self.gateConnector = nil

    if self.chatConnector then
        self.chatConnector:Close()
        self.chatConnector:Dispose()
    end
    self.chatConnector = nil

    self.net_message_center = nil
end

NetManager.__init = __init
NetManager.ConnectRealmServer = ConnectRealmServer
NetManager.ConnectGateServer = ConnectGateServer
NetManager.ConnectChatServer = ConnectChatServer

NetManager.CloseRealmServer = CloseRealmServer
NetManager.CloseGateServer = CloseGateServer
NetManager.CloseChatServer = CloseChatServer

NetManager.SendRealmMsg = SendRealmMsg
NetManager.SendGameMsg = SendGameMsg
NetManager.SendChatMsg = SendChatMsg

NetManager.Update = Update
NetManager.Dispose = Dispose
NetManager.AddListener = AddListener
NetManager.Broadcast = Broadcast
NetManager.RemoveListener = RemoveListener

return NetManager
