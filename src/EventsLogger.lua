local ReplicatedStorage = game:GetService("ReplicatedStorage")

local startMinigameEvent = ReplicatedStorage:WaitForChild("Events"):WaitForChild("StartMinigame")
local announceEvent = ReplicatedStorage:WaitForChild("Events"):WaitForChild("AnnounceMinigame")

local function logEvent(eventName)
	if eventName then
		print("Evento registrado: " .. eventName)
	else
		print("Evento registrado: [Nome do evento é nil]")
	end
end

--logar o evento de início de minigame
startMinigameEvent.OnServerEvent:Connect(function(minigameName)
	logEvent("StartMinigame: " .. minigameName)
end)

--logar o evento de anúncio de minigame
announceEvent.OnServerEvent:Connect(function(minigameName)
	logEvent("AnnounceMinigame: " .. minigameName)
end)

--adicionar log para o evento OnEnd
local function logOnEnd(minigameScript)
	if minigameScript and minigameScript.OnEnd then
		minigameScript.OnEnd.Event:Connect(function()
			logEvent("OnEnd disparado para: " .. (minigameScript.Name or "[Nome do script é nil]"))
		end)
	end
end
