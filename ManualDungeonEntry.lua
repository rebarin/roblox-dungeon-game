-- ManualDungeonEntry.lua
local player = game.Players.LocalPlayer

-- Manual methods untuk masuk dungeon
local function enterDungeon()
    print("🚀 Trying to enter dungeon...")
    
    -- Method 1: Click semua button yang mungkin
    for _, gui in pairs(game:GetDescendants()) do
        if gui:IsA("TextButton") then
            local text = gui.Text:lower()
            if text:find("start") or text:find("dungeon") or text:find("play") or text:find("enter") then
                print("🎯 Clicking: " .. gui.Text)
                gui:Fire("MouseButton1Click")
            end
        end
    end
    
    -- Method 2: Touch semua portal
    for _, part in pairs(workspace:GetDescendants()) do
        if part:IsA("Part") then
            local name = part.Name:lower()
            if name:find("portal") or name:find("dungeon") or name:find("gate") then
                print("🎯 Touching: " .. part.Name)
                if player.Character then
                    player.Character.HumanoidRootPart.CFrame = part.CFrame
                    task.wait(1)
                    firetouchinterest(player.Character.HumanoidRootPart, part, 0)
                    task.wait(0.1)
                    firetouchinterest(player.Character.HumanoidRootPart, part, 1)
                end
            end
        end
    end
    
    -- Method 3: Fire semua remote events
    for _, remote in pairs(game:GetDescendants()) do
        if remote:IsA("RemoteEvent") then
            local name = remote.Name:lower()
            if name:find("start") or name:find("dungeon") then
                print("🎯 Firing remote: " .. remote.Name)
                remote:FireServer()
            end
        end
    end
end

-- Auto try every 5 seconds
while task.wait(5) do
    enterDungeon()
end