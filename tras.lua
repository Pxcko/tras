-- // Hecho por Ansyx

-- Configuración general
local player = game:GetService("Players").LocalPlayer
local RunService = game:GetService("RunService")
local VirtualInput = game:GetService("VirtualInputManager")
local shiftPressed = false

-- Configuración de Reach
_G.Reach = 5.5 -- Alcance inicial
_G.KeyBindHigher = "r"
_G.KeyBindLower = "e"
_G.ReachOff = false -- Activar/desactivar Reach
local heightThreshold = 3 -- Diferencia de altura permitida

-- Autoactivar herramienta repetidamente
spawn(function()
    while true do
        local tool = player.Character and player.Character:FindFirstChildOfClass("Tool")
        if tool and tool:FindFirstChild("Handle") then
            tool:Activate()
        end
        task.wait(6.8 / 397)
    end
end)

-- Simular pulsación de Shift (una vez)
spawn(function()
    task.wait(0.5)
    if not shiftPressed then
        VirtualInput:SendKeyEvent(true, Enum.KeyCode.LeftShift, false, nil)
        task.wait(0.1)
        VirtualInput:SendKeyEvent(false, Enum.KeyCode.LeftShift, false, nil)
        shiftPressed = true
    end
end)

-- Sistema de Reach
RunService.Stepped:Connect(function()
    if _G.ReachOff then return end
    pcall(function()
        local Sword = player.Character:FindFirstChildOfClass("Tool") and player.Character:FindFirstChildOfClass("Tool"):FindFirstChild("Handle")
        if not Sword then return end

        for _, v in pairs(game.Players:GetPlayers()) do
            if v ~= player and v.Character and v.Character:FindFirstChild("Left Arm") then
                local yDifference = math.abs(player.Character.HumanoidRootPart.Position.Y - v.Character.HumanoidRootPart.Position.Y)
                if yDifference <= heightThreshold then
                    local distance = (player.Character.Torso.Position - v.Character.Torso.Position).Magnitude
                    if distance <= _G.Reach then
                        local limb = v.Character:FindFirstChild("Right Leg")
                        if limb then
                            limb:BreakJoints()
                            limb.Transparency = 1
                            limb.CanCollide = false
                            limb.CFrame = player.Character.HumanoidRootPart.CFrame * CFrame.new(1, 0, -3.5)
                        end
                    end
                end
            end
        end
    end)
end)

-- Teclas para aumentar/disminuir el alcance
local Mouse = player:GetMouse()
Mouse.KeyDown:Connect(function(key)
    if key == _G.KeyBindHigher then
        _G.Reach = _G.Reach + 1
        game.StarterGui:SetCore("SendNotification", {
            Title = "Alcance aumentado",
            Text = "Ahora: " .. _G.Reach,
            Duration = 1,
        })
    elseif key == _G.KeyBindLower then
        _G.Reach = _G.Reach - 1
        game.StarterGui:SetCore("SendNotification", {
            Title = "Alcance reducido",
            Text = "Ahora: " .. _G.Reach,
            Duration = 1,
        })
    end
end)
