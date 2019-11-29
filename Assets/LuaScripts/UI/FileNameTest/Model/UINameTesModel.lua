--[[
-- added by passion @ 2019/11/25 16:42:04
-- UINameTesUIMain模型层
-- 注意：
-- 1、成员变量预先在OnCreate、OnEnable函数声明，提高代码可读性
-- 2、OnCreate内放窗口生命周期内保持的成员变量，窗口销毁时才会清理
-- 3、OnEnable内放窗口打开时才需要的成员变量，窗口关闭后及时清理
-- 4、OnEnable函数每次在窗口打开时调用，可传递参数用来初始化Model
--]]
local UINameTesModel = BaseClass("UINameTesModel", UIBaseModel)


local base = UIBaseModel-- 创建
local function OnCreate(self)
	base.OnCreate(self)
	-- 窗口生命周期内保持的成员变量放这
end
-- 打开
local function OnEnable(self)
	base.OnEnable(self)
	-- 窗口关闭时可以清理的成员变量放这
end
-- 关闭
local function OnDestroy(self)
	base.OnDestroy(self)
	-- 清理成员变量
end


UINameTesModel.OnCreate = OnCreate
UINameTesModel.OnEnable = OnEnable
UINameTesModel.OnDisable = OnDisable
UINameTesModel.OnDestroy = OnDestroy

return UINameTesModel
