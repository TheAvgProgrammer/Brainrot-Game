local module = {}

local Brainrots = {}

function module.GetBrainrotDetails(name)
	return require(script.Parent.Brainrots:FindFirstChild(name))
end

function module.GetBrainrotStats(name)
	return require(script.Parent.Brainrots:FindFirstChild(name)).Stats
end

function module.GetAllBrainrots()
	return script.Parent.Brainrots:GetChildren()
end

return module
