local Players = game:GetService("Players")
local Debris = game:GetService("Debris")

local SnakeGame = {}
SnakeGame.OnEnd = Instance.new("BindableEvent")

--configurações do jogo
local gameSettings = {
	MinesToWin = 80, --o objetivo é plantar 80 minas
	TailIncrease = 0.2,
	MineLifetime = 10, --tempo total de vida da mina
	MineDelay = 0.5, --delay entre a plantação de minas
	MineColorNormal = Color3.new(1, 1, 1), --cor normal da mina (branca)
	MineColorWarning = Color3.new(1, 0, 0), --cor de alerta (vermelha)
	MineWarningDuration = 4 --duração antes da mina explodir após mudar de cor
}

--propriedades do minigame
SnakeGame.Name = "SnakeGame"
SnakeGame.Description = "Plante 80 minas, mas cuidado! Elas podem explodir!"

local function spawnMine(player)
	if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then return end

	local mine = Instance.new("Part")
	mine.Size = Vector3.new(2, 1, 2)
	mine.Position = player.Character.HumanoidRootPart.Position - Vector3.new(0, 2, 0)
	mine.Anchored = false -- As minas não estarão ancoradas para permitir a gravidade
	mine.BrickColor = BrickColor.new(gameSettings.MineColorNormal) --cor normal da mina
	mine.Parent = workspace

	--adiciona física à mina
	local bodyVelocity = Instance.new("BodyVelocity")
	bodyVelocity.Velocity = Vector3.new(0, -10, 0) --ajuste a velocidade de queda se necessário
	bodyVelocity.MaxForce = Vector3.new(0, math.huge, 0) --permitir que a mina caia
	bodyVelocity.Parent = mine

	--incrementa o número de minas plantadas
	local minesPlanted = player:GetAttribute("MinesPlanted") or 0
	player:SetAttribute("MinesPlanted", minesPlanted + 1)

	--inicia a contagem para a mudança de cor e a explosão
	task.delay(gameSettings.MineLifetime, function()
		--se a mina ainda existir, mude para a cor de alerta
		if mine then
			mine.BrickColor = BrickColor.new(gameSettings.MineColorWarning) --muda para a cor de alerta

			--espera pela duração do aviso antes de explodir
			wait(gameSettings.MineWarningDuration)

			--verifica se a mina ainda existe antes de explodir
			if mine then
				local explosion = Instance.new("Explosion")
				explosion.Position = mine.Position
				explosion.BlastRadius = 5 --define o raio da explosão
				explosion.BlastPressure = 5000 --define a pressão da explosão
				explosion.Parent = workspace

				mine:Destroy() --destroi a mina após a explosão
			end
		end
	end)

	--adiciona uma colisão na mina para verificar explosão
	mine.Touched:Connect(function(hit)
		local character = hit.Parent
		local humanoid = character:FindFirstChildOfClass("Humanoid")

		--verifica se a mina está na cor de alerta
		if humanoid and mine.BrickColor.Color == gameSettings.MineColorWarning then
			--verifica se o jogador é o que plantou a mina
			if character.Name == player.Name then
				humanoid.Health = 0 --o jogador morre ao tocar sua própria mina
				player:SetAttribute("Alive", false) --marca o jogador como morto
				print(player.Name .. " morreu ao tocar sua própria mina!")
			else
				--se for um jogador diferente e a mina estiver vermelha ele também morre
				humanoid.Health = 0
				print(hit.Name .. " morreu ao tocar a mina!")
			end
		end
	end)

	--verifica se o jogador atingiu a meta de minas
	if player:GetAttribute("MinesPlanted") >= gameSettings.MinesToWin then
		print(player.Name .. " venceu o Snake!")
		SnakeGame.OnEnd:Fire(player) --sinaliza a vitória do jogador
	end
end

--função para lidar com o respawn dos jogadores
local function onPlayerAdded(player)
	player:SetAttribute("MinesPlanted", 0)
	player:SetAttribute("Alive", true) --atributo para controlar se o jogador está vivo

	player.CharacterAdded:Connect(function(character)
		-- Reseta os atributos ao renascer
		player:SetAttribute("MinesPlanted", 0)
		player:SetAttribute("Alive", true) --marca o jogador como vivo novamente
	end)
end

-- Iniciar Snake
function SnakeGame.Start()
	--anuncia o minigame com o nome e descrição
	local ReplicatedStorage = game:GetService("ReplicatedStorage")
	local announceEvent = ReplicatedStorage:WaitForChild("Events"):WaitForChild("AnnounceMinigame")
	announceEvent:FireAllClients(SnakeGame.Name, SnakeGame.Description)

	--conectar eventos de adição de jogadores
	Players.PlayerAdded:Connect(onPlayerAdded)
	for _, player in ipairs(Players:GetPlayers()) do
		onPlayerAdded(player) --chamando para jogadores que já estão presentes
	end

	local gameLoop = true

	while gameLoop do
		for _, player in ipairs(Players:GetPlayers()) do
			--verifica se o jogador está vivo antes de plantar minas
			if player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player:GetAttribute("Alive") then
				spawnMine(player) --planta uma mina

				--atualiza o comprimento da cauda
				local tailLength = player:GetAttribute("MinesPlanted") * gameSettings.TailIncrease
				player:SetAttribute("TailLength", tailLength)
			end
		end
		wait(gameSettings.MineDelay)
	end

	print("snake (na função Start) terminou!") --mensagem de debug para indicar o término da função
	SnakeGame.OnEnd:Fire() --sinaliza o fim do minigame
end

return SnakeGame
