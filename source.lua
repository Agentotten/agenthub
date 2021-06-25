local Material = loadstring(game:HttpGet("https://raw.githubusercontent.com/Kinlei/MaterialLua/master/Module.lua"))()
-- local Notification = loadstring(game:HttpGet("https://raw.githubusercontent.com/boop71/cappuccino/main/v3/notification.lua"))()

local Window = Material.Load({
	Title = "AgentHub - Beta",
	Style = 1,
	SizeX = 500,
	SizeY = 350,
	Theme = "Dark"
})

local ExclusiveGames = {
	LiftingTitans = {
		Name = "Lifting Titans",
		Source = function()
			loadstring(game:HttpGet("https://raw.githubusercontent.com/Agentotten/agenthub/beta/games/liftingtitans.lua"))()
		end,
		GameID = 6531005851
	}
}

do -- Local Tab
	local DefaultJumpPower = game:GetService("Players").LocalPlayer.Character.Humanoid.JumpPower
	local InfiniteJumpEnabled = false
	local FlyEnabled = false
	local NoclipLoop = nil
	local FlyLoop = nil

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
			InfiniteJumpEnabled = value
		end,
		Enabled = false
	})

	LocalTab.Toggle({ -- Noclip
		Text = "Noclip",
		Callback = function(value)
			if value == true then
				NoclipLoop = game:GetService("RunService").Stepped:Connect(function()
					for _, v in pairs(game:GetService("Players").LocalPlayer.Character:GetDescendants()) do
						if v:IsA("BasePart") and v.CanCollide == true then
							v.CanCollide = false
						end
					end
				end)
			else
				if NoclipLoop ~= nil then
					NoclipLoop:Disconnect()
				end
			end
		end,
		Enabled = false
	})

	LocalTab.Toggle({ -- Fly
		Text = "Fly",
		Callback = function(value)
			if value == true then
				DefaultJumpPower = game:GetService("Players").LocalPlayer.Character.Humanoid.JumpPower
				FlyEnabled = true
				game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
				game:GetService("Players").LocalPlayer.Character.Humanoid.JumpPower = 0.45
				FlyLoop = game:GetService("RunService").Stepped:Connect(function()
					game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
				end)
			else
				if FlyLoop ~= nil then
					FlyLoop:Disconnect()
					FlyEnabled = false
					game:GetService("Players").LocalPlayer.Character.Humanoid.JumpPower = DefaultJumpPower
				end
			end
		end,
		Enabled = false
	})

	game:GetService("UserInputService").JumpRequest:Connect(function()
		if InfiniteJumpEnabled == true then
			game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
		end
	end)

	game:GetService("UserInputService").InputBegan:Connect(function(input)
		if input.KeyCode == Enum.KeyCode.Space then
			if FlyEnabled == true then
				game:GetService("Players").LocalPlayer.Character.Humanoid.JumpPower = 25
			end
			
		elseif input.KeyCode == Enum.KeyCode.LeftControl then
			if FlyEnabled == true then
				if FlyLoop ~= nil then
					FlyLoop:Disconnect()
				end
			end
		end
	end)

	game:GetService("UserInputService").InputEnded:Connect(function(input)
		if input.KeyCode == Enum.KeyCode.Space then
			if FlyEnabled == true then
				game:GetService("Players").LocalPlayer.Character.Humanoid.JumpPower = 0.45
			end
			
		elseif input.KeyCode == Enum.KeyCode.LeftControl then
			if FlyEnabled == true then
				FlyLoop = game:GetService("RunService").Stepped:Connect(function()
					game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
				end)
			end
		end
	end)
end

do -- Teleport Tab
	local SelectedPlayer = nil

	local TeleportTab = Window.New({
		Title = "Teleport"
	})

	local TeleportToButton = TeleportTab.Button({ -- Teleport To
		Text = "Teleport To",
		Callback = function()
			game:GetService("Players").LocalPlayer.Character.PrimaryPart.CFrame = SelectedPlayer.Character.PrimaryPart.CFrame + Vector3.new(3,1,0)
		end
	})

	local PlayerListDropDown = TeleportTab.Dropdown({ -- Select Player
		Text = "Select Player",
		Callback = function(value)
			for _, plr in pairs(game:GetService("Players"):GetPlayers()) do
				if plr.Name == value then
					SelectedPlayer = plr
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

do -- Exclusive Games Tab
	local ExclusiveGamesTab = Window.New({
		Title = "Exclusive Games"
	})

	for _, v in pairs(ExclusiveGames) do -- Games loader very fancy
		ExclusiveGamesTab.Button({
			Text = v.Name,
			Callback = v.Source,
			Menu = {
				Join = function()
					game:GetService("TeleportService"):Teleport(v.GameID)
				end
			}
		})
	end
end

do -- Games Tab
	if getgenv().Games then
		local GamesTab = Window.New({
			Title = "Games"
		})
	
		for _, v in pairs(getgenv().Games) do -- Games loader very fancy
			GamesTab.Button({
				Text = v.Name,
				Callback = v.Source,
				Menu = {
					Join = function()
						game:GetService("TeleportService"):Teleport(v.GameID)
					end
				}
			})
		end
	end
end

do -- Scripts Tab
	if getgenv().Scripts then
		local ScriptsTab = Window.New({
			Title = "Scripts"
		})
	
		for _, v in pairs(getgenv().Scripts) do -- Scripts loader also very fancy
			ScriptsTab.Button({
				Text = v.Name,
				Callback = v.Source
			})
		end
	end
end

do -- Credits Tab
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