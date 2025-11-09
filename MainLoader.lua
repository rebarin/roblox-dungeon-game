-- MainLoader.lua
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
    mainFrame.Size = UDim2.new(0, 320, 0, 350)
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

    -- Status display
    local statusLabel = Instance.new("TextLabel")
    statusLabel.Size = UDim2.new(1, -20, 0, 60)
    statusLabel.Position = UDim2.new(0, 10, 0, 45)
    statusLabel.Text = "🎮 Script Loaded!\nClick buttons to toggle features"
    statusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
    statusLabel.BackgroundTransparency = 1
    statusLabel.TextSize = 12
    statusLabel.TextWrapped = true
    statusLabel.Parent = mainFrame

    -- Feature buttons
    local features = {
        {"🛡️ GOD MODE", "GodMode", "Become invincible"},
        {"⚡ UNLIMITED STATS", "UnlimitedStats", "Max level & resources"}, 
        {"🤖 AUTO FARM", "AutoFarm", "Auto kill monsters"},
        {"📦 AUTO CHEST", "AutoChest", "Auto open chests"},
        {"🚀 ANTI AFK", "AntiAFK", "Prevent AFK kick"}
    }

    local buttons = {}

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
        
        buttons[feature[2]] = button
        
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

    return screenGui, statusLabel, buttons
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

-- REAL WORKING FEATURES
function Library:StartGodMode()
    local Players = game:GetService("Players")
    local player = Players.LocalPlayer
    
    -- Method 1: Direct character protection
    local function protectCharacter(character)
        if not character then return end
        
        local humanoid = character:WaitForChild("Humanoid")
        
        -- Prevent health decrease
        humanoid.HealthChanged:Connect(function()
            if humanoid.Health < humanoid.MaxHealth then
                humanoid.Health = humanoid.MaxHealth
            end
        end)
        
        -- Prevent death
        humanoid.Died:Connect(function()
            task.wait(3)
            player:LoadCharacter()
        end)
        
        -- Constant health monitoring
        while task.wait(1) and _G.DungeonGameFeatures.GodMode do
            humanoid.Health = humanoid.MaxHealth
        end
    end
    
    if player.Character then
        protectCharacter(player.Character)
    end
    player.CharacterAdded:Connect(protectCharacter)
end

function Library:StartUnlimitedStats()
    local Players = game:GetService("Players")
    local player = Players.LocalPlayer
    
    while task.wait(2) and _G.DungeonGameFeatures.UnlimitedStats do
        -- Method 1: Modify leaderstats
        local leaderstats = player:FindFirstChild("leaderstats")
        if leaderstats then
            for _, stat in pairs(leaderstats:GetChildren()) do
                if stat:IsA("NumberValue") then
                    if stat.Name:lower():find("level") or stat.Name:lower():find("lvl") then
                        stat.Value = 999
                    elseif stat.Name:lower():find("coin") or stat.Name:lower():find("money") or stat.Name:lower():find("gold") then
                        stat.Value = 999999
                    elseif stat.Name:lower():find("damage") or stat.Name:lower():find("dmg") then
                        stat.Value = 9999
                    else
                        stat.Value = math.max(stat.Value, 999)
                    end
                end
            end
        end
        
        -- Method 2: Modify attributes
        if player.Character then
            player.Character:SetAttribute("Level", 999)
            player.Character:SetAttribute("Damage", 9999)
        end
    end
end

function Library:StartAutoFarm()
    local Players = game:GetService("Players")
    local player = Players.LocalPlayer
    
    while task.wait(3) and _G.DungeonGameFeatures.AutoFarm do
        local character = player.Character
        if not character then continue end
        
        local humanoid = character:FindFirstChild("Humanoid")
        local rootPart = character:FindFirstChild("HumanoidRootPart")
        if not humanoid or not rootPart then continue end
        
        -- Find nearest monster
        local nearestMonster = nil
        local nearestDistance = 50
        
        for _, obj in pairs(workspace:GetChildren()) do
            if obj:IsA("Model") and obj:FindFirstChild("Humanoid") then
                local monsterHumanoid = obj.Humanoid
                local monsterRoot = obj:FindFirstChild("HumanoidRootPart") or obj:FindFirstChild("Head")
                
                if monsterHumanoid and monsterRoot and monsterHumanoid.Health > 0 then
                    local distance = (rootPart.Position - monsterRoot.Position).Magnitude
                    
                    if distance < nearestDistance then
                        nearestMonster = obj
                        nearestDistance = distance
                    end
                end
            end
        end
        
        -- Attack monster
        if nearestMonster then
            local monsterRoot = nearestMonster:FindFirstChild("HumanoidRootPart")
            if monsterRoot then
                humanoid:MoveTo(monsterRoot.Position)
                task.wait(1)
                nearestMonster.Humanoid.Health = 0
            end
        end
    end
end

function Library:StartAutoChest()
    local Players = game:GetService("Players")
    local player = Players.LocalPlayer
    
    while task.wait(4) and _G.DungeonGameFeatures.AutoChest do
        local character = player.Character
        if not character then continue end
        
        local humanoid = character:FindFirstChild("Humanoid")
        local rootPart = character:FindFirstChild("HumanoidRootPart")
        if not humanoid or not rootPart then continue end
        
        -- Find chests
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("Part") and (obj.Name:lower():find("chest") or obj.Name:lower():find("box") or obj.Name:lower():find("reward")) then
                local distance = (rootPart.Position - obj.Position).Magnitude
                
                if distance < 30 then
                    humanoid:MoveTo(obj.Position)
                    task.wait(1)
                    
                    -- Try to trigger chest
                    firetouchinterest(rootPart, obj, 0)
                    task.wait(0.1)
                    firetouchinterest(rootPart, obj, 1)
                end
            end
        end
    end
end

function Library:StartAntiAFK()
    local Players = game:GetService("Players")
    local player = Players.LocalPlayer
    local VirtualInputManager = game:GetService("VirtualInputManager")
    
    while task.wait(30) and _G.DungeonGameFeatures.AntiAFK do
        -- Simulate key press
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.W, false, game)
        task.wait(0.1)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.W, false, game)
        
        -- Small movement
        local character = player.Character
        if character and character:FindFirstChild("Humanoid") then
            character.Humanoid:MoveTo(character.HumanoidRootPart.Position + Vector3.new(2, 0, 2))
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
    
    statusLabel.Text = "✅ ALL SYSTEMS READY!\nFeatures are now active"
    
    print("🎮 Dungeon Leveling Hub Activated!")
end

-- Start the script
Library:Load()
return Library
