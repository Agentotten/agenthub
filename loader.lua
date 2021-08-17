local Mixer = loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/Agentotten/mixer/main/mixer.lua"))()

local ProjectFolder = Mixer:Folder("AgentHub")
local ScriptsFolder = ProjectFolder:Folder("Scripts")
local GameScriptsFolder = ProjectFolder:Folder("GameScripts")

local scripts = {}
local gameScripts = {}

for _, s in pairs(ScriptsFolder:List()) do
	if s.Type == "File" then
		table.insert(scripts, s)
	end
end

for _, gs in pairs(GameScriptsFolder:List()) do
	if gs.Type == "File" then
		table.insert(gameScripts, gs)
	end
end

getgenv().AgentHub = {}
getgenv().AgentHub.Scripts = scripts
getgenv().AgentHub.GameScripts = gameScripts

loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/Agentotten/agenthub/master/source.lua"))()
