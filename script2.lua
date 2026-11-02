
-- MINI ADMIN V2
-- Interface arrastável + comandos locais
-- RightControl: mostrar/ocultar

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")

local player = Players.LocalPlayer
local gui = Instance.new("ScreenGui")
gui.Name = "MiniAdminV2"
gui.ResetOnSpawn = false
gui.Parent = game:GetService("CoreGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.fromOffset(390, 290)
frame.Position = UDim2.new(0.5, -195, 0.5, -145)
frame.BackgroundColor3 = Color3.fromRGB(19, 20, 29)
frame.BorderSizePixel = 0
frame.Parent = gui

Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(95, 75, 220)
stroke.Thickness = 1.5
stroke.Parent = frame

local function label(parent, text, size, position, fontSize)
    local obj = Instance.new("TextLabel")
    obj.Size = size
    obj.Position = position
    obj.BackgroundTransparency = 1
    obj.Text = text
    obj.TextColor3 = Color3.fromRGB(240, 240, 250)
    obj.Font = Enum.Font.GothamBold
    obj.TextSize = fontSize
    obj.Parent = parent
    return obj
end

local top = Instance.new("Frame")
top.Size = UDim2.new(1, 0, 0, 48)
top.BackgroundColor3 = Color3.fromRGB(29, 29, 44)
top.BorderSizePixel = 0
top.Parent = frame
Instance.new("UICorner", top).CornerRadius = UDim.new(0, 12)

label(top, "✦  MINI ADMIN", UDim2.fromOffset(220, 45),
    UDim2.fromOffset(15, 0), 18).TextXAlignment = Enum.TextXAlignment.Left

local minimize = Instance.new("TextButton")
minimize.Size = UDim2.fromOffset(32, 30)
minimize.Position = UDim2.new(1, -76, 0, 9)
minimize.Text = "—"
minimize.TextSize = 20
minimize.BackgroundColor3 = Color3.fromRGB(65, 65, 90)
minimize.TextColor3 = Color3.new(1,1,1)
minimize.Parent = top
Instance.new("UICorner", minimize).CornerRadius = UDim.new(0, 7)

local close = Instance.new("TextButton")
close.Size = UDim2.fromOffset(32, 30)
close.Position = UDim2.new(1, -38, 0, 9)
close.Text = "×"
close.TextSize = 22
close.BackgroundColor3 = Color3.fromRGB(170, 55, 75)
close.TextColor3 = Color3.new(1,1,1)
close.Parent = top
Instance.new("UICorner", close).CornerRadius = UDim.new(0, 7)

local input = Instance.new("TextBox")
input.Size = UDim2.new(1, -30, 0, 42)
input.Position = UDim2.fromOffset(15, 65)
input.BackgroundColor3 = Color3.fromRGB(34, 35, 49)
input.PlaceholderText = "Digite ;cmds para ver os comandos"
input.PlaceholderColor3 = Color3.fromRGB(145, 145, 165)
input.Text = ""
input.TextColor3 = Color3.new(1,1,1)
input.Font = Enum.Font.Gotham
input.TextSize = 14
input.ClearTextOnFocus = false
input.Parent = frame
Instance.new("UICorner", input).CornerRadius = UDim.new(0, 8)

local status = label(frame, "●  Sistema iniciado", 
    UDim2.new(1, -30, 0, 25), UDim2.fromOffset(15, 116), 12)
status.TextColor3 = Color3.fromRGB(100, 220, 155)
status.TextXAlignment = Enum.TextXAlignment.Left

local history = Instance.new("ScrollingFrame")
history.Size = UDim2.new(1, -30, 0, 125)
history.Position = UDim2.fromOffset(15, 150)
history.BackgroundColor3 = Color3.fromRGB(27, 28, 40)
history.BorderSizePixel = 0
history.ScrollBarThickness = 3
history.CanvasSize = UDim2.new()
history.Parent = frame
Instance.new("UICorner", history).CornerRadius = UDim.new(0, 8)

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 4)
layout.Parent = history

local minimized = false
local oldSize = frame.Size

local function log(message, success)
    status.Text = (success and "●  " or "●  ") .. message
    status.TextColor3 = success
        and Color3.fromRGB(100, 220, 155)
        or Color3.fromRGB(255, 120, 120)

    local item = Instance.new("TextLabel")
    item.Size = UDim2.new(1, -10, 0, 23)
    item.BackgroundTransparency = 1
    item.TextXAlignment = Enum.TextXAlignment.Left
    item.Text = "  > " .. message
    item.TextColor3 = Color3.fromRGB(205, 205, 220)
    item.Font = Enum.Font.Gotham
    item.TextSize = 11
    item.Parent = history

    task.wait()
    history.CanvasSize = UDim2.fromOffset(0, layout.AbsoluteContentSize.Y + 5)
    history.CanvasPosition = Vector2.new(0, history.AbsoluteCanvasSize.Y)
end

local function getCharacter()
    local char = player.Character
    if not char then return end
    return char, char:FindFirstChild("Humanoid"),
        char:FindFirstChild("HumanoidRootPart")
end

