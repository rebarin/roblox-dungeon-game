-- AutoFarm.lua
local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- Auto Farm GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AutoFarmStatus"
screenGui.Parent = game:GetService("CoreGui")

local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(0, 200, 0, 30)
statusLabel.Position = UDim2.new(0, 10, 0, 340)
statusLabel.Text = "⚔️ Auto Farm: ACTIVE"
statusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
statusLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
statusLabel.BackgroundTransparency = 0.3
statusLabel.TextSize = 14
statusLabel.Parent = screenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 5)
UICorner.Parent = statusLabel

local function AutoFarmDungeons()
    while task.wait(3) do
        local character = player.Character
        if character and character:FindFirstChild("Humanoid") and character:FindFirstChild("HumanoidRootPart") then
            local humanoid = character.Humanoid
            local rootPart = character.HumanoidRootPart
            
            -- Auto attack nearby enemies
            for _, enemy in pairs(workspace:GetDescendants()) do
                if enemy:IsA("Model") and (enemy.Name:lower():find("enemy") or enemy.Name:lower():find("monster") or enemy.Name:lower():find("mob")) then
                    local enemyRoot = enemy:FindFirstChild("HumanoidRootPart")
                    local enemyHumanoid = enemy:FindFirstChild("Humanoid")
                    
                    if enemyRoot and enemyHumanoid and enemyHumanoid.Health > 0 then
                        -- Move to enemy
                        humanoid:MoveTo(enemyRoot.Position)
                        statusLabel.Text = "⚔️ Auto Farm: ATTACKING!"
                        
                        wait(1)
                        
                        -- Auto attack (reduce health)
                        enemyHumanoid.Health = 0
                        
                        wait(1)
                        statusLabel.Text = "⚔️ Auto Farm: ACTIVE"
                        break -- Focus on one enemy at a time
                    end
                end
            end
            
            -- Auto collect items
            for _, item in pairs(workspace:GetDescendants()) do
                if item:IsA("Part") and (item.Name:lower():find("coin") or item.Name:lower():find("chest") or item.Name:lower():find("reward")) then
                    if (rootPart.Position - item.Position).Magnitude < 20 then
                        humanoid:MoveTo(item.Position)
                        statusLabel.Text = "⚔️ Auto Farm: COLLECTING!"
                        wait(1)
                        statusLabel.Text = "⚔️ Auto Farm: ACTIVE"
                    end
                end
            end
        end
    end
end

-- Start auto farm
coroutine.wrap(AutoFarmDungeons)()

print("✅ Auto Farm Loaded")
return "Auto Farm Loaded"