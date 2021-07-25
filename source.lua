local function GetPlayer(name)
	if name then return game:GetService("Players")[name] end
	return game:GetService("Players").LocalPlayer
end

local function GetCharacter(name)
	if name then return GetPlayer(name).Character or GetPlayer(name).CharacterAdded:Wait() end
	return GetPlayer().Character or GetPlayer().CharacterAdded:Wait()
end

local function GetHumanoid(name)
	if name then return GetCharacter(name):FindFirstChild("Humanoid") or GetCharacter(name):WaitForChild("Humanoid") end
	return GetCharacter():FindFirstChild("Humanoid") or GetCharacter():WaitForChild("Humanoid")
end

local function GetRoot(name)
	if name then return GetCharacter(name):FindFirstChild("HumanoidRootPart") or GetCharacter(name):WaitForChild("HumanoidRootPart") end
	return GetCharacter():FindFirstChild("HumanoidRootPart") or GetCharacter():WaitForChild("HumanoidRootPart")
end

local function Teleport(cframe)
	GetRoot().CFrame = cframe
end

local Material = loadstring(game:HttpGet("https://raw.githubusercontent.com/Kinlei/MaterialLua/master/Module.lua"))()

local Window = Material.Load({
	Title = "AgentHub",
	Style = 1,
	SizeX = 500,
	SizeY = 350,
	Theme = "Dark"
})

do -- Character Page
	local defaultWalkSpeed = GetHumanoid().WalkSpeed
	local defaultJumpPower = GetHumanoid().JumpPower
	local flyLoop = nil
	local flySpeed = 1
	local bodyP = nil
	local bodyG = nil
	local noclipLoop = nil
	local infiniteJumpEnabled = false

	local CharacterPage = Window.New({
		Title = "Character"
	})

	CharacterPage.Slider({ -- WalkSpeed Slider
		Text = "WalkSpeed",
		Callback = function(value)
			GetHumanoid().WalkSpeed = value
		end,
		Min = 0,
		Max = 1000,
		Def = GetHumanoid().WalkSpeed,
		Menu = {
			Reset = function(self)
				GetHumanoid().WalkSpeed = defaultWalkSpeed
			end
		}
	})

	CharacterPage.Slider({ -- JumpPower Slider
		Text = "JumpPower",
		Callback = function(value)
			GetHumanoid().JumpPower = value
		end,
		Min = 0,
		Max = 1000,
		Def = GetHumanoid().JumpPower,
		Menu = {
			Reset = function(self)
				GetHumanoid().JumpPower = defaultJumpPower
			end
		}
	})

	CharacterPage.Slider({ -- Fly Speed Slider
		Text = "Fly Speed",
		Callback = function(value)
			flySpeed = value
		end,
		Min = 0,
		Max = 100,
		Def = 1
	})

	CharacterPage.Toggle({ -- Fly Toggle
		Text = "Fly",
		Callback = function(value)
			if value then
				bodyP = Instance.new("BodyPosition")
				bodyG = Instance.new("BodyGyro")

				bodyP.MaxForce = Vector3.new(1, 1, 1) * math.huge
				bodyG.MaxTorque = Vector3.new(1, 1, 1) * 9e9
				bodyP.Position = GetRoot().Position
				bodyG.CFrame = GetRoot().CFrame

				bodyP.Parent = GetRoot()
				bodyG.Parent = GetRoot()

				GetHumanoid().PlatformStand = true

				flyLoop = game:GetService("RunService").Stepped:Connect(function()
					local newPos = (bodyG.CFrame - (bodyG.CFrame).Position) + bodyP.Position
            		local coordinateFrame = workspace.CurrentCamera.CFrame

					if game:GetService("UserInputService"):IsKeyDown("W") then
						newPos = newPos + coordinateFrame.LookVector * flySpeed
			
						bodyP.Position = (GetRoot().CFrame * CFrame.new(0, 0, -flySpeed)).Position;
						bodyG.CFrame = coordinateFrame * CFrame.Angles(-math.rad(flySpeed * 15), 0, 0);
					end
			
					if game:GetService("UserInputService"):IsKeyDown("A") then
						newPos = newPos * CFrame.new(-flySpeed, 0, 0);
					end
			
					if game:GetService("UserInputService"):IsKeyDown("S") then
						newPos = newPos - coordinateFrame.LookVector * flySpeed
			
						bodyP.Position = (GetRoot().CFrame * CFrame.new(0, 0, flySpeed)).Position;
						bodyG.CFrame = coordinateFrame * CFrame.Angles(-math.rad(flySpeed * 15), 0, 0);
					end
			
					if game:GetService("UserInputService"):IsKeyDown("D") then
						newPos = newPos * CFrame.new(flySpeed, 0, 0);
					end
			
					bodyP.Position = newPos.Position
					bodyG.CFrame = coordinateFrame
				end)
			else
				if flyLoop then
					bodyP:Destroy()
					bodyG:Destroy()
					GetHumanoid().PlatformStand = false
					flyLoop:Disconnect()
				end
			end
		end,
		Enabled = false
	})

	CharacterPage.Toggle({ -- Noclip Toggle
		Text = "Noclip",
		Callback = function(value)
			if value then
				noclipLoop = game:GetService("RunService").Stepped:Connect(function()
					for _, v in pairs(GetCharacter():GetDescendants()) do
						if v:IsA("BasePart") and v.CanCollide == true then
							v.CanCollide = false
						end
					end
				end)
			else
				if noclipLoop then
					noclipLoop:Disconnect()
				end
			end
		end,
		Enabled = false
	})

	CharacterPage.Toggle({ -- Infinite Jump Toggle
		Text = "Infinite Jump",
		Callback = function(value)
			infiniteJumpEnabled = value
		end,
		Enabled = false
	})

	game:GetService("UserInputService").JumpRequest:Connect(function()
		if infiniteJumpEnabled then
			game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
		end
	end)
