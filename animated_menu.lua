--[[
  EULEN ELITE - Solara Edition
  loadstring(game:HttpGet("https://raw.githubusercontent.com/ghosttttttt3232/Roblox-AnimatedMenu/master/animated_menu.lua"))()
--]]

task.wait(3)

local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")
local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local Tween = game:GetService("TweenService")

local Cfg = {
    esp = { on = false, box = true, health = true, dist = true, lines = true, team = true, maxDist = 1000 },
    aim = { on = false, fov = 100, showFov = true, smooth = 0.5, part = "Head" },
    player = { ws = 16, jp = 50 },
    misc = { fb = false },
}

local sg = Instance.new("ScreenGui")
sg.Name = "EulenElite"
sg.ResetOnSpawn = false
sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
sg.DisplayOrder = 999
sg.IgnoreGuiInset = true

if gethui then
    sg.Parent = gethui()
elseif syn and syn.protect_gui then
    syn.protect_gui(sg); sg.Parent = game:GetService("CoreGui")
else
    sg.Parent = game:GetService("CoreGui")
end

-- Elevated palette
local C = {
    accent = Color3.fromRGB(120, 87, 255),
    accent2 = Color3.fromRGB(87, 150, 255),
    bg = Color3.fromRGB(8, 8, 12),
    panel = Color3.fromRGB(14, 14, 20),
    card = Color3.fromRGB(20, 20, 28),
    element = Color3.fromRGB(18, 18, 26),
    hover = Color3.fromRGB(26, 26, 36),
    text = Color3.fromRGB(160, 160, 175),
    textActive = Color3.fromRGB(240, 240, 250),
    textDim = Color3.fromRGB(90, 90, 105),
    border = Color3.fromRGB(24, 24, 34),
    green = Color3.fromRGB(74, 224, 160),
    red = Color3.fromRGB(255, 77, 106),
    gold = Color3.fromRGB(255, 190, 60),
}

local function shadow(frames)
    local s = Instance.new("ImageLabel")
    s.Size = UDim2.new(1, 30, 1, 30)
    s.Position = UDim2.new(0, -15, 0, -15)
    s.BackgroundTransparency = 1
    s.Image = "rbxassetid://16648505878"
    s.ImageColor3 = Color3.fromRGB(0, 0, 0)
    s.ImageTransparency = 0.7
    s.ScaleType = Enum.ScaleType.Slice
    s.SliceCenter = Rect.new(20, 20, 180, 180)
    s.ZIndex = -1
    s.Parent = frames
end

-- Main container
local main = Instance.new("Frame")
main.Size = UDim2.new(0, 760, 0, 480)
main.Position = UDim2.new(0.5, -380, 0.5, -240)
main.BackgroundColor3 = C.bg
main.BorderSizePixel = 0
main.Active = true
main.Draggable = true
main.Visible = false
main.ClipsDescendants = true
main.Parent = sg

shadow(main)

local mc = Instance.new("UICorner")
mc.CornerRadius = UDim.new(0, 12)
mc.Parent = main

local ms = Instance.new("UIStroke")
ms.Color = C.border; ms.Thickness = 1; ms.Parent = main

-- Header
local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 52)
header.BackgroundColor3 = C.panel
header.BorderSizePixel = 0
header.Parent = main

local hc = Instance.new("UICorner")
hc.CornerRadius = UDim.new(0, 12)
hc.Parent = header

local hc2 = Instance.new("UICorner")
hc2.CornerRadius = UDim.new(0, 12)
hc2.Parent = main

local hStroke = Instance.new("UIStroke")
hStroke.Color = C.border; hStroke.Thickness = 1; hStroke.Parent = header

local logo = Instance.new("TextLabel")
logo.Size = UDim2.new(0, 120, 1, 0)
logo.Position = UDim2.new(0, 20, 0, 0)
logo.BackgroundTransparency = 1
logo.Text = "EULEN"
logo.TextColor3 = C.accent
logo.TextSize = 22
logo.Font = Enum.Font.GothamBold
logo.TextXAlignment = Enum.TextXAlignment.Left
logo.Parent = header

