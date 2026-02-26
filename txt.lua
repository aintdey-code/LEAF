local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

local PRICE = 7499
local currentBalance = 66245
local selectedPlayer = nil

local gui = Instance.new("ScreenGui")
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

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
buyFrame.Size = UDim2.fromOffset(420,230)
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

-- Balance
local balance = Instance.new("TextLabel")
balance.Size = UDim2.fromOffset(120,30)
balance.Position = UDim2.new(1,-160,0,16)
balance.BackgroundTransparency = 1
balance.Text = "\u{E002} "..string.format("%0.0f",currentBalance)
balance.Font = Enum.Font.Gotham
balance.TextSize = 15
balance.TextColor3 = Color3.fromRGB(200,200,200)
balance.TextXAlignment = Enum.TextXAlignment.Right
balance.Parent = buyFrame

-- Close
local close = Instance.new("ImageButton")
close.Size = UDim2.fromOffset(24,24)
close.Position = UDim2.new(1,-32,0,18)
close.BackgroundTransparency = 1
close.Image = "rbxassetid://6031094678"
close.Parent = buyFrame

-- Image HD
local image = Instance.new("ImageLabel")
image.Size = UDim2.fromOffset(70,70)
image.Position = UDim2.new(0,20,0,65)
image.BackgroundTransparency = 1
image.Image = "rbxassetid://136656557035530"
image.ScaleType = Enum.ScaleType.Fit
image.Parent = buyFrame

-- Item Name
local name = Instance.new("TextLabel")
name.Size = UDim2.new(1,-120,0,25)
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
price.Text = "\u{E002} "..string.format("%0.0f",PRICE)
price.Font = Enum.Font.Gotham
price.TextSize = 15
price.TextColor3 = Color3.fromRGB(200,200,200)
price.TextXAlignment = Enum.TextXAlignment.Left
price.Parent = buyFrame

-- BUY BUTTON
local buttonFrame = Instance.new("Frame")
buttonFrame.Size = UDim2.new(1,-40,0,48)
buttonFrame.Position = UDim2.new(0,20,1,-65)
buttonFrame.BackgroundColor3 = DARK_BLUE
buttonFrame.Parent = buyFrame
Instance.new("UICorner", buttonFrame).CornerRadius = UDim.new(0,8)

local sweep = Instance.new("Frame")
sweep.Size = UDim2.new(0,0,1,0)
sweep.BackgroundColor3 = LIGHT_BLUE
sweep.Parent = buttonFrame
Instance.new("UICorner", sweep).CornerRadius = UDim.new(0,8)

local buyButton = Instance.new("TextButton")
buyButton.Size = UDim2.fromScale(1,1)
buyButton.BackgroundTransparency = 1
buyButton.Text = "Buy"
buyButton.Font = Enum.Font.GothamBold
buyButton.TextSize = 18
buyButton.TextColor3 = Color3.new(1,1,1)
buyButton.Parent = buttonFrame

TweenService:Create(
	sweep,
	TweenInfo.new(3, Enum.EasingStyle.Linear),
	{Size = UDim2.new(1,0,1,0)}
):Play()

task.wait(3)
buttonFrame.BackgroundColor3 = LIGHT_BLUE

--========================
-- LEFT CONTROL PANEL
--========================
local controlFrame = Instance.new("Frame")
controlFrame.Size = UDim2.fromOffset(200,230)
controlFrame.Position = UDim2.new(0.5,-430,0.5,-115)
controlFrame.BackgroundTransparency = 1
controlFrame.Parent = gui

local balBox = Instance.new("TextBox")
balBox.Size = UDim2.new(1,0,0,35)
balBox.Position = UDim2.new(0,0,0,20)
balBox.BackgroundColor3 = Color3.fromRGB(40,40,40)
balBox.TextColor3 = Color3.new(1,1,1)
balBox.Font = Enum.Font.Gotham
balBox.TextSize = 16
balBox.Text = tostring(currentBalance)
balBox.Parent = controlFrame
Instance.new("UICorner", balBox).CornerRadius = UDim.new(0,6)

