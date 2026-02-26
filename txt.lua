local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer

-- SETTINGS
local PRICE = 7499
local currentBalance = 66245
local selectedPlayer = nil
local currentKeybind = Enum.KeyCode.F1

local DARK_BLUE = Color3.fromRGB(35,60,180)
local LIGHT_BLUE = Color3.fromRGB(88,101,242)

-- MAIN GUI
local gui = Instance.new("ScreenGui")
gui.ResetOnSpawn = false
gui.Enabled = false
gui.Parent = player:WaitForChild("PlayerGui")

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
-- LEFT CONTROL PANEL
--========================
local controlGui = Instance.new("ScreenGui")
controlGui.ResetOnSpawn = false
controlGui.Parent = player.PlayerGui

local controlFrame = Instance.new("Frame")
controlFrame.Size = UDim2.fromOffset(230,300)
controlFrame.Position = UDim2.new(0,20,0.5,-150)
controlFrame.BackgroundColor3 = Color3.fromRGB(35,35,35)
controlFrame.Parent = controlGui
Instance.new("UICorner", controlFrame).CornerRadius = UDim.new(0,10)

-- OPEN SHOP BUTTON
local openButton = Instance.new("TextButton")
openButton.Size = UDim2.new(1,-20,0,40)
openButton.Position = UDim2.new(0,10,0,15)
openButton.BackgroundColor3 = DARK_BLUE
openButton.Text = "Open Shop"
openButton.Font = Enum.Font.GothamBold
openButton.TextSize = 16
openButton.TextColor3 = Color3.new(1,1,1)
openButton.Parent = controlFrame
Instance.new("UICorner", openButton).CornerRadius = UDim.new(0,8)

-- BALANCE EDIT
local balBox = Instance.new("TextBox")
balBox.Size = UDim2.new(1,-20,0,35)
balBox.Position = UDim2.new(0,10,0,70)
balBox.BackgroundColor3 = Color3.fromRGB(45,45,45)
balBox.Text = tostring(currentBalance)
balBox.Font = Enum.Font.Gotham
balBox.TextSize = 16
balBox.TextColor3 = Color3.new(1,1,1)
balBox.Parent = controlFrame
Instance.new("UICorner", balBox).CornerRadius = UDim.new(0,6)

balBox.FocusLost:Connect(function()
	local num = tonumber(balBox.Text)
	if num then
		currentBalance = num
	end
end)

-- KEYBIND EDIT
local keybindBox = Instance.new("TextBox")
keybindBox.Size = UDim2.new(1,-20,0,35)
keybindBox.Position = UDim2.new(0,10,0,115)
keybindBox.BackgroundColor3 = Color3.fromRGB(45,45,45)
keybindBox.Text = "F1"
keybindBox.Font = Enum.Font.Gotham
keybindBox.TextSize = 16
keybindBox.TextColor3 = Color3.new(1,1,1)
keybindBox.Parent = controlFrame
Instance.new("UICorner", keybindBox).CornerRadius = UDim.new(0,6)

keybindBox.FocusLost:Connect(function()
	local key = Enum.KeyCode[keybindBox.Text]
	if key then
		currentKeybind = key
	end
end)

-- PLAYER DROPDOWN
local dropdown = Instance.new("TextButton")
dropdown.Size = UDim2.new(1,-20,0,35)
dropdown.Position = UDim2.new(0,10,0,160)
dropdown.BackgroundColor3 = Color3.fromRGB(45,45,45)
dropdown.Text = "Choose Player"
dropdown.Font = Enum.Font.Gotham
dropdown.TextSize = 14
dropdown.TextColor3 = Color3.new(1,1,1)
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
		option.Text = plr.Name
		option.Font = Enum.Font.Gotham
		option.TextSize = 14
		option.TextColor3 = Color3.new(1,1,1)
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
-- BUY FRAME
--========================
local buyFrame = Instance.new("Frame")
buyFrame.Size = UDim2.fromOffset(420,230)
buyFrame.BackgroundColor3 = Color3.fromRGB(46,46,46)
buyFrame.Parent = gui
Instance.new("UICorner", buyFrame).CornerRadius = UDim.new(0,12)

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

local balance = Instance.new("TextLabel")
balance.Size = UDim2.fromOffset(120,30)
balance.Position = UDim2.new(1,-160,0,16)
balance.BackgroundTransparency = 1
balance.Text = "\u{E002} "..currentBalance
balance.Font = Enum.Font.Gotham
balance.TextSize = 15
balance.TextColor3 = Color3.fromRGB(200,200,200)
balance.TextXAlignment = Enum.TextXAlignment.Right
balance.Parent = buyFrame

-- SUCCESS FRAME
local successFrame = buyFrame:Clone()
successFrame.Visible = false
successFrame.Parent = gui

for _,v in pairs(successFrame:GetChildren()) do
	if not v:IsA("UICorner") then
		v:Destroy()
	end
end

local sTitle = Instance.new("TextLabel")
sTitle.Size = UDim2.new(1,-40,0,40)
sTitle.Position = UDim2.new(0,20,0,20)
sTitle.BackgroundTransparency = 1
sTitle.Text = "Purchase completed"
sTitle.Font = Enum.Font.Gotham
sTitle.TextSize = 18
sTitle.TextColor3 = Color3.new(1,1,1)
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
-- OPEN LOGIC
--========================
local function openShop()
	gui.Enabled = true
	pop(buyFrame)
end

openButton.MouseButton1Click:Connect(openShop)

UserInputService.InputBegan:Connect(function(input, gp)
	if gp then return end
	if input.KeyCode == currentKeybind then
		openShop()
	end
end)

--========================
-- BUY LOGIC
--========================
okButton.MouseButton1Click:Connect(function()
	gui.Enabled = false
	successFrame.Visible = false
end)
