local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

-- Criar uma GUI para o anúncio do minigame
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

-- Criar um frame preto que cobrirá toda a tela
local blackScreen = Instance.new("Frame")
blackScreen.Size = UDim2.new(1, 0, 1, 0) -- Cobrir 100% da tela
blackScreen.Position = UDim2.new(0, 0, 0, 0)
blackScreen.BackgroundColor3 = Color3.new(0, 0, 0) -- Preto
blackScreen.Parent = screenGui
blackScreen.Visible = false -- Inicia invisível

-- Label principal para o nome do minigame
local announcementLabel = Instance.new("TextLabel")
announcementLabel.Size = UDim2.new(0.5, 0, 0.1, 0) -- Tamanho ajustado para 50% da largura
announcementLabel.Position = UDim2.new(1, -10, 0.4, -50) -- Posição à direita
announcementLabel.AnchorPoint = Vector2.new(1, 0.5) -- Alinhado à direita
announcementLabel.TextScaled = true
announcementLabel.BackgroundTransparency = 1
announcementLabel.TextColor3 = Color3.fromRGB(128, 0, 128) -- Roxo
announcementLabel.Parent = blackScreen

-- Label secundária para a descrição do minigame
local descriptionLabel = Instance.new("TextLabel")
descriptionLabel.Size = UDim2.new(0.5, 0, 0.05, 0) -- Tamanho menor
descriptionLabel.Position = UDim2.new(1, -10, 0.5, -20) -- Posição à direita
descriptionLabel.AnchorPoint = Vector2.new(1, 0.5) -- Alinhado à direita
descriptionLabel.TextScaled = true
descriptionLabel.BackgroundTransparency = 1
descriptionLabel.TextColor3 = Color3.fromRGB(255, 255, 255) -- Branco
descriptionLabel.Parent = blackScreen

-- Espera pela criação do evento dentro da pasta "Events"
local announceEvent = ReplicatedStorage:WaitForChild("Events"):WaitForChild("AnnounceMinigame")

-- Escuta o evento para anunciar o minigame
announceEvent.OnClientEvent:Connect(function(minigameName, description)
	-- Atualiza os textos das labels
	announcementLabel.Text = "Próximo minigame: " .. minigameName
	descriptionLabel.Text = description

	-- Torna a tela preta visível
	blackScreen.Visible = true

	-- Tween para mostrar a tela
	local tweenIn = TweenService:Create(blackScreen, TweenInfo.new(0.5), {BackgroundTransparency = 0})
	tweenIn:Play()
	tweenIn.Completed:Wait() -- Espera o tween completar

	-- Espera um tempo para mostrar as labels na posição
	wait(2)

	-- Tween para esconder a tela
	local tweenOutScreen = TweenService:Create(blackScreen, TweenInfo.new(0.5), {BackgroundTransparency = 1})
	tweenOutScreen:Play()
	tweenOutScreen.Completed:Wait() -- Espera o tween completar

	-- Esconde o anúncio e a tela
	blackScreen.Visible = false
end)
