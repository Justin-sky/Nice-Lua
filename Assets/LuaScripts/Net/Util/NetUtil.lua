--[[
-- added by wsh @ 2017-01-10
-- 网络模块工具类
--]]

local NetUtil = {}
local unpack = unpack or table.unpack
local MsgIDMap = require "Net.Config.MsgIDMap"
local ReceiveMsgDefine = require "Net.Config.ReceiveMsgDefine"

local function XOR(seq, msgid, data, start, length)
	assert(data ~= nil and type(data) == "string")
	assert(seq ~= nil and type(seq) == "number")
	assert(msgid ~= nil and type(msgid) == "number")
	if string.len(data) == 0 then
		return data
	end
	
	start = start or 1
	length = length or string.len(data)
	seq = seq + msgid
	
	local output = ""
	local cur_index = start
	while cur_index < start + length do
		local left_length = start + length - cur_index
		if left_length >= 4 then
			local tmp = string.unpack("=I4", data, cur_index)
			tmp = ((tmp ~ seq) & 0xffffffff)
			output = output..string.pack("=I4", tmp)
			cur_index = cur_index + 4
		elseif left_length >= 2 then
			local tmp = string.unpack("=I2", data, cur_index)
			tmp = ((tmp ~ seq) & 0xffff)
			output = output..string.pack("=I2", tmp)
			cur_index = cur_index + 2
		elseif left_length >= 1 then
			local tmp = string.unpack("=I1", data, cur_index)
			tmp = ((tmp ~ seq) & 0xff)
			output = output..string.pack("=I1", tmp)
			cur_index = cur_index + 1
		end
	end
	
	return output
end
--  i4  Singned int ；   I4  unsigned int   <: sets little endian    >: sets big endian  =: sets native endian
local function SerializeMessage(msg_obj)
	local output = ""
	local send_msg = pb.encode(MsgIDMap[msg_obj.MsgID], msg_obj.MsgProto)
	output = output..string.pack("<i4", msg_obj.Seq);
	output = output..string.pack("<I2", msg_obj.MsgID);
	--output = output..XOR(global_seq, msg_obj.MsgID, send_msg)
	output = output..send_msg
	--output = string.pack(">I4", string.len(output))..output
	print("bytes len: "..string.len(output))
	print("send bytes:", string.byte(output, 1, #output))
	return output
end

local function DeserializeMessage(data, start, length)
	assert(data ~= nil and type(data) == "string")
	start = start or 1
	length = length or string.len(data)
	--print("receive bytes:", string.byte(data, start, length))
	
	local index = start
	local request_seq = string.unpack("<i4", data, index)

	index = index + 4
	local msg_id = string.unpack("<I2", data, index)
    print("seq:"..request_seq)
    print("msgid:"..msg_id)

	local msg_name = MsgIDMap[tonumber(msg_id)]
	if msg_name == nil then
		Logger.LogError("No proto type match msg name : "..msg_name)
		return
	end

	index = index + 4
	local pb_data = string.sub(data, index)
	local msgProto = pb.decode(msg_name, pb_data)

	local receive_msg = ReceiveMsgDefine.New(request_seq, msg_id, msgProto)

	return receive_msg
end

NetUtil.XOR = XOR
NetUtil.SerializeMessage = SerializeMessage
NetUtil.DeserializeMessage = DeserializeMessage

return ConstClass("NetUtil", NetUtil)