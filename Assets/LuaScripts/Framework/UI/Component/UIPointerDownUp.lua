--[[
-- added by passion @ 2019-111-09
-- Lua侧UIPointerDownUp
-- 注意：
-- 1、按钮一般会带有其他的组件，如带一个UIText、或者一个UIImange标识说明按钮功能，所以这里是一个容器类
-- 2、UIPointerDownUp组件必须挂载在根节点，其下某个子节点有个Unity侧原生Button即可，如果有多个，需要指派相对路径
-- 使用方式：
-- self.xxx_btn = self:AddComponent(UIPointerDownUp, var_arg)--添加孩子，各种重载方式查看UIBaseContainer
--]]

local UIPointerDownUp = BaseClass("UIPointerDownUp", UIBaseContainer)
local base = UIBaseContainer

-- 创建
local function OnCreate(self, relative_path)
	base.OnCreate(self)
	-- Unity侧原生组件
	self.unity_uibutton = UIUtil.FindComponent(self.transform, typeof(CS.UIPointerDownUp), relative_path)
	-- 记录点击回调
	self.__onclick = nil
	
	if IsNull(self.unity_uibutton) and IsNull(self.gameObject) then
		self.gameObject = self.unity_uibutton.gameObject
		self.transform = self.unity_uibutton.transform
	end
end

-- 设置回调
local function SetOnDown(self, ...)
	self.__ondown = BindCallback(...)
	self.unity_uibutton.onClick:AddListener(self.__ondown)
end
local function SetOnUp(self, ...)
	self.__onup = BindCallback(...)
	self.unity_uibutton.onPressUp:AddListener(self.__onup)
end

-- 资源释放
local function OnDestroy(self)
	if self.__ondown ~= nil then
		self.unity_uibutton.onPressDown:RemoveListener(self.__ondown)
	end
	if self.__onup ~= nil then
		self.unity_uibutton.onClick:RemoveListener(self.__onup)
	end
	self.unity_uibutton = nil
	self.__ondown = nil
	self.__onup = nil
	base.OnDestroy(self)
end

UIPointerDownUp.OnCreate = OnCreate
UIPointerDownUp.SetOnDown = SetOnDown
UIPointerDownUp.SetOnUp = SetOnUp
UIPointerDownUp.OnDestroy = OnDestroy

return UIPointerDownUp