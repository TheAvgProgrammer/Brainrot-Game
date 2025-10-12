local RS = game:GetService("ReplicatedStorage")

local BodyMoverHandler = require(RS.Modules.Misc.BodyMoverHandler)
local HitEvent = RS:WaitForChild("Events"):WaitForChild("HitEvent")

local module = {}

function module.RegisterHit(player, data)
	BodyMoverHandler.DestroyAllVelocities(player.Character)

	for _, tuple in pairs(data.Targets) do
		if tuple.target and tuple.target:FindFirstChildOfClass("Humanoid") then
			local humanoid = tuple.target:FindFirstChildOfClass("Humanoid")
			local direction = tuple.direction
			local target = tuple.target
			if humanoid and humanoid.Health > 0 then
				-- Apply knockback effect
				local knockbackVelocity = direction * 50 + Vector3.new(0, 30, 0) -- Adjust values as needed
				BodyMoverHandler.AddVelocity(target, knockbackVelocity, 0.3)
			end
		end
	end
end

function module.Initialize()
	HitEvent.OnServerEvent:Connect(function(player, data)
		module.RegisterHit(player, data)
	end)
end

return module
