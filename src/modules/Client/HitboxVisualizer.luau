local TS = game:GetService("TweenService")
local RS = game:GetService("ReplicatedStorage")

local DIST_FROM_GROUND = 1
local module = {}

-- Debug toggle
local showVisualizer = false

-- Function to enable/disable visualizer externally
function module.EnableVisualizer(state: boolean)
	showVisualizer = state
end

-- Create a hitbox visualizer part
local function createVisualizer(size, cframe)
	local part = Instance.new("Part")
	part.Anchored = true
	part.CanCollide = false
	part.Material = Enum.Material.Neon
	part.Color = Color3.fromRGB(255, 0, 0)
	part.Transparency = 0.6
	part.Size = size
	part.CFrame = cframe
	part.Name = "HitboxVisualizer"
	part.Parent = workspace
	return part
end

function module.InitializeHitbox(char, model: Model, duration)
	local prms = OverlapParams.new()
	prms.FilterType = Enum.RaycastFilterType.Exclude
	prms.FilterDescendantsInstances = { workspace.Map, char }

	local st = tick()

	task.spawn(function()
		local visualizer
		if showVisualizer then
			local _, size = model:GetBoundingBox()
			visualizer = createVisualizer(size, model:GetPivot())
		end

		while tick() - st < duration do
			local orientation, size = model:GetBoundingBox()
			local TouchingParts = workspace:GetPartBoundsInBox(model:GetPivot(), size, prms)

			if visualizer then
				visualizer.Size = size
				visualizer.CFrame = model:GetPivot()
			end

			local Targets = {}
			for _, part in TouchingParts do
				local ancestorModel = part:FindFirstAncestorOfClass("Model")
				local humanoid = ancestorModel and ancestorModel:FindFirstChildOfClass("Humanoid")
				if humanoid then
					table.insert(Targets, humanoid.Parent)
				end
			end

			print(Targets)
			task.wait()
		end

		if visualizer then
			visualizer:Destroy()
		end
	end)
end

function module.ThrowBrainrot(char, model, distance, speed)
	local ModelInstance = RS.Models:FindFirstChild(model):Clone()
	ModelInstance:PivotTo(char.HumanoidRootPart.CFrame * CFrame.new(0, 0, -2))
	ModelInstance.Parent = workspace.Brainrots
	local time = distance / speed

	local Tween = TS:Create(
		ModelInstance.PrimaryPart,
		TweenInfo.new(time),
		{ CFrame = char.HumanoidRootPart.CFrame * CFrame.new(0, DIST_FROM_GROUND, -distance) }
	)
	Tween:Play()

	module.InitializeHitbox(char, ModelInstance, time)

	game.Debris:AddItem(ModelInstance, time)
end

return module
