--[[
-- added by wsh @ 2017-12-08
-- Lua侧UIImage
-- 使用方式：
-- self.xxx_img = self:AddComponent(UIImage, var_arg)--添加孩子，各种重载方式查看UIBaseContainer
--]]

local UIImage = BaseClass("UIImage", UIBaseComponent)
local base = UIBaseComponent

-- 创建
local function OnCreate(self, atlas_config, binder, property_name)
	base.OnCreate(self)
	-- Unity侧原生组件
	self.unity_uiimage = UIUtil.FindImage(self.transform)
	self.atlas_config = atlas_config

	if IsNull(self.unity_uiimage) and not IsNull(self.gameObject) then
		self.gameObject = self.unity_uiimage.gameObject
		self.transform = self.unity_uiimage.transform
	end

	--添加绑定
	if(binder~=nil and property_name~=nil and not IsNull(self.unity_uiimage)) then
		--ViewModel => Input
		binder:Add(property_name, function (oldValue, newValue)
			if oldValue ~= newValue then
				if(newValue ~= nil) then
					self:SetSpriteName(newValue)
				end
			end
		end)
	end
end

-- 获取Sprite名称
local function GetSpriteName(self)
	return self.sprite_name
end

-- 设置Sprite名称
local function SetSpriteName(self, sprite_name)
	self.sprite_name = sprite_name
	if IsNull(self.unity_uiimage) then
		return
	end

	AtlasManager:GetInstance():LoadImageAsync(self.atlas_config, sprite_name, function(sprite, sprite_name)
		-- 预设已经被销毁
		if IsNull(self.unity_uiimage) then
			return
		end
		
		-- 被加载的Sprite不是当前想要的Sprite：可能预设被复用，之前的加载操作就要作废
		if sprite_name ~= self.sprite_name then
			return
		end
		
		if not IsNull(sprite) then
			self.unity_uiimage.sprite = sprite
		end
	end, self.sprite_name)
end

-- 销毁
local function OnDestroy(self)
	self.unity_uiimage = nil
	base.OnDestroy(self)
end

UIImage.OnCreate = OnCreate
UIImage.GetSpriteName = GetSpriteName
UIImage.SetSpriteName = SetSpriteName
UIImage.OnDestroy = OnDestroy

return UIImage