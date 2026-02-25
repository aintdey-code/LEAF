--// SERVICES
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer

--// FAKE ROBUX BALANCE
local balance = 211500
local ADMIN_PRICE = 7499

--// GUI
local gui = Instance.new("ScreenGui")
gui.Name = "AdminShopClone"
gui.ResetOnSpawn = false
gui.Parent = LocalPlayer:WaitForChild("PlayerGui")

--// OPEN BUTTON (LEFT SIDE)
local openButton = Instance.new("TextButton")
openButton.Size = UDim2.new(0,50,0,120)
openButton.Position = UDim2.new(0,10,0.4,0)
openButton.Text = "SHOP"
openButton.BackgroundColor3 = Color3.fromRGB(30,30,30)
openButton.TextColor3 = Color3.new(1,1,1)
openButton.Parent = gui

--// MAIN FRAME (FIRST IMAGE)
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0,600,0,420)
mainFrame.Position = UDim2.new(0.5,-300,0.5,-210)
mainFrame.BackgroundColor3 = Color3.fromRGB(55,65,70)
mainFrame.Visible = false
mainFrame.Parent = gui

-- RIGHT SIDE TITLE
local title = Instance.new("TextLabel")
title.Size = UDim2.new(0,40,1,0)
title.Position = UDim2.new(1,-40,0,0)
title.Text = "GAMEPASSES"
title.Rotation = 90
title.BackgroundTransparency = 1
title.TextColor3 = Color3.new(1,1,1)
title.TextScaled = true
title.Parent = mainFrame

-- CLOSE BUTTON
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0,40,0,40)
closeBtn.Position = UDim2.new(1,-45,1,-45)
closeBtn.Text = "X"
closeBtn.BackgroundColor3 = Color3.fromRGB(200,50,50)
closeBtn.TextColor3 = Color3.new(1,1,1)
closeBtn.Parent = mainFrame

-- ADMIN PANEL CARD
local adminCard = Instance.new("Frame")
adminCard.Size = UDim2.new(0.4,0,0.6,0)
adminCard.Position = UDim2.new(0.1,0,0.2,0)
adminCard.BackgroundColor3 = Color3.fromRGB(20,45,45)
adminCard.Parent = mainFrame

local adminTitle = Instance.new("TextLabel")
adminTitle.Size = UDim2.new(1,0,0.3,0)
adminTitle.BackgroundTransparency = 1
adminTitle.Text = "ADMIN PANEL"
adminTitle.TextScaled = true
adminTitle.TextColor3 = Color3.new(1,1,1)
adminTitle.Parent = adminCard

-- RAINBOW MOVING TEXT
local rainbowLabel = Instance.new("TextLabel")
rainbowLabel.Size = UDim2.new(1,0,0.3,0)
rainbowLabel.Position = UDim2.new(0,0,0.3,0)
rainbowLabel.BackgroundTransparency = 1
rainbowLabel.Text = "Get Admin Commands"
rainbowLabel.TextScaled = true
rainbowLabel.Parent = adminCard

-- MOVING RAINBOW EFFECT
RunService.RenderStepped:Connect(function()
	local hue = tick() % 5 / 5
	rainbowLabel.TextColor3 = Color3.fromHSV(hue,1,1)
end)

-- PRICE BUTTON
local buyAdmin = Instance.new("TextButton")
buyAdmin.Size = UDim2.new(0.8,0,0.2,0)
buyAdmin.Position = UDim2.new(0.1,0,0.7,0)
buyAdmin.Text = "7,499"
buyAdmin.BackgroundColor3 = Color3.fromRGB(70,160,90)
buyAdmin.TextColor3 = Color3.new(1,1,1)
buyAdmin.TextScaled = true
buyAdmin.Parent = adminCard

-- GIFT PLAYER BUTTON
local giftButton = Instance.new("TextButton")
giftButton.Size = UDim2.new(0,150,0,50)
giftButton.Position = UDim2.new(0,20,1,-60)
giftButton.Text = "Gift Player"
giftButton.BackgroundColor3 = Color3.fromRGB(0,80,80)
giftButton.TextColor3 = Color3.new(1,1,1)
giftButton.Parent = mainFrame

--// GIFT FRAME
local giftFrame = Instance.new("Frame")
giftFrame.Size = mainFrame.Size
giftFrame.Position = mainFrame.Position
giftFrame.BackgroundColor3 = mainFrame.BackgroundColor3
giftFrame.Visible = false
giftFrame.Parent = gui

local chosenPlayer = nil

local playerListFrame = Instance.new("Frame")
playerListFrame.Size = UDim2.new(0.8,0,0.7,0)
playerListFrame.Position = UDim2.new(0.1,0,0.1,0)
playerListFrame.BackgroundColor3 = Color3.fromRGB(80,80,80)
playerListFrame.Parent = giftFrame

