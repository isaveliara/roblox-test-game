--Esse arquivo é um script no ServerScriptService

local GameManager = {}
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GameMaster = require(game.ServerScriptService.GameMaster) -------era pra usar isso
local currentMinigame --armazena o minigame atual
local onEndConnection --armazena a conexão do evento OnEnd

--minigames disponíveis, adicionar iteração para definir eles automaticamente...
local availableMinigames = {"HelloWorldGame","RaceGame"}

--Albert Ainsten do nosso jogo
function GameManager:StartMinigame(minigameName)
	GameMaster:CLSDisplayUI()--cls
	wait(1)
	
	print("Iniciando minigame:", minigameName)

	--abre o módulo do jogo sorteado
	currentMinigame = require(game.ServerScriptService.Games[minigameName])

	--verifica se já está em uma conexão com o evento OnEnd para cancelar
	if onEndConnection then
		onEndConnection:Disconnect()
	end
	
	--Vulnerabilidade: O evento OnEnd determina o numero de minigames que acontecerá depois do minigame acabar
	--se o OnEnd for chamado 2 vezes por exemplo, vai ter 2 minigames ao mesmo tempo. (É o problema de cima talvez)
	

	--conectar
	onEndConnection = currentMinigame.OnEnd.Event:Connect(function()
		print("Evento OnEnd disparado para " .. minigameName)

		--tempo de espera para um próximo minigame
		GameMaster:CenterMessageLabelDisplay("Próximo Minigame em 10 segundos")
		wait(10)

		--inicia o próximo minigame após o término
		self:StartNextMinigame()
	end)
	
	--inicializar o minigame
	currentMinigame.Initialize()
	
	GameMaster:InfoGameDisplay(currentMinigame.Name, currentMinigame.Description) --display do nome e da descrição do jogo
	GameMaster:CenterMessageLabelDisplay("começando "..currentMinigame.Name.." em 4s...")
	
	wait(4)--tempo de espera para começar o jogo
	
	local selectedMap = currentMinigame.Maps[math.random(1, #currentMinigame.Maps)]
	print("Carregando o mapa:", selectedMap)
	
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
