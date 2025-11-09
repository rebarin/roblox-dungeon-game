-- UltimateSimpleHack.lua
local player = game.Players.LocalPlayer

-- Function utama yang di-loop
local function mainLoop()
    while task.wait(0.1) do
        -- Speed hack (pasti bekerja)
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.WalkSpeed = 50
        end
        
        -- Auto kill everything in range
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            for _, obj in pairs(workspace:GetChildren()) do
                if obj:IsA("Model") and obj:FindFirstChild("Humanoid") then
                    if obj ~= player.Character and obj.Humanoid.Health > 0 then
                        local root = obj:FindFirstChild("HumanoidRootPart")
                        if root then
                            local distance = (player.Character.HumanoidRootPart.Position - root.Position).Magnitude
                            if distance < 200 then  -- Jarak sangat jauh
                                obj.Humanoid.Health = 0
                            end
                        end
                    end
                end
            end
        end
        
        -- Auto touch everything
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            for _, part in pairs(workspace:GetDescendants()) do
                if part:IsA("Part") then
                    local distance = (player.Character.HumanoidRootPart.Position - part.Position).Magnitude
                    if distance < 50 then
                        firetouchinterest(player.Character.HumanoidRootPart, part, 0)
                        task.wait()
                        firetouchinterest(player.Character.HumanoidRootPart, part, 1)
                    end
                end
            end
        end
    end
end

-- Start the loop
mainLoop()

print("💀 ULTIMATE SIMPLE HACK ACTIVATED!")
warn("Killing everything in 200 stud radius...")