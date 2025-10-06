local TS = game:GetService("TweenService")
local RS = game:GetService("ReplicatedStorage")

local DIST_FROM_GROUND = 1

local module = {}

function module.ThrowBrainrot(char, model, distance, speed)
	local ModelInstance = RS.Models:FindFirstChild(model):Clone()
	ModelInstance.PrimaryPart.CFrame = char.HumanoidRootPart.CFrame * CFrame.new(0, 0, -2)
	ModelInstance.Parent = workspace.Brainrots
	local time = distance / speed

	local Tween = TS:Create(
		ModelInstance.PrimaryPart,
		TweenInfo.new(time),
		{ CFrame = char.HumanoidRootPart.CFrame * CFrame.new(0, DIST_FROM_GROUND, -distance) }
	)
	Tween:Play()
end

return module
