--Esse arquivo é um module script.
--Seus métodos são cruciais para que sejam usados pelos minigames, e interagem diretamente com o GameMasterClient.

local GameMaster = {}
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RemoteEvents = ReplicatedStorage:WaitForChild("Events") --eventos que serão usados na comunicação com o cliente.

--informações do jogo (nome e descrição)
function GameMaster:InfoGameDisplay(gameName, gameDescription)
	RemoteEvents.DisplayInfo:FireAllClients(gameName, gameDescription)
end

--display de uma scoreboard
function GameMaster:ScoreBoardDisplay(scores)
	RemoteEvents.DisplayScore:FireAllClients(scores)
end

--display para título
function GameMaster:MessageDisplay(messageText)
	RemoteEvents.DisplayMessage:FireAllClients(messageText)
end

--display para subtítulo
function GameMaster:SubMessageDisplay(subMessageText)
	RemoteEvents.DisplaySubMessage:FireAllClients(subMessageText)
end

--display para rótulo (podem estar lançadas até 3 mensagens no máximo)
function GameMaster:CenterMessageLabelDisplay(messageText)
	RemoteEvents.AddCenterLabelMessage:FireAllClients(messageText)
end

return GameMaster