local logoSub = Instance.new("TextLabel")
logoSub.Size = UDim2.new(0, 60, 1, 0)
logoSub.Position = UDim2.new(0, 110, 0, 0)
logoSub.BackgroundTransparency = 1
logoSub.Text = "ELITE"
logoSub.TextColor3 = C.accent2
logoSub.TextSize = 14
logoSub.Font = Enum.Font.Gotham
logoSub.TextXAlignment = Enum.TextXAlignment.Left
logoSub.TextTransparency = 0.5
logoSub.Parent = header

-- Accent line under header
local accentLine = Instance.new("Frame")
accentLine.Size = UDim2.new(1, 0, 0, 2)
accentLine.Position = UDim2.new(0, 0, 1, 0)
accentLine.BackgroundColor3 = C.accent
accentLine.BorderSizePixel = 0
accentLine.Parent = header

-- Close button
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 32, 0, 32)
closeBtn.Position = UDim2.new(1, -42, 0, 10)
closeBtn.BackgroundTransparency = 1
closeBtn.Text = ""
closeBtn.Parent = header

local closeIcon = Instance.new("TextLabel")
closeIcon.Size = UDim2.new(1, 0, 1, 0)
closeIcon.BackgroundTransparency = 1
closeIcon.Text = "✕"
closeIcon.TextColor3 = C.textDim
closeIcon.TextSize = 18
closeIcon.Font = Enum.Font.Gotham
closeIcon.Parent = closeBtn

closeBtn.MouseEnter:Connect(function() closeIcon.TextColor3 = C.red end)
closeBtn.MouseLeave:Connect(function() closeIcon.TextColor3 = C.textDim end)

-- Sidebar
local sidebar = Instance.new("Frame")
sidebar.Size = UDim2.new(0, 160, 1, -52)
sidebar.Position = UDim2.new(0, 0, 0, 52)
sidebar.BackgroundColor3 = C.panel
sidebar.BorderSizePixel = 0
sidebar.Parent = main

local sc = Instance.new("UICorner")
sc.CornerRadius = UDim.new(0, 12)
sc.Parent = sidebar

local sidebarDivider = Instance.new("Frame")
sidebarDivider.Size = UDim2.new(0, 1, 1, -20)
sidebarDivider.Position = UDim2.new(1, 0, 0, 10)
sidebarDivider.BackgroundColor3 = C.border
sidebarDivider.BorderSizePixel = 0
sidebarDivider.Parent = sidebar

local tabs = {"ESP", "AIMBOT", "PLAYER", "MISC"}
local tabIcons = {"◆", "◈", "◇", "○"}
local tabBtns = {}
local tabFrames = {}
local activeTab = 1

