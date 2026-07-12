--[[
  Animated GUI Menu - Drawing Edition (works on ALL executors)
  loadstring(game:HttpGet("https://raw.githubusercontent.com/ghosttttttt3232/Roblox-AnimatedMenu/master/animated_menu.lua"))()
--]]

task.wait(3)

local UserInputService = game:GetService("UserInputService")
local mouse = UserInputService:GetMouseLocation()
local mouseDown = false
local open = false
local animProgress = 0
local animDirection = 0
local hoveredIndex = nil

local menu = {
    Title = "Menu Principale",
    Options = {"Gioca", "Impostazioni", "Inventario", "Negozio", "Esci"},
    X = 0, Y = 0, W = 400, H = 500,
    elements = {},
    bgAlpha = 0,
    titleAlpha = 0,
    optionsAlpha = {},
    optionGlow = {},
}

local Player = game:GetService("Players").LocalPlayer
local characterAdded = Player.CharacterAdded:Connect(function() end)

-- Drawing objects
function menu:Create()
    self.bg = Drawing.new("Square")
    self.bg.Visible = false
    self.bg.Thickness = 0
    self.bg.Color = Color3.fromRGB(18, 18, 24)

    self.border = Drawing.new("Square")
    self.border.Visible = false
    self.border.Thickness = 2
    self.border.Color = Color3.fromRGB(28, 28, 36)
    self.border.Filled = false

    self.titleBg = Drawing.new("Square")
    self.titleBg.Visible = false
    self.titleBg.Thickness = 0
    self.titleBg.Color = Color3.fromRGB(14, 14, 18)

    self.titleText = Drawing.new("Text")
    self.titleText.Visible = false
    self.titleText.Text = self.Title
    self.titleText.Color = Color3.fromRGB(212, 135, 106)
    self.titleText.Size = 22
    self.titleText.Center = false
    self.titleText.Outline = true

    self.underline = Drawing.new("Line")
    self.underline.Visible = false
    self.underline.Thickness = 2
    self.underline.Color = Color3.fromRGB(212, 135, 106)

    self.options = {}
    self.glowLines = {}
    self.highlights = {}
    self.highlights2 = {}
    self.texts = {}

    for i, opt in ipairs(self.Options) do
        local bg = Drawing.new("Square")
        bg.Visible = false
        bg.Thickness = 0
        bg.Color = Color3.fromRGB(20, 20, 26)
        table.insert(self.options, bg)

        local hl = Drawing.new("Square")
        hl.Visible = false
        hl.Thickness = 0
        hl.Color = Color3.fromRGB(30, 30, 40)
        hl.Filled = true
        table.insert(self.highlights, hl)

        local hl2 = Drawing.new("Square")
        hl2.Visible = false
        hl2.Thickness = 0
        hl2.Color = Color3.fromRGB(212, 135, 106)
        hl2.Filled = true
        table.insert(self.highlights2, hl2)

        local glow = Drawing.new("Line")
        glow.Visible = false
        glow.Thickness = 4
        glow.Color = Color3.fromRGB(212, 135, 106)
        table.insert(self.glowLines, glow)

        local txt = Drawing.new("Text")
        txt.Visible = false
        txt.Text = opt
        txt.Color = Color3.fromRGB(155, 155, 165)
        txt.Size = 16
        txt.Center = true
        txt.Outline = true
        table.insert(self.texts, txt)
    end

    self:UpdatePositions()
end

function menu:UpdatePositions()
    local cx = self.X
    local cy = self.Y
    local w = self.W
    local h = self.H

    self.bg.Position = Vector2.new(cx, cy)
    self.bg.Size = Vector2.new(w, h)

    self.border.Position = Vector2.new(cx, cy)
    self.border.Size = Vector2.new(w, h)

    self.titleBg.Position = Vector2.new(cx, cy)
    self.titleBg.Size = Vector2.new(w, 48)

    self.titleText.Position = Vector2.new(cx + 16, cy + 12)

    self.underline.From = Vector2.new(cx + 0, cy + 48)
    self.underline.To = Vector2.new(cx + w, cy + 48)

    for i, opt in ipairs(self.Options) do
        local by = cy + 56 + (i - 1) * 58
        local bh = 50

        if i == #self.Options then
            bh = 50
        end

        self.options[i].Position = Vector2.new(cx + 10, by)
        self.options[i].Size = Vector2.new(w - 20, bh)

        self.highlights[i].Position = Vector2.new(cx + 10, by)
        self.highlights[i].Size = Vector2.new(w - 20, bh)

        self.highlights2[i].Position = Vector2.new(cx + 10, by)
        self.highlights2[i].Size = Vector2.new(w - 20, bh)

        self.glowLines[i].From = Vector2.new(cx + 10, by + 0)
        self.glowLines[i].To = Vector2.new(cx + 10, by + bh)
        self.glowLines[i].Color = Color3.fromRGB(212, 135, 106)

        self.texts[i].Position = Vector2.new(cx + w / 2, by + bh / 2 - 6)
    end
