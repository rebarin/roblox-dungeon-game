-- GameAnalyzer.lua
local Players = game:GetService("Players")
local player = Players.LocalPlayer

print("🔍 ANALYZING DUNGEON LEVELING GAME...")

-- Analyze Player Data
print("\n📊 PLAYER DATA:")
if player then
    print("Player: " .. player.Name)
    
    -- Leaderstats
    local leaderstats = player:FindFirstChild("leaderstats")
    if leaderstats then
        print("📈 Leaderstats found:")
        for _, stat in pairs(leaderstats:GetChildren()) do
            print("  - " .. stat.Name .. ": " .. tostring(stat.Value))
        end
    else
        print("❌ No leaderstats found")
    end
    
    -- Backpack items
    local backpack = player:FindFirstChild("Backpack")
    if backpack then
        print("🎒 Backpack items: " .. #backpack:GetChildren())
    end
    
    -- Character analysis
    if player.Character then
        print("👤 Character analysis:")
        for _, child in pairs(player.Character:GetChildren()) do
            if child:IsA("NumberValue") or child:IsA("StringValue") or child:IsA("BoolValue") then
                print("  - " .. child.Name .. " (" .. child.ClassName .. "): " .. tostring(child.Value))
            end
        end
    end
end

-- Analyze Game Structure
print("\n🎮 GAME STRUCTURE:")
print("Game ID: " .. game.PlaceId)

-- Services analysis
local importantServices = {
    "Workspace",
    "Lighting", 
    "ReplicatedStorage",
    "ServerScriptService",
    "StarterPlayer",
    "Teams"
}

for _, serviceName in pairs(importantServices) do
    local service = game:GetService(serviceName)
    if service then
        print("✅ " .. serviceName .. " exists")
        if serviceName == "Workspace" then
            local monsters = 0
            local chests = 0
            for _, obj in pairs(service:GetDescendants()) do
                if obj:IsA("Model") and (obj.Name:lower():find("monster") or obj.Name:lower():find("enemy")) then
                    monsters = monsters + 1
                end
                if obj.Name:lower():find("chest") then
                    chests = chests + 1
                end
            end
            print("   Monsters: " .. monsters)
            print("   Chests: " .. chests)
        end
    end
end

-- Find important modules
print("\n🔧 LOOKING FOR GAME MODULES:")
local replicatedStorage = game:GetService("ReplicatedStorage")
for _, obj in pairs(replicatedStorage:GetDescendants()) do
    if obj:IsA("ModuleScript") then
        print("  - Module: " .. obj:GetFullName())
    end
    if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then
        print("  - Remote: " .. obj:GetFullName())
    end
end

print("\n🎯 ANALYSIS COMPLETE!")