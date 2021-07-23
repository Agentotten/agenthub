local Mixer = loadstring(game:HttpGet("https://raw.githubusercontent.com/Agentotten/mixer/main/mixer.lua"))()

local ProjectFolder = Mixer:AddProject("AgentHub")
local ScriptsFolder = ProjectFolder:AddFolder("Scripts")
local GameScriptsFolder = ProjectFolder:AddFolder("GameScripts")

local Scripts = {}
local GameScripts = {}

for _, Script in pairs(ScriptsFolder:ListFiles()) do
    if Script.Type == "file" then
        table.insert(Scripts, Script())
    end
end

for _, GameScript in pairs(GameScriptsFolder:ListFiles()) do
    if GameScript.Type == "file" then
        table.insert(GameScripts, GameScript())
    end
end

getgenv().Scripts = Scripts
getgenv().GameScripts = GameScripts

loadstring(game:HttpGet("https://raw.githubusercontent.com/Agentotten/agenthub/master/source.lua"))()