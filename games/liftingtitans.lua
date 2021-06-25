local Material = loadstring(game:HttpGet("https://raw.githubusercontent.com/Kinlei/MaterialLua/master/Module.lua"))()

local Window = Material.Load({
	Title = "AgentHub - Beta",
	Style = 1,
	SizeX = 500,
	SizeY = 350,
	Theme = "Dark"
})

do -- Settings Tab
    local SettingsTab = Window.New({
        Title = "Settings"
    })

    SettingsTab.Button({ -- Return to AgentHub
        Text = "Return to AgentHub",
        Callback = function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/Agentotten/agenthub/beta/source.lua"))()
        end
    })
end