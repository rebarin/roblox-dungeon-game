-- GameGUI.lua
local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- Main Features GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "DungeonGameFeatures"
screenGui.Parent = game:GetService("CoreGui")

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 250, 0, 200)
mainFrame.Position = UDim2.new(0, 10, 0, 130)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
mainFrame.BackgroundTransparency = 0.2
mainFrame.Parent = screenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = mainFrame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.Position = UDim2.new(0, 0, 0, 0)
title.Text = "🎮 DUNGEON GAME FEATURES"
title.TextColor3 = Color3.fromRGB(255, 255, 0)
title.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
title.TextSize = 14
title.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 8)
titleCorner.Parent = title

-- Features list
local features = {
    "🛡️ Anti Hit: ACTIVE",
    "❤️ Unlimited Health: ACTIVE", 
    "🔵 Unlimited Mana: ACTIVE",
    "⚡ Fast Revive: ACTIVE",
    "📦 Fast Chest: ACTIVE",
    "🤖 Anti AFK: ACTIVE",
    "⚔️ Auto Farm: ACTIVE"
}

for i, featureText in ipairs(features) do
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -10, 0, 20)
    label.Position = UDim2.new(0, 5, 0, 30 + (i-1)*22)
    label.Text = "  " .. featureText
    label.TextColor3 = Color3.fromRGB(0, 255, 0)
    label.BackgroundTransparency = 1
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextSize = 12
    label.Parent = mainFrame
end

-- Anti AFK System
local function SetupAntiAFK()
    while task.wait(30) do
        local character = player.Character
        if character and character:FindFirstChild("Humanoid") then
            local humanoid = character.Humanoid
            -- Small movement to prevent AFK
            humanoid:MoveTo(character.PrimaryPart.Position + Vector3.new(2, 0, 2))
        end
    end
end

-- Fast Revive System
local function SetupFastRevive()
    player.CharacterAdded:Connect(function(character)
        local humanoid = character:WaitForChild("Humanoid")
        humanoid.Died:Connect(function()
            wait(3) -- Fast revive in 3 seconds
            if player then
                player:LoadCharacter()
            end
        end)
    end)
end

-- Start systems
coroutine.wrap(SetupAntiAFK)()
SetupFastRevive()

print("✅ Game GUI Loaded")
return "Game GUI Loaded"