-- AdvancedDungeonHack.lua
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

local Features = {
    GodMode = true,
    OneHitKill = true, 
    AutoFarm = true,
    AutoChest = true,
    SpeedHack = true
}

-- CREATE GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = game:GetService("CoreGui")

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 300, 0, 250)
mainFrame.Position = UDim2.new(0, 10, 0, 10)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
mainFrame.Parent = screenGui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.Position = UDim2.new(0, 0, 0, 0)
title.Text = "⚔️ ADVANCED DUNGEON HACK"
title.TextColor3 = Color3.fromRGB(255, 255, 0)
title.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
title.Parent = mainFrame

local status = Instance.new("TextLabel")
status.Size = UDim2.new(1, -10, 0, 60)
status.Position = UDim2.new(0, 5, 0, 35)
status.Text = "🔄 LOADING ADVANCED METHODS..."
status.TextColor3 = Color3.fromRGB(0, 255, 255)
status.BackgroundTransparency = 1
status.TextSize = 12
status.TextWrapped = true
status.Parent = mainFrame

-- FEATURE BUTTONS
local buttons = {}
local featureList = {
    {"💀 ONE HIT KILL", "OneHitKill"},
    {"🛡️ GOD MODE", "GodMode"},
    {"⚡ SPEED HACK", "SpeedHack"},
    {"🤖 AUTO FARM", "AutoFarm"},
    {"📦 AUTO CHEST", "AutoChest"}
}

for i, feature in ipairs(featureList) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 25)
    btn.Position = UDim2.new(0, 5, 0, 100 + (i-1)*28)
    btn.Text = feature[1] .. " | " .. (Features[feature[2]] and "ON" or "OFF")
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.BackgroundColor3 = Features[feature[2]] and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(150, 0, 0)
    btn.TextSize = 11
    btn.Parent = mainFrame
    buttons[feature[2]] = btn
    
    btn.MouseButton1Click:Connect(function()
        Features[feature[2]] = not Features[feature[2]]
        btn.Text = feature[1] .. " | " .. (Features[feature[2]] and "ON" or "OFF")
        btn.BackgroundColor3 = Features[feature[2]] and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(150, 0, 0)
    end)
end

-- METHOD 1: HOOK METATABLES (PALING EFFECTIVE)
task.spawn(function()
    -- Hook __namecall metatable untuk intercept semua function calls
    local mt = getrawmetatable(game)
    local oldNamecall = mt.__namecall
    
    if setreadonly then setreadonly(mt, false) end
    
    mt.__namecall = newcclosure(function(self, ...)
        local method = getnamecallmethod()
        local args = {...}
        
        -- GOD MODE: Block damage related calls
        if Features.GodMode then
            if method == "FireServer" then
                if tostring(self):lower():find("damage") or tostring(self):lower():find("hit") then
                    for i, arg in ipairs(args) do
                        if arg == player or arg == player.Character then
                            return nil -- Block damage to player
                        end
                    end
                end
            end
            
            if method == "TakeDamage" then
                if self == player.Character.Humanoid then
                    return nil -- Block TakeDamage function
                end
            end
        end
        
        -- ONE HIT KILL: Boost damage dari player
        if Features.OneHitKill then
            if method == "FireServer" then
                if tostring(self):lower():find("damage") or tostring(self):lower():find("attack") then
                    for i, arg in ipairs(args) do
                        if arg == player or arg == player.Character then
                            -- Modify damage arguments
                            for j, damageArg in ipairs(args) do
                                if type(damageArg) == "number" and damageArg > 0 then
                                    args[j] = 999999
                                end
                            end
                        end
                    end
                end
            end
        end
        
        return oldNamecall(self, unpack(args))
    end)
    
    status.Text = "✅ METATABLE HOOKED!\nReal protection activated"
end)

-- METHOD 2: CONSTANT CHARACTER PROTECTION
task.spawn(function()
    while task.wait(0.1) do
        if player.Character then
            -- GOD MODE: Force health regeneration
            if Features.GodMode then
                pcall(function()
                    player.Character.Humanoid.Health = player.Character.Humanoid.MaxHealth
                    
                    -- Force immune attributes
                    player.Character:SetAttribute("IsImmune", true)
                    player.Character:SetAttribute("HP", 99999)
                    
                    -- Hook health change
                    if not player.Character.Humanoid.HealthChangedHook then
                        player.Character.Humanoid.HealthChangedHook = true
                        player.Character.Humanoid.HealthChanged:Connect(function()
                            if player.Character.Humanoid.Health < player.Character.Humanoid.MaxHealth then
                                player.Character.Humanoid.Health = player.Character.Humanoid.MaxHealth
                            end
                        end)
                    end
                end)
            end
            
            -- SPEED HACK
            if Features.SpeedHack then
                pcall(function()
                    player.Character.Humanoid.WalkSpeed = 50
                end)
            end
        end
    end
end)

