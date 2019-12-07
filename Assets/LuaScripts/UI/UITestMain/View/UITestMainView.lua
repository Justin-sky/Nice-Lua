--[[
-- added by wsh @ 2018-02-26
-- UITestMain视图层
--]]

local UITestMainView = BaseClass("UITestMainView", UIBaseView)
local base = UIBaseView

-- 各个组件路径
local fighting_btn_path = "ContentRoot/BtnGrid/FightingBtn"
local logout_btn_path = "ContentRoot/BtnGrid/LogoutBtn"

local hp_text_path = "ContentRoot/Top/HP/Text"
local mp_text_path = "ContentRoot/Top/MP/Text"
local money_text_path = "ContentRoot/Top/Money/Text"

local function OnCreate(self)
	base.OnCreate(self)
	-- 初始化各个组件
	self.fighting_btn = self:AddComponent(UIButton, fighting_btn_path)
	self.logout_btn = self:AddComponent(UIButton, logout_btn_path)

	self.hp_text = self:AddComponent(UIText, hp_text_path, self.Binder, "hp_text")
	self.mp_text = self:AddComponent(UIText, mp_text_path, self.Binder, "mp_text")
	self.money_text = self:AddComponent(UIText, money_text_path, self.Binder, "money_text")

	-- 调用父类Bind所有属性
	base.BindAll(self)

	self.fighting_btn:SetOnClick(function()
		self.ctrl:StartFighting()
	end)
	
	self.logout_btn:SetOnClick(function()
		self.ctrl:Logout()
	end)

	-- 初始化 TOP
	local data = {
		hp_text=1800,mp_text=800,money_text=120
	}
	self.viewModelProperty.Value:UpdateData(data)
end

local function OnEnable(self)
	base.OnEnable(self)
end

local function OnDestroy(self)
	base.OnDestroy(self)
end

UITestMainView.OnCreate = OnCreate
UITestMainView.OnEnable = OnEnable
UITestMainView.OnDestroy = OnDestroy

return UITestMainView