for i, name in ipairs(tabs) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -12, 0, 42)
    btn.Position = UDim2.new(0, 6, 0, 10 + (i-1) * 50)
    btn.BackgroundColor3 = i == activeTab and C.card or C.panel
    btn.BackgroundTransparency = i == activeTab and 0 or 1
    btn.BorderSizePixel = 0
    btn.Text = ""
    btn.Parent = sidebar

    local bnc = Instance.new("UICorner")
    bnc.CornerRadius = UDim.new(0, 8)
    bnc.Parent = btn

    -- Accent bar on left
    local acc = Instance.new("Frame")
    acc.Size = UDim2.new(0, 3, 0, 24)
    acc.Position = UDim2.new(0, 0, 0.5, -12)
    acc.BackgroundColor3 = C.accent
    acc.BorderSizePixel = 0
    acc.Visible = i == activeTab
    acc.Parent = btn

    -- Icon
    local icon = Instance.new("TextLabel")
    icon.Size = UDim2.new(0, 24, 1, 0)
    icon.Position = UDim2.new(0, 12, 0, 0)
    icon.BackgroundTransparency = 1
    icon.Text = tabIcons[i]
    icon.TextColor3 = i == activeTab and C.accent or C.textDim
    icon.TextSize = 14
    icon.Font = Enum.Font.Gotham
    icon.Parent = btn

    -- Label
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -46, 1, 0)
    lbl.Position = UDim2.new(0, 40, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = name
    lbl.TextColor3 = i == activeTab and C.textActive or C.text
    lbl.TextSize = 13
    lbl.Font = Enum.Font.Gotham
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = btn

    tabBtns[i] = {Btn = btn, Accent = acc, Icon = icon, Label = lbl}
end

-- Content
local content = Instance.new("Frame")
content.Size = UDim2.new(1, -160, 1, -52)
content.Position = UDim2.new(0, 160, 0, 52)
content.BackgroundTransparency = 1
content.Parent = main

-- UI Components
local function Toggle(parent, title, get, set, desc)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, -24, 0, 42)
    row.Position = UDim2.new(0, 12, 0, 0)
    row.BackgroundColor3 = C.element
    row.BorderSizePixel = 0
    row.Parent = parent

    local rc = Instance.new("UICorner")
    rc.CornerRadius = UDim.new(0, 8)
    rc.Parent = row

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -70, 0, 20)
    lbl.Position = UDim2.new(0, 14, 0, 5)
    lbl.BackgroundTransparency = 1
    lbl.Text = title
    lbl.TextColor3 = C.text
    lbl.TextSize = 13
    lbl.Font = Enum.Font.Gotham
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = row

    if desc then
        local dsc = Instance.new("TextLabel")
        dsc.Size = UDim2.new(1, -70, 0, 14)
        dsc.Position = UDim2.new(0, 14, 0, 24)
        dsc.BackgroundTransparency = 1
        dsc.Text = desc
        dsc.TextColor3 = C.textDim
        dsc.TextSize = 10
        dsc.Font = Enum.Font.Gotham
        dsc.TextXAlignment = Enum.TextXAlignment.Left
        dsc.Parent = row
    end

    local tog = Instance.new("Frame")
    tog.Size = UDim2.new(0, 42, 0, 22)
    tog.Position = UDim2.new(1, -54, 0.5, -11)
    tog.BackgroundColor3 = get() and C.green or C.border
    tog.BorderSizePixel = 0
    tog.Parent = row

    local tc = Instance.new("UICorner")
    tc.CornerRadius = UDim.new(0, 11)
    tc.Parent = tog

    local dot = Instance.new("Frame")
    dot.Size = UDim2.new(0, 16, 0, 16)
    dot.Position = UDim2.new(0, get() and 24 or 3, 0, 3)
    dot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    dot.BorderSizePixel = 0
    dot.Parent = tog

    local dotc = Instance.new("UICorner")
    dotc.CornerRadius = UDim.new(0, 8)
    dotc.Parent = dot

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.BackgroundTransparency = 1
    btn.Text = ""
    btn.Parent = row

    btn.MouseButton1Click:Connect(function()
        local v = not get()
        set(v)
        Tween:Create(tog, TweenInfo.new(0.2), {BackgroundColor3 = v and C.green or C.border}):Play()
        Tween:Create(dot, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Position = UDim2.new(0, v and 24 or 3, 0, 3)
        }):Play()
    end)

    row.MouseEnter:Connect(function()
        if not btn:IsDescendantOf(parent) then return end
        Tween:Create(row, TweenInfo.new(0.15), {BackgroundColor3 = C.hover}):Play()
    end)
    row.MouseLeave:Connect(function()
        Tween:Create(row, TweenInfo.new(0.2), {BackgroundColor3 = C.element}):Play()
    end)

    return row
end

