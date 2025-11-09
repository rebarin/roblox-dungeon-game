-- GameAnalyzer.lua
local function AnalyzeGame()
    local output = {"=== DUNGEON LEVELING GAME ANALYSIS ==="}
    local player = game.Players.LocalPlayer
    
    -- Function to add lines to output
    local function addLine(text)
        table.insert(output, text)
    end
    
    addLine("🎮 GAME INFORMATION:")
    addLine("Game: " .. game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name)
    addLine("Place ID: " .. game.PlaceId)
    addLine("")
    
    -- Player Data Analysis
    addLine("👤 PLAYER DATA:")
    addLine("Player Name: " .. player.Name)
    addLine("")
    
    -- Leaderstats Analysis
    addLine("📊 LEADERSTATS ANALYSIS:")
    local leaderstats = player:FindFirstChild("leaderstats")
    if leaderstats then
        for _, stat in pairs(leaderstats:GetChildren()) do
            addLine("  " .. stat.Name .. " = " .. tostring(stat.Value) .. " (" .. stat.ClassName .. ")")
        end
    else
        addLine("  ❌ No leaderstats found")
    end
    addLine("")
    
    -- Character Analysis
    addLine("🎯 CHARACTER ANALYSIS:")
    if player.Character then
        -- Basic character info
        local humanoid = player.Character:FindFirstChild("Humanoid")
        if humanoid then
            addLine("  Health: " .. humanoid.Health .. "/" .. humanoid.MaxHealth)
            addLine("  WalkSpeed: " .. humanoid.WalkSpeed)
        end
        
        -- Character Values
        addLine("  CHARACTER VALUES:")
        local hasValues = false
        for _, child in pairs(player.Character:GetChildren()) do
            if child:IsA("NumberValue") or child:IsA("StringValue") or child:IsA("BoolValue") then
                addLine("    " .. child.Name .. " = " .. tostring(child.Value))
                hasValues = true
            end
        end
        if not hasValues then
            addLine("    ❌ No value objects found")
        end
        
        -- Character Attributes
        addLine("  CHARACTER ATTRIBUTES:")
        local attributes = player.Character:GetAttributes()
        if next(attributes) then
            for attr, value in pairs(attributes) do
                addLine("    " .. attr .. " = " .. tostring(value))
            end
        else
            addLine("    ❌ No attributes found")
        end
    else
        addLine("  ❌ No character found")
    end
    addLine("")
    
    -- Backpack Analysis
    addLine("🎒 BACKPACK ANALYSIS:")
    local backpack = player:FindFirstChild("Backpack")
    if backpack then
        local toolCount = 0
        for _, item in pairs(backpack:GetChildren()) do
            toolCount = toolCount + 1
            if toolCount <= 10 then  -- Show first 10 items only
                addLine("  " .. item.Name .. " (" .. item.ClassName .. ")")
            end
        end
        addLine("  Total items: " .. toolCount)
    else
        addLine("  ❌ No backpack found")
    end
    addLine("")
    
    -- Game Services Analysis
    addLine("🏗️ GAME SERVICES ANALYSIS:")
    
    -- ReplicatedStorage Analysis
    addLine("  REPLICATED STORAGE:")
    local repStorage = game:GetService("ReplicatedStorage")
    local remoteCount = 0
    local moduleCount = 0
    
    for _, item in pairs(repStorage:GetChildren()) do
        if item:IsA("RemoteEvent") then
            remoteCount = remoteCount + 1
            if remoteCount <= 5 then
                addLine("    📡 RemoteEvent: " .. item.Name)
            end
        elseif item:IsA("RemoteFunction") then
            remoteCount = remoteCount + 1
            if remoteCount <= 5 then
                addLine("    🔄 RemoteFunction: " .. item.Name)
            end
        elseif item:IsA("ModuleScript") then
            moduleCount = moduleCount + 1
            if moduleCount <= 5 then
                addLine("    📦 ModuleScript: " .. item.Name)
            end
        end
    end
    addLine("    Total Remotes: " .. remoteCount)
    addLine("    Total Modules: " .. moduleCount)
    addLine("")
    
    -- Workspace Analysis
    addLine("🗺️ WORKSPACE ANALYSIS:")
    
    local monsterCount = 0
    local chestCount = 0
    local npcCount = 0
    
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("Model") then
            if obj:FindFirstChild("Humanoid") then
                if obj ~= player.Character then
                    if obj.Name:lower():find("monster") or obj.Name:lower():find("enemy") or obj.Name:lower():find("mob") then
                        monsterCount = monsterCount + 1
                    else
                        npcCount = npcCount + 1
                    end
                end
            end
            
            if obj.Name:lower():find("chest") or obj.Name:lower():find("box") or obj.Name:lower():find("reward") then
                chestCount = chestCount + 1
            end
        end
    end
    
    addLine("  🐉 Monsters: " .. monsterCount)
    addLine("  📦 Chests: " .. chestCount)
    addLine("  👥 NPCs: " .. npcCount)
    addLine("")
    
    -- PlayerGui Analysis
    addLine("📱 PLAYER GUI ANALYSIS:")
    local playerGui = player:FindFirstChild("PlayerGui")
    if playerGui then
        local screenGuiCount = 0
        for _, gui in pairs(playerGui:GetDescendants()) do
            if gui:IsA("ScreenGui") then
                screenGuiCount = screenGuiCount + 1
                if screenGuiCount <= 3 then
                    addLine("  ScreenGui: " .. gui.Name)
                end
            end
        end
        addLine("  Total ScreenGuis: " .. screenGuiCount)
    else
        addLine("  ❌ No PlayerGui found")
    end
    addLine("")
    
    -- Final Summary
    addLine("✅ ANALYSIS COMPLETE!")
    addLine("📋 COPY ALL TEXT ABOVE AND PASTE IT TO ME")
    addLine("==========================================")
    
    -- Print all output
    for _, line in pairs(output) do
        print(line)
    end
    
    -- Also show in message box for easy copying
    local fullText = table.concat(output, "\n")
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Game Analysis Complete!",
        Text = "Check Developer Console (F9) and copy all text",
        Duration = 10
    })
    
    return fullText
end

-- Run the analysis
AnalyzeGame()
