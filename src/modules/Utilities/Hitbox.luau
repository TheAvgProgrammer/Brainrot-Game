-- TODO: Implement hitbox spawning logic. Try to add GetPartsInBounds() functionality. Add visualizer option.

-- local Settings = require(script.Parent.Parent.Settings.HitboxSettings)
-- type HitboxSettings = Settings.HitboxSettings
local module = {}

function module.SpawnHitbox(hbsettings: HitboxSettings)
    
end

export type HitboxSettings = {
	Size: Vector3,
	PivotModel: Model,
	PivotPart: BasePart,
	Offset: Vector3,
	ShouldWeld: boolean,
	WeldPartName: string,
	Duration: number,
    Visualizer: boolean,
}


return module