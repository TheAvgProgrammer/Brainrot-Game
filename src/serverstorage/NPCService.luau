local module = {}

local PathfindingService = game:GetService("PathfindingService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local RunService = game:GetService("RunService")

-- CONFIGURATION
local NUM_NPCS = 40
local SPAWN_PART = workspace:WaitForChild("NPCSpawn"):WaitForChild("SpawnPart")
local NPC_MODEL = ReplicatedStorage.Models.NPCs.Rig -- Your NPC template model
local MAP_BOUNDS = workspace:WaitForChild("NPCSpawn").SpawnPart -- optional part to limit wander area

local function getRandomPointInPart(part)
	local size = part.Size
	local pos = part.Position
	return Vector3.new(pos.X + (math.random() - 0.5) * size.X, pos.Y, pos.Z + (math.random() - 0.5) * size.Z)
end

local function startWandering(npc)
	local humanoid = npc:FindFirstChildOfClass("Humanoid")
	local hrp = npc:WaitForChild("HumanoidRootPart")

	-- ✅ Setup humanoid movement
	humanoid.WalkSpeed = 16
	humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping, false)
	humanoid:SetStateEnabled(Enum.HumanoidStateType.Climbing, false)
	humanoid:ChangeState(Enum.HumanoidStateType.Running)

	-- ✅ Optional: custom animation
	local animator = humanoid:FindFirstChildOfClass("Animator") or Instance.new("Animator", humanoid)
	local runAnim = Instance.new("Animation")
	runAnim.AnimationId = "http://www.roblox.com/asset/?id=507767714"
	local track = animator:LoadAnimation(runAnim)
	track.Looped = true
	track:Play()

	task.spawn(function()
		while npc.Parent do
			local randomPos = getRandomPointInPart(MAP_BOUNDS or SPAWN_PART)
			local path = PathfindingService:CreatePath()
			path:ComputeAsync(hrp.Position, randomPos)

			if path.Status == Enum.PathStatus.Success then
				for _, waypoint in path:GetWaypoints() do
					humanoid:MoveTo(waypoint.Position)
					humanoid.MoveToFinished:Wait()
				end
			end

			task.wait(math.random(2, 5))
		end
	end)
end

function module.Initialize()
	for i = 1, NUM_NPCS do
		local npc = NPC_MODEL:Clone()
		npc.Parent = workspace
		-- ✅ Spawn above ground and spaced apart
		npc:MoveTo(getRandomPointInPart(SPAWN_PART) + Vector3.new(math.random(-3, 3), 3, math.random(-3, 3)))
		startWandering(npc)
	end
end

return module
