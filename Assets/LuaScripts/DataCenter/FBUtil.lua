local FBUtil = BaseClass("FBUtil", Singleton)
local AddressablesManager = CS.Addressable.AddressablesManager.Instance
local  flatbuffers = require("flatbuffers")


local function __init(self)
    self.fbCaches = {}
end

-- 加载所有PB
local function LoadFB(self)
    local loader = AddressablesManager:LoadFBAsync("FB");
    loader.OnFBLoadedHandle = Bind(self, function (self, name, buf)
        local fbBuf = flatbuffers.binaryArray.New(buf)
        self.fbCaches[name] = fbBuf
        Logger.Log("Load fb file:"..name)
    end);
    coroutine.waitforasyncop(loader, null)

    AddressablesManager:ReleaseFB()

    --初始化Map
    require("fb.FBMapManager"):GetInstance()

end

local function GetFB(self, key)
    local fb = self.fbCaches[key];
    assert(fb ~= nil, "FB不存在："..key)
    return fb;
end

FBUtil.__init = __init
FBUtil.LoadFB = LoadFB
FBUtil.GetFB = GetFB
return FBUtil
