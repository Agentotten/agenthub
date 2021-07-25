local Mixer = loadstring(game:HttpGet("https://raw.githubusercontent.com/Agentotten/mixer/main/mixer.lua"))()

local ProjectFolder = Mixer:AddProject("AgentHub")
local ScriptsFolder = ProjectFolder:AddFolder("Scripts")
local GameScriptsFolder = ProjectFolder:AddFolder("GameScripts")

local scripts = {}
local gameScripts = {}

for _, s in pairs(ScriptsFolder:ListFiles()) do
    if s.Type == "file" then
        table.insert(scripts, s)
    end
end

for _, gs in pairs(GameScriptsFolder:ListFiles()) do
    if gs.Type == "file" then
        table.insert(gameScripts, gs)
    end
end

getgenv().agenthub.scripts = scripts
getgenv().agenthub.gameScripts = gameScripts

loadstring(game:HttpGet("https://raw.githubusercontent.com/Agentotten/agenthub/master/source.lua"))()