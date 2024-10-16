local Players = game:GetService("Players")
local player = Players.LocalPlayer
local startButton = script.Parent
local startedPlayers = {}

startButton.MouseButton1Click:Connect(function()
	if not startedPlayers[player.UserId] then
		startedPlayers[player.UserId] = player
		print(player.Name .. " começou o jogo!")

		player:SetAttribute("InGame", true)
		
		local playerGui = game.Players.LocalPlayer:WaitForChild("PlayerGui")

		for _, gui in ipairs(playerGui:GetChildren()) do
			if gui:IsA("ScreenGui") then
				gui:Destroy()
			end
		end
	end
end)
