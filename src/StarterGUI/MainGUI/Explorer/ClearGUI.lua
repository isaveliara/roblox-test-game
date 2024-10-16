local Players = game:GetService("Players")
local player = Players.LocalPlayer
local startButton = script.Parent
local startedPlayers = {}

startButton.MouseButton1Click:Connect(function()
	local playerGui = game.Players.LocalPlayer:WaitForChild("PlayerGui")

	for _, gui in ipairs(playerGui:GetChildren()) do
		if gui:IsA("ScreenGui") then
			gui:Destroy()
		end
	end
end)
