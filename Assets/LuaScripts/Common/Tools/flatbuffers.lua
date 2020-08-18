local m = {}

m.Builder = require("Common.Tools.flatbuffers.builder").New
m.N = require("Common.Tools.flatbuffers.numTypes")
m.view = require("Common.Tools.flatbuffers.view")
m.binaryArray = require("Common.Tools.flatbuffers.binaryarray")

return m