--[[
  EULEN STYLE - Solara Edition (Instance GUI)
  loadstring(game:HttpGet("https://raw.githubusercontent.com/ghosttttttt3232/Roblox-AnimatedMenu/master/animated_menu.lua"))()
--]]

task.wait(3)

local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")
local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local Tween = game:GetService("TweenService")

-- Config
local Cfg = {
    esp = { on = false, box = true, health = true, dist = true, lines = true, team = true, maxDist = 1000 },
    aim = { on = false, fov = 100, showFov = true, smooth = 0.5, part = "Head" },
    player = { ws = 16, jp = 50 },
    misc = { fb = false },
}

-- GUI Setup
local sg = Instance.new("ScreenGui")
sg.Name = "EulenMenu"
sg.ResetOnSpawn = false
sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
sg.DisplayOrder = 999
sg.IgnoreGuiInset = true

if gethui then
    sg.Parent = gethui()
elseif syn and syn.protect_gui then
    syn.protect_gui(sg)
    sg.Parent = game:GetService("CoreGui")
else
    sg.Parent = game:GetService("CoreGui")
end

-- Colors
local C = {
    accent = Color3.fromRGB(212, 135, 106),
    bg = Color3.fromRGB(14, 14, 18),
    panel = Color3.fromRGB(18, 18, 24),
    card = Color3.fromRGB(26, 26, 34),
    element = Color3.fromRGB(20, 20, 26),
    text = Color3.fromRGB(155, 155, 165),
    textActive = Color3.fromRGB(235, 235, 240),
    textDim = Color3.fromRGB(95, 95, 105),
    border = Color3.fromRGB(28, 28, 36),
    green = Color3.fromRGB(74, 224, 160),
    red = Color3.fromRGB(255, 77, 106),
}

-- Main Frame
local main = Instance.new("Frame")
main.Size = UDim2.new(0, 700, 0, 450)
main.Position = UDim2.new(0.5, -350, 0.5, -225)
main.BackgroundColor3 = C.bg
main.BorderSizePixel = 0
main.Active = true
main.Draggable = true
main.Visible = false
main.Parent = sg

local mc = Instance.new("UICorner")
mc.CornerRadius = UDim.new(0, 8)
mc.Parent = main

local ms = Instance.new("UIStroke")
ms.Color = C.border
ms.Thickness = 1
ms.Parent = main

-- Title bar
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 40)
titleBar.BackgroundColor3 = Color3.fromRGB(10, 10, 14)
titleBar.BorderSizePixel = 0
titleBar.Parent = main

local titleBarC = Instance.new("UICorner")
titleBarC.CornerRadius = UDim.new(0, 8)
titleBarC.Parent = titleBar

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -20, 1, 0)
titleLabel.Position = UDim2.new(0, 20, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "EULEN"
titleLabel.TextColor3 = C.accent
titleLabel.TextSize = 18
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = titleBar

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -35, 0, 5)
closeBtn.BackgroundTransparency = 1
closeBtn.Text = "X"
closeBtn.TextColor3 = C.red
closeBtn.TextSize = 16
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Parent = titleBar

-- Sidebar
local sidebar = Instance.new("Frame")
sidebar.Size = UDim2.new(0, 130, 1, -40)
sidebar.Position = UDim2.new(0, 0, 0, 40)
sidebar.BackgroundColor3 = Color3.fromRGB(10, 10, 14)
sidebar.BorderSizePixel = 0
sidebar.Parent = main

local tabs = {"ESP", "AIMBOT", "PLAYER", "MISC"}
local tabBtns = {}
local tabFrames = {}
local activeTab = 1

for i, name in ipairs(tabs) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 34)
    btn.Position = UDim2.new(0, 5, 0, 5 + (i-1) * 40)
    btn.BackgroundColor3 = i == activeTab and C.card or Color3.new(1, 1, 1)
    btn.BackgroundTransparency = i == activeTab and 0 or 1
    btn.BorderSizePixel = 0
    btn.Text = ""
    btn.Parent = sidebar

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, 0, 1, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = name
    lbl.TextColor3 = i == activeTab and C.accent or C.text
    lbl.TextSize = 13
    lbl.Font = Enum.Font.Gotham
    lbl.Parent = btn

    local accent = Instance.new("Frame")
    accent.Size = UDim2.new(0, 3, 1, -10)
    accent.Position = UDim2.new(0, 0, 0, 5)
    accent.BackgroundColor3 = C.accent
    accent.BorderSizePixel = 0
    accent.Visible = i == activeTab
    accent.Parent = btn

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = btn

    tabBtns[i] = btn
    tabBtns[i].Accent = accent
    tabBtns[i].Label = lbl
