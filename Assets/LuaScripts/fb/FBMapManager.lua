local FBMapManager = BaseClass("FBMapManager", Singleton) 
local function __init(self)
	require("fb.heroconfigUtil"):GetInstance()
	require("fb.skillconfigUtil"):GetInstance()
	require("fb.unitconfigUtil"):GetInstance()
end
FBMapManager.__init = __init
return FBMapManager
