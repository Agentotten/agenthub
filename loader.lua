local LoadedScripts = {}
local LoadedGameScripts = {}

local function ReadScripts(path, output)
    for _, v in pairs(listfiles(path)) do
        if isfile(v) then
            local src = loadfile(v)()
            table.insert(output, src)
        end
    end
end

if not isfolder("AgentHub") then
    makefolder("AgentHub")
end

if isfolder("AgentHub/scripts") then
    ReadScripts("AgentHub/scripts", LoadedScripts)
else
    makefolder("AgentHub/scripts")
end

if isfolder("AgentHub/gamescripts") then
    ReadScripts("AgentHub/gamescripts", LoadedGameScripts)
else
    makefolder("AgentHub/gamescripts")
end

getgenv().Scripts = LoadedScripts
getgenv().GameScripts = LoadedGameScripts

loadstring(game:HttpGet("https://raw.githubusercontent.com/Agentotten/agenthub/master/source.lua"))()
