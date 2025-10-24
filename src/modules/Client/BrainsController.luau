local RS = game:GetService("ReplicatedStorage")
local Remote = RS.Events.RepEvent

-- local Hitbox = require(RS.Modules.Misc.Hitbox)

local Player = game.Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()

local module = {}

function module.Initialize() end

return module
