# É necessário que os jogos sejam Module
# É necessário os seguintes objetos para o funcionamento:
- `NomeDoScript.End()` -> chama o `NomeDoScript.OnEnd:Fire()`. Defina como: 
```lua
--deve ser definido no começo do script como
NomeDoScript.OnEnd = Instance.new("BindableEvent")
```

- `NomeDoScript.Initialize()` -> são os atributos do jogo. Exemplo de definição:
```lua
function HelloWorldGame.Initialize()
	HelloWorldGame.Name = "test game"
	HelloWorldGame.Description = "Apenas um teste de minigame."
	HelloWorldGame.GameVersion = 1 --mais recente
	HelloWorldGame.TypeGame = "FreeForAll"
	HelloWorldGame.Maps = {"raceMap"} --lista dos mapas que o jogo pode ser usado.
    --Pode ser escolhido os seguintes mapas: raceMap
end
```

- `NomeDoScript.Start()` -> é a entrada do minigame pelo GameManager>GameStart. Exemplo:
```lua
function HelloWorldGame.Start()
	GameMaster:InfoGameDisplay(HelloWorldGame.Name, HelloWorldGame.Description) --mostra o display da tela

	GameMaster:MessageDisplay("Teste de Hello-World") --mostra uma mensagem na tela
	GameMaster:SubMessageDisplay("Jogo Finalizando em 5 segundos...")
	wait(5) --delay

	HelloWorldGame.End() --função que você define para terminar
end
```


# Sobre o GameMaster:
Inicialize ele com:
```lua
local GameMaster = require(game.ServerScriptService.GameMaster) -- Importar GameMaster
```
Ele dá alguns métodos, como display de scoreboard, informações do jogo, e outras coisas que não tou afim de documentar ainda.

- InfoGameDisplay
```lua
GameMaster:InfoGameDisplay(HelloWorldGame.Name, HelloWorldGame.Description)
```

- MessageDisplay
```lua
GameMaster:MessageDisplay("Teste")
```

- SubMessageDisplay
```lua
GameMaster:SubMessageDisplay("Teste Só que Menor")
```