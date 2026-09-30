-- ============================================
--          Читы by laroslav7  |  v2
-- ============================================
local CoreGui    = game:GetService("CoreGui")
local Players    = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInput  = game:GetService("UserInputService")
local lp         = Players.LocalPlayer

pcall(function()
    local old = CoreGui:FindFirstChild("YaroslavUI")
    if old then old:Destroy() end
end)

-- ============ STATE ============
local State = {
    speed    = {enabled=false, value=16,  key=nil},
    jump     = {enabled=false, value=50,  key=nil},
    fly      = {enabled=false, speed=60,  key=nil},
    noclip   = {enabled=false, key=nil},
    godmode  = {enabled=false, key=nil},
    highlight= {enabled=false, key=nil},
    esp      = {enabled=false, key=nil},
    vehicle  = {enabled=false, value=250, key=nil},
    anim534  = {enabled=false, key=nil},
}

-- runtime vars
local flyBV, flyBG
local hlFolder, espFolder
local animM6D, animTorso, animIsR6
local awaitingKey = nil

-- ============ GUI ============
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "YaroslavUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = CoreGui

local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 430, 0, 560)
Main.Position = UDim2.new(0.5, -215, 0.5, -280)
Main.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true
Main.Visible = false
Main.Parent = ScreenGui
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 12)

