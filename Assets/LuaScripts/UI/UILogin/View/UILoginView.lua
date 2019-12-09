--[[
-- added by wsh @ 2017-12-01
-- UILogin视图层
-- 注意：
-- 1、成员变量最好预先在__init函数声明，提高代码可读性
-- 2、OnEnable函数每次在窗口打开时调用，直接刷新
-- 3、组件命名参考代码规范
--]]

local UILoginView = BaseClass("UILoginView", UIBaseView)
local base = UIBaseView


-- 各个组件路径
local server_text_path = "ContentRoot/SvrRoot/SvrSelectBtn/SvrText"
local account_input_path = "ContentRoot/AccountRoot/AccountInput"
local password_input_path = "ContentRoot/PasswordRoot/PasswordInput"
local server_select_btn_path = "ContentRoot/SvrRoot/SvrSelectBtn"
local login_btn_path = "ContentRoot/LoginBtn"
local long_press_bg = "BgRoot/Bg"

local app_version_text_path = "ContentRoot/AppVersionText"
local res_version_text_path = "ContentRoot/ResVersionText"

-- 以下为测试用的组件路径
local test_uieffect1_path = "TestEffect1"
local test_uieffect2_path = "TestEffect2"
local test_uieffect2_1_path = "TestEffect2/ef_ui_TaskFinish/ani/ani_font1/p_font1/xingxing_01"
local test_uieffect2_2_path = "TestEffect2/ef_ui_TaskFinish/ani/ani_font2/p_font2/xingxing_02"
local test_uieffect2_3_path = "TestEffect2/ef_ui_TaskFinish/ani/ani_font3/p_font3/xingxing_03"
local test_uieffect2_4_path = "TestEffect2/ef_ui_TaskFinish/ani/ani_font4/p_font4/xingxing_04"
local test_content_canvas_path = "ContentRoot"
local test_bottom_canvas_path = "BottomRoot"
local test_top_canvas_path = "TopRoot"

-- 以下为定时器、更新函数、协程测试用的组件路径
local test_timer_path = "TestTimer"
local test_coroutine_path = "TestCoroutine"


local function OnCreate(self)
	base.OnCreate(self)
	-- 初始化各个组件
	self.app_version_text = self:AddComponent(UIText, app_version_text_path, self.Binder, "app_version_text")
	self.res_version_text = self:AddComponent(UIText, res_version_text_path, self.Binder, "res_version_text")
	self.server_text = self:AddComponent(UIText, server_text_path, self.Binder, "server_text")
	self.account_input = self:AddComponent(UIInput, account_input_path, self.Binder, "account_input")
	self.password_input = self:AddComponent(UIInput, password_input_path, self.Binder, "password_input")
	self.server_select_btn = self:AddComponent(UIButton, server_select_btn_path,self.Binder,"server_select_btn")
	self.login_btn = self:AddComponent(UIButton, login_btn_path, self.Binder, "login_btn_click")

	--长按事件
	self.long_pass_btn=self:AddComponent(UIPointerLongPress, long_press_bg, self.Binder, "long_pass_btn");

	-- 以下为UI特效层级测试代码
	do
		local effect1_config = EffectConfig.UIPetRankYellow
		local effect2_config = EffectConfig.UITaskFinish
		self.test_effect1 = self:AddComponent(UIEffect, test_uieffect1_path, 1, effect1_config)
		self.test_effect2 = self:AddComponent(UIEffect, test_uieffect2_path, 2, effect2_config, function()
			if not IsNull(self.test_effect2.effect.gameObject) then
				self.test_effect2.effect.transform.name = "ef_ui_TaskFinish"
				self:AddComponent(UIEffect, test_uieffect2_1_path, 2)
				self:AddComponent(UIEffect, test_uieffect2_2_path, 4)
				self:AddComponent(UIEffect, test_uieffect2_3_path, 4)
				self:AddComponent(UIEffect, test_uieffect2_4_path, 6)
			end
		end)
		self:AddComponent(UICanvas, test_content_canvas_path, 2)
		self:AddComponent(UICanvas, test_bottom_canvas_path, 1)
		self:AddComponent(UICanvas, test_uieffect2_path, 3)
		self:AddComponent(UICanvas, test_top_canvas_path, 5)
	end

	-- 以下为计时器、更新函数、协程的测试代码
	do
		self.test_timer_text = self:AddComponent(UIText, test_timer_path, self.Binder, "test_timer_text")
		self.test_coroutine_text = self:AddComponent(UIText, test_coroutine_path, self.Binder, "test_coroutine_text")
	end

	-- 调用父类Bind所有属性
	base.BindAll(self)
end



local function OnDestroy(self)
	self.app_version_text = nil
	self.res_version_text = nil
	self.server_text = nil
	self.account_input = nil
	self.password_input = nil
	self.server_select_btn = nil
	self.login_btn = nil

	base.OnDestroy(self)
end

UILoginView.OnCreate = OnCreate
UILoginView.OnDestroy = OnDestroy

return UILoginView