local function Slider(parent, title, get, set, min, max, step)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, -24, 0, 50)
    row.Position = UDim2.new(0, 12, 0, 0)
    row.BackgroundColor3 = C.element
    row.BorderSizePixel = 0
    row.Parent = parent

    local rc = Instance.new("UICorner")
    rc.CornerRadius = UDim.new(0, 8)
    rc.Parent = row

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -60, 0, 20)
    lbl.Position = UDim2.new(0, 14, 0, 4)
    lbl.BackgroundTransparency = 1
    lbl.Text = title
    lbl.TextColor3 = C.text
    lbl.TextSize = 13
    lbl.Font = Enum.Font.Gotham
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = row

    local valLbl = Instance.new("TextLabel")
    valLbl.Size = UDim2.new(0, 44, 0, 20)
    valLbl.Position = UDim2.new(1, -56, 0, 4)
    valLbl.BackgroundTransparency = 1
    valLbl.Text = tostring(get())
    valLbl.TextColor3 = C.accent
    valLbl.TextSize = 14
    valLbl.Font = Enum.Font.GothamBold
    valLbl.TextXAlignment = Enum.TextXAlignment.Right
    valLbl.Parent = row

    local bar = Instance.new("Frame")
    bar.Size = UDim2.new(1, -24, 0, 4)
    bar.Position = UDim2.new(0, 12, 0, 34)
    bar.BackgroundColor3 = C.bg
    bar.BorderSizePixel = 0
    bar.Parent = row

    local barc = Instance.new("UICorner")
    barc.CornerRadius = UDim.new(0, 2)
    barc.Parent = bar

    local pct = (get() - min) / (max - min)
    local fill = Instance.new("Frame")
    fill.Size = UDim2.new(pct, 0, 1, 0)
    fill.BackgroundColor3 = C.accent
    fill.BorderSizePixel = 0
    fill.Parent = bar

    local fillc = Instance.new("UICorner")
    fillc.CornerRadius = UDim.new(0, 2)
    fillc.Parent = fill

    local dragging = false
    local function updateSlider(mpos)
        local absX = bar.AbsolutePosition.X
        local absW = bar.AbsoluteSize.X
        if absW <= 0 then return end
        local pct2 = math.clamp((mpos - absX) / absW, 0, 1)
        local v = min + math.floor((pct2 * (max - min)) / step) * step
        v = math.clamp(v, min, max)
        set(v)
        pct = (v - min) / (max - min)
        fill.Size = UDim2.new(pct, 0, 1, 0)
        valLbl.Text = tostring(v)
    end

    row.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            updateSlider(UIS:GetMouseLocation().X)
        end
    end)
    row.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseInput then
            updateSlider(input.Position.X)
        end
    end)

    row.MouseEnter:Connect(function()
        Tween:Create(row, TweenInfo.new(0.15), {BackgroundColor3 = C.hover}):Play()
    end)
    row.MouseLeave:Connect(function()
        Tween:Create(row, TweenInfo.new(0.2), {BackgroundColor3 = C.element}):Play()
    end)

    return row
end

-- Build tab content
local function buildESP()
    local f = Instance.new("ScrollingFrame")
    f.Size = UDim2.new(1, 0, 1, 0)
    f.BackgroundTransparency = 1; f.BorderSizePixel = 0
    f.ScrollBarThickness = 3; f.ScrollBarImageColor3 = C.element
    f.Visible = false; f.CanvasSize = UDim2.new(0, 0, 0, 0)
    f.Parent = content

    local layout = Instance.new("UIListLayout")
    layout.SortOrder = Enum.SortOrder.LayoutOrder; layout.Padding = UDim.new(0, 6)
    layout.Parent = f

    local pad = Instance.new("UIPadding")
    pad.PaddingLeft = UDim.new(0, 12); pad.PaddingRight = UDim.new(0, 12)
    pad.PaddingTop = UDim.new(0, 12); pad.PaddingBottom = UDim.new(0, 12)
    pad.Parent = f

    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        f.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 24)
    end)

    Toggle(f, "ESP Enabled", function() return Cfg.esp.on end, function(v) Cfg.esp.on = v end)
    Toggle(f, "Box", function() return Cfg.esp.box end, function(v) Cfg.esp.box = v end, "2D bounding box around players")
    Toggle(f, "Health", function() return Cfg.esp.health end, function(v) Cfg.esp.health = v end, "Show health values")
    Toggle(f, "Distance", function() return Cfg.esp.dist end, function(v) Cfg.esp.dist = v end, "Show distance in meters")
    Toggle(f, "Tracer Lines", function() return Cfg.esp.lines end, function(v) Cfg.esp.lines = v end, "Lines from screen center")
    Toggle(f, "Team Check", function() return Cfg.esp.team end, function(v) Cfg.esp.team = v end, "Ignore teammates")
    Slider(f, "Max Distance", function() return Cfg.esp.maxDist end, function(v) Cfg.esp.maxDist = v, 100, 5000, 100)
    return f
