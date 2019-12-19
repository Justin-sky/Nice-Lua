--[[
-- added by wsh @ 2017-01-09
-- 网络接收包定义
--]]

local ReceiveMsgDefine = {
	RequestSeq = 0,
	MsgProto = {},
	MsgId = 0,
	
	__init = function(self, request_seq,msg_id, msgProto)
		self.RequestSeq = request_seq
		self.MsgProto = msgProto
		self.MsgId = msg_id
	end,
	
	__tostring = function(self)
		local str = "RequestSeq = "..tostring(self.RequestSeq).."MsgId = "..tostring(self.MsgId)
		return str
	end,
}

return DataClass("ReceiveMsgDefine", ReceiveMsgDefine)