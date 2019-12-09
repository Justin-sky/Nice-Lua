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
local test_updater_path = "TestUpdater"
local test_coroutine_path = "TestCoroutine"

local function ClickOnLoginBtn(self)
	local name = self.viewModelProperty.Value["account_input"].Value
	local password =self.viewModelProperty.Value["password_input"].Value
	print("user: "..name.." pwd: "..password)

	self.ctrl:LoginServer(name, password)

end

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
	do
		self.press_Img=self:AddComponent(UIPointerLongPress, long_press_bg);
		self.press_Img:SetOnClick(function()
			print("click")
		end);
		self.press_Img:SetOnPress(function()
			print("long Press")
		end);
	end

	-- 设置点击回调
	do
		-- 使用方式一：闭包绑定
		--self.server_select_btn:SetOnClick(function()
		--	self.ctrl:ChooseServer()
		--end)
		-- 使用方式二：私有函数、成员函数绑定
		--self.login_btn:SetOnClick(self, ClickOnLoginBtn)
	end

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
		self.timer_value = 0
		self.update_value = 0
		self.coroutine_value = 0
		self.test_timer_text = self:AddComponent(UIText, test_timer_path)
		self.test_updater_text = self:AddComponent(UIText, test_updater_path)
		self.test_coroutine_text = self:AddComponent(UIText, test_coroutine_path)
		-- 这里一定要对回调函数持有引用，否则随时可能被GC，引起定时器失效
		-- 或者使用成员函数，它的生命周期是和对象绑定在一块的
		self.timer_action = function(self)
			self.timer_value = self.timer_value + 1
			self.test_timer_text:SetText(tostring(self.timer_value))
		end
		self.timer = TimerManager:GetInstance():GetTimer(1, self.timer_action , self)
		-- 启动定时器
		self.timer:Start()
		-- 启动协程
		coroutine.start(function()
			-- 下面的代码仅仅用于测试，别模仿，很容易出现问题：
			-- 1、时间统计有累积误差，其实协程用在UI倒计时展示时一般问题不大，倒计时会稍微比真实时间长，具体影响酌情考虑
			-- 2、这个协程一旦启用无法被回收，当然，可以避免这点，使用一个控制变量，在对象销毁的时候退出死循环即可
			while true do
				coroutine.waitforseconds(0.5)
				self.coroutine_value = self.coroutine_value + 0.5
				self.test_coroutine_text:SetText(tostring(string.format("%.3f", self.coroutine_value)))
			end
		end)
	end



	-- 调用父类Bind所有属性
	base.BindAll(self)
end


local function OnEnable(self)
	base.OnEnable(self)
	self:OnRefresh()
end

-- Update测试
local function Update(self)

	self.update_value = self.update_value + Time.deltaTime
	self.test_updater_text:SetText(tostring(string.format("%.3f", self.update_value)))
end

local function OnRefreshServerInfo(self)
	local data = {
		server_text=self.model.area_name.." "..self.model.server_name,
	}
	self.viewModelProperty.Value:UpdateData(data)
end

local function OnRefresh(self)
	-- 各组件刷新

	local data = {
		app_version_text="app: 2.0",
		res_version_text="res: 87",
		server_text="server",
		account_input="Justin",
		password_input="123456",
	}
	self.viewModelProperty.Value:UpdateData(data)

	OnRefreshServerInfo(self)
end


local function OnAddListener(self)
	base.OnAddListener(self)
	-- UI消息注册
	self:AddUIListener(UIMessageNames.UILOGIN_ON_SELECTED_SVR_CHG, OnRefreshServerInfo)
end

local function OnRemoveListener(self)
	base.OnRemoveListener(self)
	-- UI消息注销
	self:RemoveUIListener(UIMessageNames.UILOGIN_ON_SELECTED_SVR_CHG, OnRefreshServerInfo)
end

local function OnDestroy(self)
	self.app_version_text = nil
	self.res_version_text = nil
	self.server_text = nil
	self.account_input = nil
	self.password_input = nil
	self.server_select_btn = nil
	self.login_btn = nil
	-- 测试代码
	self.timer:Stop()
	base.OnDestroy(self)
end

UILoginView.OnCreate = OnCreate
UILoginView.OnEnable = OnEnable
UILoginView.Update = Update
UILoginView.OnRefresh = OnRefresh
UILoginView.OnAddListener = OnAddListener
UILoginView.OnRemoveListener = OnRemoveListener
UILoginView.OnDestroy = OnDestroy

return UILoginView