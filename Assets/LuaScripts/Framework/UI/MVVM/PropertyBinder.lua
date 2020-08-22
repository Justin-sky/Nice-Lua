local PropertyBinder = BaseClass("PropertyBinder")

local function getProperty(viewModel, path)
    local property = viewModel
    local propertyPath = {}
    for i = 1, #path - 1 do
        local name = path[i]
        local bindableProperty = property[name]
        if bindableProperty == nil then
            return nil
        end

        if type(bindableProperty) ~= 'table' then
            return nil
        end

        if bindableProperty.OnValueChanged == nil then
            return nil
        end

        table.insert(propertyPath, bindableProperty)
        property = bindableProperty.Value
    end

    return propertyPath, property[path[#path]]
end

-- 如非必要，别重写构造函数，使用OnCreate初始化
local function __init(self, view)
    self.view = view
    self._binders = {} --function(viewModel)
    self._unbinders = {} --function(viewModel)
end

local function GetView(self)
    return self.view
end

local  function Add(self, name, valueChangedHandler)
    local registerFunc = function(viewModel, bindableProperty)
        table.insert(bindableProperty.OnValueChanged, valueChangedHandler)
        local value = bindableProperty.Value
        valueChangedHandler(nil, value) --初始化数据
    end

    local unregisterFunc = function(viewModel, bindableProperty)
        table.remove_value(bindableProperty.OnValueChanged, valueChangedHandler)
    end

    self:RegisterEvent(registerFunc, unregisterFunc, name)
end

local  function AddEx(self, name, onAdd, onInsert, onRemove)--给list用绑定
    local registerFunc = function(viewModel, bindableProperty)
        if bindableProperty.AddHandlers then
            table.insert(bindableProperty.AddHandlers, onAdd)
        end
        if bindableProperty.InsertHandlers then
            table.insert(bindableProperty.InsertHandlers, onInsert)
        end
        if bindableProperty.RemoveHandlers then
            table.insert(bindableProperty.RemoveHandlers, onRemove)
        end
    end

    local unregisterFunc = function(viewModel, bindableProperty)
        if bindableProperty.AddHandlers then
            table.remove_value(bindableProperty.AddHandlers, onAdd)
        end
        if bindableProperty.InsertHandlers then
            table.remove_value(bindableProperty.InsertHandlers, onInsert)
        end
        if bindableProperty.RemoveHandlers then
            table.remove_value(bindableProperty.RemoveHandlers, onRemove)
        end
    end

    self:RegisterEvent(registerFunc, unregisterFunc, name)
end

local  function RegisterEvent(self, eventRegisterHandler, eventUnregisterHandler, name)
    name = name or ''

    local bind = nil
    local unbind = nil
    local RebindGen = function(currentPath)
        local currentPathArray = string.split(currentPath, '.')
        return function(oldValue, newValue)
            if oldValue ~= nil then
                unbind(oldValue, currentPathArray)
            end
            bind(newValue, currentPathArray)
        end
    end

    local path = string.split(name, '.')
    local rebinders = {}
    for i = 1, #path - 1 do
        table.insert(rebinders, RebindGen(table.concat(path, '.', i + 1)))
    end

    bind = function(viewModel, currentPath)
        currentPath = currentPath or path
        local bindableProperties, targetValue = getProperty(viewModel, currentPath)
        if bindableProperties==nil then
            error(string.format("bindableProperty empty! name=%s",name))
        end

        for i, bindableProperty in ipairs(bindableProperties) do
            table.insert(bindableProperty.OnValueChanged, rebinders[i])
            viewModel = bindableProperty
        end
        eventRegisterHandler(viewModel, targetValue)
    end

    unbind = function(viewModel, currentPath)
        currentPath = currentPath or path
        local bindableProperties, targetValue = getProperty(viewModel, currentPath)
        for i, bindableProperty in ipairs(bindableProperties) do
            table.remove_value(bindableProperty.OnValueChanged, rebinders[i])
            viewModel = bindableProperty
        end
        eventUnregisterHandler(viewModel, targetValue)
    end

    table.insert(self._binders, bind)
    table.insert(self._unbinders, unbind)
end

local function Bind(self, viewModel)
    if viewModel then
        for _, binder in pairs(self._binders) do
            binder(viewModel)
        end
    end
end

local function Unbind(self, viewModel)
    if viewModel then
        for _, unbinder in pairs(self._unbinders) do
            unbinder(viewModel)
        end
    end
end

PropertyBinder.__init = __init
PropertyBinder.Add = Add
PropertyBinder.AddEx = AddEx
PropertyBinder.RegisterEvent = RegisterEvent
PropertyBinder.Bind = Bind
PropertyBinder.Unbind = Unbind
PropertyBinder.GetView = GetView

return PropertyBinder