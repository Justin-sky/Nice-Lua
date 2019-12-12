--[[
-- added by wsh @ 2017-12-18
-- UILNoticeTip模型层
--]]

local UINoticeTipViewModel = BaseClass("UINoticeTipViewModel", UIBaseViewModel)
local base = UIBaseViewModel

-- 创建
local function OnCreate(self)
	base.OnCreate(self)

	self.keep_model = false

end

-- 打开
local function OnEnable(self, cs_func, ...)
	if(self.keep_model == false) then
		UIManager:GetInstance():SetKeepModel(self.__ui_name, true)
		self.keep_model = true
	end

	base.OnEnable(self)
	-- 对应的CS脚本函数
	self.cs_func = cs_func
	-- 传入参数
	self.args = SafePack(...)
	-- 当前等待协程
	self.__co = nil

	-- cs单例对象
	self.cs_obj = CS.UINoticeTip.Instance

	if self.cs_func~= nil then
		self.cs_func(self.cs_obj, SafeUnpack(self.args))
	end
end

--显示
local function OnShow(self)

end

-- 等待响应
local function WaitForResponse(self)
	self.__co = coroutine.running()
	coroutine.waitforasyncop(self.cs_obj)
	self.__co = nil
	return CS.UINoticeTip.LastClickIndex
end

-- 关闭
local function OnDisable(self)
	base.OnDisable(self)
	if self.__co then
		-- 被关闭时不能让协程卡住
		coroutine.stopwaiting(self.__co, -1)
	end
	self.cs_func = nil
	self.args = nil
	self.__co = nil
end

UINoticeTipViewModel.OnCreate = OnCreate
UINoticeTipViewModel.OnEnable = OnEnable
UINoticeTipViewModel.WaitForResponse = WaitForResponse
UINoticeTipViewModel.OnDisable = OnDisable
UINoticeTipViewModel.OnShow = OnShow

return UINoticeTipViewModel