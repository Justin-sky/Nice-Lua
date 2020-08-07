local UILoginServerViewModel = BaseClass("UILoginServerViewModel", UIBaseViewModel)
local base = UIBaseViewModel

local function OnCreate(self)

    self.selected_server_id = 10001
    self.area_ids = BindableProperty.New()
    self.area_servers = BindableProperty.New()
    self.recommend_servers = BindableProperty.New()

    self.back_btn = {
        OnClick = function()
            UIManager:GetInstance():CloseWindow(UIWindowNames.UILoginServer)
        end
    }
    self.confirm_btn = {
        OnClick = function()
            -- 合法性校验
            if self.selected_server_id == nil then
                -- TODO：错误弹窗
                Logger.LogError("svr_id nil")
                return
            end
            local servers = ServerData:GetInstance().servers
            if servers[self.selected_server_id] == nil then
                -- TODO：错误弹窗
                Logger.LogError("no svr_id : "..tostring(self.selected_server_id))
                return
            end

            ClientData:GetInstance():SetLoginServerID(self.selected_server_id)
            UIManager:GetInstance():CloseWindow(UIWindowNames.UILoginServer)
        end
    }


end

-- 打开
local function OnEnable(self)
    base.OnEnable(self)
    -- 窗口关闭时可以清理的成员变量放这
    -- 推荐服务器列表
    self.recommend_servers.Value = nil
    -- 区域id列表
    self.area_ids.Value = nil
    -- 所有区域下的服务器列表
    self.area_servers.Value = nil
    -- 当前选择的登陆服务器
    self.selected_server_id = 0

    self:OnRefresh()
end

-- 获取推荐服务器列表
local function FetchRecommendList(servers)
    local recommend_servers = {}
    for _,v in pairs(servers) do
        if v.recommend then
            table.insert(recommend_servers, v)
        end
    end
    table.sort(recommend_servers, function(ltb, rtb)
        return ltb.server_id < rtb.server_id
    end
    )
    return recommend_servers
end

-- 按区域划分服务器列表
local function FetchAreaList(servers)
    local area_ids_record = {}
    local area_ids = {}
    local area_servers = {}
    for _,v in pairs(servers) do
        local key = v.area_id
        local area = area_servers[key]
        if area == nil then
            area = {}
        end
        table.insert(area, v)
        area_servers[key] = area
        if area_ids_record[v.area_id] == nil then
            area_ids_record[v.area_id] = v.area_id
            table.insert(area_ids, v.area_id)
        end
    end
    table.sort(area_ids)
    for _,v in pairs(area_servers) do
        table.sort(v, function(ltb, rtb)
            return ltb.server_id < rtb.server_id
        end)
    end
    return area_ids, area_servers
end

local function OnRefresh(self)
    local server_data = ServerData:GetInstance()
    self.recommend_servers.Value = FetchRecommendList(server_data.servers)

    self.area_ids.Value, self.area_servers.Value = FetchAreaList(server_data.servers)
    self.selected_server_id = ClientData:GetInstance().login_server_id

end

-- 关闭
local function OnDisable(self)
    base.OnDisable(self)
    -- 清理成员变量
    self.recommend_servers.Value = nil
    self.area_ids.Value = nil
    self.area_servers.Value = nil
    self.selected_server_id = 0
end

-- 销毁
local function OnDistroy(self)
    base.OnDistroy(self)
    -- 清理成员变量
end


UILoginServerViewModel.OnEnable = OnEnable
UILoginServerViewModel.OnDisable = OnDisable
UILoginServerViewModel.OnCreate = OnCreate
UILoginServerViewModel.OnDistroy = OnDistroy
UILoginServerViewModel.OnRefresh = OnRefresh


return UILoginServerViewModel