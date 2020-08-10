--[[
-- added by wsh @ 2017-01-09
-- 网络接收包定义
--]]

local ReceiveMsgDefine = {
	Seq = 0,
	MsgProto = {},
	MsgId = 0,
	
	__init = function(self, msg_id, msgProto)
		self.MsgProto = msgProto
		self.MsgId = msg_id

		if(msgProto["RpcId"] ~= nil)then
			self.Seq = msgProto["RpcId"]
		else
			self.Seq = -1
		end
	end,
	
	__tostring = function(self)
		local str = "seq = "..tostring(self.Seq).."MsgId = "..tostring(self.MsgId)
		return str
	end,
}

return DataClass("ReceiveMsgDefine", ReceiveMsgDefine)