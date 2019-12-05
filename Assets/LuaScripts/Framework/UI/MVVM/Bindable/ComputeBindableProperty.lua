
WeakReference = {
    __mode = 'v'
}

function WeakReference.New(value)
    local t = {
        Ref = value
    }
    setmetatable(t, WeakReference)
    return t
end

ComputeBindableProperty = {}

local get = {}
local set = {}

ComputeBindableProperty.__index = function(t, k)
    local var = rawget(ComputeBindableProperty, k)

    if var == nil then
        var = rawget(get, k)

        if var ~= nil then
            return var(t)
        end
    end

    return var
end

ComputeBindableProperty.__tostring = function(self)
    local value = rawget(self, '_value')
    if value then
        return tostring(value)
    else
        return 'nil'
    end
end

ComputeBindableProperty.__newindex = function(t, k, v)
    local var = rawget(ComputeBindableProperty, k)

    if var == nil then
        var = rawget(set, k)

        if var ~= nil then
            return var(t, v)
        end
    end
end

function ComputeBindableProperty.New(bindableProperties, func)
    local t = {
        bindableProperties = bindableProperties,
        oldValue = nil,
        func = func,
        OnValueChanged = {}
    }
    local weak_self = WeakReference.New(t)

    local onChange = function()
        if weak_self.Ref then
            ComputeBindableProperty.OnContainValueChanged(weak_self.Ref)
            return false
        else
            return true
        end
    end

    for _, property in ipairs(t.bindableProperties) do
        table.insert(property.OnValueChanged, onChange)
    end


    setmetatable(t, ComputeBindableProperty)
    return t
end

function ComputeBindableProperty:Set_Value(value)
end

function ComputeBindableProperty:Get_Value()
    self:OnContainValueChanged(true)
    local value = self.oldValue
    return value
end

function ComputeBindableProperty:OnContainValueChanged(onlyCalculateValue)
    onlyCalculateValue = onlyCalculateValue or false
    if self.func then
        local args = {}
        local properties = rawget(self, 'bindableProperties')
        for _, property in pairs(properties) do
            table.insert(args, property.Value)
        end

        local result = self.func(table.unpack(args))
        rawset(self, 'oldValue', result)

        if not onlyCalculateValue then
            local expiredOnValueChange = {}
            for _, onValueChanged in pairs(self.OnValueChanged) do
                local expired = onValueChanged(self.oldValue, result)
                if expired then
                    table.insert(expiredOnValueChange, onValueChanged)
                end
            end

            for _, expired in pairs(expiredOnValueChange) do
                table.remove_value(self.OnValueChanged, expired)
            end
        end
    end
end

get.Value = ComputeBindableProperty.Get_Value
set.Value = ComputeBindableProperty.Set_Value