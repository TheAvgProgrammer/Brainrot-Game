local RS = game:GetService("ReplicatedStorage")
local Remote = RS.Events.RepEvent

local Player = game.Players.LocalPlayer

local module = {}

function module.Initialize()
	-- Remote.OnClientEvent:Connect(function(data)
	-- 	if data.message and data.message == "SpawnBrains" then
	-- 		local BrainModel = RS.Models.Brain:Clone()
	-- 		module.SpawnBrains(BrainModel, data.numberBrains)
	-- 	end
	-- end)
end

return module
