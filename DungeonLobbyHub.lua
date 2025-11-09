-- DungeonLobbyHub.lua
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

local Features = {
    GodMode = false,  -- Matikan dulu sampai masuk dungeon
    OneHitKill = false,
    AutoFarm = false,
    AutoChest = false,
    SpeedHack = true,
    AutoEnterDungeon = true  -- Fitur baru!
}

-- DETECT CURRENT LOCATION
function isInLobby()
    return workspace:FindFirstChild("Lobby") or 
           workspace:FindFirstChild("Spawn") or
           game:GetService("Lighting"):FindFirstChild("LobbyLighting") or
           string.find(game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name, "Lobby")
end

function isInDungeon()
    return workspace:FindFirstChild("Dungeon") or
           workspace:FindFirstChild("Monsters") or
           workspace:FindFirstChild("Boss") or
           string.find(game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name, "Dungeon")
end

-- CREATE ADAPTIVE GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = game:GetService("CoreGui")

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 320, 0, 280)
mainFrame.Position = UDim2.new(0, 10, 0, 10)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
mainFrame.Parent = screenGui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.Position = UDim2.new(0, 0, 0, 0)
title.Text = "⚔️ DUNGEON LOBBY HUB"
title.TextColor3 = Color3.fromRGB(255, 255, 0)
title.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
title.Parent = mainFrame

local status = Instance.new("TextLabel")
status.Size = UDim2.new(1, -10, 0, 50)
status.Position = UDim2.new(0, 5, 0, 35)
status.Text = "🔍 Detecting location..."
status.TextColor3 = Color3.fromRGB(255, 255, 0)
status.BackgroundTransparency = 1
status.TextSize = 12
status.TextWrapped = true
status.Parent = mainFrame

-- UPDATE STATUS BERDASARKAN LOKASI
task.spawn(function()
    while task.wait(2) do
        if isInLobby() then
            status.Text = "📍 CURRENT: LOBBY\n➡️ Use 'Auto Enter Dungeon' to start!"
            status.TextColor3 = Color3.fromRGB(255, 255, 0)
        elseif isInDungeon() then
            status.Text = "🎯 CURRENT: DUNGEON\n✅ Cheats are now ACTIVE!"
            status.TextColor3 = Color3.fromRGB(0, 255, 0)
            
            -- Auto aktifkan cheat ketika masuk dungeon
            if not Features.GodMode then
                Features.GodMode = true
                Features.OneHitKill = true
                Features.AutoFarm = true
                Features.AutoChest = true
                updateButtons()
            end
        else
            status.Text = "❓ UNKNOWN LOCATION\nTrying to detect..."
            status.TextColor3 = Color3.fromRGB(255, 100, 100)
        end
    end
end)

-- FEATURE BUTTONS
local buttons = {}
local featureList = {
    {"🚪 AUTO ENTER DUNGEON", "AutoEnterDungeon"},
    {"🛡️ GOD MODE", "GodMode"},
    {"💀 ONE HIT KILL", "OneHitKill"}, 
    {"🤖 AUTO FARM", "AutoFarm"},
    {"📦 AUTO CHEST", "AutoChest"},
    {"⚡ SPEED HACK", "SpeedHack"}
}

function updateButtons()
    for featureName, btn in pairs(buttons) do
        btn.Text = featureName .. " | " .. (Features[featureName] and "ON" or "OFF")
        btn.BackgroundColor3 = Features[featureName] and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(150, 0, 0)
    end
end

for i, feature in ipairs(featureList) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 25)
    btn.Position = UDim2.new(0, 5, 0, 90 + (i-1)*28)
    btn.Text = feature[1] .. " | " .. (Features[feature[2]] and "ON" or "OFF")
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.BackgroundColor3 = Features[feature[2]] and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(150, 0, 0)
    btn.TextSize = 11
    btn.Parent = mainFrame
    buttons[feature[2]] = btn
    
    btn.MouseButton1Click:Connect(function()
        Features[feature[2]] = not Features[feature[2]]
        updateButtons()
    end)
end

-- FITUR UTAMA: AUTO ENTER DUNGEON
task.spawn(function()
    while task.wait(3) do
        if Features.AutoEnterDungeon and isInLobby() then
            pcall(function()
                -- Method 1: Cari portal/entrance dungeon
                for _, obj in pairs(workspace:GetDescendants()) do
                    if obj:IsA("Part") and (
                        obj.Name:lower():find("portal") or
                        obj.Name:lower():find("dungeon") or
                        obj.Name:lower():find("enter") or
                        obj.Name:lower():find("start") or
                        obj.Name:lower():find("gate")
                    ) then
                        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                            local distance = (player.Character.HumanoidRootPart.Position - obj.Position).Magnitude
                            
                            if distance > 10 then
                                -- Move to portal
                                player.Character.Humanoid:MoveTo(obj.Position)
                                status.Text = "🚶 Moving to dungeon portal..."
                            else
                                -- Sudah dekat, trigger portal
                                firetouchinterest(player.Character.HumanoidRootPart, obj, 0)
                                task.wait(0.1)
                                firetouchinterest(player.Character.HumanoidRootPart, obj, 1)
                                status.Text = "🎯 Entering dungeon..."
                            end
                        end
                    end
                end
                
                -- Method 2: Cari GUI buttons untuk start dungeon
                for _, gui in pairs(game:GetService("CoreGui"):GetDescendants()) do
                    if gui:IsA("TextButton") and (
                        gui.Text:lower():find("start") or
                        gui.Text:lower():find("dungeon") or
                        gui.Text:lower():find("enter") or
                        gui.Text:lower():find("play")
                    ) then
                        gui:Fire("MouseButton1Click")
                        status.Text = "🔄 Clicking start button..."
                    end
                end
                
                -- Method 3: Cari remote events untuk start dungeon
                for _, remote in pairs(game:GetDescendants()) do
                    if remote:IsA("RemoteEvent") and (
                        remote.Name:lower():find("start") or
                        remote.Name:lower():find("dungeon") or
                        remote.Name:lower():find("enter")
                    ) then
                        remote:FireServer()
                        status.Text = "⚡ Firing dungeon start event..."
                    end
                end
            end)
        end
    end
end)

