local RS = game:GetService("ReplicatedStorage")
local TS = game:GetService("TweenService")
local SS = game:GetService("ServerStorage")

local BrainrotConfigModule = require(RS.Modules.Config.BrainrotConfig)
local PlayerService = require(SS.Modules.PlayerService)

local HitService = require(script.Parent.HitService)

local ThrowEvent = RS.Events.ThrowEvent

local module = {}

function module.InitializeHitbox(player, model: Model, duration)
	local char = player.Character

	local prms = OverlapParams.new()
	prms.FilterType = Enum.RaycastFilterType.Exclude
	prms.FilterDescendantsInstances = { workspace.Map, char }

	local st = tick()

	task.spawn(function()
		--HitboxModule.EnableVisualizer(true)

		while tick() - st < duration do
			local orientation, size = model:GetBoundingBox()
			local TouchingParts = workspace:GetPartBoundsInBox(model:GetPivot(), size, prms)

			local Targets = {}

			for _, part in TouchingParts do
				if
					part:FindFirstAncestorOfClass("Model")
					and part:FindFirstAncestorOfClass("Model"):FindFirstChildOfClass("Humanoid")
				then
					local humanoid = part:FindFirstAncestorOfClass("Model"):FindFirstChildOfClass("Humanoid")
					if not table.find(Targets, humanoid.Parent) then
						local tuple = {
							target = humanoid.Parent,
							direction = (model:GetPivot().Position - char.HumanoidRootPart.Position).Unit,
						}
						table.insert(Targets, tuple)
					end
				end
			end

			if Targets and #Targets > 0 then
				local data = {
					Targets = Targets,
					Message = "RegisteredHits",
				}
				HitService.RegisterHit(player, data)
			end

			task.wait()
		end

		--HitboxModule.EnableVisualizer(false)
	end)
end

function module.ThrowBrainrot(player)
	local char = player.Character

	local Brainrot = PlayerService.GetSelectedBrainrot(player)
	if not Brainrot then
		error("No Brainrot Selected or brainrot not found")
	end

	local BrainrotStats = BrainrotConfigModule.GetBrainrotStats(Brainrot)

	local ModelInstance: Model = RS.Models:FindFirstChild(Brainrot):Clone()
	local DIST_FROM_GROUND = ModelInstance:GetPivot().Y
	ModelInstance:PivotTo(char.HumanoidRootPart.CFrame * CFrame.new(0, -3 + DIST_FROM_GROUND, -2))
	ModelInstance.Parent = workspace.Brainrots

	local time = BrainrotStats.Distance / BrainrotStats.Speed

	local Tween = TS:Create(
		ModelInstance.PrimaryPart,
		TweenInfo.new(time),
		{ CFrame = char.HumanoidRootPart.CFrame * CFrame.new(0, 0, -BrainrotStats.Distance) }
	)
	Tween:Play()

	module.InitializeHitbox(player, ModelInstance, time)

	game.Debris:AddItem(ModelInstance, time)
end

function module.Initialize()
	ThrowEvent.OnServerEvent:Connect(function(player)
		module.ThrowBrainrot(player)
	end)
end

return module