end

-- Content area
local content = Instance.new("Frame")
content.Size = UDim2.new(1, -130, 1, -40)
content.Position = UDim2.new(0, 130, 0, 40)
content.BackgroundTransparency = 1
content.Parent = main

-- Tab content builder
local function makeToggle(parent, title, get, set)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, -20, 0, 36)
    row.BackgroundColor3 = C.element
    row.BorderSizePixel = 0
    row.Parent = parent

    local rc = Instance.new("UICorner")
    rc.CornerRadius = UDim.new(0, 6)
    rc.Parent = row

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -60, 1, 0)
    lbl.Position = UDim2.new(0, 12, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = title
    lbl.TextColor3 = C.text
    lbl.TextSize = 13
    lbl.Font = Enum.Font.Gotham
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = row

    local tog = Instance.new("TextButton")
    tog.Size = UDim2.new(0, 44, 0, 22)
    tog.Position = UDim2.new(1, -54, 0, 7)
    tog.BackgroundColor3 = get() and C.green or C.border
    tog.BorderSizePixel = 0
    tog.Text = ""
    tog.Parent = row

    local tc = Instance.new("UICorner")
    tc.CornerRadius = UDim.new(0, 11)
    tc.Parent = tog

    local dot = Instance.new("Frame")
    dot.Size = UDim2.new(0, 16, 0, 16)
    dot.Position = UDim2.new(0, get() and 26 or 3, 0, 3)
    dot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    dot.BorderSizePixel = 0
    dot.Parent = tog

    local dotc = Instance.new("UICorner")
    dotc.CornerRadius = UDim.new(0, 8)
    dotc.Parent = dot

    tog.MouseButton1Click:Connect(function()
        local v = not get()
        set(v)
        tog.BackgroundColor3 = v and C.green or C.border
        Tween:Create(dot, TweenInfo.new(0.15), {Position = UDim2.new(0, v and 26 or 3, 0, 3)}):Play()
    end)

    return row
end

local function makeSlider(parent, title, get, set, min, max, step, fmt)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, -20, 0, 44)
    row.BackgroundColor3 = C.element
    row.BorderSizePixel = 0
    row.Parent = parent

    local rc = Instance.new("UICorner")
    rc.CornerRadius = UDim.new(0, 6)
    rc.Parent = row

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -60, 0, 20)
    lbl.Position = UDim2.new(0, 12, 0, 2)
    lbl.BackgroundTransparency = 1
    lbl.Text = title
    lbl.TextColor3 = C.text
    lbl.TextSize = 13
    lbl.Font = Enum.Font.Gotham
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = row

    local valLbl = Instance.new("TextLabel")
    valLbl.Size = UDim2.new(0, 40, 0, 20)
    valLbl.Position = UDim2.new(1, -50, 0, 2)
    valLbl.BackgroundTransparency = 1
    valLbl.Text = tostring(get())
    valLbl.TextColor3 = C.accent
    valLbl.TextSize = 13
    valLbl.Font = Enum.Font.GothamBold
    valLbl.TextXAlignment = Enum.TextXAlignment.Right
    valLbl.Parent = row

    local bar = Instance.new("Frame")
    bar.Size = UDim2.new(1, -24, 0, 4)
    bar.Position = UDim2.new(0, 12, 0, 28)
    bar.BackgroundColor3 = C.border
    bar.BorderSizePixel = 0
    bar.Parent = row

    local bc = Instance.new("UICorner")
    bc.CornerRadius = UDim.new(0, 2)
    bc.Parent = bar

    local fill = Instance.new("Frame")
    local pct = (get() - min) / (max - min)
    fill.Size = UDim2.new(pct, 0, 1, 0)
    fill.BackgroundColor3 = C.accent
    fill.BorderSizePixel = 0
    fill.Parent = bar

    local fc = Instance.new("UICorner")
    fc.CornerRadius = UDim.new(0, 2)
    fc.Parent = fill

    local dragging = false
    row.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
        end
    end)
    row.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseInput then
            local mx = input.Position.X
            local absX, absY = bar.AbsolutePosition.X, bar.AbsoluteSize.X
            local pct2 = math.clamp((mx - absX) / absX, 0, 1)
            local v = math.floor((min + pct2 * (max - min)) / step) * step
            v = math.clamp(v, min, max)
            set(v)
            pct = (v - min) / (max - min)
            fill.Size = UDim2.new(pct, 0, 1, 0)
            valLbl.Text = tostring(v)
        end
    end)

    return row
