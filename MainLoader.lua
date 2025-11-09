-- MainLoader.lua
local Library = {}

-- Configuration
local username = "rebarin" 
local repo = "roblox-dungeon-game"

_G.DungeonGameFeatures = {
    AntiHit = true,
    UnlimitedMana = true,
    AntiAFK = true,
    FastRevive = true,
    AutoFarm = true,
    GameGUI = true
}

function Library:CreateToggleGUI()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "DungeonGameToggle"
    screenGui.Parent = game:GetService("CoreGui")
    
    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, 300, 0, 400)
    mainFrame.Position = UDim2.new(0.5, -150, 0.5, -200)
    mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
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
    title.Text = "🎮 DUNGEON LEVELING HUB"
    title.TextColor3 = Color3.fromRGB(255, 255, 0)
    title.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    title.TextSize = 16
    title.Font = Enum.Font.GothamBold
    title.Parent = mainFrame
    
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 12)
    titleCorner.Parent = title
    
    -- Close button
    local closeButton = Instance.new("TextButton")
    closeButton.Size = UDim2.new(0, 30, 0, 30)
    closeButton.Position = UDim2.new(1, -35, 0, 5)
    closeButton.Text = "X"
    closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    closeButton.TextSize = 14
    closeButton.Parent = title
    
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 15)
    closeCorner.Parent = closeButton
    
    -- Toggle buttons
    local features = {
        {"🛡️ God Mode (No Damage)", "AntiHit"},
        {"🔵 Unlimited Mana/Energy", "UnlimitedMana"},
        {"⚡ Instant Revive", "FastRevive"},
        {"🤖 Anti AFK", "AntiAFK"},
        {"⚔️ Auto Farm Monsters", "AutoFarm"},
        {"📦 Auto Open Chests", "AutoFarm"},
        {"📊 Status GUI", "GameGUI"}
    }
    
    local toggleButtons = {}
    
    for i, feature in ipairs(features) do
        local featureName, featureKey = feature[1], feature[2]
        
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(0.6, 0, 0, 35)
        label.Position = UDim2.new(0, 15, 0, 50 + (i-1)*45)
        label.Text = "  " .. featureName
        label.TextColor3 = Color3.fromRGB(255, 255, 255)
        label.BackgroundTransparency = 1
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.TextSize = 12
        label.Parent = mainFrame
        
        local toggleButton = Instance.new("TextButton")
        toggleButton.Size = UDim2.new(0, 60, 0, 30)
        toggleButton.Position = UDim2.new(1, -80, 0, 52 + (i-1)*45)
        toggleButton.Text = _G.DungeonGameFeatures[featureKey] and "ON" or "OFF"
        toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        toggleButton.BackgroundColor3 = _G.DungeonGameFeatures[featureKey] and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(200, 0, 0)
        toggleButton.TextSize = 12
        toggleButton.Font = Enum.Font.GothamBold
        toggleButton.Parent = mainFrame
        
        local toggleCorner = Instance.new("UICorner")
        toggleCorner.CornerRadius = UDim.new(0, 8)
        toggleCorner.Parent = toggleButton
        
        toggleButtons[featureKey] = toggleButton
        
        toggleButton.MouseButton1Click:Connect(function()
            _G.DungeonGameFeatures[featureKey] = not _G.DungeonGameFeatures[featureKey]
            
            if _G.DungeonGameFeatures[featureKey] then
                toggleButton.Text = "ON"
                toggleButton.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
                Library:LoadFeature(featureKey)
            else
                toggleButton.Text = "OFF"
                toggleButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
                Library:DisableFeature(featureKey)
            end
        end)
    end
    
    -- Control buttons
    local allOnButton = Instance.new("TextButton")
    allOnButton.Size = UDim2.new(0, 120, 0, 35)
    allOnButton.Position = UDim2.new(0, 20, 1, -50)
    allOnButton.Text = "🎯 ALL ON"
    allOnButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    allOnButton.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
    allOnButton.TextSize = 14
    allOnButton.Parent = mainFrame
    
    local allOnCorner = Instance.new("UICorner")
    allOnCorner.CornerRadius = UDim.new(0, 8)
    allOnCorner.Parent = allOnButton
    
    local allOffButton = Instance.new("TextButton")
    allOffButton.Size = UDim2.new(0, 120, 0, 35)
    allOffButton.Position = UDim2.new(1, -140, 1, -50)
    allOffButton.Text = "🚫 ALL OFF"
    allOffButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    allOffButton.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
    allOffButton.TextSize = 14
    allOffButton.Parent = mainFrame
    
    local allOffCorner = Instance.new("UICorner")
    allOffCorner.CornerRadius = UDim.new(0, 8)
    allOffCorner.Parent = allOffButton
    
    allOnButton.MouseButton1Click:Connect(function()
        for featureKey, button in pairs(toggleButtons) do
            _G.DungeonGameFeatures[featureKey] = true
            button.Text = "ON"
            button.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
            Library:LoadFeature(featureKey)
        end
    end)
    
    allOffButton.MouseButton1Click:Connect(function()
        for featureKey, button in pairs(toggleButtons) do
            _G.DungeonGameFeatures[featureKey] = false
            button.Text = "OFF"
            button.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
            Library:DisableFeature(featureKey)
        end
    end)
    
    closeButton.MouseButton1Click:Connect(function()
        screenGui:Destroy()
    end)
    
    return screenGui
end

function Library:LoadFeature(featureName)
    local moduleUrl = "https://raw.githubusercontent.com/"..username.."/"..repo.."/main/"..featureName..".lua"
    
    local success, result = pcall(function()
        loadstring(game:HttpGet(moduleUrl, true))()
    end)
    
    if success then
        print("✅ " .. featureName .. " activated!")
    else
        warn("❌ Failed to load " .. featureName .. ": " .. tostring(result))
    end
end

function Library:DisableFeature(featureName)
    if featureName == "GameGUI" then
        local gui = game:GetService("CoreGui"):FindFirstChild("DungeonGameFeatures")
        if gui then gui:Destroy() end
    elseif featureName == "AntiHit" then
        local gui = game:GetService("CoreGui"):FindFirstChild("AntiHitStatus")
        if gui then gui:Destroy() end
    elseif featureName == "UnlimitedMana" then
        local gui = game:GetService("CoreGui"):FindFirstChild("ManaStatus")
        if gui then gui:Destroy() end
    elseif featureName == "AutoFarm" then
        local gui = game:GetService("CoreGui"):FindFirstChild("AutoFarmStatus")
        if gui then gui:Destroy() end
    end
    
    print("🚫 " .. featureName .. " deactivated!")
end

function Library:LoadDungeonGame()
    if not game:IsLoaded() then
        game.Loaded:Wait()
    end
    
    if _G.DungeonGameLoaded then return end
    _G.DungeonGameLoaded = true
    
    -- Create toggle GUI
    Library:CreateToggleGUI()
    
    -- Load enabled features
    for featureName, enabled in pairs(_G.DungeonGameFeatures) do
        if enabled then
            Library:LoadFeature(featureName)
            wait(1)
        end
    end
    
    print("🎮 Dungeon Leveling Hub Ready!")
end

wait(2)
Library:LoadDungeonGame()
return Library
