local Players = game:GetService("Players")
local TS = game:GetService("TweenService")
local RS = game:GetService("ReplicatedStorage")

-- local HitboxModule = require(script.Parent.HitboxVisualizer)
local SignalModule = require(RS.Packages.signal)
local InputController = require(RS.Modules.Client.InputController)

local ThrowEvent = RS.Events.ThrowEvent
local HitEvent = RS.Events.HitEvent

local DIST_FROM_GROUND = 1

local module = {}

function module.ThrowBrainrot()
	ThrowEvent:FireServer()
end

function module.Initialize()
	local QSignal = InputController.GetSignal(Enum.KeyCode.Q)
	QSignal:Connect(function(message)
		local char = Players.LocalPlayer.Character
		if char and char:FindFirstChildOfClass("Humanoid") and char.Humanoid.Health > 0 then
			module.ThrowBrainrot()
		end
	end)
end

return module
