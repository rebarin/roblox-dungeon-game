-- DungeonLevelingHub.lua
local Library = {}

_G.DungeonGameFeatures = {
    GodMode = true,
    UnlimitedStats = true, 
    AutoFarm = true,
    AutoChest = true,
    AntiAFK = true
}

function Library:CreateGUI()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "DungeonLevelingHub"
    screenGui.Parent = game:GetService("CoreGui")
    
    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, 300, 0, 350)
    mainFrame.Position = UDim2.new(0, 10, 0, 10)
    mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    mainFrame.BackgroundTransparency = 0.1
    mainFrame.BorderSizePixel = 0
    mainFrame.Parent = screenGui
    
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 12)
    UICorner.Parent = mainFrame
    
    -- Title
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 40)
    title.Position = UDim2.new(0, 0, 0, 0)
    title.Text = "⚔️ DUNGEON LEVELING HUB"
    title.TextColor3 = Color3.fromRGB(255, 255, 0)
    title.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
    title.TextSize = 16
    title.Font = Enum.Font.GothamBold
    title.Parent = mainFrame
    
    local UICorner2 = Instance.new("UICorner")
    UICorner2.CornerRadius = UDim.new(0, 12)
    UICorner2.Parent = title

    -- Status
    local statusLabel = Instance.new("TextLabel")
    statusLabel.Size = UDim2.new(1, -20, 0, 60)
    statusLabel.Position = UDim2.new(0, 10, 0, 45)
    statusLabel.Text = "✅ Game Detected: Dungeon Leveling\nClick buttons to toggle features"
    statusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
    statusLabel.BackgroundTransparency = 1
    statusLabel.TextSize = 12
    statusLabel.TextWrapped = true
    statusLabel.Parent = mainFrame

    -- Features
    local features = {
        {"🛡️ GOD MODE", "GodMode", "Unlimited HP & No Death"},
        {"⚡ UNLIMITED STATS", "UnlimitedStats", "Max Level, Gold, MP"}, 
        {"🤖 AUTO FARM", "AutoFarm", "Auto kill monsters"},
        {"📦 AUTO CHEST", "AutoChest", "Auto open chests"},
        {"🚀 ANTI AFK", "AntiAFK", "Prevent AFK kick"}
    }

    for i, feature in ipairs(features) do
        local button = Instance.new("TextButton")
        button.Size = UDim2.new(1, -20, 0, 35)
        button.Position = UDim2.new(0, 10, 0, 115 + (i-1)*40)
        button.Text = feature[1] .. " | " .. (_G.DungeonGameFeatures[feature[2]] and "ON" or "OFF")
        button.TextColor3 = Color3.fromRGB(255, 255, 255)
        button.BackgroundColor3 = _G.DungeonGameFeatures[feature[2]] and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(150, 0, 0)
        button.TextSize = 12
        button.Parent = mainFrame
        
        local tooltip = Instance.new("TextLabel")
        tooltip.Size = UDim2.new(1, 0, 0, 15)
        tooltip.Position = UDim2.new(0, 0, 1, 0)
        tooltip.Text = feature[3]
        tooltip.TextColor3 = Color3.fromRGB(200, 200, 200)
        tooltip.BackgroundTransparency = 1
        tooltip.TextSize = 10
        tooltip.Parent = button
        
        local UICorner3 = Instance.new("UICorner")
        UICorner3.CornerRadius = UDim.new(0, 6)
        UICorner3.Parent = button
        
        button.MouseButton1Click:Connect(function()
            _G.DungeonGameFeatures[feature[2]] = not _G.DungeonGameFeatures[feature[2]]
            button.Text = feature[1] .. " | " .. (_G.DungeonGameFeatures[feature[2]] and "ON" or "OFF")
            button.BackgroundColor3 = _G.DungeonGameFeatures[feature[2]] and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(150, 0, 0)
            
            if _G.DungeonGameFeatures[feature[2]] then
                Library:EnableFeature(feature[2])
            else
                Library:DisableFeature(feature[2])
            end
        end)
    end

    return screenGui, statusLabel
end

function Library:EnableFeature(feature)
    if feature == "GodMode" then
        self:StartGodMode()
    elseif feature == "UnlimitedStats" then
        self:StartUnlimitedStats()
    elseif feature == "AutoFarm" then
        self:StartAutoFarm()
    elseif feature == "AutoChest" then
        self:StartAutoChest()
    elseif feature == "AntiAFK" then
        self:StartAntiAFK()
    end
end

function Library:DisableFeature(feature)
    print("Disabled: " .. feature)
end

-- REAL FEATURES BASED ON GAME ANALYSIS
function Library:StartGodMode()
    local player = game.Players.LocalPlayer
    
    local function protectCharacter(character)
        if not character then return end
        
        local humanoid = character:WaitForChild("Humanoid")
        
        -- CONSTANT HP & MP REGEN
        while task.wait(0.5) and _G.DungeonGameFeatures.GodMode do
            if character and humanoid then
                -- Set HP to max (based on game attributes)
                character:SetAttribute("HP", 99999)
                character:SetAttribute("MaxHP", 99999)
                humanoid.Health = 99999
                humanoid.MaxHealth = 99999
                
                -- Set MP to max
                character:SetAttribute("MP", 99999)
                character:SetAttribute("MaxMP", 99999)
                
                -- Make immune to damage
                character:SetAttribute("IsImmune", true)
                character:SetAttribute("Stunned", false)
            end
        end
    end
    
    if player.Character then
        coroutine.wrap(function() protectCharacter(player.Character) end)()
    end
    player.CharacterAdded:Connect(function(character)
        task.wait(2)
        coroutine.wrap(function() protectCharacter(character) end)()
    end)
