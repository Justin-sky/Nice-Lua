--[[
-- added by passion @ 2019-111-09
-- Lua侧UIPointerLongPress
-- 注意：
-- 1、按钮一般会带有其他的组件，如带一个UIText、或者一个UIImange标识说明按钮功能，所以这里是一个容器类
-- 2、UIPointerLongPress组件必须挂载在根节点，其下某个子节点有个Unity侧原生Button即可，如果有多个，需要指派相对路径
-- 使用方式：
-- self.xxx_btn = self:AddComponent(UIPointerLongPress, var_arg)--添加孩子，各种重载方式查看UIBaseContainer
--]]

local UIPointerLongPress = BaseClass("UIPointerLongPress", UIBaseContainer)
local base = UIBaseContainer

-- 创建
local function OnCreate(self,binder,property_name, relative_path)
	base.OnCreate(self)
	-- Unity侧原生组件
	self.unity_uibutton = UIUtil.FindComponent(self.transform, typeof(CS.UIPointerLongPress), relative_path)
	-- 记录点击回调
	self.__onclick = nil
	self.__onpress = nil
	
	if IsNull(self.unity_uibutton) and IsNull(self.gameObject) then
		self.gameObject = self.unity_uibutton.gameObject
		self.transform = self.unity_uibutton.transform
	end

	if(binder == nil) then return end
	--绑定事件
	binder:RegisterEvent(function(viewModel, property)

		local onPress = property['OnPress']
		if(onPress ~= nil) then
			self:SetOnPress(function ()
				onPress()
			end)
		end
		local onClick = property['OnClick']
		if(onClick ~= nil) then
			self:SetOnClick(function ()
				onClick()
			end)
		end

	end, function()
		if self.__onPress ~= nil then
			self.unity_uibutton.onLongPress:RemoveListener(self.__onPress)
		end
		if self.__onclick ~= nil then
			self.unity_uibutton.onClick:RemoveListener(self.__onclick)
		end
	end, property_name)

end

-- 点击回调
local function SetOnClick(self, ...)
	self.__onclick = BindCallback(...)
	self.unity_uibutton.onClick:AddListener(self.__onclick)
end
-- 长安回调
local function SetOnPress(self, ...)
	self.__onpress = BindCallback(...)
	self.unity_uibutton.onLongPress:AddListener(self.__onpress)
end

-- 资源释放
local function OnDestroy(self)
	if self.__onclick ~= nil then
		self.unity_uibutton.onClick:RemoveListener(self.__onclick)
	end
	if self.__onpress ~= nil then
		self.unity_uibutton.onLongPress:RemoveListener(self.__onpress)
	end
	self.unity_uibutton = nil
	self.__onclick = nil
	self.__onpress = nil
	base.OnDestroy(self)
end

UIPointerLongPress.OnCreate = OnCreate
UIPointerLongPress.SetOnClick = SetOnClick
UIPointerLongPress.SetOnPress = SetOnPress
UIPointerLongPress.OnDestroy = OnDestroy

return UIPointerLongPress