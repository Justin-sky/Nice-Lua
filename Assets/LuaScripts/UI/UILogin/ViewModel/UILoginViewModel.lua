--[[
-- added by wsh @ 2017-12-01
-- UILogin视图层
-- 注意：
-- 1、成员变量最好预先在__init函数声明，提高代码可读性
-- 2、OnEnable函数每次在窗口打开时调用，直接刷新
-- 3、组件命名参考代码规范
--]]


local UILoginViewModel = BaseClass("UILoginViewModel")
local UILoginItemViewModel = require "UI.UILogin.ViewModel.UILoginItemViewModel"

local function OnCreate(self)

    self.Name = BindableProperty.New("Justin..")
    self.Age = BindableProperty.New(0)


    Items = BindableProperty.New({})

    self.testList = BindableProperty.New({})
    local tmplist = {}
    for i = 1, 10 do
        local it = UILoginItemViewModel.New()
        it:OnCreate(i + 1000)

        table.insert(tmplist, it)
    end
    --self.testList.Value = tmplist


    self.List = ObservableList.New();
    self.List.Value = tmplist


    self.Content = ComputeBindableProperty.New({ self.Name, self.Age}, function(Name, Age)
        print(Name .. Age.." justin.......................")
        return Name .. Age.." justin......................."
    end)

end

local function UpdateData(self,name)
    --self.Name.Value = "Justin....modify......"
    --self.Age.Value = 99;
    print("==================Update Jjjjj")
    local it = UILoginItemViewModel.New()
    it:OnCreate(999)
    self.List:Add(it)

    self.Name.Value = "Baby...Tell me..."..name

end

UILoginViewModel.OnCreate = OnCreate
UILoginViewModel.UpdateData = UpdateData


return UILoginViewModel