local stroke = Instance.new("UIStroke", Main)
stroke.Color = Color3.fromRGB(0, 170, 255)
stroke.Thickness = 2
stroke.Transparency = 0.35

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 45)
Title.BackgroundColor3 = Color3.fromRGB(28, 28, 38)
Title.BorderSizePixel = 0
Title.Text = "⚡ Читы by laroslav7  |  v2"
Title.TextColor3 = Color3.fromRGB(0, 170, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.Parent = Main
Instance.new("UICorner", Title).CornerRadius = UDim.new(0, 12)

local Scroll = Instance.new("ScrollingFrame")
Scroll.Size = UDim2.new(1, -10, 1, -55)
Scroll.Position = UDim2.new(0, 5, 0, 50)
Scroll.BackgroundTransparency = 1
Scroll.BorderSizePixel = 0
Scroll.ScrollBarThickness = 4
Scroll.ScrollBarImageColor3 = Color3.fromRGB(0, 170, 255)
Scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
Scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
Scroll.Parent = Main

local UIListLayout = Instance.new("UIListLayout", Scroll)
UIListLayout.Padding = UDim.new(0, 6)
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

local UIPadding = Instance.new("UIPadding", Scroll)
UIPadding.PaddingTop = UDim.new(0, 6)
UIPadding.PaddingLeft = UDim.new(0, 6)
UIPadding.PaddingRight = UDim.new(0, 6)
UIPadding.PaddingBottom = UDim.new(0, 6)

-- ============ GUI HELPERS ============
local function makeHeader(text)
    local h = Instance.new("TextLabel")
    h.Size = UDim2.new(1, 0, 0, 24)
    h.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
    h.BorderSizePixel = 0
    h.Text = "  ▸ " .. text
    h.TextColor3 = Color3.fromRGB(0, 170, 255)
    h.Font = Enum.Font.GothamBold
    h.TextSize = 13
    h.TextXAlignment = Enum.TextXAlignment.Left
    h.Parent = Scroll
    Instance.new("UICorner", h).CornerRadius = UDim.new(0, 6)
end

local function updateKB(btn, key)
    if key then
        btn.Text = "["..key.Name.."]"
        btn.TextColor3 = Color3.fromRGB(0, 170, 255)
    else
        btn.Text = "Клавиша: -"
        btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    end
end

local function makeToggleRow(name, state)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, 0, 0, 36)
    row.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
    row.BorderSizePixel = 0
    row.Parent = Scroll
    Instance.new("UICorner", row).CornerRadius = UDim.new(0, 6)

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(0.45, 0, 1, 0)
    lbl.Position = UDim2.new(0, 12, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = name
    lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    lbl.Font = Enum.Font.Gotham
    lbl.TextSize = 13
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = row

    local kbBtn = Instance.new("TextButton")
    kbBtn.Size = UDim2.new(0, 100, 0, 26)
    kbBtn.Position = UDim2.new(1, -155, 0.5, -13)
    kbBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    kbBtn.BorderSizePixel = 0
    kbBtn.Font = Enum.Font.Gotham
    kbBtn.TextSize = 11
    kbBtn.Parent = row
    Instance.new("UICorner", kbBtn).CornerRadius = UDim.new(0, 6)
    updateKB(kbBtn, state.key)

    kbBtn.MouseButton1Click:Connect(function()
        if awaitingKey and awaitingKey.btn then
            updateKB(awaitingKey.btn, awaitingKey.state.key)
        end
        awaitingKey = {state = state, btn = kbBtn}
        kbBtn.Text = "Нажми..."
        kbBtn.TextColor3 = Color3.fromRGB(255, 200, 0)
    end)

    local tgBtn = Instance.new("TextButton")
    tgBtn.Size = UDim2.new(0, 45, 0, 26)
    tgBtn.Position = UDim2.new(1, -48, 0.5, -13)
    tgBtn.BorderSizePixel = 0
    tgBtn.Font = Enum.Font.GothamBold
    tgBtn.TextSize = 11
    tgBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    tgBtn.Parent = row
    Instance.new("UICorner", tgBtn).CornerRadius = UDim.new(0, 6)

    local function refresh()
        if state.enabled then
            tgBtn.Text = "ON"
            tgBtn.BackgroundColor3 = Color3.fromRGB(40, 160, 70)
        else
            tgBtn.Text = "OFF"
            tgBtn.BackgroundColor3 = Color3.fromRGB(120, 40, 40)
        end
    end

    tgBtn.MouseButton1Click:Connect(function()
        state.enabled = not state.enabled
        refresh()
        if state.onToggle then state.onToggle(state.enabled) end
    end)

    state.toggleUI = function()
        state.enabled = not state.enabled
        refresh()
        if state.onToggle then state.onToggle(state.enabled) end
    end
    refresh()
end

local function makeSliderRow(name, state, min, max, valueKey)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, 0, 0, 46)
    row.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
    row.BorderSizePixel = 0
    row.Parent = Scroll
    Instance.new("UICorner", row).CornerRadius = UDim.new(0, 6)

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -20, 0, 18)
    lbl.Position = UDim2.new(0, 12, 0, 4)
    lbl.BackgroundTransparency = 1
    lbl.Text = name .. ": " .. tostring(state[valueKey])
    lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    lbl.Font = Enum.Font.Gotham
    lbl.TextSize = 12
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = row

    local bar = Instance.new("Frame")
    bar.Size = UDim2.new(1, -20, 0, 10)
    bar.Position = UDim2.new(0, 12, 0, 28)
    bar.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    bar.BorderSizePixel = 0
    bar.Parent = row
    Instance.new("UICorner", bar).CornerRadius = UDim.new(0, 5)

    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((state[valueKey]-min)/(max-min), 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
    fill.BorderSizePixel = 0
    fill.Parent = bar
    Instance.new("UICorner", fill).CornerRadius = UDim.new(0, 5)

    local dragging = false
    bar.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true end
    end)
    UserInput.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)
    UserInput.InputChanged:Connect(function(i)
        if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
            local rel = (i.Position.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X
            rel = math.clamp(rel, 0, 1)
            fill.Size = UDim2.new(rel, 0, 1, 0)
            local val = math.floor(min + (max - min) * rel)
            state[valueKey] = val
            lbl.Text = name .. ": " .. val
        end
    end)
end

-- ============ FEATURE LOGIC ============

-- FLY
local function startFly()
    local char = lp.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    if flyBV then flyBV:Destroy() end
    if flyBG then flyBG:Destroy() end
    flyBV = Instance.new("BodyVelocity")
    flyBV.MaxForce = Vector3.new(1e9, 1e9, 1e9)
    flyBV.Velocity = Vector3.zero
    flyBV.Parent = hrp
    flyBG = Instance.new("BodyGyro")
    flyBG.MaxTorque = Vector3.new(1e9, 1e9, 1e9)
    flyBG.P = 15000
    flyBG.D = 800
    flyBG.Parent = hrp
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then hum.PlatformStand = true end
end

local function stopFly()
    if flyBV then flyBV:Destroy() flyBV = nil end
    if flyBG then flyBG:Destroy() flyBG = nil end
    local char = lp.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then hum.PlatformStand = false end
    end
end

-- VISUALS (Highlight + ESP)
local function clearVisuals()
    if hlFolder then hlFolder:Destroy() hlFolder = nil end
    if espFolder then espFolder:Destroy() espFolder = nil end
end

local function createVisuals()
    clearVisuals()
    hlFolder = Instance.new("Folder")
    hlFolder.Name = "HL"
    hlFolder.Parent = ScreenGui
    espFolder = Instance.new("Folder")
    espFolder.Name = "ESP"
    espFolder.Parent = ScreenGui

    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= lp then
            local char = plr.Character
            if char then
                if State.highlight.enabled then
                    local h = Instance.new("Highlight")
                    h.FillColor = Color3.fromRGB(0, 170, 255)
                    h.OutlineColor = Color3.fromRGB(255, 255, 255)
                    h.FillTransparency = 0.5
                    h.OutlineTransparency = 0.2
                    h.Adornee = char
                    h.Parent = hlFolder
                end
                if State.esp.enabled then
                    local head = char:FindFirstChild("Head")
                    if head then
                        local bb = Instance.new("BillboardGui")
                        bb.Size = UDim2.new(0, 200, 0, 44)
                        bb.StudsOffset = Vector3.new(0, 3, 0)
                        bb.AlwaysOnTop = true
                        bb.Adornee = head
                        bb.Parent = espFolder

                        local nameL = Instance.new("TextLabel")
                        nameL.Size = UDim2.new(1, 0, 0.55, 0)
                        nameL.BackgroundTransparency = 1
                        nameL.Text = plr.Name
                        nameL.TextColor3 = Color3.fromRGB(0, 170, 255)
                        nameL.TextStrokeTransparency = 0
                        nameL.Font = Enum.Font.GothamBold
                        nameL.TextSize = 14
                        nameL.Parent = bb

                        local distL = Instance.new("TextLabel")
                        distL.Name = "Dist"
                        distL.Size = UDim2.new(1, 0, 0.45, 0)
                        distL.Position = UDim2.new(0, 0, 0.55, 0)
                        distL.BackgroundTransparency = 1
                        distL.Text = "0m"
                        distL.TextColor3 = Color3.fromRGB(255, 255, 255)
                        distL.TextStrokeTransparency = 0
                        distL.Font = Enum.Font.Gotham
                        distL.TextSize = 12
                        distL.Parent = bb
                    end
                end
            end
        end
    end
end

local function refreshVisuals()
    if State.highlight.enabled or State.esp.enabled then
        createVisuals()
    else
        clearVisuals()
    end
end

-- ANIMATION 534
local function startAnim534()
    animM6D, animTorso = nil, nil
    local char = lp.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    animIsR6 = (hum.RigType == Enum.HumanoidRigType.R6)
    if animIsR6 then
        animTorso = char:FindFirstChild("Torso")
        animM6D = animTorso and animTorso:FindFirstChild("Right Shoulder")
    else
        animTorso = char:FindFirstChild("UpperTorso")
        animM6D = animTorso and animTorso:FindFirstChild("RightShoulder")
    end
end

-- Attach onToggle callbacks
State.fly.onToggle = function(en)
    if en then startFly() else stopFly() end
end

State.highlight.onToggle = refreshVisuals
State.esp.onToggle = refreshVisuals

State.anim534.onToggle = function(en)
    if en then
        startAnim534()
    else
        animM6D, animTorso = nil, nil
    end
end

-- ============ BUILD GUI CONTENT ============
makeHeader("ДВИЖЕНИЕ")
makeToggleRow("Скорость", State.speed)
makeSliderRow("Скорость (ед)", State.speed, 16, 300, "value")
makeToggleRow("Прыжок", State.jump)
makeSliderRow("Прыжок (ед)", State.jump, 50, 500, "value")
makeToggleRow("Полёт", State.fly)
makeSliderRow("Скорость полёта", State.fly, 10, 500, "speed")
makeToggleRow("Noclip (одна кнопка)", State.noclip)

makeHeader("ЗАЩИТА")
makeToggleRow("Бессмертие", State.godmode)

makeHeader("ВИЗУАЛ")
makeToggleRow("Подсветка игроков", State.highlight)
makeToggleRow("ESP (ник + дист.)", State.esp)

makeHeader("ТРАНСПОРТ")
makeToggleRow("Ускорение транспорта", State.vehicle)
makeSliderRow("Скорость транспорта", State.vehicle, 50, 1500, "value")

makeHeader("АНИМАЦИИ")
makeToggleRow("Анимация 534", State.anim534)

-- ============ INPUT ============
UserInput.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.Insert then
        Main.Visible = not Main.Visible
        return
    end
    if awaitingKey then
        if input.KeyCode == Enum.KeyCode.Escape then
            awaitingKey.state.key = nil
            updateKB(awaitingKey.btn, nil)
        else
            awaitingKey.state.key = input.KeyCode
            updateKB(awaitingKey.btn, input.KeyCode)
        end
        awaitingKey = nil
        return
    end
    for _, st in pairs(State) do
        if st.key and st.toggleUI and input.KeyCode == st.key then
            st.toggleUI()
        end
    end
end)

