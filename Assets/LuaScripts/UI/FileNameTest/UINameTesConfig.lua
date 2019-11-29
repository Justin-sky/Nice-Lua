--[[
-- added by passion @ 2019/11/25 16:42:04
-- UINameTes模块窗口配置，要使用还需要导出到UI.Config.UIConfig.lua
--]]
-- 窗口配置
local UINameTes= {
	Name = UIWindowNames.UINameTes,
	Layer = UILayers.NormalLayer,
	Model = require "UI.UINameTes.Model.UINameTesModel",
	Ctrl =  require "UI.UINameTes.Controller.UINameTesCtrl",
	View = require "UI.UINameTes.View.UINameTesView",
	PrefabPath = "UI/Prefabs/View/UINameTes.prefab",
}


return {
	UINameTes=UINameTes,
}