-- CHEATS YANG AKTIF HANYA DI DUNGEON
task.spawn(function()
    while task.wait(0.5) do
        if isInDungeon() then
            -- GOD MODE (hanya di dungeon)
            if Features.GodMode and player.Character then
                pcall(function()
                    player.Character.Humanoid.Health = player.Character.Humanoid.MaxHealth
                    player.Character:SetAttribute("HP", 99999)
                    player.Character:SetAttribute("IsImmune", true)
                end)
            end
            
            -- ONE HIT KILL (hanya di dungeon)
            if Features.OneHitKill then
                pcall(function()
                    for _, obj in pairs(workspace:GetChildren()) do
                        if obj:IsA("Model") and obj:FindFirstChild("Humanoid") then
                            if obj ~= player.Character and obj.Humanoid.Health > 0 then
                                -- Cek jika ini monster (bukan NPC lobby)
                                if obj.Name:lower():find("monster") or 
                                   obj.Name:lower():find("enemy") or
                                   obj.Name:lower():find("boss") or
                                   obj:FindFirstChild("HumanoidRootPart") then
                                   
                                    local distance = 100
                                    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                                        distance = (player.Character.HumanoidRootPart.Position - obj.HumanoidRootPart.Position).Magnitude
                                    end
                                    
                                    if distance < 50 then
                                        obj.Humanoid.Health = 0
                                    end
                                end
                            end
                        end
                    end
                end)
            end
            
            -- AUTO FARM (hanya di dungeon)
            if Features.AutoFarm and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                pcall(function()
                    for _, obj in pairs(workspace:GetChildren()) do
                        if obj:IsA("Model") and obj:FindFirstChild("Humanoid") and obj.Humanoid.Health > 0 then
                            if obj ~= player.Character then
                                local root = obj:FindFirstChild("HumanoidRootPart")
                                if root then
                                    local distance = (player.Character.HumanoidRootPart.Position - root.Position).Magnitude
                                    
                                    if distance < 100 then
                                        player.Character.Humanoid:MoveTo(root.Position)
                                        task.wait(0.5)
                                        obj.Humanoid.Health = 0
                                        break
                                    end
                                end
                            end
                        end
                    end
                end)
            end
            
            -- AUTO CHEST (hanya di dungeon)
            if Features.AutoChest and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                pcall(function()
                    for _, obj in pairs(workspace:GetDescendants()) do
                        if obj:IsA("Part") and (
                            obj.Name:lower():find("chest") or
                            obj.Name:lower():find("reward") or
                            obj.Name:lower():find("loot") or
                            obj.Name:lower():find("coin")
                        ) then
                            local distance = (player.Character.HumanoidRootPart.Position - obj.Position).Magnitude
                            
                            if distance < 30 then
                                player.Character.Humanoid:MoveTo(obj.Position)
                                task.wait(0.3)
                                firetouchinterest(player.Character.HumanoidRootPart, obj, 0)
                                task.wait(0.1)
                                firetouchinterest(player.Character.HumanoidRootPart, obj, 1)
                                break
                            end
                        end
                    end
                end)
            end
        end
        
        -- SPEED HACK (bisa di mana saja)
        if Features.SpeedHack and player.Character then
            pcall(function()
                player.Character.Humanoid.WalkSpeed = 50
            end)
        end
    end
end)

-- DETECT WHEN ENTERING DUNGEON
task.spawn(function()
    local lastLocation = "unknown"
    
    while task.wait(1) do
        local currentLocation = isInLobby() and "lobby" or isInDungeon() and "dungeon" or "unknown"
        
        if currentLocation ~= lastLocation then
            if currentLocation == "dungeon" then
                -- Notify ketika masuk dungeon
                game:GetService("StarterGui"):SetCore("SendNotification", {
                    Title = "🎯 DUNGEON ENTERED",
                    Text = "Cheats are now ACTIVATED!",
                    Duration = 5
                })
            elseif currentLocation == "lobby" then
                -- Notify ketika kembali ke lobby
                game:GetService("StarterGui"):SetCore("SendNotification", {
                    Title = "📍 BACK TO LOBBY",
                    Text = "Use Auto Enter to start dungeon",
                    Duration = 5
                })
            end
            
            lastLocation = currentLocation
        end
    end
end)

print("🎮 DUNGEON LOBBY HUB LOADED!")
