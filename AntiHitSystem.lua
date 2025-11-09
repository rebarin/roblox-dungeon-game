-- AntiHitSystem.lua
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

-- Create AntiHit GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AntiHitStatus"
screenGui.Parent = game:GetService("CoreGui")

local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(0, 200, 0, 30)
statusLabel.Position = UDim2.new(0, 10, 0, 50)
statusLabel.Text = "🛡️ Anti Hit: ACTIVE"
statusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
statusLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
statusLabel.BackgroundTransparency = 0.3
statusLabel.TextSize = 14
statusLabel.Parent = screenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 5)
UICorner.Parent = statusLabel

-- Anti Hit Function
local function StartAntiHit()
    local character = player.Character
    if not character then
        player.CharacterAdded:Wait()
        character = player.Character
    end
    
    local humanoid = character:WaitForChild("Humanoid")
    
    -- Health protection
    humanoid.HealthChanged:Connect(function()
        if humanoid.Health < humanoid.MaxHealth then
            wait(0.1)
            humanoid.Health = humanoid.MaxHealth
            statusLabel.Text = "🛡️ Anti Hit: BLOCKED DAMAGE!"
            wait(1)
            statusLabel.Text = "🛡️ Anti Hit: ACTIVE"
        end
    end)
    
    -- Auto avoid damage parts
    RunService.Heartbeat:Connect(function()
        if character and humanoid and character.PrimaryPart then
            for _, part in pairs(workspace:GetDescendants()) do
                if part:IsA("Part") and (part.Name:lower():find("damage") or part.Name:lower():find("hurt") or part.Name:lower():find("kill")) then
                    if (character.PrimaryPart.Position - part.Position).Magnitude < 15 then
                        humanoid:MoveTo(character.PrimaryPart.Position + Vector3.new(15, 0, 15))
                        statusLabel.Text = "🛡️ Anti Hit: AVOIDING DANGER!"
                        wait(1)
                        statusLabel.Text = "🛡️ Anti Hit: ACTIVE"
                    end
                end
            end
        end
    end)
end

-- Start protection
StartAntiHit()
player.CharacterAdded:Connect(StartAntiHit)

print("✅ AntiHit System Loaded")
return "AntiHit System Loaded"