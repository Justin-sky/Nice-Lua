local unitconfigUtil = BaseClass("unitconfigUtil", Singleton)
local function __init(self)
	self.map = {}
	local unitconfigTB = require("fb.unitconfigTB")
	local tbbuf = FBUtil:GetInstance():GetFB("unitconfig")
	local tbObj = unitconfigTB.GetRootAsunitconfigTB(tbbuf, 0)
	for i = 1, tbObj:UnitconfigTRSLength() do
		local trObj = tbObj:UnitconfigTRS(i);
		self.map[trObj:_id()] = trObj
	end
end
local function GetByID(self, id)
	return self.map[id]
end
local function GetAll(self)
	return self.map
end
unitconfigUtil.__init = __init
unitconfigUtil.GetByID = GetByID
unitconfigUtil.GetAll = GetAll
return unitconfigUtil