end

local function buildAIM()
    local f = Instance.new("ScrollingFrame")
    f.Size = UDim2.new(1, 0, 1, 0)
    f.BackgroundTransparency = 1; f.BorderSizePixel = 0
    f.ScrollBarThickness = 3; f.ScrollBarImageColor3 = C.element
    f.Visible = false; f.CanvasSize = UDim2.new(0, 0, 0, 0)
    f.Parent = content

    local layout = Instance.new("UIListLayout")
    layout.SortOrder = Enum.SortOrder.LayoutOrder; layout.Padding = UDim.new(0, 6)
    layout.Parent = f

    local pad = Instance.new("UIPadding")
    pad.PaddingLeft = UDim.new(0, 12); pad.PaddingRight = UDim.new(0, 12)
    pad.PaddingTop = UDim.new(0, 12); pad.PaddingBottom = UDim.new(0, 12)
    pad.Parent = f

    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        f.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 24)
    end)

    Toggle(f, "Aimbot Enabled", function() return Cfg.aim.on end, function(v) Cfg.aim.on = v end)
    Toggle(f, "Show FOV Circle", function() return Cfg.aim.showFov end, function(v) Cfg.aim.showFov = v end, "Visual FOV indicator")
    Slider(f, "FOV Size", function() return Cfg.aim.fov end, function(v) Cfg.aim.fov = v, 10, 500, 5)
    Slider(f, "Smoothness", function() return Cfg.aim.smooth end, function(v) Cfg.aim.smooth = v, 0.1, 2, 0.1)
    return f
end

local function buildPlayer()
    local f = Instance.new("ScrollingFrame")
    f.Size = UDim2.new(1, 0, 1, 0)
    f.BackgroundTransparency = 1; f.BorderSizePixel = 0
    f.ScrollBarThickness = 3; f.ScrollBarImageColor3 = C.element
    f.Visible = false; f.CanvasSize = UDim2.new(0, 0, 0, 0)
    f.Parent = content

    local layout = Instance.new("UIListLayout")
    layout.SortOrder = Enum.SortOrder.LayoutOrder; layout.Padding = UDim.new(0, 6)
    layout.Parent = f

    local pad = Instance.new("UIPadding")
    pad.PaddingLeft = UDim.new(0, 12); pad.PaddingRight = UDim.new(0, 12)
    pad.PaddingTop = UDim.new(0, 12); pad.PaddingBottom = UDim.new(0, 12)
    pad.Parent = f

    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        f.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 24)
    end)

    Slider(f, "WalkSpeed", function() return Cfg.player.ws end, function(v) Cfg.player.ws = v; if LP.Character and LP.Character:FindFirstChild("Humanoid") then LP.Character.Humanoid.WalkSpeed = v end end, 16, 250, 1)
    Slider(f, "JumpPower", function() return Cfg.player.jp end, function(v) Cfg.player.jp = v; if LP.Character and LP.Character:FindFirstChild("Humanoid") then LP.Character.Humanoid.JumpPower = v end end, 50, 350, 5)
    return f
end

