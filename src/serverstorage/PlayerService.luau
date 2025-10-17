local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local module = {}

function module.Initialize(player)
	local leaderstats = Instance.new("Folder")
	leaderstats.Name = "leaderstats"
	leaderstats.Parent = player

	local metadata = Instance.new("Folder")
	metadata.Name = "Metadata"
	metadata.Parent = player

	local SelectedBrainrot = Instance.new("StringValue")
	SelectedBrainrot.Name = "SelectedBrainrot"
	SelectedBrainrot.Value = "TungSahur"
	SelectedBrainrot.Parent = metadata
end

function module.GetSelectedBrainrot(player)
	local selectedBrainrot = player:FindFirstChild("Metadata") and player.Metadata:FindFirstChild("SelectedBrainrot")
	if selectedBrainrot then
		return selectedBrainrot.Value
	else
		warn("SelectedBrainrot not found for player: " .. player.Name)
		return nil
	end
end

return module
