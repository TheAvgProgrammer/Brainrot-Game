local ReplicatedStorage = game:GetService("ReplicatedStorage")

local RepEvent = ReplicatedStorage.Events:FindFirstChild("RepEvent")

local module = {}

function module.Initialize(player)
	if RepEvent then
		RepEvent:FireAllClients({
			plr = player,
			message = "InitializeBrainrot",
			SelectedBrainrot = player.Metadata.SelectedBrainrot.Value,
		})
	end
end

return module
