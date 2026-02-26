local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

local gui = Instance.new("ScreenGui")
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

--========================
-- BUY FRAME
--========================
local buyFrame = Instance.new("Frame")
buyFrame.Size = UDim2.fromOffset(420,250)
buyFrame.Position = UDim2.new(0.5,-210,1,300)
buyFrame.BackgroundColor3 = Color3.fromRGB(46,46,46)
buyFrame.BorderSizePixel = 0
buyFrame.Parent = gui
Instance.new("UICorner", buyFrame).CornerRadius = UDim.new(0,12)

-- Slide up animation
TweenService:Create(
	buyFrame,
	TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
	{Position = UDim2.new(0.5,-210,0.5,-125)}
):Play()

-- Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,-60,0,40)
title.Position = UDim2.new(0,20,0,12)
title.BackgroundTransparency = 1
title.Text = "Buy item"
title.Font = Enum.Font.Gotham
title.TextSize = 18
title.TextColor3 = Color3.new(1,1,1)
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = buyFrame

-- Close button (real X icon)
local close = Instance.new("ImageButton")
close.Size = UDim2.fromOffset(24,24)
close.Position = UDim2.new(1,-40,0,18)
close.BackgroundTransparency = 1
close.Image = "rbxassetid://6031094678"
close.Parent = buyFrame

close.MouseButton1Click:Connect(function()
	gui:Destroy()
end)

-- Item Image (FIXED TEXTURE ID)
local image = Instance.new("ImageLabel")
image.Size = UDim2.fromOffset(70,70)
image.Position = UDim2.new(0,20,0,65)
image.BackgroundTransparency = 1
image.Image = "rbxassetid://136656557035530"
image.ScaleType = Enum.ScaleType.Fit
image.Parent = buyFrame

-- Item Name
local name = Instance.new("TextLabel")
name.Size = UDim2.new(1,-120,0,30)
name.Position = UDim2.new(0,110,0,70)
name.BackgroundTransparency = 1
name.Text = "[GIFT] ADMIN PANEL"
name.Font = Enum.Font.Gotham
name.TextSize = 16
name.TextColor3 = Color3.new(1,1,1)
name.TextXAlignment = Enum.TextXAlignment.Left
name.Parent = buyFrame

-- Price
local price = Instance.new("TextLabel")
price.Size = UDim2.new(1,-120,0,25)
price.Position = UDim2.new(0,110,0,100)
price.BackgroundTransparency = 1
price.Text = "\u{E002} 7,499"
price.Font = Enum.Font.Gotham
price.TextSize = 15
price.TextColor3 = Color3.fromRGB(200,200,200)
price.TextXAlignment = Enum.TextXAlignment.Left
price.Parent = buyFrame

--========================
-- BUY BUTTON
--========================
local buyButton = Instance.new("Frame")
buyButton.Size = UDim2.new(1,-40,0,48)
buyButton.Position = UDim2.new(0,20,1,-65)
buyButton.BackgroundColor3 = Color3.fromRGB(35,60,180) -- dark blue
buyButton.Parent = buyFrame
Instance.new("UICorner", buyButton).CornerRadius = UDim.new(0,8)

-- Light blue sweep overlay
local sweep = Instance.new("Frame")
sweep.Size = UDim2.new(0,0,1,0)
sweep.BackgroundColor3 = Color3.fromRGB(88,101,242)
sweep.BorderSizePixel = 0
sweep.Parent = buyButton
Instance.new("UICorner", sweep).CornerRadius = UDim.new(0,8)

local buyText = Instance.new("TextButton")
buyText.Size = UDim2.fromScale(1,1)
buyText.BackgroundTransparency = 1
buyText.Text = "Buy"
buyText.Font = Enum.Font.GothamBold
buyText.TextSize = 18
buyText.TextColor3 = Color3.new(1,1,1)
buyText.Parent = buyButton

--========================
-- SUCCESS FRAME
--========================
local successFrame = Instance.new("Frame")
successFrame.Size = UDim2.fromOffset(420,260)
successFrame.Position = UDim2.new(0.5,-210,0.5,-130)
successFrame.BackgroundColor3 = Color3.fromRGB(46,46,46)
successFrame.BorderSizePixel = 0
successFrame.Visible = false
successFrame.Parent = gui
Instance.new("UICorner", successFrame).CornerRadius = UDim.new(0,12)

local sTitle = Instance.new("TextLabel")
sTitle.Size = UDim2.new(1,-20,0,40)
sTitle.Position = UDim2.new(0,20,0,12)
sTitle.BackgroundTransparency = 1
sTitle.Text = "Purchase completed"
sTitle.Font = Enum.Font.Gotham
sTitle.TextSize = 18
sTitle.TextColor3 = Color3.new(1,1,1)
sTitle.TextXAlignment = Enum.TextXAlignment.Left
sTitle.Parent = successFrame

local checkCircle = Instance.new("Frame")
checkCircle.Size = UDim2.fromOffset(60,60)
checkCircle.Position = UDim2.new(0.5,-30,0,70)
checkCircle.BackgroundColor3 = Color3.fromRGB(60,180,75)
checkCircle.Parent = successFrame
Instance.new("UICorner", checkCircle).CornerRadius = UDim.new(1,0)

local check = Instance.new("TextLabel")
check.Size = UDim2.fromScale(1,1)
check.BackgroundTransparency = 1
check.Text = "✓"
check.Font = Enum.Font.GothamBold
check.TextSize = 36
check.TextColor3 = Color3.new(1,1,1)
check.Parent = checkCircle

local successText = Instance.new("TextLabel")
successText.Size = UDim2.new(1,-40,0,60)
successText.Position = UDim2.new(0,20,0,150)
successText.BackgroundTransparency = 1
successText.TextWrapped = true
successText.Text = "You have successfully gifted [GIFT] ADMIN PANEL."
successText.Font = Enum.Font.Gotham
successText.TextSize = 15
successText.TextColor3 = Color3.fromRGB(200,200,200)
successText.TextXAlignment = Enum.TextXAlignment.Center
successText.Parent = successFrame

local okButton = Instance.new("TextButton")
okButton.Size = UDim2.new(1,-40,0,48)
okButton.Position = UDim2.new(0,20,1,-65)
okButton.BackgroundColor3 = Color3.fromRGB(88,101,242)
okButton.Text = "OK"
okButton.Font = Enum.Font.GothamBold
okButton.TextSize = 18
okButton.TextColor3 = Color3.new(1,1,1)
okButton.Parent = successFrame
Instance.new("UICorner", okButton).CornerRadius = UDim.new(0,8)

--========================
-- BUTTON LOGIC
--========================
buyText.MouseButton1Click:Connect(function()
	buyText.Active = false
	
	-- 3 second sweep animation
	TweenService:Create(
		sweep,
		TweenInfo.new(3, Enum.EasingStyle.Linear),
		{Size = UDim2.new(1,0,1,0)}
	):Play()
	
	task.wait(3)
	
	buyFrame.Visible = false
	successFrame.Visible = true
end)

okButton.MouseButton1Click:Connect(function()
	gui:Destroy()
end)
