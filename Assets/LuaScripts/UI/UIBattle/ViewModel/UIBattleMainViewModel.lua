local UIBattleMainViewModel = BaseClass("UIBattleMainViewModel",UIBaseViewModel)
local base = UIBaseViewModel

local function OnCreate(self)

    self.back_btn = {
        OnClick = function()
            SceneManager:GetInstance():SwitchScene(SceneConfig.HomeScene)
        end
    }

end


local function OnDestroy(self)

    base.OnDestroy(self)
end

UIBattleMainViewModel.OnCreate = OnCreate
UIBattleMainViewModel.OnDestroy = OnDestroy


return UIBattleMainViewModel