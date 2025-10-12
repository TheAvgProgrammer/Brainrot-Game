local module = {}

function module.AddVelocity(character, velocity, time)
	local hrp = character:FindFirstChild("HumanoidRootPart")
	if hrp then
		local bodyVelocity = Instance.new("BodyVelocity")
		bodyVelocity.Velocity = velocity
		bodyVelocity.MaxForce = Vector3.new(1e5, 1e5, 1e5)
		bodyVelocity.P = 1e4
		bodyVelocity.Parent = hrp

		-- Remove the BodyVelocity after a short duration to prevent continuous movement
		game:GetService("Debris"):AddItem(bodyVelocity, time or 0.5)
	end
end

function module.DestroyAllVelocities(character)
	local hrp = character:FindFirstChild("HumanoidRootPart")
	if hrp then
		for _, bv in pairs(hrp:GetChildren()) do
			if bv:IsA("BodyMover") then
				bv:Destroy()
			end
		end
	end
end

return module
