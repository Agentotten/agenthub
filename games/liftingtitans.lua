local Material = loadstring(game:HttpGet("https://raw.githubusercontent.com/Kinlei/MaterialLua/master/Module.lua"))()

local Window = Material.Load({
	Title = "Lifting Titans - AgentHub - Beta",
	Style = 1,
	SizeX = 500,
	SizeY = 350,
	Theme = "Dark"
})

do -- Farming Tab
    local AutoSellEnabled = false
    local AutoFarmStrengthLoop = nil

    local FarmingTab = Window.New({
        Title = "Farming"
    })

    FarmingTab.Toggle({
        Text = "Autofarm Strength",
        Callback = function(value)
            if value == true then
                AutoFarmStrengthLoop = game:GetService("RunService").Stepped:Connect(function()
                    if AutoSellEnabled == true then
                        local strengthValues = game:GetService("Players").LocalPlayer.PlayerGui:WaitForChild("MainUis"):WaitForChild("StatLabels"):WaitForChild("StrenghLabel"):WaitForChild("StatText").Text:split("/")
                        if strengthValues[1] == strengthValues[2] then
                            game:GetService("ReplicatedStorage").Remotes.Sell:FireServer("Sell")
                        end
                    end
                    game:GetService("ReplicatedStorage").Remotes.OnLift:FireServer()
                end)
            else
                if AutoFarmStrengthLoop ~= nil then
                    AutoFarmStrengthLoop:Disconnect()
                end
            end
        end,
        Enabled = false
    })

    FarmingTab.Toggle({
        Text = "Auto Sell",
        Callback = function(value)
            AutoSellEnabled = value
        end,
        Enabled = false
    })
end

do -- Settings Tab
    local SettingsTab = Window.New({
        Title = "Settings"
    })

    SettingsTab.Button({ -- Return to AgentHub
        Text = "Return to AgentHub",
        Callback = function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/Agentotten/agenthub/master/source.lua"))()
        end
    })
end
