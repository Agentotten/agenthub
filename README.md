## Script
```Lua
getgenv().Games = {
	
}

getgenv().Scripts = {
    Infinite_Yield = { -- https://infyield.yolasite.com
		Name = "Infinite Yield FE",

		Source = function()
			loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
		end
	},

	Hydroxide = { -- https://github.com/Upbolt/Hydroxide
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

loadstring(game:HttpGet("https://raw.githubusercontent.com/Agentotten/agenthub/beta/source.lua"))()
```
