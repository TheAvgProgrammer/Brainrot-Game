local RS = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local module = {}

function module.init(player, data)
	local self = setmetatable({}, { __index = module })

	local BrainrotName = data.SelectedBrainrot

	if not BrainrotName then
		error("No Brainrot Selected or brainrot not found")
	end

	self.player = player
	self.ActiveBrainrot = nil
	self.FloatOffset = math.random() * 2 * math.pi
	self.FxPart = nil

	self:SetNewBrainrot(BrainrotName)
	self:onHeartbeat(player)

	return self
end

function module:SetNewBrainrot(brainrotName: string)
	local Model: Model = RS.Models:FindFirstChild(brainrotName):Clone()
	Model.Parent = self.player.Character
	Model.PrimaryPart.Anchored = true -- We'll manually position it

	local Fx = RS.Models.LevelUp:Clone()
	Fx.Parent = Model.VfxInstance

	local Weld = Instance.new("WeldConstraint", Fx)
	Weld.Part0 = Model.VfxInstance
	Weld.Part1 = Fx

	self.FxPart = Fx
	self.ActiveBrainrot = Model
end

function module:onHeartbeat(player)
	RunService.Heartbeat:Connect(function(deltaTime)
		self:UpdateBrainrotPosition(player, deltaTime)
	end)
end

function module:UpdateBrainrotPosition(player, deltaTime)
	local Model = self.ActiveBrainrot
	if not Model then
		return
	end

	if not Model.PrimaryPart or not player.Character then
		return
	end

	local hrp = player.Character:FindFirstChild("HumanoidRootPart")
	if not hrp then
		return
	end

	-- Fixed offset relative to player (to their top-right)
	local offset = Vector3.new(2.5, 1.5, 0) -- (X=right, Y=up, Z=front/back)

	-- Floating motion
	local floatSpeed = 2
	local floatAmplitude = 0.5
	local floatY = math.sin(tick() * floatSpeed + self.FloatOffset) * floatAmplitude

	-- Compute target position
	local targetPos = hrp.Position + offset + Vector3.new(0, floatY, 0)

	-- Smoothly interpolate (lerp) for clean motion
	local currentPos = Model.PrimaryPart.Position
	local newPos = currentPos:Lerp(targetPos, 0.1) -- smaller = smoother

	-- Face same direction as player
	local targetCFrame = CFrame.new(newPos) * CFrame.Angles(0, hrp.Orientation.Y * math.pi / 180, 0)
	Model:SetPrimaryPartCFrame(targetCFrame)
end

function module:UpgradeBrainrot(scale)
	local data = self.ActiveBrainrot

	self:IncreaseSize(scale)
	self:PlayFx()
end

function module:IncreaseSize(scale)
	local model: Model = self.ActiveBrainrot
	self:TweenScale(model:GetScale(), scale, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), model)
	self:PlayFx()
end

function module:PlayFx()
	for _, fx in pairs(self.FxPart:GetDescendants()) do
		if fx:IsA("ParticleEmitter") then
			fx:Emit(fx:GetAttribute("EmitCount"))
		end
	end
end

function module:TweenScale(startScale: number, endScale: number, tweenInfo: TweenInfo, model: Model)
	local elapsed = 0
	local scale = 0
	local tweenConnection

	local function onStep(deltaTime: number)
		elapsed = math.min(elapsed + deltaTime, tweenInfo.Time)

		local alpha = TweenService:GetValue(elapsed / tweenInfo.Time, tweenInfo.EasingStyle, tweenInfo.EasingDirection)

		scale = startScale + alpha * (endScale - startScale)

		model:ScaleTo(scale)

		if elapsed == tweenInfo.Time then
			tweenConnection:Disconnect()
		end
	end

	tweenConnection = RunService.Heartbeat:Connect(onStep)
end

return module
