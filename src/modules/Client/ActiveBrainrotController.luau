local RS = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local ActiveBrainrot = require(script.Parent.ActiveBrainrot)
local RepEvent = RS.Events.RepEvent

local module = {
	Instance = nil,
}

local ActiveBrainrots = {}

function module.Initialize()
	RepEvent.OnClientEvent:Connect(function(data)
		if data.message then
			if data.message == "InitializeBrainrot" then
				module.InitializePlayer(data.plr, data)
			elseif data.message == "UpdateBrainrotScale" then
				module.Instance.ActiveBrainrot:UpgradeBrainrot(data.NewScale)
			end
		end
	end)
end

function module.InitializePlayer(player, data)
	module.Instance = ActiveBrainrot.init(player, data)
	local instance = module.Instance
	task.delay(3, function()
		for i = 1, 5 do
			instance:UpgradeBrainrot(instance.ActiveBrainrot:GetScale() + i / 10)
			task.wait(0.5)
		end
	end)
end

function module.IncreaseBrainrotSize(player) end

return module
