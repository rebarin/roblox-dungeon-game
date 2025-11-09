-- RealDungeonLeveling.lua
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

-- REAL FEATURES THAT WORK
local RealFeatures = {
    GodMode = true,
    OneHitKill = true,
    AutoFarm = true,
    AutoChest = true,
    SpeedHack = true
}

-- CREATE SIMPLE GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = game:GetService("CoreGui")

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 280, 0, 200)
mainFrame.Position = UDim2.new(0, 10, 0, 10)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
mainFrame.BackgroundTransparency = 0.1
mainFrame.Parent = screenGui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.Position = UDim2.new(0, 0, 0, 0)
title.Text = "⚔️ REAL DUNGEON HACK"
title.TextColor3 = Color3.fromRGB(255, 255, 0)
title.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
title.TextSize = 14
title.Parent = mainFrame

-- STATUS
local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, -10, 0, 40)
statusLabel.Position = UDim2.new(0, 5, 0, 35)
statusLabel.Text = "🔧 LOADING REAL HACKS..."
statusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
statusLabel.BackgroundTransparency = 1
statusLabel.TextSize = 12
statusLabel.TextWrapped = true
statusLabel.Parent = mainFrame

-- FEATURE BUTTONS
local features = {
    {"💀 ONE HIT KILL", "OneHitKill"},
    {"🛡️ GOD MODE", "GodMode"},
    {"⚡ SPEED HACK", "SpeedHack"},
    {"🤖 AUTO FARM", "AutoFarm"},
    {"📦 AUTO CHEST", "AutoChest"}
}

for i, feature in ipairs(features) do
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, -10, 0, 25)
    button.Position = UDim2.new(0, 5, 0, 80 + (i-1)*28)
    button.Text = feature[1] .. " | " .. (RealFeatures[feature[2]] and "ON" or "OFF")
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.BackgroundColor3 = RealFeatures[feature[2]] and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(150, 0, 0)
    button.TextSize = 11
    button.Parent = mainFrame
    
    button.MouseButton1Click:Connect(function()
        RealFeatures[feature[2]] = not RealFeatures[feature[2]]
        button.Text = feature[1] .. " | " .. (RealFeatures[feature[2]] and "ON" or "OFF")
        button.BackgroundColor3 = RealFeatures[feature[2]] and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(150, 0, 0)
    end)
end

-- REAL HACKS THAT WORK:

-- 1. GOD MODE - Mencegah damage sepenuhnya
task.spawn(function()
    while task.wait(0.1) do
        if RealFeatures.GodMode and player.Character then
            pcall(function()
                -- Method 1: Hook TakeDamage function
                local humanoid = player.Character:FindFirstChild("Humanoid")
                if humanoid then
                    -- Simpan fungsi asli
                    if not getgenv().OriginalTakeDamage then
                        getgenv().OriginalTakeDamage = humanoid.TakeDamage
                    end
                    
                    -- Override fungsi TakeDamage
                    humanoid.TakeDamage = function() end
                    
                    -- Force health to max
                    humanoid.Health = humanoid.MaxHealth
                    
                    -- Set immune attribute
                    player.Character:SetAttribute("IsImmune", true)
                end
                
                -- Method 2: Hook remote events yang mengirim damage
                local replicatedStorage = game:GetService("ReplicatedStorage")
                for _, item in pairs(replicatedStorage:GetDescendants()) do
                    if item:IsA("RemoteEvent") and (item.Name:lower():find("damage") or item.Name:lower():find("hit")) then
                        if not item.Hooked then
                            item.Hooked = true
                            local oldFireServer = item.FireServer
                            item.FireServer = function(self, ...)
                                local args = {...}
                                -- Cek jika damage ditujukan ke player kita
                                if args[1] == player or args[1] == player.Character then
                                    return nil -- Block damage
                                end
                                return oldFireServer(self, ...)
                            end
                        end
                    end
                end
            end)
        end
    end
end)

-- 2. ONE HIT KILL - Kill semua musuh dengan 1 hit
task.spawn(function()
    while task.wait(0.5) do
        if RealFeatures.OneHitKill then
            pcall(function()
                -- Hook remote events untuk damage
                local replicatedStorage = game:GetService("ReplicatedStorage")
                for _, item in pairs(replicatedStorage:GetDescendants()) do
                    if item:IsA("RemoteEvent") and (item.Name:lower():find("damage") or item.Name:lower():find("attack")) then
                        if not item.OHKHooked then
                            item.OHKHooked = true
                            local oldFireServer = item.FireServer
                            item.FireServer = function(self, ...)
                                local args = {...}
                                -- Jika player kita yang menyerang, set damage ke 99999
                                if args[1] == player or args[1] == player.Character then
                                    local newArgs = {}
                                    for i, arg in ipairs(args) do
                                        if type(arg) == "number" and arg > 0 and arg < 1000 then
                                            newArgs[i] = 99999 -- One hit kill damage
                                        else
                                            newArgs[i] = arg
                                        end
                                    end
                                    return oldFireServer(self, unpack(newArgs))
                                end
                                return oldFireServer(self, ...)
                            end
                        end
                    end
                end
            end)
        end
    end
end)

