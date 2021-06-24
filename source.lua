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

	LocalTab.Toggle({ -- Fly
		Text = "Fly",
		Callback = function(value)
			if value == true then
				getgenv().DefaultJumpPower = game:GetService("Players").LocalPlayer.Character.Humanoid.JumpPower
				getgenv().FlyEnabled = true
				game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
				game:GetService("Players").LocalPlayer.Character.Humanoid.JumpPower = 0.45
				getgenv().FlyLoop = game:GetService("RunService").Stepped:Connect(function()
					game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
				end)
			else
				if getgenv().FlyLoop ~= nil then
					getgenv().FlyLoop:Disconnect()
					getgenv().FlyEnabled = false
					game:GetService("Players").LocalPlayer.Character.Humanoid.JumpPower = getgenv().DefaultJumpPower
				end
			end
		end,
		Enabled = false
	})

	-- Infinite Jump Loop
	game:GetService("UserInputService").JumpRequest:Connect(function()
		if getgenv().InfiniteJumpEnabled == true then
			game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
		end
	end)

	game:GetService("UserInputService").InputBegan:Connect(function(input)
		if input.KeyCode == Enum.KeyCode.Space then
			if getgenv().FlyEnabled == true then
				game:GetService("Players").LocalPlayer.Character.Humanoid.JumpPower = 25
			end
			
		elseif input.KeyCode == Enum.KeyCode.LeftControl then
			if getgenv().FlyEnabled == true then
				if getgenv().FlyLoop ~= nil then
					getgenv().FlyLoop:Disconnect()
				end
			end
		end
	end)

	game:GetService("UserInputService").InputEnded:Connect(function(input)
		if input.KeyCode == Enum.KeyCode.Space then
			if getgenv().FlyEnabled == true then
				game:GetService("Players").LocalPlayer.Character.Humanoid.JumpPower = 0.45
			end
			
		elseif input.KeyCode == Enum.KeyCode.LeftControl then
			if getgenv().FlyEnabled == true then
				getgenv().FlyLoop = game:GetService("RunService").Stepped:Connect(function()
					game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
				end)
			end
		end
	end)
end

do -- Teleport Tab
	local TeleportTab = Window.New({
		Title = "Teleport"
	})

	local TeleportToButton = TeleportTab.Button({ -- Teleport To
		Text = "Teleport To",
		Callback = function()
			game:GetService("Players").LocalPlayer.Character.PrimaryPart.CFrame = getgenv().SelectedPlayer.Character.PrimaryPart.CFrame + Vector3.new(3,1,0)
		end
	})

	local PlayerListDropDown = TeleportTab.Dropdown({ -- Select Player
		Text = "Select Player",
		Callback = function(value)
			for _, plr in pairs(game:GetService("Players"):GetPlayers()) do
				if plr.Name == value then
					getgenv().SelectedPlayer = plr
					TeleportToButton:SetText("Teleport To " .. plr.Name)
					return
				end
			end
		end,
		Options = {}
	})

	local function UpdatePlayerListDropDown()
		local players = {}
		for _, plr in pairs(game:GetService("Players"):GetPlayers()) do
			table.insert(players, plr.Name)
		end
		PlayerListDropDown:SetOptions(players)
	end

	UpdatePlayerListDropDown()
	game:GetService("Players").PlayerAdded:Connect(UpdatePlayerListDropDown)
	game:GetService("Players").PlayerRemoving:Connect(UpdatePlayerListDropDown)
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