local Players = game:GetService("Players")
local Debris = game:GetService("Debris")
local RunService = game:GetService("RunService")
local GameMaster = require(game.ServerScriptService.GameMaster)

local RaceGame = {}
RaceGame.OnEnd = Instance.new("BindableEvent")

function RaceGame.Initialize()
	RaceGame.Name = "RaceGame"
	RaceGame.Description = "Corra até a linha de chegada!"
	RaceGame.Author = "pixelar144"
	RaceGame.GameVersion = 1
	RaceGame.TypeGame = "FreeForAll"
	RaceGame.Maps = {"raceMap"}
end

-- Propriedades da corrida
local raceMap = workspace:FindFirstChild("raceMap")
local checkpointSize = Vector3.new(3, 1, 3) --tamanho dos checkpoints
local numCheckpoints = 2 --numero de checkpoints
local minigameDuration = 30 --duração máxima em segundos
local raceInProgress = false
local playersCompleted = {}


local function createCheckpoints()
	local checkpoints = {}
	for i = 1, numCheckpoints do
		local checkpoint = Instance.new("Part")
		checkpoint.Size = checkpointSize
		checkpoint.Anchored = true
		checkpoint.BrickColor = BrickColor.new("Bright yellow")
		checkpoint.Name = "Checkpoint" .. i

		local xRange = (raceMap.Size.X / 2) - 5
		local zRange = (raceMap.Size.Z / 2) - 5
		local randomPosX = math.random(-xRange, xRange)
		local randomPosZ = math.random(-zRange, zRange)

		checkpoint.Position = raceMap.Position + Vector3.new(randomPosX, 2, randomPosZ)
		checkpoint.Parent = workspace
		table.insert(checkpoints, checkpoint)
	end

	return checkpoints
end

local function playerTouchedCheckpoint(player, checkpoint)
	local character = player.Character
	if not character or not character:FindFirstChild("HumanoidRootPart") then return false end

	local distance = (character.HumanoidRootPart.Position - checkpoint.Position).Magnitude
	return distance < 5 --5 studs de tolerancia
end

local function resetPlayerAttributes(player)
	player:SetAttribute("TouchedCheckpoint1", false)
	player:SetAttribute("TouchedCheckpoint2", false)
end

local function teleportPlayersToStart()
	for _, player in ipairs(Players:GetPlayers()) do
		if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
			player.Character.HumanoidRootPart.CFrame = CFrame.new(raceMap.Position - Vector3.new(raceMap.Size.X / 2 - 5, 0, raceMap.Size.Z / 2 - 5))
			resetPlayerAttributes(player) --resetar atributos
		end
	end
end


--entrada
function RaceGame.Start()
	--criar checkpoints
	local checkpoints = createCheckpoints()
	if #checkpoints == 0 then
		warn("Sem checkpoints, minigame de corrida não pode iniciar.")
		return
	end

	--resetar o estado da partida
	raceInProgress = true
	playersCompleted = {}

	--teleportar os jogadores para o início
	teleportPlayersToStart()

	--timer do tempo máximo
	local remainingTime = minigameDuration
	local endMinigameTimer = RunService.Heartbeat:Connect(function(dt)
		remainingTime = remainingTime - dt
		if remainingTime <= 0 then
			raceInProgress = false
		end
	end)

	--main loop
	while raceInProgress do
		for _, player in ipairs(Players:GetPlayers()) do
			if player.Character and player.Character:FindFirstChild("HumanoidRootPart") and not playersCompleted[player] then
				--checkpoint 1
				if not player:GetAttribute("TouchedCheckpoint1") and playerTouchedCheckpoint(player, checkpoints[1]) then
					player:SetAttribute("TouchedCheckpoint1", true)
					GameMaster:CenterMessageLabelDisplay(player.Name .. " tocou o checkpoint 1!")
				end

				--checkpoint 2
				if player:GetAttribute("TouchedCheckpoint1") and not player:GetAttribute("TouchedCheckpoint2") and playerTouchedCheckpoint(player, checkpoints[2]) then
					player:SetAttribute("TouchedCheckpoint2", true)
					GameMaster:CenterMessageLabelDisplay(player.Name .. " tocou o checkpoint 2! Venceu a corrida!")
					playersCompleted[player] = true
				end
			end
		end

		if #playersCompleted == #Players:GetPlayers() or not raceInProgress then
			break
		end

		wait(0.1)
	end

	--limpar os checkpoints
	for _, checkpoint in ipairs(checkpoints) do
		checkpoint:Destroy()
	end

	--desconectar o timer
	endMinigameTimer:Disconnect()
	RaceGame.End()
end


function RaceGame.End()
	RaceGame.OnEnd:Fire() --bye
end

return RaceGame
