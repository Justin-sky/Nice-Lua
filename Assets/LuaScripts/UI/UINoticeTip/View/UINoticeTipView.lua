--[[
-- added by wsh @ 2018-01-11
-- UILNoticeTip视图层
--]]

local UINoticeTipView = BaseClass("UINoticeTipView", UIBaseView)
local base = UIBaseView

local function OnCreate(self)
	base.OnCreate(self)

	self.cs_obj = CS.UINoticeTip.Instance
	self.cs_obj.UIGameObject = self.gameObject


end

local function OnEnable(self)
	base.OnEnable(self)

end

local function OnDestroy(self)
	self.cs_obj:DestroySelf()
	base.OnDestroy(self)
end

UINoticeTipView.OnCreate = OnCreate
UINoticeTipView.OnEnable = OnEnable
UINoticeTipView.OnDestroy = OnDestroy

return UINoticeTipView