
--[[
-- 模块窗口配置，要使用还需要导出到UI.Config.UIConfig.lua
-- 一个模块可以对应多个窗口，每个窗口对应一个配置项
-- 使用范例：
-- 窗口配置表 ={
--		名字Name
--		UI层级Layer
--		视图模型类ViewModel
--		视图类View
--		资源加载路径PrefabPath
-- } 
--]]

-- 窗口配置
local UITest = {
	Name = UIWindowNames.UITest,
	Layer = UILayers.BackgroudLayer,
	ViewModel = require "UI.UITest.ViewModel.nil",
	View = require "UI.UITest.View.UITestView",
	PrefabPath = "UI/Prefabs/View/UITest.prefab",
}


return {
	-- 配置
	UITest = UITest,

}