-- METHOD 3: AGGRESSIVE AUTO FARM
task.spawn(function()
    while task.wait(1) do
        if Features.AutoFarm and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            pcall(function()
                -- Cari semua model yang mungkin musuh
                for _, obj in pairs(workspace:GetDescendants()) do
                    if obj:IsA("Model") and obj:FindFirstChild("Humanoid") and obj.Humanoid.Health > 0 then
                        if obj ~= player.Character then
                            local root = obj:FindFirstChild("HumanoidRootPart") or obj:FindFirstChild("Head")
                            if root then
                                local distance = (player.Character.HumanoidRootPart.Position - root.Position).Magnitude
                                
                                if distance < 100 then
                                    -- Approach target
                                    player.Character.Humanoid:MoveTo(root.Position)
                                    
                                    -- INSTANT KILL dengan berbagai metode
                                    task.wait(0.3)
                                    
                                    -- Method 1: Direct health set
                                    obj.Humanoid.Health = 0
                                    
                                    -- Method 2: Fire damage remote
                                    local args = {
                                        player.Character,
                                        obj,
                                        999999, -- Massive damage
                                        "Sword",
                                        Vector3.new(0, 0, 0)
                                    }
                                    
                                    -- Coba semua remote event yang mungkin
                                    for _, remote in pairs(game:GetDescendants()) do
                                        if remote:IsA("RemoteEvent") then
                                            pcall(function()
                                                remote:FireServer(unpack(args))
                                            end)
                                        end
                                    end
                                    
                                    break -- Focus satu target dulu
                                end
                            end
                        end
                    end
                end
            end)
        end
    end
end)

-- METHOD 4: AGGRESSIVE AUTO CHEST
task.spawn(function()
    while task.wait(2) do
        if Features.AutoChest and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            pcall(function()
                -- Cari semua chest/collectible
                for _, obj in pairs(workspace:GetDescendants()) do
                    if obj:IsA("Part") then
                        local nameLower = obj.Name:lower()
                        if nameLower:find("chest") or nameLower:find("coin") or nameLower:find("reward") or nameLower:find("loot") or nameLower:find("gem") then
                            local distance = (player.Character.HumanoidRootPart.Position - obj.Position).Magnitude
                            
                            if distance < 50 then
                                -- Move to object
                                player.Character.Humanoid:MoveTo(obj.Position)
                                task.wait(0.5)
                                
                                -- Method 1: Touch trigger
                                firetouchinterest(player.Character.HumanoidRootPart, obj, 0)
                                task.wait(0.1)
                                firetouchinterest(player.Character.HumanoidRootPart, obj, 1)
                                
                                -- Method 2: Remote event trigger
                                local args = {
                                    player,
                                    obj,
                                    "Collect"
                                }
                                
                                for _, remote in pairs(game:GetDescendants()) do
                                    if remote:IsA("RemoteEvent") then
                                        pcall(function()
                                            remote:FireServer(unpack(args))
                                        end)
                                    end
                                end
                                
                                break
                            end
                        end
                    end
                end
            end)
        end
    end
end)

-- METHOD 5: STATS MANIPULATION
task.spawn(function()
    while task.wait(2) do
        pcall(function()
            -- Leaderstats manipulation
            if player:FindFirstChild("leaderstats") then
                for _, stat in pairs(player.leaderstats:GetChildren()) do
                    if stat:IsA("IntValue") or stat:IsA("NumberValue") then
                        if stat.Name == "Level" then stat.Value = 999 end
                        if stat.Name == "Gold" then stat.Value = 999999 end
                        if stat.Name == "Gems" then stat.Value = 99999 end
                    end
                end
            end
            
            -- Attributes manipulation
            if player.Character then
                player.Character:SetAttribute("Level", 999)
                player.Character:SetAttribute("EXP", 999999)
                player.Character:SetAttribute("Damage", 9999)
                player.Character:SetAttribute("AttackSpeed", 10)
            end
        end)
    end
end)

print("🎮 ADVANCED DUNGEON HACK LOADED!")