local TeleportPlayer = require(game.ReplicatedStorage.Modules.Misc.TeleportPlayer)
local ThrowModule = require(game.ReplicatedStorage.Modules.Gui.Main.Throw)

local Player = game.Players.LocalPlayer

Player.CharacterAdded:Connect(function(char)
	TeleportPlayer.init()
	ThrowModule.init()
end)