local flying = false
local flyConnection

local function stopFly()
    flying = false
    if flyConnection then
        flyConnection:Disconnect()
        flyConnection = nil
    end
    log("Fly desativado", true)
end

local function run(raw)
    local args = string.split(raw, " ")
    local cmd = string.lower(args[1] or "")
    local char, humanoid, root = getCharacter()

    if cmd == ";cmds" then
        log("Comandos: ;fire ;unfire ;fly ;unfly ;jump ;speed ;reset", true)

    elseif cmd == ";fire" then
        if not root then return log("Personagem não encontrado", false) end
        if root:FindFirstChild("MiniAdminFire") then
            return log("Fire já está ativo", false)
        end
        local fire = Instance.new("Fire")
        fire.Name = "MiniAdminFire"
        fire.Parent = root
        log("Fire local ativado", true)

    elseif cmd == ";unfire" then
        if not root then return log("Personagem não encontrado", false) end
        local fire = root:FindFirstChild("MiniAdminFire")
        if fire then fire:Destroy() end
        log("Fire removido", true)

    elseif cmd == ";jump" then
        if not humanoid then return log("Humanoid não encontrado", false) end
        humanoid.Jump = true
        log("Jump executado", true)

    elseif cmd == ";speed" then
        local value = tonumber(args[2])
        if not humanoid then return log("Humanoid não encontrado", false) end
        if not value or value < 0 or value > 100 then
            return log("Use ;speed 50 (máximo 100)", false)
        end
        humanoid.WalkSpeed = value
        log("Velocidade local: " .. value, true)

    elseif cmd == ";reset" then
        if humanoid then
            humanoid.Health = 0
            log("Reset executado", true)
        end

    elseif cmd == ";fly" then
        if flying then return log("Fly já está ativo", false) end
        if not root then return log("Personagem não encontrado", false) end

        flying = true
        local attachment = Instance.new("Attachment")
        attachment.Name = "MiniFlyAttachment"
        attachment.Parent = root

        local velocity = Instance.new("LinearVelocity")
        velocity.Name = "MiniFlyVelocity"
        velocity.Attachment0 = attachment
        velocity.MaxForce = 100000
        velocity.VectorVelocity = Vector3.zero
        velocity.Parent = root

        local direction = Vector3.zero
        flyConnection = game:GetService("RunService").RenderStepped:Connect(function()
            if not flying or not root.Parent then
                stopFly()
                return
            end

            local camera = workspace.CurrentCamera
            direction = Vector3.zero

            if UIS:IsKeyDown(Enum.KeyCode.W) then direction += camera.CFrame.LookVector end
            if UIS:IsKeyDown(Enum.KeyCode.S) then direction -= camera.CFrame.LookVector end
            if UIS:IsKeyDown(Enum.KeyCode.A) then direction -= camera.CFrame.RightVector end
            if UIS:IsKeyDown(Enum.KeyCode.D) then direction += camera.CFrame.RightVector end
            if UIS:IsKeyDown(Enum.KeyCode.Space) then direction += Vector3.yAxis end
            if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then direction -= Vector3.yAxis end

            velocity.VectorVelocity = direction * 50
        end)

        log("Fly local ativado: WASD + Espaço", true)

    elseif cmd == ";unfly" then
        stopFly()
        if root then
            local v = root:FindFirstChild("MiniFlyVelocity")
            local a = root:FindFirstChild("MiniFlyAttachment")
            if v then v:Destroy() end
            if a then a:Destroy() end
        end

    else
        log("Comando desconhecido: " .. cmd, false)
    end
end

input.FocusLost:Connect(function(enter)
    if enter then
        local command = input.Text
        input.Text = ""
        run(command)
    end
end)

minimize.MouseButton1Click:Connect(function()
    minimized = not minimized
    if minimized then
        frame.Size = UDim2.fromOffset(390, 48)
        input.Visible = false
        status.Visible = false
        history.Visible = false
        minimize.Text = "+"
    else
        frame.Size = oldSize
        input.Visible = true
        status.Visible = true
        history.Visible = true
        minimize.Text = "—"
    end
end)

close.MouseButton1Click:Connect(function()
    if flyConnection then flyConnection:Disconnect() end
    gui:Destroy()
end)

-- Arrastar janela
local dragging = false
local dragStart, startPosition

top.InputBegan:Connect(function(inputObject)
    if inputObject.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = inputObject.Position
        startPosition = frame.Position
    end
end)

UIS.InputChanged:Connect(function(inputObject)
    if dragging and inputObject.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = inputObject.Position - dragStart
        frame.Position = UDim2.new(
            startPosition.X.Scale,
            startPosition.X.Offset + delta.X,
            startPosition.Y.Scale,
            startPosition.Y.Offset + delta.Y
        )
    end
end)

UIS.InputEnded:Connect(function(inputObject)
    if inputObject.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

UIS.InputBegan:Connect(function(key, processed)
    if not processed and key.KeyCode == Enum.KeyCode.RightControl then
        frame.Visible = not frame.Visible
    end
end)

log("Mini Admin V2 carregado", true)
