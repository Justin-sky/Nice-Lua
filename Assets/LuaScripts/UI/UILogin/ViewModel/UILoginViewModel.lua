--[[
-- added by wsh @ 2017-12-01
-- UILogin视图层
-- 注意：
-- 1、成员变量最好预先在__init函数声明，提高代码可读性
-- 2、OnEnable函数每次在窗口打开时调用，直接刷新
-- 3、组件命名参考代码规范
--]]


local UILoginViewModel = BaseClass("UILoginViewModel",UIBaseViewModel)

local function OnCreate(self)
    print("UILogin View Model OnCreate..................")
    self.account_input = BindableProperty.New("justin")
    self.password_input = BindableProperty.New()

end

local function UpdateData(self,name)

end

UILoginViewModel.OnCreate = OnCreate
UILoginViewModel.UpdateData = UpdateData


return UILoginViewModel