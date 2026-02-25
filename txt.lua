

--// PIXEL PERFECT ADMIN SHOP CLONE
--// Put inside StarterGui > ScreenGui > LocalScript

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer

--====================================================
-- CONFIG
--====================================================

local BALANCE = 211500
local ADMIN_PRICE = 7499
local selectedPlayer = nil

local function format(n)
	return tostring(n):reverse():gsub("(%d%d%d)","%1,"):reverse():gsub("^,","")
end

local function Corner(obj, radius)
	local c = Instance.new("UICorner")
	c.CornerRadius = UDim.new(0, radius)
	c.Parent = obj
end

--====================================================
-- GUI BASE
--====================================================

local sg = Instance.new("ScreenGui")
sg.ResetOnSpawn = false
sg.Parent = player:WaitForChild("PlayerGui")

--====================================================
-- OPEN BUTTON (LEFT SIDE)
--====================================================

local openBtn = Instance.new("TextButton")
openBtn.Size = UDim2.new(0,50,0,120)
openBtn.Position = UDim2.new(0,10,0.4,0)
openBtn.BackgroundColor3 = Color3.fromRGB(25,25,25)
openBtn.Text = "SHOP"
openBtn.TextColor3 = Color3.new(1,1,1)
openBtn.Font = Enum.Font.GothamBlack
openBtn.TextSize = 16
openBtn.Parent = sg
Corner(openBtn,8)

--====================================================
-- SHOP FRAME (IMAGE 1 EXACT STYLE)
--====================================================

local shopFrame = Instance.new("Frame")
shopFrame.Size = UDim2.new(0,600,0,420)
shopFrame.Position = UDim2.new(0.5,-300,0.5,-210)
shopFrame.BackgroundColor3 = Color3.fromRGB(70,90,95)
shopFrame.BorderSizePixel = 0
shopFrame.Visible = false
shopFrame.Parent = sg
Corner(shopFrame,10)

-- Vertical GAMEPASSES Bar
local sideBar = Instance.new("Frame")
sideBar.Size = UDim2.new(0,52,1,0)
sideBar.Position = UDim2.new(1,-52,0,0)
sideBar.BackgroundColor3 = Color3.fromRGB(90,110,115)
sideBar.BorderSizePixel = 0
sideBar.Parent = shopFrame

local sideText = Instance.new("TextLabel")
sideText.Size = UDim2.new(1,0,1,0)
sideText.BackgroundTransparency = 1
sideText.Text = "GAMEPASSES"
sideText.TextColor3 = Color3.new(1,1,1)
sideText.Font = Enum.Font.GothamBlack
sideText.TextSize = 18
sideText.Rotation = 90
sideText.Parent = sideBar

-- Close Button
local shopClose = Instance.new("TextButton")
shopClose.Size = UDim2.new(0,40,0,40)
shopClose.Position = UDim2.new(1,-45,1,-45)
shopClose.BackgroundColor3 = Color3.fromRGB(200,40,40)
shopClose.Text = "X"
shopClose.TextColor3 = Color3.new(1,1,1)
shopClose.Font = Enum.Font.GothamBlack
shopClose.TextSize = 18
shopClose.Parent = shopFrame
Corner(shopClose,8)

--====================================================
-- ADMIN PANEL CARD
--====================================================

local adminCard = Instance.new("Frame")
adminCard.Size = UDim2.new(0,480,0,150)
adminCard.Position = UDim2.new(0,40,0,70)
adminCard.BackgroundColor3 = Color3.fromRGB(15,60,55)
adminCard.BorderSizePixel = 0
adminCard.Parent = shopFrame
Corner(adminCard,8)

local adminImage = Instance.new("ImageLabel")
adminImage.Size = UDim2.new(0,80,0,80)
adminImage.Position = UDim2.new(0,15,0.5,-40)
adminImage.BackgroundTransparency = 1
adminImage.Image = "rbxassetid://76531501501891"
adminImage.Parent = adminCard

local adminTitle = Instance.new("TextLabel")
adminTitle.Size = UDim2.new(0,250,0,32)
adminTitle.Position = UDim2.new(0,110,0,20)
adminTitle.BackgroundTransparency = 1
adminTitle.Text = "ADMIN PANEL"
adminTitle.TextColor3 = Color3.new(1,1,1)
adminTitle.Font = Enum.Font.GothamBlack
adminTitle.TextSize = 22
adminTitle.TextXAlignment = Enum.TextXAlignment.Left
adminTitle.Parent = adminCard

local rainbowLbl = Instance.new("TextLabel")
rainbowLbl.Size = UDim2.new(0,260,0,28)
rainbowLbl.Position = UDim2.new(0,110,0,60)
rainbowLbl.BackgroundTransparency = 1
rainbowLbl.Text = "Get Admin Commands"
rainbowLbl.Font = Enum.Font.GothamBold
rainbowLbl.TextSize = 18
rainbowLbl.TextXAlignment = Enum.TextXAlignment.Left
rainbowLbl.Parent = adminCard

