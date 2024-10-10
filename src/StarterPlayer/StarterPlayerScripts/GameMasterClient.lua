--Esse arquivo é um local script no StarterPlayerScripts

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local RemoteEvents = ReplicatedStorage:WaitForChild("Events")

--animação suave de transição para o nome e a descrição do jogo
local function animateToPosition(guiObject, finalPosition, duration)
	local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
	local tween = TweenService:Create(guiObject, tweenInfo, {Position = finalPosition})
	tween:Play()
end


--exibir informações do jogo no cliente, com animação
RemoteEvents.DisplayInfo.OnClientEvent:Connect(function(gameName, gameDescription)
	local gui = Instance.new("ScreenGui")
	local infoLabel = Instance.new("TextLabel")

	--verificar ser nil antes de concatenar
	local displayName = gameName and gameName or "Unknown"
	local displayDescription = gameDescription and gameDescription or "Unknown"

	--configurações da label de scoreboard
	infoLabel.Text = displayName .. "\n" .. displayDescription
	infoLabel.Font = Enum.Font.SourceSansBold
	infoLabel.TextSize = 28 --tamanho da fonte
	infoLabel.TextColor3 = Color3.fromRGB(170, 49, 148) --uma cor rosa
	infoLabel.BackgroundTransparency = 1 --sem o fundo
	infoLabel.Size = UDim2.new(0.35, 0, 0.15, 0)
	infoLabel.AnchorPoint = Vector2.new(0.5, 0.5)
	infoLabel.Position = UDim2.new(0.5, 0, -0.2, 0) --começa fora da tela, no topo
	infoLabel.Parent = gui
	gui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

	--animação para mover o infoLabel
	animateToPosition(infoLabel, UDim2.new(0.85, 0, 0.1, 0), 1.5)
end)


--exibir ScoreBoard
RemoteEvents.DisplayScore.OnClientEvent:Connect(function(scores)
	local gui = Instance.new("ScreenGui")
	local scoreLabel = Instance.new("TextLabel")

	local scoreText = "Scoreboard:\n"

	--formatar o placar
	for userName, points in pairs(scores) do
		scoreText = scoreText .. userName .. " - " .. points .. "\n"
		--não é ordenado automaticamente, já que isso pode não ser uma scoreboard em si.
		--deve ser feito isso manualmente.
	end

	--configs
	scoreLabel.Text = scoreText
	scoreLabel.Font = Enum.Font.SourceSansBold
	scoreLabel.TextSize = 20 --tamanho da fonte
	scoreLabel.TextColor3 = Color3.fromRGB(8, 16, 89) --cor azul escuro
	scoreLabel.BackgroundTransparency = 1 --sem o fundo
	scoreLabel.Size = UDim2.new(0.3, 0, 0.25, 0) --evitar sobreposição com as infos display
	scoreLabel.AnchorPoint = Vector2.new(0.5, 0.5)
	scoreLabel.Position = UDim2.new(0.85, 0, 0.3, 0) --
	scoreLabel.Parent = gui
	gui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
end)


--exibir mensagem no cliente, sem animação, é a centralizada no topo
RemoteEvents.DisplayMessage.OnClientEvent:Connect(function(messageText)
	local gui = Instance.new("ScreenGui")
	local messageLabel = Instance.new("TextLabel")

	--configurações da label
	messageLabel.Text = messageText
	messageLabel.Font = Enum.Font.SourceSansBold
	messageLabel.TextSize = 32 --tamanho da fonte
	messageLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	messageLabel.BackgroundTransparency = 0.5
	messageLabel.BackgroundColor3 = Color3.fromRGB(75, 0, 130) -- fundo roxo
	messageLabel.Size = UDim2.new(0.5, 0, 0.1, 0)
	messageLabel.AnchorPoint = Vector2.new(0.5, 0.5)
	messageLabel.Position = UDim2.new(0.5, 0, 0.05, 0) --posição fixa
	messageLabel.Parent = gui
	gui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

	--remover após 4 segundos
	wait(4)
	gui:Destroy()
end)

--exibir a sub-mensagem no cliente, é a centralizada no topo
RemoteEvents.DisplaySubMessage.OnClientEvent:Connect(function(subMessageText)
	local gui = Instance.new("ScreenGui")
	local subMessageLabel = Instance.new("TextLabel")

	--configs da label
	subMessageLabel.Text = subMessageText
	subMessageLabel.Font = Enum.Font.SourceSans
	subMessageLabel.TextSize = 30 --tamanho
	subMessageLabel.TextColor3 = Color3.fromRGB(4, 4, 4) --em cor preta
	subMessageLabel.BackgroundTransparency = 1 --sem fundo
	subMessageLabel.Size = UDim2.new(0.5, 0, 0.08, 0)
	subMessageLabel.AnchorPoint = Vector2.new(0.5, 0.5)
	subMessageLabel.Position = UDim2.new(0.5, 0, 0.15, 0) --posição fixa
	subMessageLabel.Parent = gui
	gui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

	--remover após 4 segundos
	wait(4)
	gui:Destroy()
end)
