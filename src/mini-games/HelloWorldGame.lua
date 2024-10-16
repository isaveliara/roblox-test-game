local HelloWorldGame = {}
local GameMaster = require(game.ServerScriptService.GameMaster) -- Importar GameMaster

--evento OnEnd, que será desparado quando o minigame acabar
HelloWorldGame.OnEnd = Instance.new("BindableEvent")

--infos do game
function HelloWorldGame.Initialize()
	HelloWorldGame.Name = "Hello World Game"
	HelloWorldGame.Description = "Apenas um exemplo simples de minigame."
	HelloWorldGame.Author = "pixelar144"
	HelloWorldGame.GameVersion = 1
	HelloWorldGame.TypeGame = "FreeForAll"
	HelloWorldGame.Maps = {"raceMap"} -- Lista de mapas permitidos
end

--entrada
function HelloWorldGame.Start()
	HelloWorldGame.Initialize() --Essa função deve ser chamada no começo para que as informações do jogo sejam inicializadas.

	--GameDisplay (pode ser acionado se você quiser alterar as informações para uma outra no meio do jogo)
	--GameMaster:InfoGameDisplay(HelloWorldGame.Name, HelloWorldGame.Description)

	--mensagem inicial
	GameMaster:MessageDisplay("Bem-vindo ao Hello World Game!")
	
	--placar de exemplo. Deve ser definido nos scripts jogo para aparecer
	local scores = {
		["Player1"] = 10,
		["Player2"] = 20,
		["Player3"] = 15
	}
	GameMaster:ScoreBoardDisplay(scores)

	--subtítulo
	GameMaster:SubMessageDisplay("Prepare-se para começar!")

	--mensagem de info- adicional
	GameMaster:CenterMessageLabelDisplay("terminando em 5 segundos")
	wait(1)
	GameMaster:CenterMessageLabelDisplay("Adicione o jogo nos seus favoritos!")

	wait(4) --delay

	--finalizar o jogo chamando o OnEnd
	HelloWorldGame.End()
end

function HelloWorldGame.End()
	print("O Hello World Game terminou!")
	HelloWorldGame.OnEnd:Fire() --disparar o evento OnEnd
end

return HelloWorldGame
