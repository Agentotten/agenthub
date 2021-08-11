local AgentUtils = {Keys = {}} do
	function AgentUtils:GetPlayer(playerName)
		if playerName then return game:GetService("Players")[playerName] end
		return game:GetService("Players").LocalPlayer
	end

	function AgentUtils:GetCharacter(playerName)
		if playerName then return self:GetPlayer(playerName).Character end
		return self:GetPlayer().Character
	end

	function AgentUtils:GetHumanoid(playerName)
		if playerName then return self:GetCharacter(playerName).Humanoid end
		return self:GetCharacter().Humanoid
	end

	function AgentUtils:GetRoot(playerName)
		if playerName then return self:GetCharacter(playerName).HumanoidRootPart end
		return self:GetCharacter().HumanoidRootPart
	end

	function AgentUtils:Teleport(position)
		self:GetRoot().CFrame = position
	end

	game:GetService("UserInputService").InputBegan:Connect(function(input, proccessed)
		if proccessed then return end
		local key = string.split(tostring(input.KeyCode), ".")[3]
		AgentUtils.Keys[key] = true
	end)
	
	game:GetService("UserInputService").InputEnded:Connect(function(input, proccessed)
		if proccessed then return end
		local key = string.split(tostring(input.KeyCode), ".")[3]
		if AgentUtils.Keys[key] then AgentUtils.Keys[key] = false end
	end)
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
	getgenv().AgentHub.CanFly = false
	getgenv().AgentHub.CanNoclip = false
	getgenv().AgentHub.CanInfJump = false
	getgenv().AgentHub.FlySpeed = 0.25

	local CharacterPage = Window.New({
		Title = "Character"
	})

	CharacterPage.Slider({ -- WalkSpeed Slider
		Text = "WalkSpeed",
		Callback = function(value)
			AgentUtils:GetHumanoid().WalkSpeed = value
		end,
		Min = 0,
		Max = 1000,
		Def = AgentUtils:GetHumanoid().WalkSpeed
	})

	CharacterPage.Slider({ -- JumpPower Slider
		Text = "JumpPower",
		Callback = function(value)
			AgentUtils:GetHumanoid().JumpPower = value
		end,
		Min = 0,
		Max = 1000,
		Def = AgentUtils:GetHumanoid().JumpPower
	})

	CharacterPage.Slider({ -- Fly Speed Slider
		Text = "Fly Speed",
		Callback = function(value)
			getgenv().AgentHub.FlySpeed = value * 0.25
		end,
		Min = 0,
		Max = 100,
		Def = 1
	})

	CharacterPage.Toggle({ -- Fly Toggle
		Text = "Fly",
		Callback = function(value)
			if value == true then
				getgenv().AgentHub.CanFly = true

				local root = AgentUtils:GetRoot()
				local bodyP = Instance.new("BodyPosition")
				local bodyG = Instance.new("BodyGyro")

				bodyP.MaxForce = Vector3.new(1, 1, 1) * math.huge
				bodyP.Position = root.Position
				bodyP.Parent = root

				bodyG.MaxTorque = Vector3.new(1, 1, 1) * 9e9
				bodyG.CFrame = root.CFrame
				bodyG.Parent = root

				AgentUtils:GetHumanoid().PlatformStand = true

				local flyLoop flyLoop = game:GetService("RunService").Stepped:Connect(function()
					if getgenv().AgentHub.CanFly == false then
						flyLoop:Disconnect()
						bodyP:Destroy()
						bodyG:Destroy()
						AgentUtils:GetHumanoid().PlatformStand = false
					end

					local newPos = (bodyG.CFrame - (bodyG.CFrame).Position) + bodyP.Position
					local coordinateFrame = workspace.CurrentCamera.CFrame

					if AgentUtils.Keys["W"] then
						newPos = newPos + coordinateFrame.LookVector * getgenv().AgentHub.FlySpeed

						bodyP.Position = (root.CFrame * CFrame.new(0, 0, -getgenv().AgentHub.FlySpeed)).Position
						bodyG.CFrame = coordinateFrame * CFrame.Angles(-math.rad(getgenv().AgentHub.FlySpeed * 15), 0, 0)
					end

					if AgentUtils.Keys["A"] then
						newPos = newPos * CFrame.new(-getgenv().AgentHub.FlySpeed, 0, 0)
					end

					if AgentUtils.Keys["S"] then
						newPos = newPos - coordinateFrame.LookVector * getgenv().AgentHub.FlySpeed

						bodyP.Position = (root.CFrame * CFrame.new(0, 0, getgenv().AgentHub.FlySpeed)).Position
						bodyG.CFrame = coordinateFrame * CFrame.Angles(-math.rad(getgenv().AgentHub.FlySpeed * 15), 0, 0)
					end

					if AgentUtils.Keys["D"] then
						newPos = newPos * CFrame.new(getgenv().AgentHub.FlySpeed, 0, 0)
					end

					bodyP.Position = newPos.Position
					bodyG.CFrame = coordinateFrame
				end)

			elseif getgenv().AgentHub.CanFly == true then
				getgenv().AgentHub.CanFly = false
			end
		end,
		Enabled = false
	})

	CharacterPage.Toggle({ -- Noclip Toggle
		Text = "Noclip",
		Callback = function(value)
			if value == true then
				getgenv().AgentHub.CanNoclip = true

				local noclipLoop noclipLoop = game:GetService("RunService").Stepped:Connect(function()
					if getgenv().AgentHub.CanNoclip == false then
						noclipLoop:Disconnect()
					end

					for _, v in pairs(AgentUtils:GetCharacter():GetDescendants()) do
						if v:IsA("BasePart") and v.CanCollide == true then
							v.CanCollide = false
						end
					end
				end)

			elseif getgenv().AgentHub.CanNoclip == true then
				getgenv().AgentHub.CanNoclip = false
			end
		end,
		Enabled = false
	})

	CharacterPage.Toggle({ -- Infinite Jump Toggle
		Text = "Infinite Jump",
		Callback = function(value)
			if value == true then
				getgenv().AgentHub.CanInfJump = true

				local infJumpLoop infJumpLoop = game:GetService("UserInputService").JumpRequest:Connect(function()
					if getgenv().AgentHub.CanInfJump == false then
						infJumpLoop:Disconnect()
					end

					game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
				end)

			elseif getgenv().AgentHub.CanInfJump == true then
				getgenv().AgentHub.CanInfJump = false
			end
		end,
		Enabled = false
	})
