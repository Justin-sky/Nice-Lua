--[[
-- added by wsh @ 2017-01-09
-- 网络发送包定义
--]]

local SendMsgDefine = {
    MsgID = 0,
    MsgProto = "",
    Seq = 0,


    __init = function(self, seq, msg_id, msg_proto)
        self.Seq = seq
        self.MsgID = msg_id
        self.MsgProto = msg_proto
	end,
	
	__tostring = function(self)
        local str = "MsgID = "..tostring(self.MsgID)..", Seq = "..tostring(self.Seq).."\n"
        return str
	end,
}

return DataClass("SendMsgDefine", SendMsgDefine)