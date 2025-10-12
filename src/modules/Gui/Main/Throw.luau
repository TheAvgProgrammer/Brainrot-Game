local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local ThrowModule = require(ReplicatedStorage.Modules.Client.ThrowController)

local module = {}

function onButtonClicked(char)
	ThrowModule.ThrowBrainrot()
end

function module.init()
	local Player = game.Players.LocalPlayer
	local Gui = Player.PlayerGui
	local Char = Player.Character

	local Button = Gui.MainUI.Frame.Throw

	Button.MouseButton1Click:Connect(function()
		onButtonClicked(Char)
	end)
end

return module