-- ============ LOOPS ============

-- Speed / Jump / Godmode
task.spawn(function()
    while task.wait(0.15) do
        local char = lp.Character
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then
                if State.speed.enabled then hum.WalkSpeed = State.speed.value end
                if State.jump.enabled then
                    hum.UseJumpPower = true
                    hum.JumpPower = State.jump.value
                end
                if State.godmode.enabled then
                    hum.MaxHealth = math.huge
                    if hum.Health < hum.MaxHealth then hum.Health = hum.MaxHealth end
                end
            end
        end
    end
end)

-- Noclip
RunService.Stepped:Connect(function()
    if not State.noclip.enabled then return end
    local char = lp.Character
    if not char then return end
    for _, p in ipairs(char:GetDescendants()) do
        if p:IsA("BasePart") and p.CanCollide then
            p.CanCollide = false
        end
    end
end)

-- Fly movement
RunService.Heartbeat:Connect(function()
    if not State.fly.enabled or not flyBV or not flyBG then return end
    local char = lp.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local cam = workspace.CurrentCamera
    local moveDir = Vector3.zero
    if UserInput:IsKeyDown(Enum.KeyCode.W) then moveDir += cam.CFrame.LookVector end
    if UserInput:IsKeyDown(Enum.KeyCode.S) then moveDir -= cam.CFrame.LookVector end
    if UserInput:IsKeyDown(Enum.KeyCode.A) then moveDir -= cam.CFrame.RightVector end
    if UserInput:IsKeyDown(Enum.KeyCode.D) then moveDir += cam.CFrame.RightVector end
    if UserInput:IsKeyDown(Enum.KeyCode.Space) then moveDir += Vector3.new(0, 1, 0) end
    if UserInput:IsKeyDown(Enum.KeyCode.LeftControl) then moveDir -= Vector3.new(0, 1, 0) end
    flyBV.Velocity = moveDir * State.fly.speed
    flyBG.CFrame = cam.CFrame
end)

