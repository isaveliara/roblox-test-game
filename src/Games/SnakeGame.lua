local Players = game:GetService("Players")
local Debris = game:GetService("Debris")

local SnakeGame = {}
SnakeGame.OnEnd = Instance.new("BindableEvent")

--configurações do jogo
local gameSettings = {
	MinesToWin = 20,
	TailIncrease = 0.2,
	MineLifetime = 10,
	MineDelay = 0.5
}

--propriedades do minigame
SnakeGame.Name = "SnakeGame"
SnakeGame.Description = "Evite as minas e colecione pontos!"

--spawnar uma mina
local function spawnMine(player)
	if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then return end

	local mine = Instance.new("Part")
	mine.Size = Vector3.new(2, 1, 2)
	mine.Position = player.Character.HumanoidRootPart.Position - Vector3.new(0, 2, 0)
	mine.Anchored = true
	mine.BrickColor = BrickColor.new("Bright red")
	mine.Parent = workspace

	--destruir a mina após o tempo
	Debris:AddItem(mine, gameSettings.MineLifetime)

	--verifica se o atributo "MinesPlanted" está definido e incrementa
	local minesPlanted = player:GetAttribute("MinesPlanted") or 0
	player:SetAttribute("MinesPlanted", minesPlanted + 1)
end

--oniciar Snake
function SnakeGame.Start()
	--anuncia o minigame com o nome e descrição
	local ReplicatedStorage = game:GetService("ReplicatedStorage")
	local announceEvent = ReplicatedStorage:WaitForChild("Events"):WaitForChild("AnnounceMinigame")
	announceEvent:FireAllClients(SnakeGame.Name, SnakeGame.Description)

	for _, player in ipairs(Players:GetPlayers()) do
		player:SetAttribute("MinesPlanted", 0)
		player:SetAttribute("TailLength", 0)
	end

	local gameLoop = true

	while gameLoop do
		for _, player in ipairs(Players:GetPlayers()) do
			if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
				spawnMine(player)

				local tailLength = player:GetAttribute("MinesPlanted") * gameSettings.TailIncrease
				player:SetAttribute("TailLength", tailLength)

				if player:GetAttribute("MinesPlanted") >= gameSettings.MinesToWin then
					print(player.Name .. " venceu o Snake!")
					gameLoop = false
					break
				end
			end
		end
		wait(gameSettings.MineDelay)
	end

	print("snake (na função Start) terminou!") --mensagem de debug para indicar o término da função
	if SnakeGame.OnEnd then
		SnakeGame.OnEnd:Fire() --sinaliza o fim do minigame
		print("Evento OnEnd disparado")
	else
		warn("Evento OnEnd não encontrado!")
	end
end

return SnakeGame
