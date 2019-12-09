--[[
-- added by wsh @ 2017-12-18
-- UILoading视图层
--]]

local UILoadingView = BaseClass("UILoadingView", UIBaseView)
local base = UIBaseView

-- 各个组件路径
local loading_text_path = "ContentRoot/LoadingDesc"
local loading_slider_path = "ContentRoot/SliderBar"

local function OnCreate(self)
	base.OnCreate(self)

	-- 初始化各个组件
	self.loading_text = self:AddComponent(UIText, loading_text_path, self.Binder, "loading_text")
	self.loading_slider = self:AddComponent(UISlider, loading_slider_path, self.Binder, "loading_slider")

	-- 调用父类Bind所有属性
	base.BindAll(self)

end

local function OnEnable(self)
	base.OnEnable(self)
end

local function Update(self)

end

local function OnDestroy(self)
	self.loading_text = nil
	self.loading_slider = nil
	base.OnDestroy(self)
end

UILoadingView.OnCreate = OnCreate
UILoadingView.OnEnable = OnEnable
UILoadingView.Update = Update
UILoadingView.OnDestroy = OnDestroy

return UILoadingView