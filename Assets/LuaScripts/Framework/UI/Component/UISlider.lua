--[[
-- added by wsh @ 2017-12-18
-- Lua侧UISlider
-- 使用方式：
-- self.xxx_text = self:AddComponent(UISlider, var_arg)--添加孩子，各种重载方式查看UIBaseContainer
--]]

local UISlider = BaseClass("UISlider", UIBaseComponent)
local base = UIBaseComponent

-- 创建
local function OnCreate(self, binder, property_name,on_value_changed)
	base.OnCreate(self)
	-- Unity侧原生组件
	self.unity_uislider = UIUtil.FindSlider(self.transform)
	
	if not IsNull(self.unity_uislider) and IsNull(self.gameObject) then
		self.gameObject = self.unity_uislider.gameObject
		self.transform = self.unity_uislider.transform
	end

	--添加双向绑定
	if(binder~=nil and property_name~=nil and not IsNull(self.unity_uislider)) then
		--ViewModel => Input
		binder:Add(property_name, function (oldValue, newValue)
			if oldValue ~= newValue then
				self:SetValue(newValue)
			end
		end)

		--绑定事件
		if(on_value_changed ~= nil) then
			binder:RegisterEvent(function(viewModel, property)
				self:SetOnValueChanged(function ()
					local onValueChanged = property['OnValueChanged']
					if onValueChanged == nil then
						return
					end
					onValueChanged()
				end)
			end, function()
				if self.__onValueChanged ~= nil then
					self.unity_uislider.onValueChanged:RemoveListener(self.__onValueChanged)
				end
			end, on_value_changed)
		end
	end
end

-- 设置回调
local function SetOnValueChanged(self, ...)
	self.__onValueChanged = BindCallback(...)
	self.unity_uislider.onValueChanged:AddListener(self.__onValueChanged)
end

-- 获取进度
local function GetValue(self)
	if not IsNull(self.unity_uislider) then
		return self.unity_uislider.normalizedValue
	end
end

-- 设置进度
local function SetValue(self, value)
	if not IsNull(self.unity_uislider) then
		self.unity_uislider.normalizedValue = value
	end
end

-- 销毁
local function OnDestroy(self)
	self.unity_uislider = nil
	base.OnDestroy(self)
end

UISlider.OnCreate = OnCreate
UISlider.GetValue = GetValue
UISlider.SetValue = SetValue
UISlider.OnDestroy = OnDestroy

return UISlider