-- ESP distance update
RunService.RenderStepped:Connect(function()
    if not State.esp.enabled or not espFolder then return end
    local myChar = lp.Character
    local myHrp = myChar and myChar:FindFirstChild("HumanoidRootPart")
    if not myHrp then return end
    for _, bb in ipairs(espFolder:GetChildren()) do
        if bb:IsA("BillboardGui") and bb.Adornee then
            local dl = bb:FindFirstChild("Dist")
            if dl then
                local d = (myHrp.Position - bb.Adornee.Position).Magnitude
                dl.Text = math.floor(d) .. "m"
            end
        end
    end
end)

-- Vehicle speed
RunService.Heartbeat:Connect(function()
    local char = lp.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    local seat = hum and hum.SitPart
    local vehicleRoot = nil
    if seat and seat:IsA("VehicleSeat") and seat.Parent then
        vehicleRoot = seat.Parent.PrimaryPart or seat
    end

    if not State.vehicle.enabled or not vehicleRoot then
        -- cleanup any leftover velocity
        for _, p in ipairs(workspace:GetDescendants()) do
            if p.Name == "YaroslavVehVel" then p:Destroy() end
        end
        return
    end

    local throttle = 0
    if UserInput:IsKeyDown(Enum.KeyCode.W) then throttle = 1 end
    if UserInput:IsKeyDown(Enum.KeyCode.S) then throttle = -1 end

    if throttle ~= 0 then
        local bv = vehicleRoot:FindFirstChild("YaroslavVehVel")
        if not bv then
            bv = Instance.new("BodyVelocity")
            bv.Name = "YaroslavVehVel"
            bv.MaxForce = Vector3.new(1e9, 0, 1e9)
            bv.Parent = vehicleRoot
        end
        local dir = seat.CFrame.LookVector * throttle
        bv.Velocity = Vector3.new(dir.X, 0, dir.Z).Unit * State.vehicle.value
    else
        local bv = vehicleRoot:FindFirstChild("YaroslavVehVel")
        if bv then bv:Destroy() end
    end
end)

