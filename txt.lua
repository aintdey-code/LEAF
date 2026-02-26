local Players = game:GetService("Players")
local player = Players.LocalPlayer

local gui = Instance.new("ScreenGui")
gui.Name = "RobloxPurchaseClone"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

--========================
-- BUY ITEM FRAME
--========================
local buyFrame = Instance.new("Frame")
buyFrame.Size = UDim2.fromOffset(420,230)
buyFrame.Position = UDim2.fromScale(0.5,0.5)
buyFrame.AnchorPoint = Vector2.new(0.5,0.5)
buyFrame.BackgroundColor3 = Color3.fromRGB(46,46,46)
buyFrame.BorderSizePixel = 0
buyFrame.Parent = gui
Instance.new("UICorner", buyFrame).CornerRadius = UDim.new(0,12)

-- Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,-20,0,40)
title.Position = UDim2.new(0,20,0,12)
title.BackgroundTransparency = 1
title.Text = "Buy item"
title.Font = Enum.Font.Gotham
title.TextSize = 18
title.TextColor3 = Color3.fromRGB(255,255,255)
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = buyFrame

-- Close X
local close = Instance.new("TextButton")
close.Size = UDim2.fromOffset(30,30)
close.Position = UDim2.new(1,-40,0,10)
close.BackgroundTransparency = 1
close.Text = "✕"
close.Font = Enum.Font.GothamBold
close.TextSize = 18
close.TextColor3 = Color3.fromRGB(200,200,200)
close.Parent = buyFrame

-- Balance Top Right
local balance = Instance.new("TextLabel")
balance.Size = UDim2.fromOffset(120,30)
balance.Position = UDim2.new(1,-150,0,12)
balance.BackgroundTransparency = 1
balance.Text = "\u{E002} 66,245"
balance.Font = Enum.Font.Gotham
balance.TextSize = 15
balance.TextColor3 = Color3.fromRGB(200,200,200)
balance.TextXAlignment = Enum.TextXAlignment.Right
balance.Parent = buyFrame

-- Item Image
local image = Instance.new("ImageLabel")
image.Size = UDim2.fromOffset(70,70)
image.Position = UDim2.new(0,20,0,60)
image.BackgroundTransparency = 1
image.Image = "rbxassetid://76531501501891"
image.ScaleType = Enum.ScaleType.Fit
image.Parent = buyFrame

-- Item Name
local itemName = Instance.new("TextLabel")
itemName.Size = UDim2.new(1,-120,0,25)
itemName.Position = UDim2.new(0,110,0,65)
itemName.BackgroundTransparency = 1
itemName.Text = "[GIFT] ADMIN PANEL"
itemName.Font = Enum.Font.Gotham
itemName.TextSize = 16
itemName.TextColor3 = Color3.fromRGB(255,255,255)
itemName.TextXAlignment = Enum.TextXAlignment.Left
itemName.Parent = buyFrame

-- Price
local price = Instance.new("TextLabel")
price.Size = UDim2.new(1,-120,0,25)
price.Position = UDim2.new(0,110,0,95)
price.BackgroundTransparency = 1
price.Text = "\u{E002} 7,499"
price.Font = Enum.Font.Gotham
price.TextSize = 15
price.TextColor3 = Color3.fromRGB(200,200,200)
price.TextXAlignment = Enum.TextXAlignment.Left
price.Parent = buyFrame

-- Buy Button
local buyButton = Instance.new("TextButton")
buyButton.Size = UDim2.new(1,-40,0,48)
buyButton.Position = UDim2.new(0,20,1,-65)
buyButton.BackgroundColor3 = Color3.fromRGB(88,101,242)
buyButton.BorderSizePixel = 0
buyButton.Text = "Buy"
buyButton.Font = Enum.Font.GothamBold
buyButton.TextSize = 18
buyButton.TextColor3 = Color3.fromRGB(255,255,255)
buyButton.Parent = buyFrame
Instance.new("UICorner", buyButton).CornerRadius = UDim.new(0,8)

--========================
-- PURCHASE COMPLETED FRAME
--========================
local successFrame = buyFrame:Clone()
successFrame.Visible = false
successFrame.Parent = gui

-- Clear old contents
for _,v in pairs(successFrame:GetChildren()) do
	if not v:IsA("UICorner") then
		v:Destroy()
	end
end

-- Title
local sTitle = title:Clone()
sTitle.Text = "Purchase completed"
sTitle.Parent = successFrame

-- Check Icon
local check = Instance.new("TextLabel")
check.Size = UDim2.fromOffset(60,60)
check.Position = UDim2.new(0.5,-30,0,70)
check.BackgroundTransparency = 1
check.Text = "✔"
check.Font = Enum.Font.GothamBold
check.TextSize = 40
check.TextColor3 = Color3.fromRGB(255,255,255)
check.TextXAlignment = Enum.TextXAlignment.Center
check.Parent = successFrame

-- Success Text
local successText = Instance.new("TextLabel")
successText.Size = UDim2.new(1,-40,0,50)
successText.Position = UDim2.new(0,20,0,140)
successText.BackgroundTransparency = 1
successText.TextWrapped = true
successText.Text = "You have successfully gifted [GIFT] ADMIN PANEL."
successText.Font = Enum.Font.Gotham
successText.TextSize = 15
successText.TextColor3 = Color3.fromRGB(200,200,200)
successText.TextXAlignment = Enum.TextXAlignment.Center
successText.Parent = successFrame

-- OK Button
local okButton = buyButton:Clone()
okButton.Text = "OK"
okButton.Parent = successFrame

--========================
-- BUTTON LOGIC
--========================
buyButton.MouseButton1Click:Connect(function()
	buyFrame.Visible = false
	successFrame.Visible = true
end)

okButton.MouseButton1Click:Connect(function()
	gui:Destroy()
end)

close.MouseButton1Click:Connect(function()
	gui:Destroy()
end)
