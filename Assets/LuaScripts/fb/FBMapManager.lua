local FBMapManager = BaseClass("FBMapManager", Singleton)

local function __init(self)
    require("fb.skillconfigUtil"):GetInstance()

end


FBMapManager.__init = __init
return FBMapManager
