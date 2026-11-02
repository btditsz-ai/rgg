
-- Mini Admin FE - Demonstração
-- Comandos: ;fire, ;unfire, ;fly, ;unfly, ;jump

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local player = Players.LocalPlayer

local gui = Instance.new("ScreenGui")
gui.Name = "MiniAdmin"
gui.ResetOnSpawn = false
gui.Parent = game:GetService("CoreGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.fromOffset(320, 190)
frame.Position = UDim2.new(0.5, -160, 0.5, -95)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
frame.Parent = gui

local box = Instance.new("TextBox")
box.Size = UDim2.new(1, -20, 0, 40)
box.Position = UDim2.fromOffset(10, 60)
box.PlaceholderText = "Digite um comando..."
box.Text = ""
box.TextColor3 = Color3.new(1,1,1)
box.BackgroundColor3 = Color3.fromRGB(45,45,55)
box.Parent = frame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 45)
title.Text = "MINI ADMIN"
title.TextColor3 = Color3.new(1,1,1)
title.BackgroundTransparency = 1
title.TextSize = 22
title.Parent = frame

local status = Instance.new("TextLabel")
status.Size = UDim2.new(1, -20, 0, 40)
status.Position = UDim2.fromOffset(10, 115)
status.Text = "Aguardando comando..."
status.TextColor3 = Color3.fromRGB(180,180,180)
status.BackgroundTransparency = 1
status.Parent = frame

local function character()
    return player.Character
end

local function runCommand(command)
    local args = string.split(command, " ")
    local cmd = string.lower(args[1] or "")
    local char = character()
    local humanoid = char and char:FindFirstChildOfClass("Humanoid")

    if cmd == ";fire" then
        status.Text = "Fire local: efeito não garantido para outros."

        if char and not char:FindFirstChild("MiniAdminFire") then
            local fire = Instance.new("Fire")
            fire.Name = "MiniAdminFire"
            fire.Parent = char:FindFirstChild("HumanoidRootPart")
        end

    elseif cmd == ";unfire" then
        local root = char and char:FindFirstChild("HumanoidRootPart")
        local fire = root and root:FindFirstChild("MiniAdminFire")
        if fire then fire:Destroy() end
        status.Text = "Fire removido."

    elseif cmd == ";jump" then
        if humanoid then
            humanoid.Jump = true
            status.Text = "Jump executado."
        end

    elseif cmd == ";fly" then
        status.Text = "Fly precisa de implementação própria."

    elseif cmd == ";unfly" then
        status.Text = "Fly desativado."

    else
        status.Text = "Comando desconhecido."
    end
end

box.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        runCommand(box.Text)
        box.Text = ""
    end
end)

UIS.InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.KeyCode == Enum.KeyCode.RightControl then
        frame.Visible = not frame.Visible
    end
end)