end

function menu:GetOptionAt(mx, my)
    local cx = self.X
    local cy = self.Y
    local w = self.W
    local h = self.H

    if mx < cx or mx > cx + w or my < cy or my > cy + h then
        return nil
    end

    for i, opt in ipairs(self.Options) do
        local by = cy + 56 + (i - 1) * 58
        local bh = 50

        if my >= by and my <= by + bh then
            return i
        end
    end
    return nil
end

function menu:Show()
    if open then return end
    open = true
    animDirection = 1
    animProgress = 0

    local cx = UserInputService:GetMouseLocation().X
    local cy = UserInputService:GetMouseLocation().Y
    self.X = cx - 50
    self.Y = cy - 50
    self:UpdatePositions()

    self.bg.Visible = true
    self.border.Visible = true
    self.titleBg.Visible = true
    self.titleText.Visible = true
    self.underline.Visible = true

    for i = 1, #self.Options do
        self.options[i].Visible = true
        self.texts[i].Visible = true
        self.glowLines[i].Visible = true
        self.optionsAlpha[i] = 0
    end
end

function menu:Hide()
    if not open then return end
    open = false
    animDirection = -1

    self.bg.Visible = false
    self.border.Visible = false
    self.titleBg.Visible = false
    self.titleText.Visible = false
    self.underline.Visible = false

    for i = 1, #self.Options do
        self.options[i].Visible = false
        self.highlights[i].Visible = false
        self.highlights2[i].Visible = false
        self.glowLines[i].Visible = false
        self.texts[i].Visible = false
    end
end

-- Main render loop
local animTime = 0
game:GetService("RunService").RenderStepped:Connect(function(dt)
    mouse = UserInputService:GetMouseLocation()
    animTime = animTime + dt

    if open then
        animProgress = math.min(animProgress + dt * 2.5, 1)
        local ease = 1 - (1 - animProgress) * (1 - animProgress)

        local targetW = 360
        local targetH = 50 + #menu.Options * 58
        local currentW = targetW * ease
        local currentH = targetH * ease

        menu.bg.Size = Vector2.new(currentW, currentH)
        menu.bg.Transparency = 1 - ease

        menu.border.Size = Vector2.new(currentW, currentH)
        menu.border.Transparency = 1 - ease

        menu.titleBg.Size = Vector2.new(currentW, 48)
        menu.titleBg.Transparency = 1 - ease

        menu.titleText.Transparency = math.max(0, 1 - ease * 2)

        menu.underline.From = Vector2.new(menu.X, menu.Y + 48)
        menu.underline.To = Vector2.new(menu.X + currentW, menu.Y + 48)
        menu.underline.Transparency = math.min(0.8, 0.8 - ease)

        -- Options fade in sequentially
        for i = 1, #menu.Options do
            menu.optionsAlpha[i] = math.min(menu.optionsAlpha[i] + dt * 4, 1)
            local oEase = menu.optionsAlpha[i]
            local by = menu.Y + 56 + (i - 1) * 58

            menu.options[i].Position = Vector2.new(menu.X + 10, by)
            menu.options[i].Size = Vector2.new(currentW - 20, 50)
            menu.options[i].Transparency = math.max(0, 0.6 - oEase * 0.6)
            menu.options[i].Color = Color3.fromRGB(20, 20, 26)

            menu.texts[i].Position = Vector2.new(menu.X + currentW / 2, by + 19)
            menu.texts[i].Transparency = math.max(0, 1 - oEase)
            menu.texts[i].Color = Color3.fromRGB(155, 155, 165)

            menu.glowLines[i].From = Vector2.new(menu.X + 10, by)
            menu.glowLines[i].To = Vector2.new(menu.X + 10, by + 50)
            menu.glowLines[i].Transparency = 1 - oEase
            menu.glowLines[i].Transparency = 1 - oEase * 0.3
        end
    end

    -- Hover detection
    local prevHovered = hoveredIndex
    hoveredIndex = menu:GetOptionAt(mouse.X, mouse.Y)

    if hoveredIndex and open then
        if hoveredIndex ~= prevHovered then
            for i = 1, #menu.Options do
                if i == hoveredIndex then
                    menu.highlights[i].Visible = true
                    menu.highlights[i].Transparency = 0.5
                    menu.texts[i].Color = Color3.fromRGB(235, 235, 240)
                    menu.glowLines[i].Transparency = 0.2
                else
                    menu.highlights[i].Visible = false
                    menu.texts[i].Color = Color3.fromRGB(155, 155, 165)
                    menu.glowLines[i].Transparency = 0.7
                end
            end
        end
    end

    if mouseDown and hoveredIndex and open then
        mouseDown = false
        local selected = menu.Options[hoveredIndex]
        if selected == "Esci" then
            menu:Hide()
        end
    end
end)

UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        mouseDown = true
    end
    if input.KeyCode == Enum.KeyCode.RightShift then
        if open then menu:Hide() else menu:Show() end
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        mouseDown = false
    end
end)

menu:Create()
menu:Show()
