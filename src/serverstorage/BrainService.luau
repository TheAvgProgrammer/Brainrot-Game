local RS = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local CurrencyService = require(script.Parent.CurrencyService)

local Remote = RS.Events.RepEvent

local module = {}

function onBrainTouched(touchedPart, brain)
	local TouchedCharacter = touchedPart:FindFirstAncestorOfClass("Model")
	print("Brain touched by ", TouchedCharacter.Name)
	print("Checking for humanoid in ", TouchedCharacter:FindFirstChildOfClass("Humanoid"))
	print("Player from character: ", game.Players:GetPlayerFromCharacter(TouchedCharacter))

	if
		TouchedCharacter
		and TouchedCharacter:FindFirstChildOfClass("Humanoid")
		and game.Players:GetPlayerFromCharacter(TouchedCharacter)
	then
		print("Brain collected by ", game.Players:GetPlayerFromCharacter(TouchedCharacter).Name)
		CurrencyService.AddCurrency(game.Players:GetPlayerFromCharacter(TouchedCharacter), "RotPoints", 1)
		brain:Destroy()
	end
end

function module.SpawnBrains(part, number)
	for i = 1, number do
		local brain = RS.Models.Brain:Clone()
		brain.Position = part.Position
			+ Vector3.new(
				math.random(-part.Position.X, part.Position.X),
				1,
				math.random(-part.Position.Z, part.Position.Z)
			)
		brain.Parent = workspace
		brain.Anchored = true
		brain.CanCollide = false
		brain.Name = "Brain"

		RunService.Heartbeat:Connect(function(dt)
			local currentOrientation = brain.Orientation
			local targetY = currentOrientation.Y + math.random(30, 179) * dt
			brain.Orientation = Vector3.new(currentOrientation.X, targetY, currentOrientation.Z)
		end)

		local TouchedOnce = false
		brain.Touched:Connect(function(otherPart)
			if not TouchedOnce then
				onBrainTouched(otherPart, brain)
				TouchedOnce = true
			end
		end)
	end
end

function module.Initialize()
	game.Players.PlayerAdded:Connect(function(player)
		Remote:FireAllClients({ message = "SpawnBrains", numberBrains = 100 })
	end)

	module.SpawnBrains(workspace.Map["Protect the Statue (Easter Island)"].SpawnPart, 100)
end

return module