end

-- Build tabs
local layouts = {}

-- ESP tab
local espFrame = Instance.new("ScrollingFrame")
espFrame.Size = UDim2.new(1, 0, 1, 0)
espFrame.BackgroundTransparency = 1
espFrame.BorderSizePixel = 0
espFrame.ScrollBarThickness = 3
espFrame.ScrollBarImageColor3 = C.element
espFrame.Visible = false
espFrame.Parent = content

local espLayout = Instance.new("UIListLayout")
espLayout.SortOrder = Enum.SortOrder.LayoutOrder
espLayout.Padding = UDim.new(0, 6)
espLayout.Parent = espFrame

local espPad = Instance.new("UIPadding")
espPad.PaddingLeft = UDim.new(0, 12)
espPad.PaddingRight = UDim.new(0, 12)
espPad.PaddingTop = UDim.new(0, 12)
espPad.PaddingBottom = UDim.new(0, 12)
espPad.Parent = espFrame

makeToggle(espFrame, "Enabled", function() return Cfg.esp.on end, function(v) Cfg.esp.on = v end)
makeToggle(espFrame, "Box", function() return Cfg.esp.box end, function(v) Cfg.esp.box = v end)
makeToggle(espFrame, "Health", function() return Cfg.esp.health end, function(v) Cfg.esp.health = v end)
makeToggle(espFrame, "Distance", function() return Cfg.esp.dist end, function(v) Cfg.esp.dist = v end)
makeToggle(espFrame, "Lines", function() return Cfg.esp.lines end, function(v) Cfg.esp.lines = v end)
makeToggle(espFrame, "Team Check", function() return Cfg.esp.team end, function(v) Cfg.esp.team = v end)
layouts["ESP"] = espFrame

-- Aimbot tab
local aimFrame = Instance.new("ScrollingFrame")
aimFrame.Size = UDim2.new(1, 0, 1, 0)
aimFrame.BackgroundTransparency = 1
aimFrame.BorderSizePixel = 0
aimFrame.ScrollBarThickness = 3
aimFrame.ScrollBarImageColor3 = C.element
aimFrame.Visible = false
aimFrame.Parent = content

local aimLayout = Instance.new("UIListLayout")
aimLayout.SortOrder = Enum.SortOrder.LayoutOrder
aimLayout.Padding = UDim.new(0, 6)
aimLayout.Parent = aimFrame

local aimPad = Instance.new("UIPadding")
aimPad.PaddingLeft = UDim.new(0, 12)
aimPad.PaddingRight = UDim.new(0, 12)
aimPad.PaddingTop = UDim.new(0, 12)
aimPad.PaddingBottom = UDim.new(0, 12)
aimPad.Parent = aimFrame

makeToggle(aimFrame, "Enabled", function() return Cfg.aim.on end, function(v) Cfg.aim.on = v end)
makeToggle(aimFrame, "Show FOV", function() return Cfg.aim.showFov end, function(v) Cfg.aim.showFov = v end)
makeSlider(aimFrame, "FOV Size", function() return Cfg.aim.fov end, function(v) Cfg.aim.fov = v, 10, 500, 5)
layouts["AIMBOT"] = aimFrame

-- Player tab
local plyFrame = Instance.new("ScrollingFrame")
plyFrame.Size = UDim2.new(1, 0, 1, 0)
plyFrame.BackgroundTransparency = 1
plyFrame.BorderSizePixel = 0
plyFrame.ScrollBarThickness = 3
plyFrame.ScrollBarImageColor3 = C.element
plyFrame.Visible = false
plyFrame.Parent = content

local plyLayout = Instance.new("UIListLayout")
plyLayout.SortOrder = Enum.SortOrder.LayoutOrder
plyLayout.Padding = UDim.new(0, 6)
plyLayout.Parent = plyFrame

local plyPad = Instance.new("UIPadding")
plyPad.PaddingLeft = UDim.new(0, 12)
plyPad.PaddingRight = UDim.new(0, 12)
plyPad.PaddingTop = UDim.new(0, 12)
plyPad.PaddingBottom = UDim.new(0, 12)
plyPad.Parent = plyFrame

