--[[

--]]

local UIBaseViewModel = BaseClass("UIBaseViewModel")

-- 如非必要，别重写构造函数，使用OnCreate初始化
local function __init(self, ui_name)
    self.__data_callback = {}
    self.__ui_name = ui_name
    self:OnCreate()
end

-- 如非必要，别重写析构函数，使用OnDestroy销毁资源
local function __delete(self)
    self:OnDestroy()
    for k,v in pairs(self.__data_callback) do
        self:RemoveDataListener(k, v)
    end
    self.__data_callback = nil
    self.__ui_name = nil
end

local function AddCallback(keeper, msg_name, callback)
    assert(callback ~= nil)
    keeper[msg_name] = callback
end

local function GetCallback(keeper, msg_name)
    return keeper[msg_name]
end

local function RemoveCallback(keeper, msg_name, callback)
    assert(callback ~= nil)
    keeper[msg_name] = nil
end

-- 注册游戏数据监听事件，别重写
local function AddDataListener(self, msg_name, callback)
    local bindFunc = Bind(self, callback)
    AddCallback(self.__data_callback, msg_name, bindFunc)
    DataManager:GetInstance():AddListener(msg_name, bindFunc)
end

-- 注销游戏数据监听事件，别重写
local function RemoveDataListener(self, msg_name, callback)
    local bindFunc = GetCallback(self.__data_callback, msg_name)
    RemoveCallback(self.__data_callback, msg_name, bindFunc)
    DataManager:GetInstance():RemoveListener(msg_name, bindFunc)
end

-- 创建：变量定义，初始化，消息注册
-- 注意：窗口生命周期内保持的成员变量放这
local function OnCreate(self)
end

-- 打开：刷新数据模型
-- 注意：窗口关闭时可以清理的成员变量放这
local function OnEnable(self, ...)
end

-- 关闭
-- 注意：必须清理OnEnable中声明的变量
local function OnDisable(self)
end

-- 销毁
-- 注意：必须清理OnCreate中声明的变量
local function OnDestroy(self)
end

-- 注册消息
local function OnAddListener(self)
end

-- 注销消息
local function OnRemoveListener(self)
end

-- 激活：给UIManager用，别重写
local function Activate(self, ...)
    self:OnAddListener()
    self:OnEnable(...)
end

-- 反激活：给UIManager用，别重写
local function Deactivate(self)
    self:OnRemoveListener()
    self:OnDisable()
end



UIBaseViewModel.__init = __init
UIBaseViewModel.__delete = __delete
UIBaseViewModel.OnDestroy = OnDestroy
UIBaseViewModel.Activate = Activate
UIBaseViewModel.Deactivate = Deactivate
UIBaseViewModel.OnCreate = OnCreate
UIBaseViewModel.OnEnable = OnEnable
UIBaseViewModel.OnDisable = OnDisable
UIBaseViewModel.OnAddListener = OnAddListener
UIBaseViewModel.OnRemoveListener = OnRemoveListener
UIBaseViewModel.AddDataListener = AddDataListener
UIBaseViewModel.RemoveDataListener = RemoveDataListener


return UIBaseViewModel