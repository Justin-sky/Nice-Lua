local heroconfigUtil = BaseClass("heroconfigUtil", Singleton)
local function __init(self)
	self.map = {}
	local heroconfigTB = require("fb.heroconfigTB")
	local tbbuf = FBUtil:GetInstance():GetFB("heroconfig")
	local tbObj = heroconfigTB.GetRootAsheroconfigTB(tbbuf, 0)
	for i = 1, tbObj:HeroconfigTRSLength() do
		local trObj = tbObj:HeroconfigTRS(i);
		self.map[trObj:_id()] = trObj
	end
end
local function GetByID(self, id)
	return self.map[id]
end
local function GetAll(self)
	return self.map
end
heroconfigUtil.__init = __init
heroconfigUtil.GetByID = GetByID
heroconfigUtil.GetAll = GetAll
return heroconfigUtil
