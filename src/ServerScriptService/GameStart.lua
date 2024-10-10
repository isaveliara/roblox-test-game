--Esse arquivo é um module script no ServerScriptService

local GameStart = {}
local GameMaster = require(game.ServerScriptService.GameMaster) --importar master

function GameStart:StartGame(minigameName)
	--tenta importar o minigame selecionado
	local minigame = require(game.ServerScriptService[minigameName])

	--inicializa as informações que estão lá no script (E deve ser obrigatória nele)
	minigame.Initialize()

	--carregar 1 mapa dos que estiverem disponíveis para o jogo (adicionar votação depois...)
	local selectedMap = minigame.Maps[math.random(1, #minigame.Maps)]
	print("Carregando o mapa:", selectedMap)
	--logica aqui (sem lógica, sou burra)

	--interface
	GameMaster:InfoGameDisplay(minigame.Name, minigame.Description)

	--outra função obrigatória no script
	minigame.Start()

	--o minigame dispara o evento OnEnd internamente, e o GameManager fica esperando esse evento
end

return GameStart