local function buildMisc()
    local f = Instance.new("ScrollingFrame")
    f.Size = UDim2.new(1, 0, 1, 0)
    f.BackgroundTransparency = 1; f.BorderSizePixel = 0
    f.ScrollBarThickness = 3; f.ScrollBarImageColor3 = C.element
    f.Visible = false; f.CanvasSize = UDim2.new(0, 0, 0, 0)
    f.Parent = content

    local layout = Instance.new("UIListLayout")
    layout.SortOrder = Enum.SortOrder.LayoutOrder; layout.Padding = UDim.new(0, 6)
    layout.Parent = f

    local pad = Instance.new("UIPadding")
    pad.PaddingLeft = UDim.new(0, 12); pad.PaddingRight = UDim.new(0, 12)
    pad.PaddingTop = UDim.new(0, 12); pad.PaddingBottom = UDim.new(0, 12)
    pad.Parent = f

    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        f.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 24)
    end)

    Toggle(f, "Fullbright", function() return Cfg.misc.fb end, function(v)
        Cfg.misc.fb = v
        local L = game:GetService("Lighting")
        L.Brightness = v and 2 or 1
        L.GlobalShadows = not v
        L.OutdoorAmbient = v and Color3.fromRGB(128,128,128) or Color3.fromRGB(70,70,70)
    end, "Remove darkness, see everything")
    return f
end

tabFrames["ESP"] = buildESP()
tabFrames["AIMBOT"] = buildAIM()
tabFrames["PLAYER"] = buildPlayer()
tabFrames["MISC"] = buildMisc()

-- Tab switching
for i, name in ipairs(tabs) do
    tabBtns[i].Btn.MouseButton1Click:Connect(function()
        if activeTab == i then return end
        for j = 1, #tabs do
            local b = tabBtns[j]
            Tween:Create(b.Btn, TweenInfo.new(0.15), {BackgroundTransparency = 1}):Play()
            b.Label.TextColor3 = C.text; b.Icon.TextColor3 = C.textDim; b.Accent.Visible = false
            tabFrames[tabs[j]].Visible = false
        end
        local b = tabBtns[i]
        b.Btn.BackgroundTransparency = 0
        b.Label.TextColor3 = C.textActive; b.Icon.TextColor3 = C.accent; b.Accent.Visible = true
        tabFrames[name].Visible = true
        activeTab = i
    end)
end

-- Events
closeBtn.MouseButton1Click:Connect(function() main.Visible = false end)

local toggleKey = Enum.KeyCode.RightShift
UIS.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == toggleKey then
        main.Visible = not main.Visible
        if main.Visible then
            main.Size = UDim2.new(0, 0, 0, 0)
            main.Position = UDim2.new(0.5, 0, 0.5, 0)
            Tween:Create(main, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                Size = UDim2.new(0, 760, 0, 480),
                Position = UDim2.new(0.5, -380, 0.5, -240),
            }):Play()
        end
    end
end)

-- Animate in
main.Size = UDim2.new(0, 0, 0, 0)
main.Position = UDim2.new(0.5, 0, 0.5, 0)
main.Visible = true
Tween:Create(main, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
    Size = UDim2.new(0, 760, 0, 480),
    Position = UDim2.new(0.5, -380, 0.5, -240),
}):Play()