end

function Library:StartUnlimitedStats()
    local player = game.Players.LocalPlayer
    
    while task.wait(2) and _G.DungeonGameFeatures.UnlimitedStats do
        -- MAX LEVEL & GOLD
        local leaderstats = player:FindFirstChild("leaderstats")
        if leaderstats then
            local level = leaderstats:FindFirstChild("Level")
            local gold = leaderstats:FindFirstChild("Gold")
            
            if level then level.Value = 999 end
            if gold then gold.Value = 999999 end
        end
        
        -- MAX CHARACTER ATTRIBUTES
        if player.Character then
            -- Level and EXP
            player.Character:SetAttribute("Level", 999)
            player.Character:SetAttribute("EXP", 999999)
            player.Character:SetAttribute("MXP", 999999)
            
            -- Combat stats
            player.Character:SetAttribute("AttackSpeed", 10)
            player.Character:SetAttribute("Blocking", 999)
            player.Character:SetAttribute("MaxBlocking", 999)
            
            -- Boosts
            player.Character:SetAttribute("EXPBoost", 100)
            player.Character:SetAttribute("MXPBoost", 100)
            
            -- Class enhancements
            player.Character:SetAttribute("AttKStats", "999:999:999:999:999:999")
            player.Character:SetAttribute("DefStats", "999:999:999:999:999:999")
        end
    end
end

function Library:StartAutoFarm()
    local player = game.Players.LocalPlayer
    
    while task.wait(3) and _G.DungeonGameFeatures.AutoFarm do
        local character = player.Character
        if not character then continue end
        
        local humanoid = character:FindFirstChild("Humanoid")
        local rootPart = character:FindFirstChild("HumanoidRootPart")
        if not humanoid or not rootPart then continue end
        
        -- Find and attack NPCs (based on analysis showing 8 NPCs)
        for _, npc in pairs(workspace:GetChildren()) do
            if not _G.DungeonGameFeatures.AutoFarm then break end
            
            if npc:IsA("Model") and npc:FindFirstChild("Humanoid") then
                local npcHumanoid = npc.Humanoid
                local npcRoot = npc:FindFirstChild("HumanoidRootPart")
                
                if npcHumanoid and npcRoot and npcHumanoid.Health > 0 and npc ~= character then
                    local distance = (rootPart.Position - npcRoot.Position).Magnitude
                    
                    if distance < 50 then
                        -- Move to NPC
                        humanoid:MoveTo(npcRoot.Position)
                        task.wait(1)
                        
                        -- Auto attack
                        npcHumanoid.Health = 0
                        task.wait(1)
                    end
                end
            end
        end
    end
end

function Library:StartAutoChest()
    local player = game.Players.LocalPlayer
    
    while task.wait(4) and _G.DungeonGameFeatures.AutoChest do
        local character = player.Character
        if not character then continue end
        
        local humanoid = character:FindFirstChild("Humanoid")
        local rootPart = character:FindFirstChild("HumanoidRootPart")
        if not humanoid or not rootPart then continue end
        
        -- Find and open chests (analysis showed 2 chests)
        for _, obj in pairs(workspace:GetDescendants()) do
            if not _G.DungeonGameFeatures.AutoChest then break end
            
            if obj:IsA("Part") and (
                obj.Name:lower():find("chest") or 
                obj.Name:lower():find("box") or
                obj.Name:lower():find("reward")
            ) then
                local distance = (rootPart.Position - obj.Position).Magnitude
                
                if distance < 30 then
                    -- Move to chest
                    humanoid:MoveTo(obj.Position)
                    task.wait(1)
                    
                    -- Auto collect chest
                    firetouchinterest(rootPart, obj, 0)
                    task.wait(0.2)
                    firetouchinterest(rootPart, obj, 1)
                    task.wait(1)
                end
            end
        end
    end
end

function Library:StartAntiAFK()
    local player = game.Players.LocalPlayer
    local VirtualInputManager = game:GetService("VirtualInputManager")
    
    while task.wait(25) and _G.DungeonGameFeatures.AntiAFK do
        -- Simulate movement
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.W, false, game)
        task.wait(0.1)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.W, false, game)
        
        -- Small character movement
        local character = player.Character
        if character and character:FindFirstChild("Humanoid") then
            character.Humanoid:MoveTo(character.HumanoidRootPart.Position + Vector3.new(3, 0, 3))
        end
    end
end

function Library:Load()
    if not game:IsLoaded() then
        game.Loaded:Wait()
    end
    
    if _G.DungeonLoaded then return end
    _G.DungeonLoaded = true
    
    local gui, statusLabel = self:CreateGUI()
    
    -- Auto start enabled features
    for feature, enabled in pairs(_G.DungeonGameFeatures) do
        if enabled then
            task.spawn(function()
                self:EnableFeature(feature)
            end)
        end
    end
    
    statusLabel.Text = "✅ DUNGEON LEVELING HUB LOADED!\nAll features are now active"
    
    -- Notification
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Dungeon Leveling Hub",
        Text = "Script loaded successfully!",
        Duration = 5
    })
    
    print("🎮 Dungeon Leveling Hub Activated!")
end

-- Start the script
Library:Load()
return Library