local Material = loadstring(game:HttpGet("https://raw.githubusercontent.com/Kinlei/MaterialLua/master/Module.lua"))()
-- local Notification = loadstring(game:HttpGet("https://raw.githubusercontent.com/boop71/cappuccino/main/v3/notification.lua"))()

local Window = Material.Load({
	Title = "AgentHub",
	Style = 1,
	SizeX = 500,
	SizeY = 350,
	Theme = "Light",
})

local Scripts = {
	Infinite_Yield = {
		Name = "Infinite Yield FE",
		Source = function()
			loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
		end,
	},

	Hydroxide = {
		Name = "Hydroxide - Remote Spy",
		Source = function()
			Window.Banner({
				Text = "Hydroxide might take a while to load",
			})
			loadstring(game:HttpGetAsync(("https://raw.githubusercontent.com/%s/Hydroxide/%s/%s.lua"):format("Upbolt", "revision", "init")), "init" .. ".lua")()
			loadstring(game:HttpGetAsync(("https://raw.githubusercontent.com/%s/Hydroxide/%s/%s.lua"):format("Upbolt", "revision", "ui/main")), "ui/main" .. ".lua")()
		end,
	}
}

do -- Local Tab
	getgenv().DefaultWalkSpeed = game.Players.LocalPlayer.Character.Humanoid.WalkSpeed
	getgenv().DefaultJumpPower = game.Players.LocalPlayer.Character.Humanoid.JumpPower
	getgenv().InfiniteJumpEnabled = false

	local LocalTab = Window.New({
		Title = "Local",
	})

	LocalTab.Slider({ -- Walk Speed
		Text = "Walk Speed",
		Callback = function(Value)
			game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
		end,
		Min = 0,
		Max = 1000,
		Def = game.Players.LocalPlayer.Character.Humanoid.WalkSpeed,
	})

	LocalTab.Slider({ -- Jump Power
		Text = "Jump Power",
		Callback = function(Value)
			game.Players.LocalPlayer.Character.Humanoid.JumpPower = Value
		end,
		Min = 0,
		Max = 1000,
		Def = game.Players.LocalPlayer.Character.Humanoid.JumpPower,
	})

	LocalTab.Toggle({ -- Infinite Jump
		Text = "Infinite Jump",
		Callback = function(Value)
			getgenv().InfiniteJumpEnabled = Value
		end,
		Enabled = false,
	})

	LocalTab.Toggle({ -- Noclip
		Text = "Noclip",
		Callback = function(Value)
			if Value == true then
				local function NoclipLoop()
					for _, c in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
						if c:IsA("BasePart") and c.CanCollide == true then
							c.CanCollide = false
						end
					end
				end
				getgenv().NoclipLoop = game:GetService("RunService").Stepped:Connect(NoclipLoop)
			else
				if getgenv().NoclipLoop then
					getgenv().NoclipLoop:Disconnect()
				end
			end
		end,
		Enabled = false,
	})
end

do -- Scripts
	local ScriptsTab = Window.New({
		Title = "Scripts",
	})

	for _, scriptInfo in pairs(Scripts) do -- Scripts loader very fancy
		ScriptsTab.Button({
			Text = scriptInfo.Name,
			Callback = scriptInfo.Source,
		})
	end
end

do -- Credits
    local CreditsTab = Window.New({
        Title = "Credits"
    })

    CreditsTab.Button({ -- Programmer
        Text = "Programmer: Agentotten#2610",
        Callback = function()
        end,
		Menu = {
			Copy = function()
				setclipboard("Agentotten#2610")
			end
		}
    })

    CreditsTab.Button({ -- UI Design
        Text = "UI Design: Material Lua - Twink Marie",
        Callback = function()
        end,
		Menu = {
			Copy = function()
				setclipboard("https://materiallua.ml")
			end
		}
    })
end