end

do -- Teleport Page
	local selectedPlayer = nil

	local TeleportPage = Window.New({
		Title = "Teleport"
	})

	TeleportPage.Button({ -- Teleport To Button
		Text = "Teleport To",
		Callback = function()
			Teleport(GetRoot(selectedPlayer).CFrame * CFrame.new(0, 0, 2))
		end
	})

	local PlayerListDropdown = TeleportPage.Dropdown({ -- Player List Dropdown
		Text = "Select Player",
		Callback = function(value)
			selectedPlayer = value
		end,
		Options = {}
	})

	local function UpdatePlayerList()
		local players = {}

		for _, player in pairs(game:GetService("Players"):GetPlayers()) do
			table.insert(players, player.Name)
		end

		PlayerListDropdown:SetOptions(players)
	end

	spawn(UpdatePlayerList)

	game:GetService("Players").PlayerAdded:Connect(UpdatePlayerList)
	game:GetService("Players").PlayerRemoving:Connect(UpdatePlayerList)
end

do -- Games Page
	if getgenv().agenthubGameScripts and #getgenv().agenthubGameScripts > 0 then
		local GameScriptsPage = Window.New({
			Title = "Games"
		})
	
		for _, gs in pairs(getgenv().agenthubGameScripts) do
			GameScriptsPage.Button({
				Text = gs.Name,
				Callback = gs
			})
		end
	end
end

do -- Scripts Page
	if getgenv().agenthubScripts and #getgenv().agenthubScripts > 0 then
		local ScriptsPage = Window.New({
			Title = "Scripts"
		})
	
		for _, s in pairs(getgenv().agenthubScripts) do
			ScriptsPage.Button({
				Text = s.Name,
				Callback = s
			})
		end
	end
end

do -- Credits Page
    local CreditsPage = Window.New({
        Title = "Credits"
    })

    CreditsPage.Button({ -- Programmer Credits
        Text = "Programmer: Agentotten#2610",
        Callback = function() end
    })

    CreditsPage.Button({ -- UI Design Credits
        Text = "UI Design: Material Lua - Twink Marie",
        Callback = function() end
    })
end