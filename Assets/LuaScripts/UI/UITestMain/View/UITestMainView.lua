--[[
-- added by wsh @ 2018-02-26
-- UITestMain视图层
--]]

local UITestMainView = BaseClass("UITestMainView", UIBaseView)
local base = UIBaseView

-- 各个组件路径
local fighting_btn_path = "ContentRoot/BtnGrid/FightingBtn"
local logout_btn_path = "ContentRoot/BtnGrid/LogoutBtn"
local noticetip_btn_path = "ContentRoot/BtnGrid/NoticetipBtn"

local hp_text_path = "ContentRoot/Top/HP/Text"
local mp_text_path = "ContentRoot/Top/MP/Text"
local money_text_path = "ContentRoot/Top/Money/Text"

local hp_image_path = "ContentRoot/Top/HP/Image"
local mp_image_path = "ContentRoot/Top/MP/Image"
local money_image_path = "ContentRoot/Top/Money/Image"

local function OnCreate(self)
	base.OnCreate(self)
	-- 初始化各个组件
	self.fighting_btn = self:AddComponent(UIButton, fighting_btn_path, self.Binder, "fighting_btn")
	self.logout_btn = self:AddComponent(UIButton, logout_btn_path, self.Binder, "logout_btn")
	self.noticetip_btn = self:AddComponent(UIButton, noticetip_btn_path, self.Binder, "noticetip_btn")

	self.hp_text = self:AddComponent(UIText, hp_text_path, self.Binder, "hp_text")
	self.mp_text = self:AddComponent(UIText, mp_text_path, self.Binder, "mp_text")
	self.money_text = self:AddComponent(UIText, money_text_path, self.Binder, "money_text")

	self.hp_image = self:AddComponent(UIImage,hp_image_path, AtlasConfig.Login, self.Binder, "hp_image" )
	self.mp_image = self:AddComponent(UIImage,mp_image_path, AtlasConfig.Login, self.Binder, "mp_image")
	self.money_image = self:AddComponent(UIImage,money_image_path, AtlasConfig.Login, self.Binder,"money_image")

	-- 调用父类Bind所有属性
	base.BindAll(self)


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