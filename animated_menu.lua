--[[
  Animated GUI Menu - Ultra Safe (Xeno compatible)
  loadstring(game:HttpGet("https://raw.githubusercontent.com/ghosttttttt3232/Roblox-AnimatedMenu/master/animated_menu.lua"))()
--]]

local success, result = pcall(function()

task.wait(5)

local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- Safety check
if not Drawing or not Drawing.new then
    return warn("Drawing API not supported")
end

local open = false
local hovered = nil
local mouseDown = false
local options = {"Gioca", "Impostazioni", "Inventario", "Negozio", "Esci"}

-- Create drawings
local title = Drawing.new("Text")
title.Text = "MENU PRINCIPALE"
title.Color = Color3.fromRGB(212, 135, 106)
title.Size = 20
title.Center = true
title.Outline = true
title.Visible = false

local optionTexts = {}
local optionLines = {}
local optionHighlights = {}

for i, opt in ipairs(options) do
    local txt = Drawing.new("Text")
    txt.Text = opt
    txt.Color = Color3.fromRGB(155, 155, 165)
    txt.Size = 16
    txt.Center = true
    txt.Outline = true
    txt.Visible = false
    optionTexts[i] = txt

    local line = Drawing.new("Line")
    line.From = Vector2.new(0, 0)
    line.To = Vector2.new(0, 0)
    line.Thickness = 4
    line.Color = Color3.fromRGB(212, 135, 106)
    line.Visible = false
    optionLines[i] = line

    local hl = Drawing.new("Line")
    hl.From = Vector2.new(0, 0)
    hl.To = Vector2.new(0, 0)
    hl.Thickness = 50
    hl.Transparency = 0.8
    hl.Color = Color3.fromRGB(212, 135, 106)
    hl.Visible = false
    optionHighlights[i] = hl
end

local bgLines = {}
for i = 1, 4 do
    local l = Drawing.new("Line")
    l.Thickness = 1
    l.Color = Color3.fromRGB(28, 28, 36)
    l.Visible = false
    bgLines[i] = l
end

function show()
    if open then return end
    open = true
    menuX = UIS:GetMouseLocation().X - 150
    menuY = UIS:GetMouseLocation().Y - 120

    title.Visible = true
    for i = 1, #options do
        optionTexts[i].Visible = true
        optionLines[i].Visible = true
    end
    for i = 1, 4 do
        bgLines[i].Visible = true
    end
end

function hide()
    if not open then return end
    open = false

    title.Visible = false
    for i = 1, #options do
        optionTexts[i].Visible = false
        optionLines[i].Visible = false
        optionHighlights[i].Visible = false
    end
    for i = 1, 4 do
        bgLines[i].Visible = false
    end
end

function getOptionAt(mx, my)
    local sx, sy = menuX, menuY
    local w, h = 300, 50 + #options * 48 + 10

    if mx < sx or mx > sx + w or my < sy or my > sy + h then
        return nil
    end

    for i = 1, #options do
        local by = sy + 50 + (i - 1) * 48 + 10
        if my >= by and my <= by + 36 then
            return i
        end
    end
    return nil
end

local menuX, menuY = 200, 200

-- Render loop
RunService.RenderStepped:Connect(function()
    local mx = UIS:GetMouseLocation().X
    local my = UIS:GetMouseLocation().Y
    local cx = menuX
    local cy = menuY

    if open then
        local w, h = 300, 50 + #options * 48 + 10

        -- Border box
        bgLines[1].From = Vector2.new(cx, cy)
        bgLines[1].To = Vector2.new(cx + w, cy)
        bgLines[2].From = Vector2.new(cx + w, cy)
        bgLines[2].To = Vector2.new(cx + w, cy + h)
        bgLines[3].From = Vector2.new(cx + w, cy + h)
        bgLines[3].To = Vector2.new(cx, cy + h)
        bgLines[4].From = Vector2.new(cx, cy + h)
        bgLines[4].To = Vector2.new(cx, cy)

        title.Position = Vector2.new(cx + w / 2, cy + 18)

        for i = 1, #options do
            local by = cy + 50 + (i - 1) * 48 + 10
            optionTexts[i].Position = Vector2.new(cx + w / 2, by + 12)

            optionLines[i].From = Vector2.new(cx + 10, by)
            optionLines[i].To = Vector2.new(cx + 10, by + 36)

            optionHighlights[i].From = Vector2.new(cx + 10, by + 18)
            optionHighlights[i].To = Vector2.new(cx + w - 10, by + 18)
        end

        -- Hover
        local prev = hovered
        hovered = getOptionAt(mx, my)
        if hovered and hovered ~= prev then
            for i = 1, #options do
                if i == hovered then
                    optionTexts[i].Color = Color3.fromRGB(235, 235, 240)
                    optionLines[i].Color = Color3.fromRGB(212, 135, 106)
                    optionHighlights[i].Visible = true
                else
                    optionTexts[i].Color = Color3.fromRGB(155, 155, 165)
                    optionLines[i].Color = Color3.fromRGB(60, 60, 70)
                    optionHighlights[i].Visible = false
                end
            end
        end

        -- Click
        if mouseDown and hovered then
            mouseDown = false
            if options[hovered] == "Esci" then
                hide()
            end
        end
    end
end)

UIS.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        mouseDown = true
    end
    if input.KeyCode == Enum.KeyCode.RightShift then
        if open then hide() else show() end
    end
end)

UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        mouseDown = false
    end
end)

show()

end)

if not success then
    warn("Menu error: " .. tostring(result))
end
