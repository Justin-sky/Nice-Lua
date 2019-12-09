--[[
-- added by wsh @ 2017-12-01
-- UILogin视图层
-- 注意：
-- 1、成员变量最好预先在__init函数声明，提高代码可读性
-- 2、OnEnable函数每次在窗口打开时调用，直接刷新
-- 3、组件命名参考代码规范
--]]


local UILoadingViewModel = BaseClass("UILoadingViewModel",UIBaseViewModel)
local base = UIBaseViewModel

local function OnCreate(self)
    self.loading_text = BindableProperty.New()
    self.loading_slider = BindableProperty.New(0)



    -- 定时器
    -- 这里一定要对回调函数持有引用，否则随时可能被GC，引起定时器失效
    -- 或者使用成员函数，它的生命周期是和对象绑定在一块的
    local circulator = table.circulator({"loading", "loading.", "loading..", "loading..."})
    self.timer_action = function(self)
        self.loading_text.Value = circulator()
    end
    self.timer = TimerManager:GetInstance():GetTimer(1, self.timer_action , self)
    self.timer:Start()
end

local function UpdateData(self)


end

local function OnDestroy(self)
    self.timer:Stop()
    self.loading_text = nil
    self.loading_slider = nil
    self.timer_action = nil
    self.timer = nil
    base.OnDestroy(self)
end

UILoadingViewModel.OnCreate = OnCreate
UILoadingViewModel.UpdateData = UpdateData
UILoadingViewModel.OnDestroy = OnDestroy


return UILoadingViewModel