local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

local gui = Instance.new("ScreenGui")
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

-- SETTINGS
local ITEM_PRICE = 7499
local balanceAmount = 66245
local selectedPlayer = nil

local DARK_BLUE = Color3.fromRGB(35,60,180)
local LIGHT_BLUE = Color3.fromRGB(88,101,242)

--========================
-- POP ANIMATION
--========================
local function pop(frame)
	frame.Position = UDim2.new(0.5,-210,0.5,-90)
	TweenService:Create(
		frame,
		TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
		{Position = UDim2.new(0.5,-210,0.5,-115)}
	):Play()
end

--========================
-- BUY FRAME
--========================
local buyFrame = Instance.new("Frame")
buyFrame.Size = UDim2.fromOffset(420,260)
buyFrame.BackgroundColor3 = Color3.fromRGB(46,46,46)
buyFrame.BorderSizePixel = 0
buyFrame.Parent = gui
Instance.new("UICorner", buyFrame).CornerRadius = UDim.new(0,12)

pop(buyFrame)

-- Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,-120,0,40)
title.Position = UDim2.new(0,20,0,12)
title.BackgroundTransparency = 1
title.Text = "Buy item"
title.Font = Enum.Font.Gotham
title.TextSize = 18
title.TextColor3 = Color3.new(1,1,1)
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = buyFrame

-- Balance display
local balanceLabel = Instance.new("TextLabel")
balanceLabel.Size = UDim2.fromOffset(140,30)
balanceLabel.Position = UDim2.new(1,-170,0,16)
balanceLabel.BackgroundTransparency = 1
balanceLabel.Font = Enum.Font.Gotham
balanceLabel.TextSize = 15
balanceLabel.TextColor3 = Color3.fromRGB(200,200,200)
balanceLabel.TextXAlignment = Enum.TextXAlignment.Right
balanceLabel.Parent = buyFrame

local function updateBalance()
	balanceLabel.Text = "\u{E002} "..balanceAmount
end

updateBalance()

-- Balance edit input
local balanceBox = Instance.new("TextBox")
balanceBox.Size = UDim2.fromOffset(120,28)
balanceBox.Position = UDim2.new(0,20,0,50)
balanceBox.PlaceholderText = "Set Balance"
balanceBox.Font = Enum.Font.Gotham
balanceBox.TextSize = 14
balanceBox.BackgroundColor3 = Color3.fromRGB(60,60,60)
balanceBox.TextColor3 = Color3.new(1,1,1)
balanceBox.Parent = buyFrame
Instance.new("UICorner", balanceBox).CornerRadius = UDim.new(0,6)

balanceBox.FocusLost:Connect(function()
	local num = tonumber(balanceBox.Text)
	if num then
		balanceAmount = num
		updateBalance()
	end
end)

-- Player dropdown
local dropdown = Instance.new("TextButton")
dropdown.Size = UDim2.fromOffset(180,28)
dropdown.Position = UDim2.new(0,160,0,50)
dropdown.Text = "Select Player"
dropdown.Font = Enum.Font.Gotham
dropdown.TextSize = 14
dropdown.BackgroundColor3 = Color3.fromRGB(60,60,60)
dropdown.TextColor3 = Color3.new(1,1,1)
dropdown.Parent = buyFrame
Instance.new("UICorner", dropdown).CornerRadius = UDim.new(0,6)

local dropFrame = Instance.new("Frame")
dropFrame.Size = UDim2.fromOffset(180,100)
dropFrame.Position = UDim2.new(0,160,0,80)
dropFrame.BackgroundColor3 = Color3.fromRGB(50,50,50)
dropFrame.Visible = false
dropFrame.Parent = buyFrame
Instance.new("UICorner", dropFrame).CornerRadius = UDim.new(0,6)

local layout = Instance.new("UIListLayout", dropFrame)

dropdown.MouseButton1Click:Connect(function()
	dropFrame.Visible = not dropFrame.Visible
end)