-- ESP
local espD = {}
RS.RenderStepped:Connect(function()
    if not Cfg.esp.on then
        for _, d in pairs(espD) do
            for _, v in pairs(d) do
                if type(v) == "table" then for _, dd in pairs(v) do dd.Visible = false end
                else v.Visible = false end
            end
        end
        return
    end
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LP then
            if not espD[p] then
                local d = {}
                d.box = {}
                for i = 1, 4 do d.box[i] = Drawing.new("Line"); d.box[i].Visible = false end
                d.name = Drawing.new("Text"); d.name.Outline = true; d.name.Center = true; d.name.Visible = false
                d.health = Drawing.new("Text"); d.health.Outline = true; d.health.Center = true; d.health.Visible = false
                d.dist = Drawing.new("Text"); d.dist.Outline = true; d.dist.Center = true; d.dist.Visible = false
                d.line = Drawing.new("Line"); d.line.Visible = false
                espD[p] = d
            end
            local d = espD[p]
            local char, hrp, head, hum = p.Character, nil, nil, nil
            if char then hrp = char:FindFirstChild("HumanoidRootPart"); head = char:FindFirstChild("Head"); hum = char:FindFirstChild("Humanoid") end
            local show = hrp and head and hum and hum.Health > 0
            if show and Cfg.esp.team and p.Team and LP.Team and p.Team == LP.Team then show = false end
            if show then
                local myHRP = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
                if myHRP and (hrp.Position - myHRP.Position).Magnitude > Cfg.esp.maxDist then show = false end
            end
            if show then
                local sp2, on = Camera:WorldToViewportPoint(hrp.Position)
                local vsp2 = Vector2.new(sp2.X, sp2.Y)
                if on then
                    if Cfg.esp.box then
                        local size = char:GetExtentsSize()
                        local cf = hrp.CFrame; local hw, hh = size.X/2, size.Y/2
                        local c1 = Camera:WorldToViewportPoint((cf*CFrame.new(-hw,hh,0)).p)
                        local c2 = Camera:WorldToViewportPoint((cf*CFrame.new(hw,hh,0)).p)
                        local c3 = Camera:WorldToViewportPoint((cf*CFrame.new(hw,-hh,0)).p)
                        local c4 = Camera:WorldToViewportPoint((cf*CFrame.new(-hw,-hh,0)).p)
                        if c1.Z>0 and c2.Z>0 and c3.Z>0 and c4.Z>0 then
                            local mnX,mnY,mxX,mxY = math.min(c1.X,c2.X,c3.X,c4.X), math.min(c1.Y,c2.Y,c3.Y,c4.Y), math.max(c1.X,c2.X,c3.X,c4.X), math.max(c1.Y,c2.Y,c3.Y,c4.Y)
                            d.box[1].From=Vector2.new(mnX,mnY); d.box[1].To=Vector2.new(mxX,mnY)
                            d.box[2].From=Vector2.new(mxX,mnY); d.box[2].To=Vector2.new(mxX,mxY)
                            d.box[3].From=Vector2.new(mxX,mxY); d.box[3].To=Vector2.new(mnX,mxY)
                            d.box[4].From=Vector2.new(mnX,mxY); d.box[4].To=Vector2.new(mnX,mnY)
                            for i=1,4 do d.box[i].Visible=true; d.box[i].Thickness=2; d.box[i].Color=Color3.fromRGB(0,255,136) end
                        else for i=1,4 do d.box[i].Visible=false end end
                    else for i=1,4 do d.box[i].Visible=false end end
                    d.name.Position=vsp2-Vector2.new(0,45); d.name.Text=p.Name; d.name.Visible=true
                    d.health.Position=vsp2-Vector2.new(0,28); d.health.Text="HP: "..math.floor(hum.Health)
                    d.health.Color=hum.Health>50 and C.green or (hum.Health>25 and C.gold or C.red); d.health.Visible=Cfg.esp.health
                    if Cfg.esp.dist then
                        local dd = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") and (hrp.Position-LP.Character.HumanoidRootPart.Position).Magnitude or 0
                        d.dist.Position=vsp2-Vector2.new(0,13); d.dist.Text=string.format("%.0fm",dd); d.dist.Visible=true
                    else d.dist.Visible=false end
                    if Cfg.esp.lines then
                        d.line.From=Vector2.new(Camera.ViewportSize.X/2,Camera.ViewportSize.Y); d.line.To=vsp2; d.line.Visible=true; d.line.Color=C.accent
                    else d.line.Visible=false end
                end
            else
                d.name.Visible=false; d.health.Visible=false; d.dist.Visible=false; d.line.Visible=false
                for i=1,4 do d.box[i].Visible=false end
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
            if p~=LP and p.Character and p.Character:FindFirstChild(Cfg.aim.part) then
                local part = p.Character[Cfg.aim.part]
                local sp, on = Camera:WorldToViewportPoint(part.Position)
                if on then
                    local dd = (Vector2.new(sp.X, sp.Y)-mp).Magnitude
                    if dd<bd then bd=dd; best=p end
                end
            end
        end
        if best and best.Character and best.Character:FindFirstChild(Cfg.aim.part) then
            Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, best.Character[Cfg.aim.part].Position), Cfg.aim.smooth)
        end
    end
end)
