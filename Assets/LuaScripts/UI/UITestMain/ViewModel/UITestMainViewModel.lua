--[[
-- added by wsh @ 2017-12-01
-- UILogin视图层
-- 注意：
-- 1、成员变量最好预先在__init函数声明，提高代码可读性
-- 2、OnEnable函数每次在窗口打开时调用，直接刷新
-- 3、组件命名参考代码规范
--]]


local UITestMainViewModel = BaseClass("UITestMainViewModel",UIBaseViewModel)
local base = UIBaseViewModel

local function OnCreate(self)
    self.hp_text = BindableProperty.New(2122)
    self.mp_text = BindableProperty.New(90999)
    self.money_text = BindableProperty.New(876787)

    self.hp_image = BindableProperty.New("login2_05.png" )
    self.mp_image = BindableProperty.New("login2_10.png")
    self.money_image = BindableProperty.New("login2_11.png")

    self.fighting_btn = {
        OnClick = function()
            SceneManager:GetInstance():SwitchScene(SceneConfig.BattleScene)
        end
    }
    self.logout_btn = {
        OnClick = function()
            NetManager:GetInstance():CloseGateServer()
            SceneManager:GetInstance():SwitchScene(SceneConfig.LoginScene)
        end
    }
    self.noticetip_btn = {
        OnClick = function()
            --UIManager:GetInstance():OpenOneButtonTip("title", "content", "OK", function ()
            --
            --end)
            UIManager:GetInstance():OpenTwoButtonTip("title", "content", "OK","Cancel",
                    function ()
                        print("OK click")
                    end,function()
                        print("Cancel click")
                    end)
        end
    }
end

-- 打开
local function OnEnable(self)
    base.OnEnable(self)
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

UITestMainViewModel.OnCreate = OnCreate
UITestMainViewModel.OnEnable = OnEnable
UITestMainViewModel.OnDisable = OnDisable
UITestMainViewModel.OnDistroy = OnDistroy



return UITestMainViewModel