RunService.RenderStepped:Connect(function()
	local hue = (tick()*0.2)%1
	rainbowLbl.TextColor3 = Color3.fromHSV(hue,1,1)
end)

local adminBuyBtn = Instance.new("TextButton")
adminBuyBtn.Size = UDim2.new(0,120,0,36)
adminBuyBtn.Position = UDim2.new(1,-140,0.5,-18)
adminBuyBtn.BackgroundColor3 = Color3.fromRGB(70,160,90)
adminBuyBtn.Text = "R$ 7,499"
adminBuyBtn.TextColor3 = Color3.new(1,1,1)
adminBuyBtn.Font = Enum.Font.GothamBlack
adminBuyBtn.TextSize = 16
adminBuyBtn.Parent = adminCard
Corner(adminBuyBtn,6)

-- Gift Button
local giftBtn = Instance.new("TextButton")
giftBtn.Size = UDim2.new(0,150,0,38)
giftBtn.Position = UDim2.new(1,-210,1,-55)
giftBtn.BackgroundColor3 = Color3.fromRGB(20,55,20)
giftBtn.Text = "Gift Player"
giftBtn.TextColor3 = Color3.new(1,1,1)
giftBtn.Font = Enum.Font.GothamBold
giftBtn.TextSize = 15
giftBtn.Parent = shopFrame
Corner(giftBtn,6)

--====================================================
-- BUY FRAME (IMAGE 3 EXACT)
--====================================================

local buyFrame = Instance.new("Frame")
buyFrame.Size = UDim2.new(0,380,0,175)
buyFrame.Position = UDim2.new(0.5,-190,0.5,-87)
buyFrame.BackgroundColor3 = Color3.fromRGB(38,38,42)
buyFrame.Visible = false
buyFrame.Parent = sg
Corner(buyFrame,10)

local buyHeader = Instance.new("Frame")
buyHeader.Size = UDim2.new(1,0,0,44)
buyHeader.BackgroundColor3 = Color3.fromRGB(28,28,32)
buyHeader.Parent = buyFrame
Corner(buyHeader,8)

local buyTitle = Instance.new("TextLabel")
buyTitle.Size = UDim2.new(0,120,1,0)
buyTitle.Position = UDim2.new(0,12,0,0)
buyTitle.BackgroundTransparency = 1
buyTitle.Text = "Buy item"
buyTitle.TextColor3 = Color3.new(1,1,1)
buyTitle.Font = Enum.Font.GothamBold
buyTitle.TextSize = 16
buyTitle.TextXAlignment = Enum.TextXAlignment.Left
buyTitle.Parent = buyHeader

local balanceLbl = Instance.new("TextLabel")
balanceLbl.Size = UDim2.new(0,150,1,0)
balanceLbl.Position = UDim2.new(1,-190,0,0)
balanceLbl.BackgroundTransparency = 1
balanceLbl.Text = "R$ "..format(BALANCE)
balanceLbl.TextColor3 = Color3.new(1,1,1)
balanceLbl.Font = Enum.Font.GothamBold
balanceLbl.TextSize = 14
balanceLbl.TextXAlignment = Enum.TextXAlignment.Right
balanceLbl.Parent = buyHeader

local buyClose = Instance.new("TextButton")
buyClose.Size = UDim2.new(0,30,0,26)
buyClose.Position = UDim2.new(1,-36,0.5,-13)
buyClose.BackgroundTransparency = 1
buyClose.Text = "X"
buyClose.TextColor3 = Color3.fromRGB(200,200,200)
buyClose.Font = Enum.Font.GothamBold
buyClose.TextSize = 16
buyClose.Parent = buyHeader

local buyIcon = Instance.new("ImageLabel")
buyIcon.Size = UDim2.new(0,58,0,58)
buyIcon.Position = UDim2.new(0,14,0,54)
buyIcon.BackgroundTransparency = 1
buyIcon.Image = "rbxassetid://76531501501891"
buyIcon.Parent = buyFrame

local buyName = Instance.new("TextLabel")
buyName.Size = UDim2.new(0,250,0,26)
buyName.Position = UDim2.new(0,82,0,54)
buyName.BackgroundTransparency = 1
buyName.Text = "[GIFT] ADMIN PANEL"
buyName.TextColor3 = Color3.new(1,1,1)
buyName.Font = Enum.Font.GothamBold
buyName.TextSize = 15
buyName.TextXAlignment = Enum.TextXAlignment.Left
buyName.Parent = buyFrame

