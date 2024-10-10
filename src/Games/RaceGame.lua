local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Debris = game:GetService("Debris")

local RaceGame = {}
RaceGame.OnEnd = Instance.new("BindableEvent")

--propriedades do minigame
RaceGame.Name = "RaceGame"
RaceGame.Description = "Corra até a linha de chegada!"

--configurações da corrida
local raceMap = workspace:FindFirstChild("raceMap")
local checkpointSize = Vector3.new(3, 1, 3) --tamanho dos checkpoints
local numCheckpoints = 2 --número de checkpoints
local minigameDuration = 60 --duração máxima do minigame (segundos)

local function announceMinigame(minigameName)
	local message = Instance.new("Message")
	message.Text = "Próximo minigame: " .. minigameName
	message.Parent = workspace

	--remove a mensagem após 5 segundos
	Debris:AddItem(message, 5)
end

--criar checkpoints
local function createCheckpoints()
	if not raceMap then
		warn("Mapa de corrida 'raceMap' não encontrado!")
		return {}
	end

	--gerar checkpoints
	local checkpoints = {}
	for i = 1, numCheckpoints do
		local checkpoint = Instance.new("Part")
		checkpoint.Size = checkpointSize
		checkpoint.Anchored = true
		checkpoint.BrickColor = BrickColor.new("Bright yellow")
		checkpoint.Name = "Checkpoint" .. i

		--posição aleatória
		local xRange = (raceMap.Size.X / 2) - 5 --adiciona 5 studs
		local zRange = (raceMap.Size.Z / 2) - 5
		local randomPosX = math.random(-xRange, xRange)
		local randomPosZ = math.random(-zRange, zRange)

		checkpoint.Position = raceMap.Position + Vector3.new(randomPosX, 2, randomPosZ)
		checkpoint.Parent = workspace
		table.insert(checkpoints, checkpoint)
	end

	return checkpoints
end

--verificar se o jogador tocou o checkpoint
local function playerTouchedCheckpoint(player, checkpoint)
	local character = player.Character
	if not character or not character:FindFirstChild("HumanoidRootPart") then return false end

	local distance = (character.HumanoidRootPart.Position - checkpoint.Position).Magnitude
	return distance < 5 --tolerância de 5 studs para considerar que tocou
end

--iniciar o minigame de corrida
function RaceGame.Start()
	--anuncia o minigame
	announceMinigame(RaceGame.Name)

	--criar checkpoints
	local checkpoints = createCheckpoints()
	if #checkpoints == 0 then
		warn("Sem checkpoints, minigame de corrida não pode iniciar.")
		return
	end

	--teleportar os jogadores para a linha de partida
	for _, player in ipairs(Players:GetPlayers()) do
		if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
			player.Character.HumanoidRootPart.CFrame = CFrame.new(raceMap.Position - Vector3.new(raceMap.Size.X / 2 - 5, 0, raceMap.Size.Z / 2 - 5))
		end
	end

	local raceInProgress = true
	local playersCompleted = {}

	--timer para encerrar o minigame automaticamente após o tempo máximo definido
	local endMinigameTimer = game:GetService("RunService").Stepped:Connect(function(_, dt)
		minigameDuration = minigameDuration - dt
		if minigameDuration <= 0 then
			raceInProgress = false
		end
	end)

	--loop do minigame
	while raceInProgress do
		for _, player in ipairs(Players:GetPlayers()) do
			if player.Character and player.Character:FindFirstChild("HumanoidRootPart") and not playersCompleted[player] then
				--checkpoint 1
				if not player:GetAttribute("TouchedCheckpoint1") then
					if playerTouchedCheckpoint(player, checkpoints[1]) then
						player:SetAttribute("TouchedCheckpoint1", true)
						print(player.Name .. " tocou o checkpoint 1!")
					end
					--checkpoint 2
				elseif not player:GetAttribute("TouchedCheckpoint2") then
					if playerTouchedCheckpoint(player, checkpoints[2]) then
						player:SetAttribute("TouchedCheckpoint2", true)
						print(player.Name .. " tocou o checkpoint 2!")
						print(player.Name .. " venceu a corrida!")
						playersCompleted[player] = true
					end
				end
			end
		end

		--checar se todos os jogadores completaram ou o tempo acabou
		if #playersCompleted == #Players:GetPlayers() or not raceInProgress then
			break
		end

		wait(0.1)
	end

	--limpar os checkpoints
	for _, checkpoint in ipairs(checkpoints) do
		checkpoint:Destroy()
	end

	--finalizar o minigame
	endMinigameTimer:Disconnect()
	RaceGame.OnEnd:Fire() --sinaliza o fim do minigame
end

return RaceGame
