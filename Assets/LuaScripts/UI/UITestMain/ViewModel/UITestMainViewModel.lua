--[[
-- added by wsh @ 2017-12-01
-- UILogin视图层
-- 注意：
-- 1、成员变量最好预先在__init函数声明，提高代码可读性
-- 2、OnEnable函数每次在窗口打开时调用，直接刷新
-- 3、组件命名参考代码规范
--]]


local UITestMainViewModel = BaseClass("UITestMainViewModel",UIBaseViewModel)

local function OnCreate(self)
    self.hp_text = BindableProperty.New()
    self.mp_text = BindableProperty.New()
    self.money_text = BindableProperty.New()


end

local function UpdateData(self,data)
    if(data.hp_text) then self.hp_text.Value = data.hp_text end
    if(data.mp_text) then self.mp_text.Value = data.mp_text end
    if(data.money_text) then self.money_text.Value = data.money_text end

end

UITestMainViewModel.OnCreate = OnCreate
UITestMainViewModel.UpdateData = UpdateData


return UITestMainViewModel