local function refreshPlayers()
	dropFrame:ClearAllChildren()
	layout.Parent = dropFrame
	for _,plr in pairs(Players:GetPlayers()) do
		if plr ~= player then
			local btn = Instance.new("TextButton")
			btn.Size = UDim2.new(1,0,0,24)
			btn.Text = plr.Name
			btn.Font = Enum.Font.Gotham
			btn.TextSize = 14
			btn.BackgroundColor3 = Color3.fromRGB(70,70,70)
			btn.TextColor3 = Color3.new(1,1,1)
			btn.Parent = dropFrame
			
			btn.MouseButton1Click:Connect(function()
				selectedPlayer = plr.Name
				dropdown.Text = plr.Name
				dropFrame.Visible = false
			end)
		end
	end
end

refreshPlayers()

-- Item Image (replace with your decal anytime)
local image = Instance.new("ImageLabel")
image.Size = UDim2.fromOffset(70,70)
image.Position = UDim2.new(0,20,0,95)
image.BackgroundTransparency = 1
image.Image = "rbxassetid://136656557035530"
image.ScaleType = Enum.ScaleType.Fit
image.Parent = buyFrame

-- Item Name
local name = Instance.new("TextLabel")
name.Size = UDim2.new(1,-120,0,25)
name.Position = UDim2.new(0,110,0,100)
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
price.Position = UDim2.new(0,110,0,130)
price.BackgroundTransparency = 1
price.Text = "\u{E002} "..ITEM_PRICE
price.Font = Enum.Font.Gotham
price.TextSize = 15
price.TextColor3 = Color3.fromRGB(200,200,200)
price.TextXAlignment = Enum.TextXAlignment.Left
price.Parent = buyFrame

-- Buy Button
local buyButton = Instance.new("TextButton")
buyButton.Size = UDim2.new(1,-40,0,48)
buyButton.Position = UDim2.new(0,20,1,-65)
buyButton.BackgroundColor3 = LIGHT_BLUE
buyButton.Text = "Buy"
buyButton.Font = Enum.Font.GothamBold
buyButton.TextSize = 18
buyButton.TextColor3 = Color3.new(1,1,1)
buyButton.Parent = buyFrame
Instance.new("UICorner", buyButton).CornerRadius = UDim.new(0,8)

--========================
-- SUCCESS FRAME
--========================
local successFrame = buyFrame:Clone()
successFrame.Visible = false
successFrame.Parent = gui

for _,v in pairs(successFrame:GetChildren()) do
	if not v:IsA("UICorner") then
		v:Destroy()
	end
end

local sTitle = title:Clone()
sTitle.Text = "Purchase completed"
sTitle.Parent = successFrame

local successText = Instance.new("TextLabel")
successText.Size = UDim2.new(1,-40,0,60)
successText.Position = UDim2.new(0,20,0,120) -- LOWERED
successText.BackgroundTransparency = 1
successText.TextWrapped = true
successText.Font = Enum.Font.Gotham
successText.TextSize = 15
successText.TextColor3 = Color3.fromRGB(200,200,200)
successText.TextXAlignment = Enum.TextXAlignment.Center
successText.Parent = successFrame

local okButton = Instance.new("TextButton")
okButton.Size = UDim2.new(1,-40,0,48)
okButton.Position = UDim2.new(0,20,1,-65)
okButton.BackgroundColor3 = LIGHT_BLUE
okButton.Text = "OK"
okButton.Font = Enum.Font.GothamBold
okButton.TextSize = 18
okButton.TextColor3 = Color3.new(1,1,1)
okButton.Parent = successFrame
Instance.new("UICorner", okButton).CornerRadius = UDim.new(0,8)

--========================
-- LOGIC
--========================
buyButton.MouseButton1Click:Connect(function()
	if not selectedPlayer then return end
	if balanceAmount < ITEM_PRICE then return end
	
	balanceAmount -= ITEM_PRICE
	updateBalance()
	
	successText.Text = "You have successfully gifted [GIFT] ADMIN PANEL to "..selectedPlayer.."."
	
	buyFrame.Visible = false
	successFrame.Visible = true
	pop(successFrame)
end)

okButton.MouseButton1Click:Connect(function()
	gui:Destroy()
end)
