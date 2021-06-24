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

    local WalkSpeedSlider = CharacterTab.Slider({
        Text = "Walk Speed",
        Callback = function(Value)
            game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
        end,
        Min = 0,
        Max = 500,
        Def = game.Players.LocalPlayer.Character.Humanoid.WalkSpeed
    })

    local JumpPowerSlider = CharacterTab.Slider({
        Text = "Jump Power",
        Callback = function(Value)
            game.Players.LocalPlayer.Character.Humanoid.JumpPower = Value
        end,
        Min = 0,
        Max = 500,
        Def = game.Players.LocalPlayer.Character.Humanoid.JumpPower
    })

    local ResetWalkSpeedButton = CharacterTab.Button({
        Text = "Reset Walk Speed",
        Callback = function()
            game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = getgenv().DefaultWalkSpeed
        end
    })

    local ResetJumpPowerButton = CharacterTab.Button({
        Text = "Reset Jump Power",
        Callback = function()
            game.Players.LocalPlayer.Character.Humanoid.JumpPower = getgenv().DefaultJumpPower
        end
    })

    local InfJumpToggle = CharacterTab.Toggle({
        Text = "Infinite Jump",
        Callback = function(Value)
            getgenv().InfiniteJumpEnabled = Value
        end,
        Enabled = false
    })
    
    local NoclipToggle = CharacterTab.Toggle({
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

    ScriptsTab.Button({
        Text = "Infinite Yield",
        Callback = function()
            loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()
        end
    })
end

do -- Games Tab
    local GamesTab = Window.New({
        Title = "Games"
    })
end
