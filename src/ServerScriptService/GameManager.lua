--Esse arquivo é um script no ServerScriptService

local GameManager = {}
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GameStart = require(game.ServerScriptService.GameStart) -------era pra usar isso
local currentMinigame --armazena o minigame atual
local onEndConnection --armazena a conexão do evento OnEnd

--minigames disponíveis, adicionar iteração para definir eles automaticamente...
local availableMinigames = {"HelloWorldGame"}

--Albert Ainsten do nosso jogo
function GameManager:StartMinigame(minigameName)
	print("Iniciando minigame:", minigameName)

	--abre o módulo do jogo sorteado
	currentMinigame = require(game.ServerScriptService[minigameName])

	--verifica se já está em uma conexão com o evento OnEnd para cancelar
	if onEndConnection then
		onEndConnection:Disconnect()
	end

	--conectar
	onEndConnection = currentMinigame.OnEnd.Event:Connect(function()
		print("Evento OnEnd disparado para " .. minigameName)

		--tempo de espera para um próximo minigame
		wait(15)

		--inicia o próximo minigame após o término
		self:StartNextMinigame()
	end)

	--iniciar o minigame
	currentMinigame.Start()
end

--próximo minigame
function GameManager:StartNextMinigame()
	--minigame aleatório
	local randomMinigame = availableMinigames[math.random(1, #availableMinigames)]

	self:StartMinigame(randomMinigame)
end

function GameManager:MonitorMinigames()
	--...
	self:StartNextMinigame()
end

--Inicia o ainsten do jogo caso o servidor seja um recém aberto, essa é a entrada de tudo
GameManager:MonitorMinigames()

return GameManager
