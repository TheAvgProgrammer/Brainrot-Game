local Workspace = game:GetService("Workspace")
local TeleportPlayer = require(game.ReplicatedStorage.Modules.Misc.TeleportPlayer)
local ThrowModule = require(game.ReplicatedStorage.Modules.Gui.Main.Throw)
local ThrowController = require(game.ReplicatedStorage.Modules.Client.ThrowController)
local InputController = require(game.ReplicatedStorage.Modules.Client.InputController)
local ActiveBrainrotController = require(game.ReplicatedStorage.Modules.Client.ActiveBrainrotController)
local Currencies = require(game.ReplicatedStorage.Modules.Gui.HUD.Currencies)
local BrainController = require(game.ReplicatedStorage.Modules.Client.BrainsController)

local Player = game.Players.LocalPlayer or game.Players.PlayerAdded:Wait()

Currencies.Init()
-- BrainController.Initialize()

local InitializedCharModules = false

function InitializeCharacterModules(character)
	TeleportPlayer.init()
	ThrowModule.init()
	InputController.Initialize()
	ThrowController.Initialize()
	ActiveBrainrotController.Initialize()
end

Player.CharacterAdded:Connect(function(char)
	if not InitializedCharModules then
		InitializeCharacterModules(char)
		InitializedCharModules = true
	end
end)

if Player.Character then
	InitializeCharacterModules(Player.Character)
	InitializedCharModules = true
end
