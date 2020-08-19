local skillconfigUtil = BaseClass("skillconfigUtil", Singleton)
local function __init(self)
	self.map = {}
	local skillconfigTB = require("fb.skillconfigTB")
	local tbbuf = FBUtil:GetInstance():GetFB("skillconfig")
	local tbObj = skillconfigTB.GetRootAsskillconfigTB(tbbuf, 0)
	for i = 1, tbObj:SkillconfigTRSLength() do
		local trObj = tbObj:SkillconfigTRS(i);
		self.map[trObj:_id()] = trObj
	end
end
local function GetByID(self, id)
	return self.map[id]
end
local function GetAll(self)
	return self.map
end
skillconfigUtil.__init = __init
skillconfigUtil.GetByID = GetByID
skillconfigUtil.GetAll = GetAll
return skillconfigUtil