makeSlider(plyFrame, "WalkSpeed", function() return Cfg.player.ws end, function(v) Cfg.player.ws = v; if LP.Character and LP.Character:FindFirstChild("Humanoid") then LP.Character.Humanoid.WalkSpeed = v end end, 16, 200, 1)
makeSlider(plyFrame, "JumpPower", function() return Cfg.player.jp end, function(v) Cfg.player.jp = v; if LP.Character and LP.Character:FindFirstChild("Humanoid") then LP.Character.Humanoid.JumpPower = v end end, 50, 300, 5)
layouts["PLAYER"] = plyFrame

-- Misc tab
local miscFrame = Instance.new("ScrollingFrame")
miscFrame.Size = UDim2.new(1, 0, 1, 0)
miscFrame.BackgroundTransparency = 1
miscFrame.BorderSizePixel = 0
miscFrame.ScrollBarThickness = 3
miscFrame.ScrollBarImageColor3 = C.element
miscFrame.Visible = false
miscFrame.Parent = content

local miscLayout = Instance.new("UIListLayout")
miscLayout.SortOrder = Enum.SortOrder.LayoutOrder
miscLayout.Padding = UDim.new(0, 6)
miscLayout.Parent = miscFrame

local miscPad = Instance.new("UIPadding")
miscPad.PaddingLeft = UDim.new(0, 12)
miscPad.PaddingRight = UDim.new(0, 12)
miscPad.PaddingTop = UDim.new(0, 12)
miscPad.PaddingBottom = UDim.new(0, 12)
miscPad.Parent = miscFrame

makeToggle(miscFrame, "Fullbright", function() return Cfg.misc.fb end, function(v)
    Cfg.misc.fb = v
    local L = game:GetService("Lighting")
    L.Brightness = v and 2 or 1
    L.GlobalShadows = not v
    L.OutdoorAmbient = v and Color3.fromRGB(128,128,128) or Color3.fromRGB(70,70,70)
end)
layouts["MISC"] = miscFrame

-- Tab switching
for i, name in ipairs(tabs) do
    tabBtns[i].MouseButton1Click:Connect(function()
        for j = 1, #tabs do
            local btn = tabBtns[j]
            btn.BackgroundTransparency = 1
            btn.Label.TextColor3 = C.text
            btn.Accent.Visible = false
            layouts[tabs[j]].Visible = false
        end
        tabBtns[i].BackgroundTransparency = 0
        tabBtns[i].Label.TextColor3 = C.accent
        tabBtns[i].Accent.Visible = true
        layouts[name].Visible = true
        activeTab = i
    end)
end

-- Show first tab
layouts["ESP"].Visible = true

-- Close button
closeBtn.MouseButton1Click:Connect(function()
    main.Visible = false
end)

-- Toggle
local toggleKey = Enum.KeyCode.RightShift
UIS.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == toggleKey then
        main.Visible = not main.Visible
    end
end)

-- Show menu
main.Visible = true

-- Animate in
main.Size = UDim2.new(0, 0, 0, 0)
main.Position = UDim2.new(0.5, 0, 0.5, 0)
Tween:Create(main, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
    Size = UDim2.new(0, 700, 0, 450),
    Position = UDim2.new(0.5, -350, 0.5, -225),
}):Play()

-- ESP system
local espDrawings = {}
local function makeESPDrawing(p)
    if espDrawings[p] then return end
    local d = {}
    d.box = {}
    for i = 1, 4 do d.box[i] = Drawing.new("Line") end
    d.name = Drawing.new("Text"); d.name.Outline = true; d.name.Center = true
    d.health = Drawing.new("Text"); d.health.Outline = true; d.health.Center = true
    d.dist = Drawing.new("Text"); d.dist.Outline = true; d.dist.Center = true
    d.line = Drawing.new("Line")
    for _, v in pairs(d) do
        if type(v) == "table" then
            for _, dd in pairs(v) do dd.Visible = false end
        else v.Visible = false end
    end
    espDrawings[p] = d
end