end

do -- Teleport Page
	local selectedPlayer = nil

	local TeleportPage = Window.New({
		Title = "Teleport"
	})

	TeleportPage.Button({ -- Teleport To Button
		Text = "Teleport To",
		Callback = function()
			AgentUtils:Teleport(AgentUtils:GetRoot(selectedPlayer).CFrame * CFrame.new(0, 0, 2))
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

	UpdatePlayerList()

	game:GetService("Players").PlayerAdded:Connect(UpdatePlayerList)
	game:GetService("Players").PlayerRemoving:Connect(UpdatePlayerList)
end

do -- Games Page
	if getgenv().AgentHub.GameScripts and #getgenv().AgentHub.GameScripts > 0 then
		local GameScriptsPage = Window.New({
			Title = "Games"
		})

		for _, gs in pairs(getgenv().AgentHub.GameScripts) do
			GameScriptsPage.Button({
				Text = string.split(gs.Name, ".")[1],
				Callback = gs
			})
		end
	end
end

do -- Scripts Page
	if getgenv().AgentHub.Scripts and #getgenv().AgentHub.Scripts > 0 then
		local ScriptsPage = Window.New({
			Title = "Scripts"
		})

		for _, s in pairs(getgenv().AgentHub.Scripts) do
			ScriptsPage.Button({
				Text = string.split(s.Name, ".")[1],
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
		Callback = function()
			local sound = Instance.new("Sound")
			sound.SoundId = "rbxassetid://929935298"
			game:GetService("SoundService"):PlayLocalSound(sound)
			sound:Destroy()
		end
	})

	CreditsPage.Button({ -- UI Design Credits
		Text = "UI Design: Material Lua - Twink Marie",
		Callback = function()
			local sound = Instance.new("Sound")
			sound.SoundId = "rbxassetid://929935298"
			game:GetService("SoundService"):PlayLocalSound(sound)
			sound:Destroy()
		end
	})
end