balBox.FocusLost:Connect(function()
	local num = tonumber(balBox.Text)
	if num then
		currentBalance = num
		balance.Text = "\u{E002} "..string.format("%0.0f",currentBalance)
	end
end)

local dropdown = Instance.new("TextButton")
dropdown.Size = UDim2.new(1,0,0,35)
dropdown.Position = UDim2.new(0,0,0,70)
dropdown.BackgroundColor3 = Color3.fromRGB(40,40,40)
dropdown.TextColor3 = Color3.new(1,1,1)
dropdown.Font = Enum.Font.Gotham
dropdown.TextSize = 15
dropdown.Text = "Choose Player"
dropdown.Parent = controlFrame
Instance.new("UICorner", dropdown).CornerRadius = UDim.new(0,6)

local listFrame = Instance.new("Frame")
listFrame.Size = UDim2.new(1,0,0,0)
listFrame.Position = UDim2.new(0,0,1,0)
listFrame.BackgroundColor3 = Color3.fromRGB(30,30,30)
listFrame.Visible = false
listFrame.Parent = dropdown
Instance.new("UICorner", listFrame).CornerRadius = UDim.new(0,6)

local layout = Instance.new("UIListLayout", listFrame)

local function refreshPlayers()
	listFrame:ClearAllChildren()
	layout.Parent = listFrame
	for _,plr in pairs(Players:GetPlayers()) do
		local option = Instance.new("TextButton")
		option.Size = UDim2.new(1,0,0,30)
		option.BackgroundColor3 = Color3.fromRGB(45,45,45)
		option.TextColor3 = Color3.new(1,1,1)
		option.Font = Enum.Font.Gotham
		option.TextSize = 14
		option.Text = plr.Name
		option.Parent = listFrame

		option.MouseButton1Click:Connect(function()
			selectedPlayer = plr.Name
			dropdown.Text = plr.Name
			listFrame.Visible = false
		end)
	end
	listFrame.Size = UDim2.new(1,0,0,#Players:GetPlayers()*30)
end

dropdown.MouseButton1Click:Connect(function()
	refreshPlayers()
	listFrame.Visible = not listFrame.Visible
end)

--========================
-- SUCCESS FRAME
--========================
local successFrame = buyFrame:Clone()
successFrame.Visible = false
successFrame.Parent = gui
for _,v in pairs(successFrame:GetChildren()) do
	if v ~= successFrame:FindFirstChildOfClass("UICorner") then
		v:Destroy()
	end
end

local sTitle = title:Clone()
sTitle.Text = "Purchase completed"
sTitle.Parent = successFrame

local successText = Instance.new("TextLabel")
successText.Size = UDim2.new(1,-40,0,60)
successText.Position = UDim2.new(0,20,0,90)
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
-- BUTTON LOGIC
--========================
buyButton.MouseButton1Click:Connect(function()

	if not selectedPlayer then
		dropdown.Text = "Select a Player!"
		return
	end
	
	if currentBalance < PRICE then
		balBox.Text = "Not enough!"
		return
	end

	currentBalance -= PRICE
	balance.Text = "\u{E002} "..string.format("%0.0f",currentBalance)
	balBox.Text = tostring(currentBalance)

	buttonFrame.BackgroundColor3 = DARK_BLUE
	task.wait(0.15)

	successText.Text =
		"You have successfully gifted [GIFT] ADMIN PANEL to "..selectedPlayer.."."

	buyFrame.Visible = false
	successFrame.Visible = true
	pop(successFrame)
end)

okButton.MouseButton1Click:Connect(function()
	okButton.BackgroundColor3 = DARK_BLUE
	task.wait(0.15)
	gui:Destroy()
end)

close.MouseButton1Click:Connect(function()
	gui:Destroy()
end)
