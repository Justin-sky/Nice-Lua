
--[[
-- 视图层
-- 注意：
-- 1、成员变量最好预先在OnCreate函数声明，提高代码可读性
-- 2、OnEnable函数每次在窗口打开时调用，直接刷新
-- 3、组件命名参考代码规范
--]]

local UITestView = BaseClass("UITestView", UIBaseView)
local base = UIBaseView

--local app_version_text_path = "ContentRoot/AppVersionText"

local function OnCreate(self)
	base.OnCreate(self)
	-- 初始化各个组件
	-- self.app_version_text = self:AddComponent(UIText, app_version_text_path, self.Binder, "app_version_text")
	

end

local function OnEnable(self)
	base.OnEnable(self)
	self:OnRefresh()
end

local function OnRefresh(self)
	-- 各组件刷新
	
end

local function OnAddListener(self)
	base.OnAddListener(self)
	-- UI消息注册
	
end

local function OnRemoveListener(self)
	base.OnRemoveListener(self)
	-- UI消息注销
	
end

local function OnDestroy(self)
	-- 销毁
	--self.app_version_text = nil

	base.OnDestroy(self)
end

UITestView.OnCreate = OnCreate
UITestView.OnEnable = OnEnable
UITestView.OnRefresh = OnRefresh
UITestView.OnAddListener = OnAddListener
UITestView.OnRemoveListener = OnRemoveListener
UITestView.OnDestroy = OnDestroy

return UITestView