RS.RenderStepped:Connect(function()
    if not Cfg.esp.on then
        for _, d in pairs(espDrawings) do
            for _, v in pairs(d) do
                if type(v) == "table" then for _, dd in pairs(v) do dd.Visible = false end
                else v.Visible = false end
            end
        end
        return
    end

    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LP then
            makeESPDrawing(p)
            local d = espDrawings[p]
            local char, hrp, head, hum = p.Character, nil, nil, nil
            if char then
                hrp = char:FindFirstChild("HumanoidRootPart")
                head = char:FindFirstChild("Head")
                hum = char:FindFirstChild("Humanoid")
            end

            local show = hrp and head and hum and hum.Health > 0
            if show and Cfg.esp.team and p.Team and LP.Team and p.Team == LP.Team then show = false end
            if show then
                local myChar = LP.Character
                local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
                local dist = myHRP and (hrp.Position - myHRP.Position).Magnitude or 9999
                if dist > Cfg.esp.maxDist then show = false end
            end

            if show then
                local sp, on = Camera:WorldToViewportPoint(head.Position + Vector3.new(0, 2, 0))
                local sp2, _ = Camera:WorldToViewportPoint(hrp.Position)
                local vsp = Vector2.new(sp.X, sp.Y)
                local vsp2 = Vector2.new(sp2.X, sp2.Y)

                if on then
                    -- Box
                    if Cfg.esp.box then
                        local size = char:GetExtentsSize()
                        local cf = hrp.CFrame
                        local hw, hh = size.X/2, size.Y/2
                        local c1 = Camera:WorldToViewportPoint((cf * CFrame.new(-hw, hh, 0)).p)
                        local c2 = Camera:WorldToViewportPoint((cf * CFrame.new(hw, hh, 0)).p)
                        local c3 = Camera:WorldToViewportPoint((cf * CFrame.new(hw, -hh, 0)).p)
                        local c4 = Camera:WorldToViewportPoint((cf * CFrame.new(-hw, -hh, 0)).p)
                        if c1.Z > 0 and c2.Z > 0 and c3.Z > 0 and c4.Z > 0 then
                            local minX = math.min(c1.X,c2.X,c3.X,c4.X)
                            local maxX = math.max(c1.X,c2.X,c3.X,c4.X)
                            local minY = math.min(c1.Y,c2.Y,c3.Y,c4.Y)
                            local maxY = math.max(c1.Y,c2.Y,c3.Y,c4.Y)
                            d.box[1].From = Vector2.new(minX,minY); d.box[1].To = Vector2.new(maxX,minY)
                            d.box[2].From = Vector2.new(maxX,minY); d.box[2].To = Vector2.new(maxX,maxY)
                            d.box[3].From = Vector2.new(maxX,maxY); d.box[3].To = Vector2.new(minX,maxY)
                            d.box[4].From = Vector2.new(minX,maxY); d.box[4].To = Vector2.new(minX,minY)
                            for i = 1, 4 do d.box[i].Visible = true; d.box[i].Thickness = 2; d.box[i].Color = Color3.fromRGB(0,255,136) end
                        else for i = 1, 4 do d.box[i].Visible = false end end
                    else for i = 1, 4 do d.box[i].Visible = false end end

                    -- Name
                    d.name.Position = vsp2 - Vector2.new(0, 45)
                    d.name.Text = p.Name
                    d.name.Visible = true

                    -- Health
                    if Cfg.esp.health then
                        d.health.Position = vsp2 - Vector2.new(0, 28)
                        d.health.Text = "HP: " .. math.floor(hum.Health)
                        d.health.Color = hum.Health > 50 and C.green or (hum.Health > 25 and Color3.fromRGB(255,190,60) or C.red)
                        d.health.Visible = true
                    else d.health.Visible = false end

                    -- Distance
                    if Cfg.esp.dist then
                        local d2 = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") and (hrp.Position - LP.Character.HumanoidRootPart.Position).Magnitude or 0
                        d.dist.Position = vsp2 - Vector2.new(0, 13)
                        d.dist.Text = string.format("%.0fm", d2)
                        d.dist.Visible = true
                    else d.dist.Visible = false end

                    -- Line
                    if Cfg.esp.lines then
                        d.line.From = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y)
                        d.line.To = vsp2
                        d.line.Visible = true
                        d.line.Color = C.accent
                    else d.line.Visible = false end
                end
            else
                d.name.Visible = false; d.health.Visible = false; d.dist.Visible = false; d.line.Visible = false
                for i = 1, 4 do d.box[i].Visible = false end
            end
        end
    end
end)

-- Aimbot
RS.RenderStepped:Connect(function()
    if Cfg.aim.on and UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
        local mp = UIS:GetMouseLocation()
        local best, bd = nil, Cfg.aim.fov
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LP and p.Character and p.Character:FindFirstChild(Cfg.aim.part) then
                local part = p.Character[Cfg.aim.part]
                local sp, on = Camera:WorldToViewportPoint(part.Position)
                if on then
                    local d = (Vector2.new(sp.X, sp.Y) - mp).Magnitude
                    if d < bd then bd = d; best = p end
                end
            end
        end
        if best and best.Character and best.Character:FindFirstChild(Cfg.aim.part) then
            local target = best.Character[Cfg.aim.part].Position
            Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, target), Cfg.aim.smooth)
        end
    end
end)
