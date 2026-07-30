-- FREEZE TRADE - Compatible con Delta (móvil) y PC

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local freezeActive = false
local autoAceptarActive = false
local tradeConnection = nil

-- GUI
local gui = Instance.new("ScreenGui")
gui.Name = "FreezeTrade"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.Parent = game:GetService("CoreGui")

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 280, 0, 180)
MainFrame.Position = UDim2.new(0.5, -140, 0.5, -90)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = gui
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)
local ms = Instance.new("UIStroke", MainFrame)
ms.Color = Color3.fromRGB(80, 80, 200)
ms.Thickness = 2

-- Título
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 40)
TitleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 80)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame
Instance.new("UICorner", TitleBar).CornerRadius = UDim.new(0, 8)
local tp = Instance.new("Frame")
tp.Size = UDim2.new(1, 0, 0, 10)
tp.Position = UDim2.new(0, 0, 1, -10)
tp.BackgroundColor3 = Color3.fromRGB(30, 30, 80)
tp.BorderSizePixel = 0
tp.Parent = TitleBar

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Text = "❄ FREEZE TRADE"
TitleLabel.Size = UDim2.new(1, -10, 1, 0)
TitleLabel.Position = UDim2.new(0, 10, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextSize = 16
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = TitleBar

-- Contenedor
local Container = Instance.new("Frame")
Container.Size = UDim2.new(1, -24, 1, -56)
Container.Position = UDim2.new(0, 12, 0, 50)
Container.BackgroundTransparency = 1
Container.Parent = MainFrame
local layout = Instance.new("UIListLayout", Container)
layout.Padding = UDim.new(0, 10)
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- Botón toggle
local function makeButton(parent, text)
    local f = Instance.new("Frame")
    f.Size = UDim2.new(1, 0, 0, 48) -- más grande para touch
    f.BackgroundColor3 = Color3.fromRGB(25, 25, 45)
    f.BorderSizePixel = 0
    f.Parent = parent
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 6)
    local fs = Instance.new("UIStroke", f)
    fs.Color = Color3.fromRGB(60, 60, 120)
    fs.Thickness = 1

    local lbl = Instance.new("TextLabel")
    lbl.Text = text
    lbl.Size = UDim2.new(1, -70, 1, 0)
    lbl.Position = UDim2.new(0, 12, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.TextColor3 = Color3.fromRGB(200, 200, 255)
    lbl.TextSize = 14
    lbl.Font = Enum.Font.GothamBold
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = f

    local tbg = Instance.new("Frame")
    tbg.Size = UDim2.new(0, 50, 0, 26)
    tbg.Position = UDim2.new(1, -60, 0.5, -13)
    tbg.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    tbg.BorderSizePixel = 0
    tbg.Parent = f
    Instance.new("UICorner", tbg).CornerRadius = UDim.new(1, 0)

    local circle = Instance.new("Frame")
    circle.Size = UDim2.new(0, 20, 0, 20)
    circle.Position = UDim2.new(0, 3, 0.5, -10)
    circle.BackgroundColor3 = Color3.fromRGB(150, 150, 180)
    circle.BorderSizePixel = 0
    circle.Parent = tbg
    Instance.new("UICorner", circle).CornerRadius = UDim.new(1, 0)

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.BackgroundTransparency = 1
    btn.Text = ""
    btn.Parent = f

    return btn, tbg, circle, fs
end

local function updateVisual(bg, circle, stroke2, active, colorOn)
    if active then
        bg.BackgroundColor3 = colorOn
        circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        circle.Position = UDim2.new(1, -23, 0.5, -10)
        stroke2.Color = colorOn
    else
        bg.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
        circle.BackgroundColor3 = Color3.fromRGB(150, 150, 180)
        circle.Position = UDim2.new(0, 3, 0.5, -10)
        stroke2.Color = Color3.fromRGB(60, 60, 120)
    end
end

local function applyFreeze(on)
    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hrp or not hum then return end
    if on then
        hum.WalkSpeed = 0
        hum.JumpPower = 0
        hrp.Anchored = true
    else
        hum.WalkSpeed = 16
        hum.JumpPower = 50
        hrp.Anchored = false
    end
end

local fBtn, fBG, fCircle, fStroke = makeButton(Container, "❄  FREEZE")
local aBtn, aBG, aCircle, aStroke = makeButton(Container, "✔  AUTO ACEPTAR")

fBtn.MouseButton1Click:Connect(function()
    freezeActive = not freezeActive
    updateVisual(fBG, fCircle, fStroke, freezeActive, Color3.fromRGB(50, 50, 220))
    applyFreeze(freezeActive)
end)

aBtn.MouseButton1Click:Connect(function()
    autoAceptarActive = not autoAceptarActive
    updateVisual(aBG, aCircle, aStroke, autoAceptarActive, Color3.fromRGB(30, 160, 80))
    if autoAceptarActive then
        if tradeConnection then tradeConnection:Disconnect() end
        tradeConnection = RunService.Heartbeat:Connect(function()
            pcall(function()
                for _, v in ipairs(LocalPlayer.PlayerGui:GetDescendants()) do
                    if v:IsA("TextButton") and v.Name:lower():find("accept") then
                        v:Activate()
                    end
                end
            end)
        end)
    else
        if tradeConnection then tradeConnection:Disconnect() tradeConnection = nil end
    end
end)

LocalPlayer.CharacterAdded:Connect(function()
    task.wait(1)
    if freezeActive then applyFreeze(true) end
end)

-- ✅ Arrastre compatible con Delta (touch) y PC (mouse)
local drag = false
local dragStart = nil
local startPos = nil

local function onInputBegan(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        drag = true
        dragStart = input.Position
        startPos = MainFrame.Position
    end
end

local function onInputEnded(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        drag = false
    end
end

local function onInputChanged(input)
    if drag and (
        input.UserInputType == Enum.UserInputType.MouseMovement or
        input.UserInputType == Enum.UserInputType.Touch
    ) then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end
end

TitleBar.InputBegan:Connect(onInputBegan)
TitleBar.InputEnded:Connect(onInputEnded)
UserInputService.InputChanged:Connect(onInputChanged)