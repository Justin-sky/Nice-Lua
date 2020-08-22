--[[
-- added by wsh @ 2017-12-11
-- UILogin模块UILoginView窗口中服务器列表的可复用Item
--]]

local UIAreaWrapItem = BaseClass("UIAreaWrapItem", UIWrapComponent)
local base = UIWrapComponent


-- 创建
local function OnCreate(self)
    base.OnCreate(self)
    -- 组件初始化
    self.area_btn_text = self:AddComponent(UIText, "Text")

end

-- 组件被复用时回调该函数，执行组件的刷新
local function OnRefresh(self, real_index, check)
    local area_id = self.view.area_ids[real_index + 1]
    local btn_name = LangUtil.GetServerAreaName(area_id)
    self.area_btn_text:SetText(btn_name)
end

-- 组件添加了按钮组，则按钮被点击时回调该函数
local function OnClick(self, toggle_btn, real_index, check)
    if check then
        self.view:SetSelectedArea(real_index)
    end
end

UIAreaWrapItem.OnCreate = OnCreate
UIAreaWrapItem.OnRefresh = OnRefresh
UIAreaWrapItem.OnClick = OnClick

return UIAreaWrapItem