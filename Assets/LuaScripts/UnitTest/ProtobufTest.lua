local pb = require "pb"

function InitPB()
	--初始化pb文件，路径采用绝对路径
	assert(pb.loadfile "Assets/LuaScripts/Net/Protol/login.pb")
end

function Encoder()
	local data = {
		username="666",
		password="777",
	}
	
	-- encode lua table data into binary format in lua string and return
	local bytes = assert(pb.encode("login.req_login", data))
	print(pb.tohex(bytes))
	return bytes;
end

function Decoder(pb_data)
	-- and decode the binary data back into lua table
	local data2 = assert(pb.decode("login.req_login", bytes))
	print(data2.username)
end

local function Run()
	print("------------Test lua_PB------------");

	InitPB();

	local pb_data = Encoder()
	Decoder(pb_data)

end

return {
	Run = Run
}