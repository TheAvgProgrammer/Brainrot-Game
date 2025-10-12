local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local SignalModule = require(ReplicatedStorage.Packages.signal)

local UsedKeybinds = {
	[Enum.KeyCode.Q] = "nil",
}

local module = {}

function module.Initialize()
	for key, _ in pairs(UsedKeybinds) do
		UsedKeybinds[key] = SignalModule.new()
	end

	UserInputService.InputBegan:Connect(function(input, gameProcessed)
		if gameProcessed then
			return
		end

		local signal = UsedKeybinds[input.KeyCode]
		if signal then
			print("Input Began")
			signal:Fire("InputBegan", input.KeyCode)
		end
	end)

	UserInputService.InputEnded:Connect(function(input, gameProcessed)
		if gameProcessed then
			return
		end
		local signal = UsedKeybinds[input.KeyCode]
		if signal then
			signal:Fire("InputEnded", input.KeyCode)
		end
	end)
end

function module.GetSignal(keyCode)
	return UsedKeybinds[keyCode]
end

function module.GetSignals()
	return UsedKeybinds
end

return module
