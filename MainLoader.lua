-- MainLoader.lua
local Library = {}

function Library:LoadDungeonGame()
    -- Anti detection
    if not game:IsLoaded() then
        game.Loaded:Wait()
    end
    
    -- Check if already loaded
    if _G.DungeonGameLoaded then
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Info",
            Text = "Dungeon Game already loaded!",
            Duration = 3
        })
        return
    end
    _G.DungeonGameLoaded = true
    
    -- Load notification
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Loading...",
        Text = "Dungeon Game Features Loading!",
        Duration = 3
    })
    
    -- Load semua modules
    local modules = {
        "https://raw.githubusercontent.com/rebarin/roblox-dungeon-game/main/AntiHitSystem.lua",
        "https://raw.githubusercontent.com/rebarin/roblox-dungeon-game/main/UnlimitedMana.lua", 
        "https://raw.githubusercontent.com/rebarin/roblox-dungeon-game/main/GameGUI.lua",
        "https://raw.githubusercontent.com/rebarin/roblox-dungeon-game/main/AutoFarm.lua"
    }
    
    for i, url in ipairs(modules) do
        coroutine.wrap(function()
            local success, err = pcall(function()
                loadstring(game:HttpGet(url, true))()
            end)
            if not success then
                warn("Failed to load module " .. i .. ": " .. err)
            end
        end)()
        wait(1)
    end
    
    -- Final notification
    wait(3)
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Success!",
        Text = "All Dungeon Game Features Activated!",
        Duration = 5
    })
    
    print("🎮 Dungeon Game Loaded Successfully!")
end

-- Auto execute
Library:LoadDungeonGame()
return Library