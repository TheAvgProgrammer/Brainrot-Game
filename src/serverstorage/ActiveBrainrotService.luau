local ReplicatedStorage = game:GetService("ReplicatedStorage")

local RepEvent = ReplicatedStorage.Events:FindFirstChild("RepEvent")

local module = {}

local playerRotScales = {}

function module.IncreasePlayerScale(player, scale)
	local currentScale = playerRotScales[player.UserId] or 1.0
	local newScale = currentScale + scale
	playerRotScales[player.UserId] = newScale

	if RepEvent then
		RepEvent:FireClient(player, {
			message = "UpdateBrainrotScale",
			NewScale = newScale,
		})
	end
end

function module.Initialize(player)
	if RepEvent then
		RepEvent:FireAllClients({
			plr = player,
			message = "InitializeBrainrot",
			SelectedBrainrot = player.Metadata.SelectedBrainrot.Value,
		})
	end

	playerRotScales[player.UserId] = 1.0
end

return module
