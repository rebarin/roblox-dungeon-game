-- AutoFarm.lua
local Players = game:GetService("Players")
local player = Players.LocalPlayer

local AutoFarm = {}
AutoFarm.Enabled = true

function AutoFarm:CreateGUI()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "AutoFarmStatus"
    screenGui.Parent = game:GetService("CoreGui")
    
    local statusLabel = Instance.new("TextLabel")
    statusLabel.Size = UDim2.new(0, 220, 0, 35)
    statusLabel.Position = UDim2.new(0, 10, 0, 130)
    statusLabel.Text = "⚔️ AUTO FARM: SEARCHING"
    statusLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
    statusLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    statusLabel.BackgroundTransparency = 0.2
    statusLabel.TextSize = 14
    statusLabel.Parent = screenGui

    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 8)
    UICorner.Parent = statusLabel
    
    return statusLabel
end

function AutoFarm:StartFarming()
    local statusLabel = self:CreateGUI()
    
    while task.wait(3) and self.Enabled do
        if not self.Enabled then break end
        
        local character = player.Character
        if character and character:FindFirstChild("Humanoid") and character:FindFirstChild("HumanoidRootPart") then
            local humanoid = character.Humanoid
            local rootPart = character.HumanoidRootPart
            
            local foundTarget = false
            
            -- Auto attack monsters
            for _, obj in pairs(workspace:GetDescendants()) do
                if not self.Enabled then break end
                
                if obj:IsA("Model") and (
                    string.lower(obj.Name):find("monster") or
                    string.lower(obj.Name):find("enemy") or 
                    string.lower(obj.Name):find("mob") or
                    string.lower(obj.Name):find("boss") or
                    obj:FindFirstChild("Humanoid")
                ) then
                    local enemyRoot = obj:FindFirstChild("HumanoidRootPart") or obj:FindFirstChild("Head")
                    local enemyHumanoid = obj:FindFirstChild("Humanoid")
                    
                    if enemyRoot and enemyHumanoid and enemyHumanoid.Health > 0 then
                        local distance = (rootPart.Position - enemyRoot.Position).Magnitude
                        
                        if distance < 100 then
                            statusLabel.Text = "⚔️ AUTO FARM: ATTACKING " .. obj.Name
                            statusLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
                            
                            -- Move to enemy
                            humanoid:MoveTo(enemyRoot.Position)
                            task.wait(1)
                            
                            -- Kill enemy
                            enemyHumanoid.Health = 0
                            foundTarget = true
                            
                            -- Auto collect drops
                            task.wait(1)
                            break
                        end
                    end
                end
                
                -- Auto open chests
                if obj:IsA("Part") and (
                    string.lower(obj.Name):find("chest") or
                    string.lower(obj.Name):find("reward") or
                    string.lower(obj.Name):find("loot")
                ) then
                    local distance = (rootPart.Position - obj.Position).Magnitude
                    
                    if distance < 50 then
                        statusLabel.Text = "📦 AUTO FARM: OPENING CHEST"
                        statusLabel.TextColor3 = Color3.fromRGB(0, 255, 255)
                        
                        humanoid:MoveTo(obj.Position)
                        task.wait(1)
                        
                        -- Simulate chest open (fire proximity prompt)
                        for _, prompt in pairs(obj:GetDescendants()) do
                            if prompt:IsA("ProximityPrompt") then
                                prompt:InputHoldBegin()
                                task.wait(0.5)
                                prompt:InputHoldEnd()
                            end
                        end
                        
                        foundTarget = true
                        task.wait(1)
                    end
                end
            end
            
            if foundTarget then
                statusLabel.Text = "⚔️ AUTO FARM: ACTIVE"
                statusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
            else
                statusLabel.Text = "⚔️ AUTO FARM: SEARCHING..."
                statusLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
            end
        end
    end
end

function AutoFarm:Enable()
    self.Enabled = true
    coroutine.wrap(function() self:StartFarming() end)()
end

function AutoFarm:Disable()
    self.Enabled = false
    local gui = game:GetService("CoreGui"):FindFirstChild("AutoFarmStatus")
    if gui then
        gui:Destroy()
    end
end

-- Auto start
if _G.DungeonGameFeatures and _G.DungeonGameFeatures.AutoFarm then
    AutoFarm:Enable()
end

return AutoFarm
