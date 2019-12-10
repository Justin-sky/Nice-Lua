--[[
-- added by wsh @ 2017-12-04
-- UILoginServerView视图层
--]]

local UIServerWrapItem = require "UI.UILogin.Component.UIServerWrapItem"
local UIAreaWrapItem = require "UI.UILogin.Component.UIAreaWrapItem"

local UILoginServerView = BaseClass("UILoginServerView", UIBaseView)
local base = UIBaseView

-- 各个组件路径
local back_btn_path = "ContentRoot/BackBtnRoot/Parent/BackBtn"
local confirm_btn_path = "ContentRoot/ConfirmBtnRoot/Parent/ConfirmBtn"
local recommend_btn_path = "ContentRoot/RecommendBtn"
local area_scroll_content_path = "ContentRoot/AreaScrollView/AreaScrollRect/AreaScrollContent"
local svr_scroll_content_path = "ContentRoot/SvrScrollView/SvrScrollRect/SvrScrollContent"

local recommend_btn_virtual_index = -1

local function OnCreate(self)
	base.OnCreate(self)

	-- 1、按钮初始化
	self.back_btn = self:AddComponent(UIButton, back_btn_path, self.Binder, "back_btn")
	self.confirm_btn = self:AddComponent(UIButton, confirm_btn_path, self.Binder, "confirm_btn")
	self.recommend_btn = self:AddComponent(UIToggleButton, recommend_btn_path)


	-- 2、区域列表初始化
	-- A）继承UIWrapComponent去实现子类
	-- B）添加按钮组，area_wrapgroup下所以按钮以UIToggleButton组件实例添加到按钮组
	-- C）再添加外部按钮（推荐按钮）---设置虚拟索引为-1
	self.area_wrapgroup = self:AddComponent(UIWrapGroup, area_scroll_content_path, UIAreaWrapItem)
	self.area_wrapgroup:AddButtonGroup(UIToggleButton)
	self.area_wrapgroup:AddButton(UIToggleButton, self.recommend_btn, recommend_btn_virtual_index)
	self.area_wrapgroup:SetOriginal(recommend_btn_virtual_index)
	--推荐按钮在此接收事件
	self.area_wrapgroup:SetOnClick(function (wrap_component, toggle_btn, virtual_index, check)
		if check == true and virtual_index == recommend_btn_virtual_index then
			self:SetSelectedArea(recommend_btn_virtual_index)
		end
	end)


	-- 3、服务器列表初始化
	-- A）继承UIWrapComponent去实现子类
	-- B）添加按钮组，area_wrapgroup下所以按钮以UIToggleButton组件实例添加到按钮组
	self.svr_wrapgroup = self:AddComponent(UIWrapGroup, svr_scroll_content_path, UIServerWrapItem)
	self.svr_wrapgroup:AddButtonGroup(UIToggleButton)

	-- 数据绑定
	do
		self.Binder:Add("area_ids", function (oldValue, newValue)
			if(newValue == nil) then return end
			self.area_ids = newValue

			-- 各组件刷新，重置wrapgroup长度，wrapgroup、btngroup复位
			self.area_wrapgroup:SetLength(table.count(self.area_ids))
			self.area_wrapgroup:ResetToBeginning()

		end)
		self.Binder:Add("area_servers", function (oldValue, newValue)
			self.area_servers = newValue
		end)
		self.Binder:Add("recommend_servers", function (oldValue, newValue)
			if newValue ~=nil then
				self.recommend_servers = newValue
				self:SetSelectedArea(recommend_btn_virtual_index)

			end
		end)
	end

	-- 调用父类Bind所有属性
	base.BindAll(self)
end

local function OnEnable(self)
	base.OnEnable(self)
end


-- server_id转换到server_index
local function ServerID2ServerIndex(self, server_id)
	local choose_pairs = table.choose(self.server_list, function(i, v)
		return v.server_id == server_id
	end)
	if table.count(choose_pairs) == 0 then
		return nil
	else
		local keys = table.keys(choose_pairs)
		assert(table.count(keys) == 1)
		return keys[1] - 1
	end
end

-- 设置选择server
local function SetSelectedServer(self, server_index)
	self.viewModelProperty.Value["selected_server_id"] = self.server_list[server_index + 1].server_id
end
-- 设置选择Area
local function SetSelectedArea(self, area_index)
	if area_index == recommend_btn_virtual_index then
		self.server_list = self.recommend_servers
	else
		local area_id = self.area_ids[area_index + 1]
		self.server_list = self.area_servers[area_id]
	end
	if(self.server_list == nil) then return end

	-- 区域列表回调：UIWrapGroup建立专门脚本UIServerItem刷新示例
	local selected_server_id = self.viewModelProperty.Value["selected_server_id"]
	local selected_server_index = self:ServerID2ServerIndex(selected_server_id)
	self.svr_wrapgroup:SetLength(table.count(self.server_list))
	self.svr_wrapgroup:SetOriginal(selected_server_index)
	self.svr_wrapgroup:ResetToBeginning()
end

local function OnDestroy(self)
	self.server_list = nil
	self.area_ids = nil
	self.area_servers = nil
	base.OnDestroy(self)
end

UILoginServerView.OnCreate = OnCreate
UILoginServerView.OnEnable = OnEnable
UILoginServerView.ServerID2ServerIndex = ServerID2ServerIndex
UILoginServerView.SetSelectedServer = SetSelectedServer
UILoginServerView.SetSelectedArea = SetSelectedArea
UILoginServerView.OnDestroy = OnDestroy

return UILoginServerView