local RS = game:GetService("ReplicatedStorage")

local CurrencyEvent = RS.Events.CurrencyUpdate

local module = {}

local playercurrencies = {}

function module.Initialize(player)
	playercurrencies[player.UserId] = {
		RotPoints = 0,
		Coins = 0,
	}
end

function module.GetPlayerCoins(player)
	local userCurrencies = playercurrencies[player.UserId]
	if userCurrencies then
		return userCurrencies.Coins
	else
		return 0
	end
end

function module.GetPlayerRotPoints(player)
	local userCurrencies = playercurrencies[player.UserId]
	if userCurrencies then
		return userCurrencies.RotPoints
	else
		return 0
	end
end

function module.AddCurrency(player, name, value)
	local userCurrencies = playercurrencies[player.UserId]
	if userCurrencies then
		userCurrencies[name] = userCurrencies[name] + value
		userCurrencies[name] = math.max(0, userCurrencies[name]) -- Prevent negative currency

		local dataToSend = {
			message = "CurrencyUpdate",
			RotPoints = userCurrencies.RotPoints,
			Coins = userCurrencies.Coins,
		}

		CurrencyEvent:InvokeClient(player, dataToSend)
	end
end

CurrencyEvent.OnServerInvoke = function(player, data)
	local userCurrencies = playercurrencies[player.UserId]
	if userCurrencies and data.message == "CurrencyRequest" then
		return {
			RotPoints = userCurrencies.RotPoints,
			Coins = userCurrencies.Coins,
		}
	else
		error("No currency data found for player: " .. player.Name)
	end
end

return module
