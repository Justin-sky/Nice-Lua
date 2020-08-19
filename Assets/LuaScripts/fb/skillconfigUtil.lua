local skillconfigUtil = BaseClass("skillconfigUtil", Singleton)


local function __init(self)
    self.map = {}

    local skillconfigTB = require("fb.skillconfigTB")

    local tbbuf = FBUtil:GetInstance():GetFB("skillconfig")
    local skilltb = skillconfigTB.GetRootAsskillconfigTB(tbbuf, 0)

    for i = 1, skilltb:SkillconfigTRSLength() do
        local skilltr = skilltb:SkillconfigTRS(i);
        self.map[skilltr:_id()] = skilltr
        --print(skilltr:Name().." : "..skilltr:_id())
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
