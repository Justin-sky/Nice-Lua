BindableProperty = {}

local get = {}
local set = {}

BindableProperty.__index = function(t,k)
    local var = rawget(BindableProperty, k)

    if var == nil then
        var = rawget(get, k)

        if var ~= nil then
            return var(t)
        end
    end

    return var
end

BindableProperty.__tostring = function(self)
    local value = rawget(self, '_value')
    if value then
        return tostring(value)
    else
        return 'nil'
    end
end

BindableProperty.__newindex = function(t, k, v)
    local var = rawget(BindableProperty, k)

    if var == nil then
        var = rawget(set, k)

        if var ~= nil then
            return var(t, v)
        end
    end
end

function BindableProperty.New(value)
    local t = {
        _value = value,
        OnValueChanged = {}
    }
    setmetatable(t, BindableProperty)
    return t
end

function BindableProperty:Set_Value(value)
    local old = rawget(self, '_value')

    rawset(self, '_value', value)
    self:ValueChanged(old, value)
end

function BindableProperty:Get_Value()
    return rawget(self, '_value')
end

function BindableProperty:ValueChanged(oldValue, newValue)
    local expiredOnValueChange = {}
    for _, onValueChanged in pairs(self.OnValueChanged) do
        local expired = onValueChanged(oldValue, newValue)
        if expired then
            table.insert(expiredOnValueChange, onValueChanged)
        end
    end

    for _, expired in pairs(expiredOnValueChange) do
        table.remove_value(self.OnValueChanged, expired)
    end
end

get.Value = BindableProperty.Get_Value
set.Value = BindableProperty.Set_Value