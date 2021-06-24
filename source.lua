local Material = loadstring(game:HttpGet("https://raw.githubusercontent.com/Kinlei/MaterialLua/master/Module.lua"))()
local Notification = loadstring(game:HttpGet('https://raw.githubusercontent.com/boop71/cappuccino/main/v3/notification.lua'))()

local Window = Material.Load({
    Title = "Agent Hub",
    Style = 1,
    SizeX = 500,
    SizeY = 350,
    Theme = "Light"
})

do -- Character Tab
    getgenv().DefaultWalkSpeed = game.Players.LocalPlayer.Character.Humanoid.WalkSpeed
    getgenv().DefaultJumpPower = game.Players.LocalPlayer.Character.Humanoid.JumpPower
    getgenv().InfiniteJumpEnabled = false

    local CharacterTab = Window.New({
        Title = "Character"
    })

    CharacterTab.Slider({ -- Walk Speed
        Text = "Walk Speed",
        Callback = function(Value)
            game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
        end,
        Min = 0,
        Max = 1000,
        Def = game.Players.LocalPlayer.Character.Humanoid.WalkSpeed
    })

    CharacterTab.Slider({ -- Jump Power
        Text = "Jump Power",
        Callback = function(Value)
            game.Players.LocalPlayer.Character.Humanoid.JumpPower = Value
        end,
        Min = 0,
        Max = 1000,
        Def = game.Players.LocalPlayer.Character.Humanoid.JumpPower
    })

    CharacterTab.Toggle({ -- Infinite Jump
        Text = "Infinite Jump",
        Callback = function(Value)
            getgenv().InfiniteJumpEnabled = Value
        end,
        Enabled = false
    })
    
    CharacterTab.Toggle({ -- Noclip
        Text = "Noclip",
        Callback = function(Value)
            if Value == false then
                if getgenv().NoclipLoop then
                    getgenv().NoclipLoop:Disconnect()
                end
            else
                local function NoclipLoop()
                    for _, child in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
                        if child:IsA("BasePart") and child.CanCollide == true then
                            child.CanCollide = false
                        end
                    end
                end
                getgenv().NoclipLoop = game:GetService("RunService").Stepped:Connect(NoclipLoop)
            end
        end,
        Enabled = false
    })

    CharacterTab.Toggle({ -- Fly
        Text = "Fly",
        Callback = function()

        end,
        Enabled = false
    })

    game:GetService("UserInputService").JumpRequest:Connect(function()
        if getgenv().InfiniteJumpEnabled then
            game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
        end
    end)
end

do -- Scripts
    local ScriptsTab = Window.New({
        Title = "Scripts"
    })

    ScriptsTab.Button({ -- Infinite Yield
        Text = "Infinite Yield",
        Callback = function()
            loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()
        end
    })

    ScriptsTab.Button({ -- Remote Spy - Hydroxide
        Text = "Remote Spy - Hydroxide",
        Callback = function()
            Window.Banner({
                Text = "Hydroxide might take a while to load"
            })

            local owner = "Upbolt"
            local branch = "revision"

            local function webImport(file)
                return loadstring(game:HttpGetAsync(("https://raw.githubusercontent.com/%s/Hydroxide/%s/%s.lua"):format(owner, branch, file)), file .. '.lua')()
            end

            webImport("init")
            webImport("ui/main")
        end
    })
end
