-- AntiHitSystem.lua
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

local AntiHitSystem = {}
AntiHitSystem.Enabled = true

function AntiHitSystem:CreateGUI()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "AntiHitStatus"
    screenGui.Parent = game:GetService("CoreGui")
    
    local statusLabel = Instance.new("TextLabel")
    statusLabel.Size = UDim2.new(0, 220, 0, 35)
    statusLabel.Position = UDim2.new(0, 10, 0, 50)
    statusLabel.Text = "🛡️ GOD MODE: ACTIVE (No Damage)"
    statusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
    statusLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    statusLabel.BackgroundTransparency = 0.2
    statusLabel.TextSize = 14
    statusLabel.TextStrokeTransparency = 0.5
    statusLabel.Parent = screenGui

    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 8)
    UICorner.Parent = statusLabel
    
    return statusLabel
end

function AntiHitSystem:StartGodMode()
    local character = player.Character
    if not character then
        character = player.CharacterAdded:Wait()
    end
    
    local humanoid = character:WaitForChild("Humanoid")
    local statusLabel = self:CreateGUI()
    
    -- Method 1: Direct health manipulation
    humanoid.HealthChanged:Connect(function()
        if not self.Enabled then return end
        
        -- Immediately restore health if damaged
        if humanoid.Health < humanoid.MaxHealth then
            humanoid.Health = humanoid.MaxHealth
            statusLabel.Text = "🛡️ GOD MODE: BLOCKED DAMAGE!"
            statusLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
            task.wait(1)
            statusLabel.Text = "🛡️ GOD MODE: ACTIVE (No Damage)"
            statusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
        end
    end)
    
    -- Method 2: Prevent death entirely
    humanoid.Died:Connect(function()
        if not self.Enabled then return end
        statusLabel.Text = "🛡️ GOD MODE: REVIVING..."
        statusLabel.TextColor3 = Color3.fromRGB(255, 165, 0)
        task.wait(2)
        player:LoadCharacter()
    end)
    
    -- Method 3: Constant health monitoring
    while task.wait(0.5) and self.Enabled do
        if not self.Enabled then break end
        
        if character and humanoid then
            -- Force health to max
            if humanoid.Health < humanoid.MaxHealth then
                humanoid.Health = humanoid.MaxHealth
            end
            
            -- Make character invincible
            humanoid.MaxHealth = math.huge
            humanoid.Health = math.huge
        end
    end
end

function AntiHitSystem:Enable()
    self.Enabled = true
    if player.Character then
        coroutine.wrap(function() self:StartGodMode() end)()
    end
    player.CharacterAdded:Connect(function(character)
        if self.Enabled then
            task.wait(1)
            coroutine.wrap(function() self:StartGodMode() end)()
        end
    end)
end

function AntiHitSystem:Disable()
    self.Enabled = false
    local gui = game:GetService("CoreGui"):FindFirstChild("AntiHitStatus")
    if gui then
        gui:Destroy()
    end
end

-- Auto start
if _G.DungeonGameFeatures and _G.DungeonGameFeatures.AntiHit then
    AntiHitSystem:Enable()
end

return AntiHitSystem
