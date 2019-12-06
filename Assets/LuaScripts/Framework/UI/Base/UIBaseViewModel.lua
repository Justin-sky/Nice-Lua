--[[

--]]

local UIBaseViewModel = BaseClass("UIBaseViewModel")

-- 如非必要，别重写构造函数，使用OnCreate初始化
local function __init(self, ui_name)

    self.__ui_name = ui_name
    self:OnCreate()
end

-- 如非必要，别重写析构函数，使用OnDestroy销毁资源
local function __delete(self)
    self:OnDestroy()

    self.__ui_name = nil
end

-- 销毁
-- 注意：必须清理OnCreate中声明的变量
local function OnDestroy(self)
end

-- 创建：变量定义，初始化，消息注册
-- 注意：窗口生命周期内保持的成员变量放这
local function OnCreate(self)
end

--更新数据
local function UpdateData(self, data)
end

UIBaseViewModel.__init = __init
UIBaseViewModel.__delete = __delete
UIBaseViewModel.OnDestroy = OnDestroy
UIBaseViewModel.OnCreate = OnCreate
UIBaseViewModel.UpdateData = UpdateData


return UIBaseViewModel