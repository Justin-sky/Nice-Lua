--[[
-- added by wsh @ 2017-12-08
-- Lua侧UIInput
-- 使用方式：
-- self.xxx_input = self:AddComponent(UIInput, var_arg)--添加孩子，各种重载方式查看UIBaseContainer
--]]

local UIInput = BaseClass("UIInput", UIBaseComponent)
local base = UIBaseComponent

-- 创建
local function OnCreate(self, binder, property_name)
	base.OnCreate(self)
	-- Unity侧原生组件
	self.unity_uiinput = UIUtil.FindInput(self.transform)
	self.view = binder:GetView()

	if not IsNull(self.unity_uiinput) and IsNull(self.gameObject) then
		self.gameObject = self.unity_uiinput.gameObject
		self.transform = self.unity_uiinput.transform
	end

	--添加双向绑定
	if(binder~=nil and property_name~=nil and not IsNull(self.unity_uiinput)) then
		--ViewModel => Input
		binder:Add(property_name, function (oldValue, newValue)
			if oldValue ~= newValue then
				self:SetText(newValue)
			end
		end)

		-- Input => ViewModel
		self.__onEditEnd = BindCallback(function(value)
			self.view.viewModelProperty.Value[property_name].Value = value
		end)
		self.unity_uiinput.onEndEdit:AddListener(self.__onEditEnd )
	end

end


-- 获取文本
local function GetText(self)
	if not IsNull(self.unity_uiinput) then
		return self.unity_uiinput.text
	end
end

-- 设置文本
local function SetText(self, text)
	if not IsNull(self.unity_uiinput) then
		self.unity_uiinput.text = text
	end
end

-- 销毁
local function OnDestroy(self)
	if self.__onclick ~= nil then
		self.unity_uiinput.onEditEnd:RemoveListener(self.__onEditEnd)
	end

	self.unity_uiinput = nil
	base.OnDestroy(self)
end

UIInput.OnCreate = OnCreate
UIInput.GetText = GetText
UIInput.SetText = SetText
UIInput.OnDestroy = OnDestroy


return UIInput