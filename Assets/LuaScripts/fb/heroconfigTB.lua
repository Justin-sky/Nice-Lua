-- automatically generated by the FlatBuffers compiler, do not modify

-- namespace: fb

local flatbuffers = require('flatbuffers')

local heroconfigTB = {} -- the module
local heroconfigTB_mt = {} -- the class metatable

function heroconfigTB.New()
    local o = {}
    setmetatable(o, {__index = heroconfigTB_mt})
    return o
end
function heroconfigTB.GetRootAsheroconfigTB(buf, offset)
    local n = flatbuffers.N.UOffsetT:Unpack(buf, offset)
    local o = heroconfigTB.New()
    o:Init(buf, n + offset)
    return o
end
function heroconfigTB_mt:Init(buf, pos)
    self.view = flatbuffers.view.New(buf, pos)
end
function heroconfigTB_mt:HeroconfigTRS(j)
    local o = self.view:Offset(4)
    if o ~= 0 then
        local x = self.view:Vector(o)
        x = x + ((j-1) * 4)
        x = self.view:Indirect(x)
        local obj = require('fb.heroconfigTR').New()
        obj:Init(self.view.bytes, x)
        return obj
    end
end
function heroconfigTB_mt:HeroconfigTRSLength()
    local o = self.view:Offset(4)
    if o ~= 0 then
        return self.view:VectorLen(o)
    end
    return 0
end
function heroconfigTB.Start(builder) builder:StartObject(1) end
function heroconfigTB.AddHeroconfigTRS(builder, heroconfigTRS) builder:PrependUOffsetTRelativeSlot(0, heroconfigTRS, 0) end
function heroconfigTB.StartHeroconfigTRSVector(builder, numElems) return builder:StartVector(4, numElems, 4) end
function heroconfigTB.End(builder) return builder:EndObject() end

return heroconfigTB -- return the module