-- POPULATE PLAYERS
local function refreshPlayers()
	playerListFrame:ClearAllChildren()
	local y = 0
	
	for _,plr in pairs(Players:GetPlayers()) do
		if plr ~= LocalPlayer then
			local btn = Instance.new("TextButton")
			btn.Size = UDim2.new(1,0,0,40)
			btn.Position = UDim2.new(0,0,0,y)
			btn.Text = plr.Name
			btn.BackgroundColor3 = Color3.fromRGB(50,50,50)
			btn.TextColor3 = Color3.new(1,1,1)
			btn.Parent = playerListFrame
			
			btn.MouseButton1Click:Connect(function()
				chosenPlayer = plr.Name
			end)
			
			y += 45
		end
	end
end

Players.PlayerAdded:Connect(refreshPlayers)
Players.PlayerRemoving:Connect(refreshPlayers)
refreshPlayers()

local confirmGift = Instance.new("TextButton")
confirmGift.Size = UDim2.new(0.4,0,0.1,0)
confirmGift.Position = UDim2.new(0.3,0,0.85,0)
confirmGift.Text = "Gift"
confirmGift.BackgroundColor3 = Color3.fromRGB(70,160,90)
confirmGift.TextColor3 = Color3.new(1,1,1)
confirmGift.Parent = giftFrame

--// BUY ITEM MODAL
local buyModal = Instance.new("Frame")
buyModal.Size = UDim2.new(0,450,0,250)
buyModal.Position = UDim2.new(0.5,-225,0.5,-125)
buyModal.BackgroundColor3 = Color3.fromRGB(40,40,40)
buyModal.Visible = false
buyModal.Parent = gui

local balanceLabel = Instance.new("TextLabel")
balanceLabel.Size = UDim2.new(0.4,0,0.2,0)
balanceLabel.Position = UDim2.new(0.6,0,0,0)
balanceLabel.BackgroundTransparency = 1
balanceLabel.TextColor3 = Color3.new(1,1,1)
balanceLabel.TextScaled = true
balanceLabel.Parent = buyModal

local buyConfirm = Instance.new("TextButton")
buyConfirm.Size = UDim2.new(0.8,0,0.3,0)
buyConfirm.Position = UDim2.new(0.1,0,0.6,0)
buyConfirm.Text = "Buy"
buyConfirm.BackgroundColor3 = Color3.fromRGB(90,120,255)
buyConfirm.TextColor3 = Color3.new(1,1,1)
buyConfirm.Parent = buyModal

--// PURCHASE COMPLETE
local completeFrame = Instance.new("Frame")
completeFrame.Size = buyModal.Size
completeFrame.Position = buyModal.Position
completeFrame.BackgroundColor3 = buyModal.BackgroundColor3
completeFrame.Visible = false
completeFrame.Parent = gui

local completeText = Instance.new("TextLabel")
completeText.Size = UDim2.new(1,0,0.5,0)
completeText.BackgroundTransparency = 1
completeText.TextColor3 = Color3.new(1,1,1)
completeText.TextScaled = true
completeText.Parent = completeFrame

local okBtn = Instance.new("TextButton")
okBtn.Size = UDim2.new(0.6,0,0.2,0)
okBtn.Position = UDim2.new(0.2,0,0.7,0)
okBtn.Text = "OK"
okBtn.BackgroundColor3 = Color3.fromRGB(90,120,255)
okBtn.TextColor3 = Color3.new(1,1,1)
okBtn.Parent = completeFrame

--// FLOW

openButton.MouseButton1Click:Connect(function()
	mainFrame.Visible = true
end)

closeBtn.MouseButton1Click:Connect(function()
	mainFrame.Visible = false
end)

giftButton.MouseButton1Click:Connect(function()
	mainFrame.Visible = false
	giftFrame.Visible = true
end)

confirmGift.MouseButton1Click:Connect(function()
	if chosenPlayer then
		giftFrame.Visible = false
		mainFrame.Visible = true
	end
end)

buyAdmin.MouseButton1Click:Connect(function()
	balanceLabel.Text = "R$ "..balance
	buyModal.Visible = true
end)

buyConfirm.MouseButton1Click:Connect(function()
	if balance >= ADMIN_PRICE then
		balance -= ADMIN_PRICE
		buyModal.Visible = false
		
		completeText.Text = "You have successfully gifted [GIFT] ADMIN PANEL to "..(chosenPlayer or "...")
		completeFrame.Visible = true
	end
end)

okBtn.MouseButton1Click:Connect(function()
	completeFrame.Visible = false
	mainFrame.Visible = false
end)
