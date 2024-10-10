local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local startMinigameEvent = ReplicatedStorage:WaitForChild("Events"):WaitForChild("StartMinigame")
local announceEvent = ReplicatedStorage:WaitForChild("Events"):WaitForChild("AnnounceMinigame")

local minigames = {
	require(script.Parent:WaitForChild("SnakeGame")),
	require(script.Parent:WaitForChild("Race2")),
	require(script.Parent:WaitForChild("RaceGame")),
}
local currentMinigameIndex = 1

local function startMinigame(minigame)
	local minigameName = minigame.Name
	local minigameDescription = minigame.Description

	print("Iniciando minigame: " .. minigameName)

	--anuncia o minigame com nome e descrição
	if announceEvent then
		announceEvent:FireAllClients(minigameName, minigameDescription)
	end

	--conectar o evento OnEnd para iniciar o próximo minigame
	minigame.OnEnd.Event:Connect(function()
		print("Evento OnEnd disparado para " .. minigameName)
		wait(2)

		--atualizar o índice e iniciar o próximo minigame
		currentMinigameIndex = (currentMinigameIndex % #minigames) + 1
		startMinigame(minigames[currentMinigameIndex])
	end)

	--inicia o minigame
	minigame.Start()
end

--iniciar o primeiro minigame
startMinigame(minigames[currentMinigameIndex])
