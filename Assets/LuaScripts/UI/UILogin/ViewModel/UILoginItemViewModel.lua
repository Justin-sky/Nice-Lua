--[[
-- added by wsh @ 2017-12-01
-- UILogin视图层
-- 注意：
-- 1、成员变量最好预先在__init函数声明，提高代码可读性
-- 2、OnEnable函数每次在窗口打开时调用，直接刷新
-- 3、组件命名参考代码规范
--]]


local UILoginItemViewModel = BaseClass("UILoginItemViewModel",UIBaseViewModel)


local function OnCreate(self,age)

    self.Name = BindableProperty.New("Jim..")
    self.Age = BindableProperty.New(age)

end

local function UpdateData(self, data)
    self.Name.Value = data.Name
    self.Age.Value = data.Age

end

UILoginItemViewModel.OnCreate = OnCreate
UILoginItemViewModel.UpdateData = UpdateData


return UILoginItemViewModel