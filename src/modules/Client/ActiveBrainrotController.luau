local RS = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local RepEvent = RS.Events.RepEvent

local PlayerService = require(SS.Modules.PlayerService)
local module = {}

local ActiveBrainrots = {}

function onHeartbeat(player)
	RunService.Heartbeat:Connect(function(deltaTime)
		module.UpdateBrainrotPosition(player, deltaTime)
	end)
end

function module.Initialize()
	RepEvent.OnClientEvent:Connect(function(plr, message)
		if message == "InitializeBrainrot" then
			module.UpdateBrainrotPosition(plr) -- immediate update
		end
	end)
end

function module.InitializePlayer(player)
	local BrainrotName = PlayerService.GetSelectedBrainrot(player)
	if not BrainrotName then
		error("No Brainrot Selected or brainrot not found")
	end

	local Model: Model = RS.Models:FindFirstChild(BrainrotName):Clone()
	Model.Parent = player.Character
	Model.PrimaryPart.Anchored = true -- We'll manually position it

	ActiveBrainrots[player] = {
		Model = Model,
		FloatOffset = math.random() * 2 * math.pi, -- randomize float phase
	}

	onHeartbeat(player)
end

function module.UpdateBrainrotPosition(player, deltaTime)
	local data = ActiveBrainrots[player]
	if not data then
		return
	end

	local Model = data.Model
	if not Model or not Model.PrimaryPart or not player.Character then
		return
	end

	local hrp = player.Character:FindFirstChild("HumanoidRootPart")
	if not hrp then
		return
	end

	-- Fixed offset relative to player (to their top-right)
	local offset = Vector3.new(2, 3, 0) -- (X=right, Y=up, Z=front/back)

	-- Floating motion
	local floatSpeed = 2
	local floatAmplitude = 0.5
	local floatY = math.sin(tick() * floatSpeed + data.FloatOffset) * floatAmplitude

	-- Compute target position
	local targetPos = hrp.Position + offset + Vector3.new(0, floatY, 0)

	-- Smoothly interpolate (lerp) for clean motion
	local currentPos = Model.PrimaryPart.Position
	local newPos = currentPos:Lerp(targetPos, 0.1) -- smaller = smoother

	-- Face same direction as player
	local targetCFrame = CFrame.new(newPos) * CFrame.Angles(0, hrp.Orientation.Y * math.pi / 180, 0)
	Model:SetPrimaryPartCFrame(targetCFrame)
end

return module
