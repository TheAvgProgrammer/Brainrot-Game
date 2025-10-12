local TeleportPlayer = require(game.ReplicatedStorage.Modules.Misc.TeleportPlayer)
local ThrowModule = require(game.ReplicatedStorage.Modules.Gui.Main.Throw)
local ThrowController = require(game.ReplicatedStorage.Modules.Client.ThrowController)
local InputController = require(game.ReplicatedStorage.Modules.Client.InputController)

local Player = game.Players.LocalPlayer

Player.CharacterAdded:Connect(function(char)
	TeleportPlayer.init()
	ThrowModule.init()
	InputController.Initialize()
	ThrowController.Initialize()
end)
