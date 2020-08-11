--[[
-- added by wsh @ 2017-12-01
-- UILogin视图层
-- 注意：
-- 1、成员变量最好预先在__init函数声明，提高代码可读性
-- 2、OnEnable函数每次在窗口打开时调用，直接刷新
-- 3、组件命名参考代码规范
--]]

local UILoginViewModel = BaseClass("UILoginViewModel",UIBaseViewModel)
local base = UIBaseViewModel


local function OnCreate(self)
    self.app_version_text = BindableProperty.New("1.0.1")
    self.res_version_text = BindableProperty.New(8898)
    self.server_text = BindableProperty.New("")

    self.account_input = BindableProperty.New("Justinz")
    self.password_input = BindableProperty.New("123456")

    self.test_timer_text  = BindableProperty.New(0)
    self.test_coroutine_text  = BindableProperty.New(0)

    self.login_btn_click = {
        OnClick = function()


            -- 合法性检验
            local name = self.account_input.Value
            local password = self.password_input.Value
            if string.len(name) > 20 or string.len(name) < 1 then
                -- TODO：错误弹窗
                Logger.LogError("name length err!")
                return;
            end
            if string.len(password) > 20 or string.len(password) < 1 then
                -- TODO：错误弹窗
                Logger.LogError("password length err!")
                return;
            end
            -- 检测是否有汉字
            for i=1, string.len(name) do
                local curByte = string.byte(name, i)
                if curByte > 127 then
                    -- TODO：错误弹窗
                    Logger.LogError("name err : only ascii can be used!")
                    return;
                end;
            end

            ClientData:GetInstance():SetAccountInfo(name, password)


            NetManager:GetInstance():ConnectRealmServer("127.0.0.1", 10002, self.OnRealmServerConnected)
            --SceneManager:GetInstance():SwitchScene(SceneConfig.HomeScene)
        end
    }
    self.server_select_btn = {
        OnClick = function()
            UIManager:GetInstance():OpenWindow(UIWindowNames.UILoginServer)
        end
    }
    self.long_pass_btn = {
        OnClick = function()
            print("================================ slong_pass_btn click............................")
        end,
        OnPress = function()
            print("================================ slong_pass_btn OnPress............................")
        end
    }


    -- 这里一定要对回调函数持有引用，否则随时可能被GC，引起定时器失效
    -- 或者使用成员函数，它的生命周期是和对象绑定在一块的
    do
        self.timer_action = function(self)
            self.test_timer_text.Value = self.test_timer_text.Value + 1
        end
        self.timer = TimerManager:GetInstance():GetTimer(1, self.timer_action , self)
        -- 启动定时器
        self.timer:Start()
        -- 启动协程
        coroutine.start(function()
            -- 下面的代码仅仅用于测试，别模仿，很容易出现问题：
            -- 1、时间统计有累积误差，其实协程用在UI倒计时展示时一般问题不大，倒计时会稍微比真实时间长，具体影响酌情考虑
            -- 2、这个协程一旦启用无法被回收，当然，可以避免这点，使用一个控制变量，在对象销毁的时候退出死循环即可
            while true do
                coroutine.waitforseconds(0.5)
                self.test_coroutine_text.Value = self.test_coroutine_text.Value + 0.5

            end
        end)
    end

    self:OnRefresh()


-- 打开
    base.OnEnable(self)
end


local function OnGateServerConnected()
    Logger.Log("Gate Server connected success")

    --Login Gate Server
    local gateInfo = ClientData:GetInstance():GetGateInfo()
    print("gate _id ： "..gateInfo.gate_id .. ", gate key:"..gateInfo.gate_key)

    local c2g_loginGate = {
        Key = gateInfo.gate_key,
        GateId = gateInfo.gate_id
    }
    NetManager:GetInstance():SendGameMsg(MsgIDDefine.C2G_LOGINGATE, c2g_loginGate, function (msg)
        Logger.Log("Login Gate Success")

        Logger.Log("PlayerID: "..msg.PlayerId .. ",Message:"..msg.Message)

        SceneManager:GetInstance():SwitchScene(SceneConfig.HomeScene)
    end, true, true)

end

local function OnRealmServerConnected(self)
    --验证服连接成功

    local c2r_login = {
        Account = "Jusitn",
        Password = "123456"
    }
    NetManager:GetInstance():SendRealmMsg(MsgIDDefine.C2R_LOGIN, c2r_login,function(msg)
        Logger.Log("receive message=====Login Success=============")

        --关闭验证服
        NetManager:GetInstance():CloseRealmServer()

        --连接登录服
        local gateAddr = msg.Address
        local gateId = msg.GateId
        local key = msg.Key
        local message = msg.Message

        ClientData:GetInstance():SetGateInfo(gateId, key)

        local addrs = string.split(gateAddr, ":")
        Logger.Log("ip: "..addrs[1] .. ",port: "..addrs[2])
        NetManager:GetInstance():ConnectGateServer(addrs[1], addrs[2], OnGateServerConnected)

    end ,true, true)

end


local function SetServerInfo(self, select_svr_id)
    local server_data = ServerData:GetInstance()
    local client_data = ClientData:GetInstance()

    local select_svr = server_data.servers[select_svr_id]

    if select_svr ~= nil then
        local area_name = LangUtil.GetServerAreaName(select_svr.area_id)
        local server_name = LangUtil.GetServerName(client_data.login_server_id)
        self.server_text.Value = area_name..server_name
    end
end

-- 刷新全部数据
local function OnRefresh(self)
    local client_data = ClientData:GetInstance()
    self.account_input.Value = client_data.account
    self.password_input.Value = client_data.password
    self.app_version_text.Value = client_data.app_version
    self.res_version_text.Value = client_data.res_version
    SetServerInfo(self, client_data.login_server_id)
end


local function OnSelectedSvrChg(self, id)
    SetServerInfo(self, id)
end

-- 监听选服变动
local function OnAddListener(self)
    base.OnAddListener(self)
    self:AddDataListener(DataMessageNames.ON_LOGIN_SERVER_ID_CHG, OnSelectedSvrChg)
end

local function OnRemoveListener(self)
    base.OnRemoveListener(self)
    self:RemoveDataListener(DataMessageNames.ON_LOGIN_SERVER_ID_CHG, OnSelectedSvrChg)
end

-- 关闭
local function OnDisable(self)
    base.OnDisable(self)
    -- 清理成员变量
end

-- 销毁
local function OnDistroy(self)
    base.OnDistroy(self)
    -- 清理成员变量
end

UILoginViewModel.OnEnable = OnEnable
UILoginViewModel.OnDisable = OnDisable
UILoginViewModel.OnCreate = OnCreate
UILoginViewModel.OnDistroy = OnDistroy
UILoginViewModel.OnRefresh = OnRefresh
UILoginViewModel.OnAddListener = OnAddListener
UILoginViewModel.OnRemoveListener = OnRemoveListener
UILoginViewModel.On_R2C_LOGIN = On_R2C_LOGIN
UILoginViewModel.OnRealmServerConnected = OnRealmServerConnected
UILoginViewModel.OnGateServerConnected = OnGateServerConnected


return UILoginViewModel