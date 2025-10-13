-- implement this, fire repevent and replicate brainrot in all clients
-- also check activebrainrotcontroller

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local RepEvent = ReplicatedStorage.Events:FindFirstChild("RepEvent")

local module = {}

function module.Initialize(player)
	if RepEvent then
		RepEvent:FireAllClients(player, "InitializeBrainrot", {
			SelectedBrainrot = player.Metadata.SelectedBrainrot.Value,
		})
	end
end

return module
