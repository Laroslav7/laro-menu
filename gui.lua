-- by laroslav7
if game:GetService("CoreGui"):FindFirstChild("YaroslavUI") then
    game:GetService("CoreGui").YaroslavUI:Destroy()
end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInput = game:GetService("UserInputService")
local lp = Players.LocalPlayer

-- Переменные
local speedValue = 16
local jumpValue = 50
local noclipEnabled = false
local speedEnabled = false
local jumpEnabled = false

-- GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "YaroslavUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game:GetService("CoreGui")

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 280, 0, 320)
Frame.Position = UDim2.new(0.5, -140, 0.5, -160)
Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
Frame.BorderSizePixel = 0
Frame.Active = true
Frame.Draggable = true
Frame.Visible = false
Frame.Parent = ScreenGui

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 10)
Corner.Parent = Frame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
Title.BorderSizePixel = 0
Title.Text = "Читы by laroslav7"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.Parent = Frame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 10)
TitleCorner.Parent = Title

-- Функция создания тоггла
local function makeToggle(text, yPos, callback)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1, -20, 0, 40)
    Btn.Position = UDim2.new(0, 10, 0, yPos)
    Btn.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    Btn.BorderSizePixel = 0
    Btn.Text = text .. ": ВЫКЛ"
    Btn.TextColor3 = Color3.fromRGB(255, 100, 100)
    Btn.Font = Enum.Font.Gotham
    Btn.TextSize = 14
    Btn.Parent = Frame

    local bc = Instance.new("UICorner")
    bc.CornerRadius = UDim.new(0, 8)
    bc.Parent = Btn

    local state = false
    Btn.MouseButton1Click:Connect(function()
        state = not state
        if state then
            Btn.Text = text .. ": ВКЛ"
            Btn.TextColor3 = Color3.fromRGB(100, 255, 100)
        else
            Btn.Text = text .. ": ВЫКЛ"
            Btn.TextColor3 = Color3.fromRGB(255, 100, 100)
        end
        callback(state)
    end)
end

-- Функция создания слайдера
local function makeSlider(text, yPos, min, max, default, callback)
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -20, 0, 20)
    Label.Position = UDim2.new(0, 10, 0, yPos)
    Label.BackgroundTransparency = 1
    Label.Text = text .. ": " .. default
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Label.Font = Enum.Font.Gotham
    Label.TextSize = 14
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Frame

    local SliderBg = Instance.new("Frame")
    SliderBg.Size = UDim2.new(1, -20, 0, 8)
    SliderBg.Position = UDim2.new(0, 10, 0, yPos + 25)
    SliderBg.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    SliderBg.BorderSizePixel = 0
    SliderBg.Parent = Frame

    local sbc = Instance.new("UICorner")
    sbc.CornerRadius = UDim.new(0, 4)
    sbc.Parent = SliderBg

    local Fill = Instance.new("Frame")
    Fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    Fill.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
    Fill.BorderSizePixel = 0
    Fill.Parent = SliderBg

    local fc = Instance.new("UICorner")
    fc.CornerRadius = UDim.new(0, 4)
    fc.Parent = Fill

    local dragging = false
    SliderBg.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
        end
    end)
    UserInput.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    UserInput.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local rel = (input.Position.X - SliderBg.AbsolutePosition.X) / SliderBg.AbsoluteSize.X
            rel = math.clamp(rel, 0, 1)
            Fill.Size = UDim2.new(rel, 0, 1, 0)
            local val = math.floor(min + (max - min) * rel)
            Label.Text = text .. ": " .. val
            callback(val)
        end
    end)
end

-- Слайдеры
makeSlider("Скорость", 50, 16, 200, 16, function(v)
    speedValue = v
end)

makeSlider("Прыжок", 115, 50, 500, 50, function(v)
    jumpValue = v
end)

-- Тогглы
makeToggle("Скорость", 180, function(state)
    speedEnabled = state
end)

makeToggle("Прыжок", 230, function(state)
    jumpEnabled = state
end)

makeToggle("Noclip", 280, function(state)
    noclipEnabled = state
end)

-- Показ UI по Insert
Frame.Visible = false
UserInput.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.Insert then
        Frame.Visible = not Frame.Visible
    end
end)

-- Применение скорости/прыжка
lp.CharacterAdded:Connect(function(char)
    task.wait(1)
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then
        if speedEnabled then hum.WalkSpeed = speedValue end
        if jumpEnabled then hum.UseJumpPower = true hum.JumpPower = jumpValue end
    end
end)

task.spawn(function()
    while task.wait(0.2) do
        local char = lp.Character
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then
                if speedEnabled then
                    hum.WalkSpeed = speedValue
                end
                if jumpEnabled then
                    hum.UseJumpPower = true
                    hum.JumpPower = jumpValue
                end
            end
        end
    end
end)

-- Noclip
RunService.Stepped:Connect(function()
    if noclipEnabled and lp.Character then
        for _, part in pairs(lp.Character:GetDescendants()) do
            if part:IsA("BasePart") and part.CanCollide then
                part.CanCollide = false
            end
        end
    end
end)

-- Уведомление
local notify = Instance.new("TextLabel")
notify.Size = UDim2.new(0, 300, 0, 40)
notify.Position = UDim2.new(0.5, -150, 0, 20)
notify.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
notify.Text = "Читы загружены! Нажми INSERT"
notify.TextColor3 = Color3.fromRGB(255, 255, 255)
notify.Font = Enum.Font.GothamBold
notify.TextSize = 14
notify.Parent = ScreenGui

local nc = Instance.new("UICorner")
nc.CornerRadius = UDim.new(0, 8)
nc.Parent = notify

task.wait(4)
notify:Destroy()