local buyPrice = Instance.new("TextLabel")
buyPrice.Size = UDim2.new(0,250,0,22)
buyPrice.Position = UDim2.new(0,82,0,80)
buyPrice.BackgroundTransparency = 1
buyPrice.Text = "R$ 7,499"
buyPrice.TextColor3 = Color3.fromRGB(210,210,210)
buyPrice.Font = Enum.Font.GothamBold
buyPrice.TextSize = 13
buyPrice.TextXAlignment = Enum.TextXAlignment.Left
buyPrice.Parent = buyFrame

local buyConfirm = Instance.new("TextButton")
buyConfirm.Size = UDim2.new(1,-28,0,40)
buyConfirm.Position = UDim2.new(0,14,0,122)
buyConfirm.BackgroundColor3 = Color3.fromRGB(86,115,255)
buyConfirm.Text = "Buy"
buyConfirm.TextColor3 = Color3.new(1,1,1)
buyConfirm.Font = Enum.Font.GothamBlack
buyConfirm.TextSize = 18
buyConfirm.Parent = buyFrame
Corner(buyConfirm,8)

--====================================================
-- PURCHASE COMPLETE FRAME
--====================================================

local completeFrame = Instance.new("Frame")
completeFrame.Size = UDim2.new(0,380,0,225)
completeFrame.Position = UDim2.new(0.5,-190,0.5,-112)
completeFrame.BackgroundColor3 = Color3.fromRGB(38,38,42)
completeFrame.Visible = false
completeFrame.Parent = sg
Corner(completeFrame,10)

local completeHeader = Instance.new("Frame")
completeHeader.Size = UDim2.new(1,0,0,44)
completeHeader.BackgroundColor3 = Color3.fromRGB(28,28,32)
completeHeader.Parent = completeFrame
Corner(completeHeader,8)

local completeTitle = Instance.new("TextLabel")
completeTitle.Size = UDim2.new(1,-50,1,0)
completeTitle.Position = UDim2.new(0,12,0,0)
completeTitle.BackgroundTransparency = 1
completeTitle.Text = "Purchase completed"
completeTitle.TextColor3 = Color3.new(1,1,1)
completeTitle.Font = Enum.Font.GothamBold
completeTitle.TextSize = 16
completeTitle.TextXAlignment = Enum.TextXAlignment.Left
completeTitle.Parent = completeHeader

local checkCircle = Instance.new("Frame")
checkCircle.Size = UDim2.new(0,62,0,62)
checkCircle.Position = UDim2.new(0.5,-31,0,54)
checkCircle.BackgroundTransparency = 1
checkCircle.Parent = completeFrame
Corner(checkCircle,31)

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(160,160,165)
stroke.Thickness = 3
stroke.Parent = checkCircle

local checkLbl = Instance.new("TextLabel")
checkLbl.Size = UDim2.new(1,0,1,0)
checkLbl.BackgroundTransparency = 1
checkLbl.Text = "✓"
checkLbl.TextColor3 = Color3.fromRGB(160,160,165)
checkLbl.Font = Enum.Font.GothamBlack
checkLbl.TextSize = 30
checkLbl.Parent = checkCircle

local completeBody = Instance.new("TextLabel")
completeBody.Size = UDim2.new(1,-30,0,46)
completeBody.Position = UDim2.new(0,15,0,124)
completeBody.BackgroundTransparency = 1
completeBody.TextColor3 = Color3.fromRGB(220,220,220)
completeBody.Font = Enum.Font.Gotham
completeBody.TextSize = 13
completeBody.TextWrapped = true
completeBody.Parent = completeFrame

local okBtn = Instance.new("TextButton")
okBtn.Size = UDim2.new(1,-28,0,40)
okBtn.Position = UDim2.new(0,14,0,176)
okBtn.BackgroundColor3 = Color3.fromRGB(86,115,255)
okBtn.Text = "OK"
okBtn.TextColor3 = Color3.new(1,1,1)
okBtn.Font = Enum.Font.GothamBlack
okBtn.TextSize = 18
okBtn.Parent = completeFrame
Corner(okBtn,8)

--====================================================
-- FLOW
--====================================================

openBtn.MouseButton1Click:Connect(function()
	shopFrame.Visible = true
end)

shopClose.MouseButton1Click:Connect(function()
	shopFrame.Visible = false
end)

adminBuyBtn.MouseButton1Click:Connect(function()
	balanceLbl.Text = "R$ "..format(BALANCE)
	shopFrame.Visible = false
	buyFrame.Visible = true
end)

buyClose.MouseButton1Click:Connect(function()
	buyFrame.Visible = false
	shopFrame.Visible = true
end)

buyConfirm.MouseButton1Click:Connect(function()
	if BALANCE >= ADMIN_PRICE then
		BALANCE -= ADMIN_PRICE
	end
	buyFrame.Visible = false
	completeBody.Text = "You have successfully gifted [GIFT] ADMIN PANEL to "..(selectedPlayer or "Player").."."
	completeFrame.Visible = true
end)

okBtn.MouseButton1Click:Connect(function()
	completeFrame.Visible = false
	shopFrame.Visible = false
end)

