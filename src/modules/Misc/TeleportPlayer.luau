-- should be called after the character loads
local Player = game.Players.LocalPlayer
local PlayerGui = Player.PlayerGui

local tp = {}

function teleportPlayerToSpawn(char: Model)
	char:PivotTo(workspace.SpawnLocation.CFrame * CFrame.new(0, 2, 0))
end

function teleportPlayerToArena(char)
	char:PivotTo(workspace.Map["Protect the Statue (Easter Island)"].SpawnPart.CFrame * CFrame.new(0, 2, 0))
end

function tp.TeleportPlayer(char, location: string)
	if location == "Arena" then
		teleportPlayerToArena(char)
	else
		teleportPlayerToSpawn(char)
	end
end

function tp.init()
	local TpButton = PlayerGui.MainUI.Frame:FindFirstChild("Teleport ")
	TpButton.TextLabel.Text = "Teleport to Arena"
	if TpButton then
		TpButton.MouseButton1Click:Connect(function()
			if TpButton.TextLabel.Text == "Teleport to Arena" then
				tp.TeleportPlayer(Player.Character, "Arena")
				TpButton.TextLabel.Text = "Teleport to Spawn"
			else
				tp.TeleportPlayer(Player.Character, "Spawn")
				TpButton.TextLabel.Text = "Teleport to Arena"
			end
		end)
	end

	Player.CharacterAdded:Connect(function(char)
		tp.TeleportPlayer(char, "Spawn")
	end)
end

return tp
