local Material = loadstring(game:HttpGet("https://raw.githubusercontent.com/Kinlei/MaterialLua/master/Module.lua"))()
-- local Notification = loadstring(game:HttpGet("https://raw.githubusercontent.com/boop71/cappuccino/main/v3/notification.lua"))()

local Window = Material.Load({
	Title = "AgentHub - Beta",
	Style = 1,
	SizeX = 500,
	SizeY = 350,
	Theme = "Dark"
})

local Scripts = {
	Infinite_Yield = {
		Name = "Infinite Yield FE",
		Source = function()
			loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
		end
	},

	Hydroxide = {
		Name = "Hydroxide - Remote Spy",
		Source = function()
			Window.Banner({
				Text = "Hydroxide might take a while to load",
			})
			loadstring(game:HttpGetAsync(("https://raw.githubusercontent.com/%s/Hydroxide/%s/%s.lua"):format("Upbolt", "revision", "init")), "init" .. ".lua")()
			loadstring(game:HttpGetAsync(("https://raw.githubusercontent.com/%s/Hydroxide/%s/%s.lua"):format("Upbolt", "revision", "ui/main")), "ui/main" .. ".lua")()
		end
	}
}

do -- Local Tab
	local LocalTab = Window.New({
		Title = "Local"
	})

	LocalTab.Slider({ -- Walk Speed
		Text = "Walk Speed",
		Callback = function(value)
			game:GetService("Players").LocalPlayer.Character.Humanoid.WalkSpeed = value
		end,
		Min = 0,
		Max = 1000,
		Def = game:GetService("Players").LocalPlayer.Character.Humanoid.WalkSpeed
	})

	LocalTab.Slider({ -- Jump Power
		Text = "Jump Power",
		Callback = function(value)
			game:GetService("Players").LocalPlayer.Character.Humanoid.JumpPower = value
		end,
		Min = 0,
		Max = 1000,
		Def = game:GetService("Players").LocalPlayer.Character.Humanoid.JumpPower
	})

	LocalTab.Toggle({ -- Infinite Jump
		Text = "Infinite Jump",
		Callback = function(value)
			getgenv().InfiniteJumpEnabled = value
		end,
		Enabled = false
	})

	LocalTab.Toggle({ -- Noclip
		Text = "Noclip",
		Callback = function(value)
			if value == true then
				local function NoclipLoop()
					for _, v in pairs(game:GetService("Players").LocalPlayer.Character:GetDescendants()) do
						if v:IsA("BasePart") and v.CanCollide == true then
							v.CanCollide = false
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
		Enabled = false
	})

	-- Infinite Jump Loop
	spawn(game:GetService("UserInputService").JumpRequest:Connect(function()
		if getgenv().InfiniteJumpEnabled == true then
			game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
		end
	end))
end

do -- Teleport Tab
	local TeleportTab = Window.New({
		Title = "Teleport"
	})

	local TeleportToButton = TeleportTab.Button({ -- Teleport To
		Text = "Teleport To",
		Callback = function()
			game:GetService("Players").LocalPlayer.Character.PrimaryPart.CFrame = CFrame.new(getgenv().SelectedPlayer.Character.PrimaryPart.Position)
		end
	})

	local PlayerList = TeleportTab.Dropdown({
		Text = "Select Player",
		Callback = function(value)
			for _, plr in pairs(game:GetService("Players"):GetPlayers()) do
				if plr.Name == value then
					getgenv().SelectedPlayer = plr
					TeleportToButton:SetText("Teleport To " .. plr.Name)
				end
			end
		end,
		Options = {"Agentotten"}
	})

	local function UpdatePlayerList()
		local players = {}
		for _, plr in pairs(game:GetService("Players"):GetPlayers()) do
			table.insert(players, plr.Name)
		end
		PlayerList:SetOptions(players)
	end

	UpdatePlayerList()

	game:GetService("Players").PlayerAdded:Connect(UpdatePlayerList)
	game:GetService("Players").PlayerRemoving:Connect(UpdatePlayerList)
end

do -- Scripts
	local ScriptsTab = Window.New({
		Title = "Scripts"
	})

	for _, v in pairs(Scripts) do -- Scripts loader very fancy
		ScriptsTab.Button({
			Text = v.Name,
			Callback = v.Source
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