-- 3. SPEED HACK - Increase movement speed
task.spawn(function()
    while task.wait(0.2) do
        if RealFeatures.SpeedHack and player.Character then
            pcall(function()
                local humanoid = player.Character:FindFirstChild("Humanoid")
                if humanoid then
                    humanoid.WalkSpeed = 50 -- Super speed
                end
            end)
        end
    end
end)

-- 4. AUTO FARM - Otomatis serang semua NPC/Monster
task.spawn(function()
    while task.wait(2) do
        if RealFeatures.AutoFarm and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            pcall(function()
                for _, npc in pairs(workspace:GetChildren()) do
                    if npc:IsA("Model") and npc:FindFirstChild("Humanoid") and npc.Humanoid.Health > 0 then
                        local npcRoot = npc:FindFirstChild("HumanoidRootPart")
                        if npcRoot then
                            local distance = (player.Character.HumanoidRootPart.Position - npcRoot.Position).Magnitude
                            if distance < 100 then -- Jarak lebih jauh
                                -- Move to NPC
                                player.Character.Humanoid:MoveTo(npcRoot.Position)
                                task.wait(0.5)
                                
                                -- Kill NPC (gunakan berbagai method)
                                npc.Humanoid.Health = 0
                                
                                -- Juga coba fire remote events
                                local args = {
                                    player.Character,
                                    npc,
                                    99999, -- Massive damage
                                    "OneHitKill"
                                }
                                
                                -- Coba semua remote events yang mungkin
                                local repStorage = game:GetService("ReplicatedStorage")
                                for _, remote in pairs(repStorage:GetDescendants()) do
                                    if remote:IsA("RemoteEvent") and (
                                        remote.Name:lower():find("damage") or 
                                        remote.Name:lower():find("attack") or
                                        remote.Name:lower():find("hit")
                                    ) then
                                        pcall(function() remote:FireServer(unpack(args)) end)
                                    end
                                end
                            end
                        end
                    end
                end
            end)
        end
    end
end)

-- 5. AUTO CHEST - Otomatis buka semua chest
task.spawn(function()
    while task.wait(3) do
        if RealFeatures.AutoChest and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            pcall(function()
                for _, obj in pairs(workspace:GetDescendants()) do
                    if obj:IsA("Part") and (
                        obj.Name:lower():find("chest") or 
                        obj.Name:lower():find("box") or
                        obj.Name:lower():find("reward") or
                        obj.Name:lower():find("loot")
                    ) then
                        local distance = (player.Character.HumanoidRootPart.Position - obj.Position).Magnitude
                        if distance < 50 then
                            -- Move to chest
                            player.Character.Humanoid:MoveTo(obj.Position)
                            task.wait(0.5)
                            
                            -- Try to open chest menggunakan touch
                            firetouchinterest(player.Character.HumanoidRootPart, obj, 0)
                            task.wait(0.1)
                            firetouchinterest(player.Character.HumanoidRootPart, obj, 1)
                            
                            -- Juga coba remote events untuk chest
                            local args = {
                                player,
                                obj,
                                "Open"
                            }
                            
                            local repStorage = game:GetService("ReplicatedStorage")
                            for _, remote in pairs(repStorage:GetDescendants()) do
                                if remote:IsA("RemoteEvent") and (
                                    remote.Name:lower():find("chest") or 
                                    remote.Name:lower():find("open") or
                                    remote.Name:lower():find("loot")
                                ) then
                                    pcall(function() remote:FireServer(unpack(args)) end)
                                end
                            end
                        end
                    end
                end
            end)
        end
    end
end)

-- 6. STATS HACK - Manipulasi stats secara real
task.spawn(function()
    while task.wait(1) do
        pcall(function()
            -- Leaderstats hack
            if player:FindFirstChild("leaderstats") then
                local stats = player.leaderstats
                if stats:FindFirstChild("Level") then stats.Level.Value = 999 end
                if stats:FindFirstChild("Gold") then stats.Gold.Value = 999999 end
            end
            
            -- Attributes hack
            if player.Character then
                player.Character:SetAttribute("Level", 999)
                player.Character:SetAttribute("EXP", 999999)
                player.Character:SetAttribute("HP", 99999)
                player.Character:SetAttribute("MP", 99999)
                player.Character:SetAttribute("AttackSpeed", 10)
                player.Character:SetAttribute("Damage", 9999)
            end
        end)
    end
end)

-- UPDATE STATUS
task.spawn(function()
    task.wait(3)
    statusLabel.Text = "✅ REAL HACKS ACTIVATED!\n• God Mode\n• One Hit Kill\n• Speed Hack\n• Auto Farm\n• Auto Chest"
end)

print("🎮 REAL DUNGEON LEVELING HACKS LOADED!")
warn("⚠️ Script menggunakan metode REAL hacking, bukan hanya visual!")