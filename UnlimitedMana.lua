-- UnlimitedMana.lua
local Players = game:GetService("Players")
local player = Players.LocalPlayer

local ManaSystem = {}
ManaSystem.Enabled = true

function ManaSystem:CreateGUI()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "ManaStatus"
    screenGui.Parent = game:GetService("CoreGui")
    
    local statusLabel = Instance.new("TextLabel")
    statusLabel.Size = UDim2.new(0, 220, 0, 35)
    statusLabel.Position = UDim2.new(0, 10, 0, 90)
    statusLabel.Text = "🔵 UNLIMITED MANA: ACTIVE"
    statusLabel.TextColor3 = Color3.fromRGB(0, 255, 255)
    statusLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    statusLabel.BackgroundTransparency = 0.2
    statusLabel.TextSize = 14
    statusLabel.Parent = screenGui

    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 8)
    UICorner.Parent = statusLabel
    
    return statusLabel
end

function ManaSystem:StartUnlimitedMana()
    local statusLabel = self:CreateGUI()
    
    while task.wait(1) and self.Enabled do
        if not self.Enabled then break end
        
        local character = player.Character
        if character then
            -- Method 1: Set attributes (common in dungeon games)
            pcall(function() 
                character:SetAttribute("Mana", 9999)
                character:SetAttribute("MaxMana", 9999)
                character:SetAttribute("Energy", 9999)
                character:SetAttribute("Stamina", 9999)
            end)
            
            -- Method 2: Find and modify mana values in leaderstats
            local leaderstats = player:FindFirstChild("leaderstats")
            if leaderstats then
                for _, stat in pairs(leaderstats:GetChildren()) do
                    if stat:IsA("NumberValue") and (
                        string.lower(stat.Name):find("mana") or 
                        string.lower(stat.Name):find("energy") or
                        string.lower(stat.Name):find("mp")
                    ) then
                        stat.Value = 9999
                    end
                end
            end
            
            -- Method 3: Check for mana in character
            for _, child in pairs(character:GetDescendants()) do
                if child:IsA("NumberValue") and (
                    string.lower(child.Name):find("mana") or 
                    string.lower(child.Name):find("energy")
                ) then
                    child.Value = 9999
                end
            end
            
            statusLabel.Text = "🔵 UNLIMITED MANA: " .. math.random(999, 9999)
        end
    end
end

function ManaSystem:Enable()
    self.Enabled = true
    coroutine.wrap(function() self:StartUnlimitedMana() end)()
end

function ManaSystem:Disable()
    self.Enabled = false
    local gui = game:GetService("CoreGui"):FindFirstChild("ManaStatus")
    if gui then
        gui:Destroy()
    end
end

-- Auto start
if _G.DungeonGameFeatures and _G.DungeonGameFeatures.UnlimitedMana then
    ManaSystem:Enable()
end

return ManaSystem
