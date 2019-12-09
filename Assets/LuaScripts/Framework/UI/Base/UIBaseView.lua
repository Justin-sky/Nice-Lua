--[[
-- added by wsh @ 2017-11-30
-- UI视图层基类：该界面所有UI刷新操作，只和展示相关的数据放在这，只有操作相关数据放Model去
-- 注意：
-- 1、被动刷新：所有界面刷新通过消息驱动---除了打开界面时的刷新
-- 2、对Model层可读，不可写---调试模式下强制
-- 3、所有写数据、游戏控制操作、网络相关操作全部放Ctrl层
-- 4、Ctrl层不依赖View层，但是依赖Model层
-- 5、任何情况下不要在游戏逻辑代码操作界面刷新---除了打开、关闭界面
--]]

local UIBaseView = BaseClass("UIBaseView", UIBaseContainer)
local base = UIBaseContainer

-- 构造函数：必须把基类需要的所有参数列齐---即使在这里不用，提高代码可读性
-- 子类别再写构造函数，初始化工作放OnCreate
local function __init(self, holder, var_arg, viewModel)
	assert(viewModel ~= nil)

	-- ViewModel
	self.Binder = PropertyBinder.New(self)
	self.viewModelProperty = BindableProperty.New()

	if(viewModel~=nil) then
		self.viewModelProperty.Value = viewModel
	end

	-- 窗口画布
	self.canvas = nil
	-- 窗口基础order，窗口内添加的其它canvas设置的order都以它做偏移
	self.base_order = 0
end

-- 创建：资源加载完毕
local function OnCreate(self)
	base.OnCreate(self)
	-- 窗口画布
	self.canvas = self:AddComponent(UICanvas, "", 0)
	-- 回调管理，使其最长保持和View等同的生命周期
	self.__ui_callback = {}
	-- 初始化RectTransform
	self.rectTransform.offsetMax = Vector2.zero
	self.rectTransform.offsetMin = Vector2.zero
	self.rectTransform.localScale = Vector3.one
	self.rectTransform.localPosition = Vector3.zero

	table.insert(self.viewModelProperty.OnValueChanged, handlerEx(self.OnBindingContextChanged, self))
end

local function BindAll(self)
	self.Binder:Bind(self.viewModelProperty.Value)
end

-- Binding 上下文改变时触发
local function OnBindingContextChanged(self,oldValue, newValue)

	if oldValue~= nil then self.Binder:Unbind(oldValue) end
	if newValue~= nil then self.Binder:Bind(newValue) end

end

-- 修改viewModel
local function SetBindingContext(self, viewModel)
	if viewModel~=nil then
		self.viewModelProperty.Value = viewModel
	end
end

-- 获取viewModel
local function GetBindingContext(self)
	return self.viewModelProperty.Value
end

-- 打开：窗口显示
local function OnEnable(self)
	self.base_order = self.holder:PopWindowOder()

	base.OnEnable(self)
end


-- 注册UI数据监听事件，别重写
local function AddUIListener(self, msg_name, callback)
	local bindFunc = Bind(self, callback)
	AddCallback(self.__ui_callback, msg_name, bindFunc)
	UIManager:GetInstance():AddListener(msg_name, bindFunc)
end

-- 注销UI数据监听事件，别重写
local function RemoveUIListener(self, msg_name, callback)
	local bindFunc = GetCallback(self.__ui_callback, msg_name)
	RemoveCallback(self.__ui_callback, msg_name, bindFunc)
	UIManager:GetInstance():RemoveListener(msg_name, bindFunc)
end

-- 关闭：窗口隐藏
local function OnDisable(self)
	base.OnDisable(self)
	self.holder:PushWindowOrder()
end

-- 销毁：窗口销毁
local function OnDestroy(self)
	for k,v in pairs(self.__ui_callback) do
		self:RemoveUIListener(k, v)
	end

	self.__ui_callback = nil

	self.Binder = nil
	table.remove_value(self.viewModelProperty.OnValueChanged, handlerEx(self.OnBindingContextChanged, self))
	self.viewModelProperty = nil

	base.OnDestroy(self)
end

UIBaseView.__init = __init
UIBaseView.OnCreate = OnCreate
UIBaseView.OnEnable = OnEnable
UIBaseView.OnDisable = OnDisable
UIBaseView.AddUIListener = AddUIListener
UIBaseView.RemoveUIListener = RemoveUIListener
UIBaseView.OnDestroy = OnDestroy
UIBaseView.SetBindingContext = SetBindingContext
UIBaseView.GetBindingContext = GetBindingContext
UIBaseView.OnBindingContextChanged = OnBindingContextChanged
UIBaseView.BindAll = BindAll

return UIBaseView