local Mixer = loadstring(game:HttpGet("https://raw.githubusercontent.com/Agentotten/mixer/master/source.lua"))()

local Scripts = {}
local GameScripts = {}

Mixer:AddProject("AgentHub")
Mixer:AddFolder("Scripts")
Mixer:AddFolder("GameScripts")

for _, Script in pairs(Mixer:ListScripts("Scripts", "AgentHub")) do
    table.insert(Scripts, Script())
end

for _, Script in pairs(Mixer:ListScripts("GameScripts", "AgentHub")) do
    table.insert(GameScripts, Script())
end

getgenv().Scripts = Scripts
getgenv().GameScripts = GameScripts

loadstring(game:HttpGet("https://raw.githubusercontent.com/Agentotten/agenthub/master/source.lua"))()