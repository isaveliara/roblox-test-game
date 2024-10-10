local HelloWorldGame = {}
local GameMaster = require(game.ServerScriptService.GameMaster) -- Importar GameMaster

--evento OnEnd, que será desparado quando o minigame acabar
HelloWorldGame.OnEnd = Instance.new("BindableEvent")

--infos do game
function HelloWorldGame.Initialize()
	HelloWorldGame.Name = "Hello World Game"
	HelloWorldGame.Description = "Apenas um exemplo simples de minigame."
	HelloWorldGame.GameVersion = 1
	HelloWorldGame.TypeGame = "FreeForAll"
	HelloWorldGame.Maps = {"raceMap"} -- Lista de mapas permitidos
end

--entrada
function HelloWorldGame.Start()
	--GameDisplay
	GameMaster:InfoGameDisplay(HelloWorldGame.Name, HelloWorldGame.Description)

	--mensagem inicial
	GameMaster:MessageDisplay("Bem-vindo ao Hello World Game!")

	--subtítulo
	GameMaster:SubMessageDisplay("Prepare-se para começar!")

	wait(5) --delay

	--placar de exemplo. Pode ser definido nos scripts jogo
	local scores = {
		["Player1"] = 10,
		["Player2"] = 20,
		["Player3"] = 15
	}
	GameMaster:ScoreBoardDisplay(scores)

	--finalizar o jogo chamando o OnEnd
	HelloWorldGame.End()
end

function HelloWorldGame.End()
	print("O Hello World Game terminou!")
	HelloWorldGame.OnEnd:Fire() --disparar o evento OnEnd
end

return HelloWorldGame
