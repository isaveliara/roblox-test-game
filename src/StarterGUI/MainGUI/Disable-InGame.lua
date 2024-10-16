--quano o jogador ver essa ui, não estará mais no jogo, já que essa é script roda quando o usuário acessa a GUI
local Players = game:GetService("Players")
local player = Players.LocalPlayer

player:SetAttribute("InGame", false)