-- Animation 534 render loop
RunService.RenderStepped:Connect(function()
    if not State.anim534.enabled then return end
    if not animM6D or not animM6D.Parent then
        startAnim534()
        if not animM6D then return end
    end
    local offset = math.sin(tick() * 25) * 0.45
    -- Transform is relative to C0, so -1 in X moves arm from side to center
    if animIsR6 then
        animM6D.Transform = CFrame.new(-1, 0, offset)
    else
        animM6D.Transform = CFrame.new(-1, 0, offset) * CFrame.Angles(math.rad(20), 0, 0)
    end
end)

-- Player join/leave refresh
Players.PlayerAdded:Connect(function()
    task.wait(1)
    if State.highlight.enabled or State.esp.enabled then refreshVisuals() end
end)
Players.PlayerRemoving:Connect(function()
    task.wait(0.5)
    if State.highlight.enabled or State.esp.enabled then refreshVisuals() end
end)

-- Character respawn
lp.CharacterAdded:Connect(function()
    task.wait(0.6)
    if State.fly.enabled then
        startFly()
    end
    if State.highlight.enabled or State.esp.enabled then
        refreshVisuals()
    end
    if State.anim534.enabled then
        startAnim534()
    end
end)

-- ============ NOTIFY ============
local notify = Instance.new("TextLabel")
notify.Size = UDim2.new(0, 320, 0, 42)
notify.Position = UDim2.new(0.5, -160, 0, 20)
notify.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
notify.BorderSizePixel = 0
notify.Text = "✓ Читы загружены! Нажми INSERT | by laroslav7"
notify.TextColor3 = Color3.fromRGB(0, 170, 255)
notify.Font = Enum.Font.GothamBold
notify.TextSize = 14
notify.Parent = ScreenGui
Instance.new("UICorner", notify).CornerRadius = UDim.new(0, 8)
local nStroke = Instance.new("UIStroke", notify)
nStroke.Color = Color3.fromRGB(0, 170, 255)
nStroke.Thickness = 2

task.wait(4)
notify:Destroy()
