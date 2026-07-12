--[[
  Animated GUI Menu - Roblox Executor
  loadstring(game:HttpGet("https://raw.githubusercontent.com/ghosttttttt3232/Roblox-AnimatedMenu/master/animated_menu.lua"))()
--]]

task.wait(3)

local AnimatedMenu = {}
AnimatedMenu.__index = AnimatedMenu

function AnimatedMenu.new(title, options)
    local self = setmetatable({}, AnimatedMenu)
    self.Title = title or "Menu"
    self.Options = options or {"Opzione 1", "Opzione 2", "Opzione 3"}
    self.ScreenGui = nil
    self.Frame = nil
    self.Open = false
    return self
end

function AnimatedMenu:Create()
    self.ScreenGui = Instance.new("ScreenGui")
    self.ScreenGui.Name = "AnimatedMenu"
    self.ScreenGui.ResetOnSpawn = false
    self.ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    self.ScreenGui.DisplayOrder = 999
    self.ScreenGui.IgnoreGuiInset = true

    if gethui then
        self.ScreenGui.Parent = gethui()
    elseif syn and syn.protect_gui then
        syn.protect_gui(self.ScreenGui)
        self.ScreenGui.Parent = game.CoreGui
    else
        self.ScreenGui.Parent = game.CoreGui
    end

    local frame = Instance.new("Frame")
    frame.Name = "MainFrame"
    frame.Size = UDim2.new(0, 400, 0, 500)
    frame.Position = UDim2.new(0.5, -200, 0.5, -250)
    frame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    frame.BorderSizePixel = 0
    frame.BackgroundTransparency = 1
    frame.ClipsDescendants = true
    frame.Visible = false
    frame.Active = true
    frame.Draggable = true
    frame.Parent = self.ScreenGui

    local shadow = Instance.new("ImageLabel")
    shadow.Name = "Shadow"
    shadow.Size = UDim2.new(1, 20, 1, 20)
    shadow.Position = UDim2.new(0, -10, 0, -10)
    shadow.BackgroundTransparency = 1
    shadow.Image = "rbxassetid://16648505878"
    shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    shadow.ImageTransparency = 0.6
    shadow.ScaleType = Enum.ScaleType.Slice
    shadow.SliceCenter = Rect.new(20, 20, 180, 180)
    shadow.Parent = frame

    local titleBar = Instance.new("Frame")
    titleBar.Name = "TitleBar"
    titleBar.Size = UDim2.new(1, 0, 0, 50)
    titleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
    titleBar.BorderSizePixel = 0
    titleBar.Parent = frame

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "TitleLabel"
    titleLabel.Size = UDim2.new(1, -20, 1, 0)
    titleLabel.Position = UDim2.new(0, 20, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = self.Title
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.TextSize = 22
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = titleBar

    local underline = Instance.new("Frame")
    underline.Name = "Underline"
    underline.Size = UDim2.new(1, 0, 0, 2)
    underline.Position = UDim2.new(0, 0, 1, 0)
    underline.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
    underline.BorderSizePixel = 0
    underline.Parent = titleBar

    local container = Instance.new("ScrollingFrame")
    container.Name = "OptionsContainer"
    container.Size = UDim2.new(1, -40, 1, -70)
    container.Position = UDim2.new(0, 20, 0, 60)
    container.BackgroundTransparency = 1
    container.BorderSizePixel = 0
    container.ScrollBarThickness = 4
    container.ScrollBarImageColor3 = Color3.fromRGB(0, 170, 255)
    container.CanvasSize = UDim2.new(0, 0, 0, #self.Options * 60 + 20)
    container.Parent = frame

    for i, opt in ipairs(self.Options) do
        local btn = Instance.new("TextButton")
        btn.Name = "Option_" .. i
        btn.Size = UDim2.new(1, 0, 0, 50)
        btn.Position = UDim2.new(0, 0, 0, (i - 1) * 60)
        btn.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
        btn.BackgroundTransparency = 0.2
        btn.BorderSizePixel = 0
        btn.Text = opt
        btn.TextColor3 = Color3.fromRGB(200, 200, 220)
        btn.TextSize = 18
        btn.Font = Enum.Font.Gotham
        btn.AutoButtonColor = false
        btn.Parent = container

        local glow = Instance.new("Frame")
        glow.Name = "Glow"
        glow.Size = UDim2.new(0, 4, 1, 0)
        glow.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
        glow.BorderSizePixel = 0
        glow.BackgroundTransparency = 1
        glow.Parent = btn

        btn.MouseEnter:Connect(function()
            game:TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(45, 45, 65)}):Play()
            game:TweenService:Create(glow, TweenInfo.new(0.2), {BackgroundTransparency = 0}):Play()
        end)
        btn.MouseLeave:Connect(function()
            game:TweenService:Create(btn, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(35, 35, 50)}):Play()
            game:TweenService:Create(glow, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
        end)

        btn.MouseButton1Click:Connect(function()
            local ripple = Instance.new("Frame")
            ripple.Size = UDim2.new(0, 0, 0, 0)
            ripple.Position = UDim2.new(0.5, 0, 0.5, 0)
            ripple.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            ripple.BackgroundTransparency = 0.7
            ripple.BorderSizePixel = 0
            ripple.Parent = btn

            game:TweenService:Create(ripple, TweenInfo.new(0.5), {
                Size = UDim2.new(2, 0, 2, 0),
                BackgroundTransparency = 1
            }):Play()
            task.delay(0.5, function() ripple:Destroy() end)

            if self.OnOptionSelected then
                self.OnOptionSelected(opt, i)
            end
        end)
    end

    self.Frame = frame
end

function AnimatedMenu:Show()
    if self.Open then return end
    self.Open = true
    self.Frame.Visible = true
    self.Frame.Size = UDim2.new(0, 0, 0, 0)
    self.Frame.Position = UDim2.new(0.5, 0, 0.5, 0)
    self.Frame.BackgroundTransparency = 1

    game:TweenService:Create(self.Frame, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 400, 0, 500),
        Position = UDim2.new(0.5, -200, 0.5, -250),
        BackgroundTransparency = 0
    }):Play()

    local titleBar = self.Frame:FindFirstChild("TitleBar")
    if titleBar then
        local titleLabel = titleBar:FindFirstChild("TitleLabel")
        if titleLabel then
            titleLabel.TextTransparency = 1
            game:TweenService:Create(titleLabel, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                TextTransparency = 0
            }):Play()
        end
    end
end

function AnimatedMenu:Hide()
    if not self.Open then return end
    self.Open = false

    game:TweenService:Create(self.Frame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
        Size = UDim2.new(0, 0, 0, 0),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        BackgroundTransparency = 1
    }):Play()

    task.delay(0.4, function()
        self.Frame.Visible = false
    end)
end

function AnimatedMenu:Toggle()
    if self.Open then self:Hide() else self:Show() end
end

function AnimatedMenu:Destroy()
    if self.ScreenGui then self.ScreenGui:Destroy() end
    self.Open = false
end

local menu = AnimatedMenu.new("Menu Principale", {
    "Gioca",
    "Impostazioni",
    "Inventario",
    "Negozio",
    "Esci"
})

menu.OnOptionSelected = function(option, index)
    if option == "Esci" then menu:Hide() end
end

menu:Create()
menu:Show()

local UserInputService = game:GetService("UserInputService")
UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.RightShift then
        menu:Toggle()
    end
end)

return AnimatedMenu
