local RS = game:GetService("ReplicatedStorage")

local Player = game.Players.LocalPlayer
local Gui = Player.PlayerGui

local HUD = Gui:WaitForChild("MainUI"):WaitForChild("HUD")
local RotPoints = HUD.RotPoints.TextLabel
local Gold = HUD.Gold.TextLabel

local CurrencyUpdate = RS.Events.CurrencyUpdate

local module = {}

function module.UpdateCurrencyGui(currencytable)
	RotPoints.Text = currencytable.RotPoints
	Gold.Text = currencytable.Coins
end

function module.Init()
	CurrencyUpdate.OnClientInvoke = function(data)
		if data.message == "CurrencyUpdate" then
			module.UpdateCurrencyGui(data)
		end
	end

	local Currency = CurrencyUpdate:InvokeServer({ message = "CurrencyRequest" })
	module.UpdateCurrencyGui(Currency)
end

return module
