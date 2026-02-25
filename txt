-- LocalScript - paste inside StarterGui
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local localPlayer = Players.LocalPlayer

local balance = 211500
local selectedPlayer = nil
local currentItemName = ""
local currentItemPrice = 0

local function formatNumber(n)
	local s = tostring(math.floor(n))
	local result = ""
	local count = 0
	for i = #s, 1, -1 do
		if count > 0 and count % 3 == 0 then
			result = "," .. result
		end
		result = s:sub(i, i) .. result
		count = count + 1
	end
	return result
end

local function newCorner(parent, radius)
	local c = Instance.new("UICorner")
	c.CornerRadius = UDim.new(0, radius or 6)
	c.Parent = parent
end

local function newStroke(parent, color, thickness)
	local s = Instance.new("UIStroke")
	s.Color = color
	s.Thickness = thickness or 2
	s.Parent = parent
end

-- =============================================
-- SCREEN GUI
-- =============================================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ShopGUI"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = localPlayer:WaitForChild("PlayerGui")

-- =============================================
-- OPEN BUTTON (left side)
-- =============================================
local openBtn = Instance.new("TextButton")
openBtn.Size = UDim2.new(0, 40, 0, 100)
openBtn.Position = UDim2.new(0, 8, 0.5, -50)
openBtn.BackgroundColor3 = Color3.fromRGB(50, 130, 50)
openBtn.BorderSizePixel = 0
openBtn.Text = "SHOP"
openBtn.TextColor3 = Color3.new(1,1,1)
openBtn.Font = Enum.Font.GothamBlack
openBtn.TextSize = 15
openBtn.ZIndex = 2
openBtn.Parent = screenGui
newCorner(openBtn, 8)
newStroke(openBtn, Color3.fromRGB(20,80,20), 2)

-- =============================================
-- SHOP FRAME
-- =============================================
local shopFrame = Instance.new("Frame")
shopFrame.Size = UDim2.new(0, 530, 0, 420)
shopFrame.Position = UDim2.new(0.5, -265, 0.5, -210)
shopFrame.BackgroundColor3 = Color3.fromRGB(18, 48, 18)
shopFrame.BorderSizePixel = 0
shopFrame.Visible = false
shopFrame.ZIndex = 5
shopFrame.Parent = screenGui
newCorner(shopFrame, 8)
newStroke(shopFrame, Color3.fromRGB(76,175,80), 3)

-- Shop Header
local shopHeader = Instance.new("Frame")
shopHeader.Size = UDim2.new(1, 0, 0, 50)
shopHeader.BackgroundColor3 = Color3.fromRGB(18, 48, 18)
shopHeader.BorderSizePixel = 0
shopHeader.ZIndex = 6
shopHeader.Parent = shopFrame

local shopTitle = Instance.new("TextLabel")
shopTitle.Size = UDim2.new(0, 80, 1, 0)
shopTitle.Position = UDim2.new(0, 8, 0, 0)
shopTitle.BackgroundTransparency = 1
shopTitle.Text = "SHOP"
shopTitle.TextColor3 = Color3.new(1,1,1)
shopTitle.Font = Enum.Font.GothamBlack
shopTitle.TextSize = 26
shopTitle.ZIndex = 7
shopTitle.Parent = shopHeader

local tabsInfo = {
	{text="GEAR",       col=Color3.fromRGB(155,105,25), x=90},
	{text="GAMEPASSES", col=Color3.fromRGB(45,95,45),   x=180},
	{text="MONEY",      col=Color3.fromRGB(55,155,55),  x=320},
}
for _, t in ipairs(tabsInfo) do
	local tb = Instance.new("TextButton")
	tb.Size = UDim2.new(0, 128, 0, 34)
	tb.Position = UDim2.new(0, t.x, 0.5, -17)
	tb.BackgroundColor3 = t.col
	tb.BorderSizePixel = 0
	tb.Text = t.text
	tb.TextColor3 = Color3.new(1,1,1)
	tb.Font = Enum.Font.GothamBold
	tb.TextSize = 13
	tb.ZIndex = 7
	tb.Parent = shopHeader
	newCorner(tb, 6)
end

local shopCloseBtn = Instance.new("TextButton")
shopCloseBtn.Size = UDim2.new(0, 38, 0, 34)
shopCloseBtn.Position = UDim2.new(1, -46, 0.5, -17)
shopCloseBtn.BackgroundColor3 = Color3.fromRGB(204, 40, 40)
shopCloseBtn.BorderSizePixel = 0
shopCloseBtn.Text = "X"
shopCloseBtn.TextColor3 = Color3.new(1,1,1)
shopCloseBtn.Font = Enum.Font.GothamBold
shopCloseBtn.TextSize = 16
shopCloseBtn.ZIndex = 7
shopCloseBtn.Parent = shopHeader
newCorner(shopCloseBtn, 6)

-- GAMEPASSES label
local gpLabel = Instance.new("TextLabel")
gpLabel.Size = UDim2.new(1, 0, 0, 30)
gpLabel.Position = UDim2.new(0, 0, 0, 52)
gpLabel.BackgroundColor3 = Color3.fromRGB(18, 48, 18)
gpLabel.BorderSizePixel = 0
gpLabel.Text = "GAMEPASSES"
gpLabel.TextColor3 = Color3.new(1,1,1)
gpLabel.Font = Enum.Font.GothamBlack
gpLabel.TextSize = 17
gpLabel.ZIndex = 6
gpLabel.Parent = shopFrame

-- =============================================
-- ADMIN PANEL CARD
-- =============================================
local adminCard = Instance.new("Frame")
adminCard.Size = UDim2.new(1, -24, 0, 92)
adminCard.Position = UDim2.new(0, 12, 0, 88)
adminCard.BackgroundColor3 = Color3.fromRGB(10, 32, 10)
adminCard.BorderSizePixel = 0
adminCard.ZIndex = 6
adminCard.Parent = shopFrame
newCorner(adminCard, 8)
newStroke(adminCard, Color3.fromRGB(40,80,40), 2)

local adminTitle = Instance.new("TextLabel")
adminTitle.Size = UDim2.new(0, 210, 0, 24)
adminTitle.Position = UDim2.new(0, 10, 0, 8)
adminTitle.BackgroundTransparency = 1
adminTitle.Text = "ADMIN PANEL"
adminTitle.TextColor3 = Color3.new(1,1,1)
adminTitle.Font = Enum.Font.GothamBlack
adminTitle.TextSize = 17
adminTitle.TextXAlignment = Enum.TextXAlignment.Left
adminTitle.ZIndex = 7
adminTitle.Parent = adminCard

-- Rainbow label (color set by RunService below)
local rainbowLabel = Instance.new("TextLabel")
rainbowLabel.Size = UDim2.new(0, 210, 0, 20)
rainbowLabel.Position = UDim2.new(0, 10, 0, 33)
rainbowLabel.BackgroundTransparency = 1
rainbowLabel.Text = "Get Admin Commands"
rainbowLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
rainbowLabel.Font = Enum.Font.GothamBold
rainbowLabel.TextSize = 13
rainbowLabel.TextXAlignment = Enum.TextXAlignment.Left
rainbowLabel.ZIndex = 7
rainbowLabel.Parent = adminCard

local cmdsLabel = Instance.new("TextLabel")
cmdsLabel.Size = UDim2.new(0, 210, 0, 32)
cmdsLabel.Position = UDim2.new(0, 10, 0, 53)
cmdsLabel.BackgroundTransparency = 1
cmdsLabel.Text = "Type ;cmds in chat for\na list of commands!"
cmdsLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
cmdsLabel.Font = Enum.Font.Gotham
cmdsLabel.TextSize = 11
cmdsLabel.TextXAlignment = Enum.TextXAlignment.Left
cmdsLabel.ZIndex = 7
cmdsLabel.Parent = adminCard

-- AP logo box
local apBox = Instance.new("Frame")
apBox.Size = UDim2.new(0, 64, 0, 64)
apBox.Position = UDim2.new(0, 228, 0, 14)
apBox.BackgroundColor3 = Color3.fromRGB(130, 130, 130)
apBox.BorderSizePixel = 0
apBox.ZIndex = 7
apBox.Parent = adminCard
newCorner(apBox, 4)

local apLabel = Instance.new("TextLabel")
apLabel.Size = UDim2.new(1, 0, 1, 0)
apLabel.BackgroundTransparency = 1
apLabel.Text = "AP"
apLabel.TextColor3 = Color3.new(1,1,1)
apLabel.Font = Enum.Font.GothamBlack
apLabel.TextSize = 24
apLabel.ZIndex = 8
apLabel.Parent = apBox

-- Worth label (no TextDecoration - just use strikethrough character workaround via RichText)
local worthLabel = Instance.new("TextLabel")
worthLabel.Size = UDim2.new(0, 150, 0, 20)
worthLabel.Position = UDim2.new(0, 310, 0, 10)
worthLabel.BackgroundTransparency = 1
worthLabel.Text = "Worth  R$ 9999"
worthLabel.RichText = true
worthLabel.TextColor3 = Color3.fromRGB(170, 170, 170)
worthLabel.Font = Enum.Font.GothamBold
worthLabel.TextSize = 12
worthLabel.ZIndex = 7
worthLabel.Parent = adminCard

-- Strikethrough line over the worth label
local strikeLine = Instance.new("Frame")
strikeLine.Size = UDim2.new(0, 100, 0, 2)
strikeLine.Position = UDim2.new(0, 318, 0, 19)
strikeLine.BackgroundColor3 = Color3.fromRGB(170, 170, 170)
strikeLine.BorderSizePixel = 0
strikeLine.ZIndex = 8
strikeLine.Parent = adminCard

-- Admin buy button
local adminBuyBtn = Instance.new("TextButton")
adminBuyBtn.Size = UDim2.new(0, 118, 0, 36)
adminBuyBtn.Position = UDim2.new(0, 318, 0, 42)
adminBuyBtn.BackgroundColor3 = Color3.fromRGB(55, 155, 55)
adminBuyBtn.BorderSizePixel = 0
adminBuyBtn.Text = "R$ 7,499"
adminBuyBtn.TextColor3 = Color3.new(1,1,1)
adminBuyBtn.Font = Enum.Font.GothamBold
adminBuyBtn.TextSize = 16
adminBuyBtn.ZIndex = 7
adminBuyBtn.Parent = adminCard
newCorner(adminBuyBtn, 6)

-- =============================================
-- 2X MONEY CARD
-- =============================================
local moneyCard = Instance.new("Frame")
moneyCard.Size = UDim2.new(0, 238, 0, 82)
moneyCard.Position = UDim2.new(0, 12, 0, 192)
moneyCard.BackgroundColor3 = Color3.fromRGB(10, 32, 10)
moneyCard.BorderSizePixel = 0
moneyCard.ZIndex = 6
moneyCard.Parent = shopFrame
newCorner(moneyCard, 8)
newStroke(moneyCard, Color3.fromRGB(40,80,40), 2)

local moneyIcon = Instance.new("TextLabel")
moneyIcon.Size = UDim2.new(0, 44, 0, 44)
moneyIcon.Position = UDim2.new(0, 6, 0.5, -22)
moneyIcon.BackgroundTransparency = 1
moneyIcon.Text = "$"
moneyIcon.TextColor3 = Color3.fromRGB(50,200,50)
moneyIcon.Font = Enum.Font.GothamBlack
moneyIcon.TextSize = 28
moneyIcon.ZIndex = 7
moneyIcon.Parent = moneyCard

local x2Badge = Instance.new("TextLabel")
x2Badge.Size = UDim2.new(0, 24, 0, 16)
x2Badge.Position = UDim2.new(0, 28, 0.5, 4)
x2Badge.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
x2Badge.BorderSizePixel = 0
x2Badge.Text = "x2"
x2Badge.TextColor3 = Color3.new(1,1,1)
x2Badge.Font = Enum.Font.GothamBold
x2Badge.TextSize = 10
x2Badge.ZIndex = 8
x2Badge.Parent = moneyCard
newCorner(x2Badge, 3)

local moneyTitle = Instance.new("TextLabel")
moneyTitle.Size = UDim2.new(0, 155, 0, 22)
moneyTitle.Position = UDim2.new(0, 58, 0, 8)
moneyTitle.BackgroundTransparency = 1
moneyTitle.Text = "2X MONEY"
moneyTitle.TextColor3 = Color3.new(1,1,1)
moneyTitle.Font = Enum.Font.GothamBlack
moneyTitle.TextSize = 15
moneyTitle.TextXAlignment = Enum.TextXAlignment.Left
moneyTitle.ZIndex = 7
moneyTitle.Parent = moneyCard

local moneyDesc = Instance.new("TextLabel")
moneyDesc.Size = UDim2.new(0, 155, 0, 24)
moneyDesc.Position = UDim2.new(0, 58, 0, 30)
moneyDesc.BackgroundTransparency = 1
moneyDesc.Text = "Earn twice as\nmuch money!"
moneyDesc.TextColor3 = Color3.fromRGB(180, 180, 180)
moneyDesc.Font = Enum.Font.Gotham
moneyDesc.TextSize = 11
moneyDesc.TextXAlignment = Enum.TextXAlignment.Left
moneyDesc.ZIndex = 7
moneyDesc.Parent = moneyCard

local moneyBuyBtn = Instance.new("TextButton")
moneyBuyBtn.Size = UDim2.new(0, 96, 0, 28)
moneyBuyBtn.Position = UDim2.new(0, 58, 0, 52)
moneyBuyBtn.BackgroundColor3 = Color3.fromRGB(55, 155, 55)
moneyBuyBtn.BorderSizePixel = 0
moneyBuyBtn.Text = "R$ 119"
moneyBuyBtn.TextColor3 = Color3.new(1,1,1)
moneyBuyBtn.Font = Enum.Font.GothamBold
moneyBuyBtn.TextSize = 14
moneyBuyBtn.ZIndex = 7
moneyBuyBtn.Parent = moneyCard
newCorner(moneyBuyBtn, 6)

-- =============================================
-- VIP CARD
-- =============================================
local vipCard = Instance.new("Frame")
vipCard.Size = UDim2.new(0, 238, 0, 82)
vipCard.Position = UDim2.new(0, 280, 0, 192)
vipCard.BackgroundColor3 = Color3.fromRGB(10, 32, 10)
vipCard.BorderSizePixel = 0
vipCard.ZIndex = 6
vipCard.Parent = shopFrame
newCorner(vipCard, 8)
newStroke(vipCard, Color3.fromRGB(40,80,40), 2)

local vipIcon = Instance.new("TextLabel")
vipIcon.Size = UDim2.new(0, 52, 0, 52)
vipIcon.Position = UDim2.new(0, 6, 0.5, -26)
vipIcon.BackgroundTransparency = 1
vipIcon.Text = "VIP"
vipIcon.TextColor3 = Color3.fromRGB(255, 200, 0)
vipIcon.Font = Enum.Font.GothamBlack
vipIcon.TextSize = 24
vipIcon.ZIndex = 7
vipIcon.Parent = vipCard

local vipTitle = Instance.new("TextLabel")
vipTitle.Size = UDim2.new(0, 160, 0, 22)
vipTitle.Position = UDim2.new(0, 62, 0, 8)
vipTitle.BackgroundTransparency = 1
vipTitle.Text = "VIP"
vipTitle.TextColor3 = Color3.new(1,1,1)
vipTitle.Font = Enum.Font.GothamBlack
vipTitle.TextSize = 15
vipTitle.TextXAlignment = Enum.TextXAlignment.Left
vipTitle.ZIndex = 7
vipTitle.Parent = vipCard

local vipDesc = Instance.new("TextLabel")
vipDesc.Size = UDim2.new(0, 160, 0, 24)
vipDesc.Position = UDim2.new(0, 62, 0, 30)
vipDesc.BackgroundTransparency = 1
vipDesc.Text = "Many benefits\nincluding multi!"
vipDesc.TextColor3 = Color3.fromRGB(180, 180, 180)
vipDesc.Font = Enum.Font.Gotham
vipDesc.TextSize = 11
vipDesc.TextXAlignment = Enum.TextXAlignment.Left
vipDesc.ZIndex = 7
vipDesc.Parent = vipCard

local vipBuyBtn = Instance.new("TextButton")
vipBuyBtn.Size = UDim2.new(0, 96, 0, 28)
vipBuyBtn.Position = UDim2.new(0, 62, 0, 52)
vipBuyBtn.BackgroundColor3 = Color3.fromRGB(55, 155, 55)
vipBuyBtn.BorderSizePixel = 0
vipBuyBtn.Text = "R$ 199"
vipBuyBtn.TextColor3 = Color3.new(1,1,1)
vipBuyBtn.Font = Enum.Font.GothamBold
vipBuyBtn.TextSize = 14
vipBuyBtn.ZIndex = 7
vipBuyBtn.Parent = vipCard
newCorner(vipBuyBtn, 6)

-- =============================================
-- STARTER PACK BAR
-- =============================================
local starterBar = Instance.new("Frame")
starterBar.Size = UDim2.new(1, -24, 0, 36)
starterBar.Position = UDim2.new(0, 12, 0, 286)
starterBar.BackgroundColor3 = Color3.fromRGB(48, 48, 48)
starterBar.BorderSizePixel = 0
starterBar.ZIndex = 6
starterBar.Parent = shopFrame
newCorner(starterBar, 6)
newStroke(starterBar, Color3.fromRGB(80,80,80), 2)

local starterLabel = Instance.new("TextLabel")
starterLabel.Size = UDim2.new(1, 0, 1, 0)
starterLabel.BackgroundTransparency = 1
starterLabel.Text = "STARTER PACK"
starterLabel.TextColor3 = Color3.new(1,1,1)
starterLabel.Font = Enum.Font.GothamBlack
starterLabel.TextSize = 17
starterLabel.ZIndex = 7
starterLabel.Parent = starterBar

-- Gift Player button
local giftPlayerBtn = Instance.new("TextButton")
giftPlayerBtn.Size = UDim2.new(0, 148, 0, 36)
giftPlayerBtn.Position = UDim2.new(1, -160, 0, 334)
giftPlayerBtn.BackgroundColor3 = Color3.fromRGB(25, 60, 25)
giftPlayerBtn.BorderSizePixel = 0
giftPlayerBtn.Text = "Gift Player"
giftPlayerBtn.TextColor3 = Color3.new(1,1,1)
giftPlayerBtn.Font = Enum.Font.GothamBold
giftPlayerBtn.TextSize = 14
giftPlayerBtn.ZIndex = 7
giftPlayerBtn.Parent = shopFrame
newCorner(giftPlayerBtn, 6)
newStroke(giftPlayerBtn, Color3.fromRGB(76,175,80), 2)

-- =============================================
-- GIFT PLAYER FRAME
-- =============================================
local giftFrame = Instance.new("Frame")
giftFrame.Size = UDim2.new(0, 340, 0, 260)
giftFrame.Position = UDim2.new(0.5, -170, 0.5, -130)
giftFrame.BackgroundColor3 = Color3.fromRGB(22, 40, 22)
giftFrame.BorderSizePixel = 0
giftFrame.Visible = false
giftFrame.ZIndex = 10
giftFrame.Parent = screenGui
newCorner(giftFrame, 8)
newStroke(giftFrame, Color3.fromRGB(76,175,80), 3)

local giftHeader = Instance.new("Frame")
giftHeader.Size = UDim2.new(1, 0, 0, 44)
giftHeader.BackgroundColor3 = Color3.fromRGB(14, 28, 14)
giftHeader.BorderSizePixel = 0
giftHeader.ZIndex = 11
giftHeader.Parent = giftFrame
newCorner(giftHeader, 6)

local giftTitle = Instance.new("TextLabel")
giftTitle.Size = UDim2.new(1, 0, 1, 0)
giftTitle.BackgroundTransparency = 1
giftTitle.Text = "GIFT PLAYER"
giftTitle.TextColor3 = Color3.new(1,1,1)
giftTitle.Font = Enum.Font.GothamBlack
giftTitle.TextSize = 17
giftTitle.ZIndex = 12
giftTitle.Parent = giftHeader

local giftClose = Instance.new("TextButton")
giftClose.Size = UDim2.new(0, 32, 0, 28)
giftClose.Position = UDim2.new(1, -38, 0.5, -14)
giftClose.BackgroundColor3 = Color3.fromRGB(204, 40, 40)
giftClose.BorderSizePixel = 0
giftClose.Text = "X"
giftClose.TextColor3 = Color3.new(1,1,1)
giftClose.Font = Enum.Font.GothamBold
giftClose.TextSize = 13
giftClose.ZIndex = 12
giftClose.Parent = giftHeader
newCorner(giftClose, 5)

local giftScroll = Instance.new("ScrollingFrame")
giftScroll.Size = UDim2.new(1, -16, 1, -54)
giftScroll.Position = UDim2.new(0, 8, 0, 50)
giftScroll.BackgroundColor3 = Color3.fromRGB(14, 26, 14)
giftScroll.BorderSizePixel = 0
giftScroll.ScrollBarThickness = 4
giftScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
giftScroll.ZIndex = 11
giftScroll.Parent = giftFrame
newCorner(giftScroll, 4)

local giftLayout = Instance.new("UIListLayout")
giftLayout.SortOrder = Enum.SortOrder.LayoutOrder
giftLayout.Padding = UDim.new(0, 6)
giftLayout.Parent = giftScroll

local giftPadding = Instance.new("UIPadding")
giftPadding.PaddingTop = UDim.new(0, 4)
giftPadding.PaddingLeft = UDim.new(0, 4)
giftPadding.PaddingRight = UDim.new(0, 4)
giftPadding.Parent = giftScroll

-- =============================================
-- BUY ITEM FRAME
-- =============================================
local buyFrame = Instance.new("Frame")
buyFrame.Size = UDim2.new(0, 380, 0, 175)
buyFrame.Position = UDim2.new(0.5, -190, 0.5, -87)
buyFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 32)
buyFrame.BorderSizePixel = 0
buyFrame.Visible = false
buyFrame.ZIndex = 15
buyFrame.Parent = screenGui
newCorner(buyFrame, 10)
newStroke(buyFrame, Color3.fromRGB(80,80,100), 3)

local buyHeader = Instance.new("Frame")
buyHeader.Size = UDim2.new(1, 0, 0, 44)
buyHeader.BackgroundColor3 = Color3.fromRGB(14, 14, 24)
buyHeader.BorderSizePixel = 0
buyHeader.ZIndex = 16
buyHeader.Parent = buyFrame
newCorner(buyHeader, 8)

local buyTitleLbl = Instance.new("TextLabel")
buyTitleLbl.Size = UDim2.new(0, 90, 1, 0)
buyTitleLbl.Position = UDim2.new(0, 10, 0, 0)
buyTitleLbl.BackgroundTransparency = 1
buyTitleLbl.Text = "Buy item"
buyTitleLbl.TextColor3 = Color3.new(1,1,1)
buyTitleLbl.Font = Enum.Font.GothamBlack
buyTitleLbl.TextSize = 16
buyTitleLbl.TextXAlignment = Enum.TextXAlignment.Left
buyTitleLbl.ZIndex = 17
buyTitleLbl.Parent = buyHeader

local balanceLabel = Instance.new("TextLabel")
balanceLabel.Size = UDim2.new(0, 140, 1, 0)
balanceLabel.Position = UDim2.new(1, -190, 0, 0)
balanceLabel.BackgroundTransparency = 1
balanceLabel.Text = "R$ " .. formatNumber(balance)
balanceLabel.TextColor3 = Color3.new(1,1,1)
balanceLabel.Font = Enum.Font.GothamBold
balanceLabel.TextSize = 14
balanceLabel.TextXAlignment = Enum.TextXAlignment.Right
balanceLabel.ZIndex = 17
balanceLabel.Parent = buyHeader

local buyClose = Instance.new("TextButton")
buyClose.Size = UDim2.new(0, 30, 0, 26)
buyClose.Position = UDim2.new(1, -36, 0.5, -13)
buyClose.BackgroundColor3 = Color3.fromRGB(204, 40, 40)
buyClose.BorderSizePixel = 0
buyClose.Text = "X"
buyClose.TextColor3 = Color3.new(1,1,1)
buyClose.Font = Enum.Font.GothamBold
buyClose.TextSize = 13
buyClose.ZIndex = 17
buyClose.Parent = buyHeader
newCorner(buyClose, 5)

local hdBox = Instance.new("Frame")
hdBox.Size = UDim2.new(0, 56, 0, 56)
hdBox.Position = UDim2.new(0, 16, 0, 52)
hdBox.BackgroundColor3 = Color3.fromRGB(85, 85, 85)
hdBox.BorderSizePixel = 0
hdBox.ZIndex = 16
hdBox.Parent = buyFrame
newCorner(hdBox, 6)

local hdLabel = Instance.new("TextLabel")
hdLabel.Size = UDim2.new(1, 0, 1, 0)
hdLabel.BackgroundTransparency = 1
hdLabel.Text = "HD"
hdLabel.TextColor3 = Color3.new(1,1,1)
hdLabel.Font = Enum.Font.GothamBlack
hdLabel.TextSize = 20
hdLabel.ZIndex = 17
hdLabel.Parent = hdBox

local buyItemNameLabel = Instance.new("TextLabel")
buyItemNameLabel.Size = UDim2.new(0, 270, 0, 24)
buyItemNameLabel.Position = UDim2.new(0, 82, 0, 54)
buyItemNameLabel.BackgroundTransparency = 1
buyItemNameLabel.Text = "[GIFT] ADMIN PANEL"
buyItemNameLabel.TextColor3 = Color3.new(1,1,1)
buyItemNameLabel.Font = Enum.Font.GothamBold
buyItemNameLabel.TextSize = 14
buyItemNameLabel.TextXAlignment = Enum.TextXAlignment.Left
buyItemNameLabel.ZIndex = 16
buyItemNameLabel.Parent = buyFrame

local buyItemPriceLabel = Instance.new("TextLabel")
buyItemPriceLabel.Size = UDim2.new(0, 270, 0, 20)
buyItemPriceLabel.Position = UDim2.new(0, 82, 0, 78)
buyItemPriceLabel.BackgroundTransparency = 1
buyItemPriceLabel.Text = "R$ 7,499"
buyItemPriceLabel.TextColor3 = Color3.new(1,1,1)
buyItemPriceLabel.Font = Enum.Font.GothamBold
buyItemPriceLabel.TextSize = 13
buyItemPriceLabel.TextXAlignment = Enum.TextXAlignment.Left
buyItemPriceLabel.ZIndex = 16
buyItemPriceLabel.Parent = buyFrame

local buyConfirmBtn = Instance.new("TextButton")
buyConfirmBtn.Size = UDim2.new(1, -32, 0, 40)
buyConfirmBtn.Position = UDim2.new(0, 16, 0, 122)
buyConfirmBtn.BackgroundColor3 = Color3.fromRGB(58, 98, 240)
buyConfirmBtn.BorderSizePixel = 0
buyConfirmBtn.Text = "Buy"
buyConfirmBtn.TextColor3 = Color3.new(1,1,1)
buyConfirmBtn.Font = Enum.Font.GothamBlack
buyConfirmBtn.TextSize = 18
buyConfirmBtn.ZIndex = 16
buyConfirmBtn.Parent = buyFrame
newCorner(buyConfirmBtn, 8)

-- =============================================
-- PURCHASE COMPLETE FRAME
-- =============================================
local completeFrame = Instance.new("Frame")
completeFrame.Size = UDim2.new(0, 380, 0, 220)
completeFrame.Position = UDim2.new(0.5, -190, 0.5, -110)
completeFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 32)
completeFrame.BorderSizePixel = 0
completeFrame.Visible = false
completeFrame.ZIndex = 20
completeFrame.Parent = screenGui
newCorner(completeFrame, 10)
newStroke(completeFrame, Color3.fromRGB(80,80,100), 3)

local completeHeader = Instance.new("Frame")
completeHeader.Size = UDim2.new(1, 0, 0, 44)
completeHeader.BackgroundColor3 = Color3.fromRGB(14, 14, 24)
completeHeader.BorderSizePixel = 0
completeHeader.ZIndex = 21
completeHeader.Parent = completeFrame
newCorner(completeHeader, 8)

local completeTitleLbl = Instance.new("TextLabel")
completeTitleLbl.Size = UDim2.new(1, -50, 1, 0)
completeTitleLbl.Position = UDim2.new(0, 10, 0, 0)
completeTitleLbl.BackgroundTransparency = 1
completeTitleLbl.Text = "Purchase completed"
completeTitleLbl.TextColor3 = Color3.new(1,1,1)
completeTitleLbl.Font = Enum.Font.GothamBlack
completeTitleLbl.TextSize = 16
completeTitleLbl.TextXAlignment = Enum.TextXAlignment.Left
completeTitleLbl.ZIndex = 22
completeTitleLbl.Parent = completeHeader

local completeClose = Instance.new("TextButton")
completeClose.Size = UDim2.new(0, 30, 0, 26)
completeClose.Position = UDim2.new(1, -36, 0.5, -13)
completeClose.BackgroundColor3 = Color3.fromRGB(204, 40, 40)
completeClose.BorderSizePixel = 0
completeClose.Text = "X"
completeClose.TextColor3 = Color3.new(1,1,1)
completeClose.Font = Enum.Font.GothamBold
completeClose.TextSize = 13
completeClose.ZIndex = 22
completeClose.Parent = completeHeader
newCorner(completeClose, 5)

local checkRing = Instance.new("Frame")
checkRing.Size = UDim2.new(0, 62, 0, 62)
checkRing.Position = UDim2.new(0.5, -31, 0, 54)
checkRing.BackgroundTransparency = 1
checkRing.ZIndex = 21
checkRing.Parent = completeFrame
newCorner(checkRing, 31)
newStroke(checkRing, Color3.fromRGB(150,150,150), 3)

local checkMark = Instance.new("TextLabel")
checkMark.Size = UDim2.new(1, 0, 1, 0)
checkMark.BackgroundTransparency = 1
checkMark.Text = "V"
checkMark.TextColor3 = Color3.fromRGB(150, 150, 150)
checkMark.Font = Enum.Font.GothamBlack
checkMark.TextSize = 28
checkMark.ZIndex = 22
checkMark.Parent = checkRing

local completeText = Instance.new("TextLabel")
completeText.Size = UDim2.new(1, -30, 0, 44)
completeText.Position = UDim2.new(0, 15, 0, 124)
completeText.BackgroundTransparency = 1
completeText.Text = "You have successfully gifted [GIFT] ADMIN PANEL to PlayerName."
completeText.TextColor3 = Color3.new(1,1,1)
completeText.Font = Enum.Font.Gotham
completeText.TextSize = 13
completeText.TextWrapped = true
completeText.ZIndex = 21
completeText.Parent = completeFrame

local okBtn = Instance.new("TextButton")
okBtn.Size = UDim2.new(1, -32, 0, 40)
okBtn.Position = UDim2.new(0, 16, 0, 172)
okBtn.BackgroundColor3 = Color3.fromRGB(58, 98, 240)
okBtn.BorderSizePixel = 0
okBtn.Text = "OK"
okBtn.TextColor3 = Color3.new(1,1,1)
okBtn.Font = Enum.Font.GothamBlack
okBtn.TextSize = 18
okBtn.ZIndex = 21
okBtn.Parent = completeFrame
newCorner(okBtn, 8)

-- =============================================
-- RAINBOW ANIMATION
-- =============================================
local rainbowColors = {
	Color3.fromRGB(255, 0, 0),
	Color3.fromRGB(255, 120, 0),
	Color3.fromRGB(255, 255, 0),
	Color3.fromRGB(0, 255, 0),
	Color3.fromRGB(0, 140, 255),
	Color3.fromRGB(160, 0, 255),
	Color3.fromRGB(255, 0, 160),
}
local rainbowT = 0
RunService.Heartbeat:Connect(function(dt)
	rainbowT = rainbowT + dt * 2.5
	local total = #rainbowColors
	local i = math.floor(rainbowT) % total + 1
	local j = i % total + 1
	local frac = rainbowT % 1
	rainbowLabel.TextColor3 = rainbowColors[i]:Lerp(rainbowColors[j], frac)
end)

-- =============================================
-- POPULATE GIFT LIST
-- =============================================
local function populateGiftList()
	for _, child in ipairs(giftScroll:GetChildren()) do
		if child:IsA("Frame") then
			child:Destroy()
		end
	end

	local others = {}
	for _, p in ipairs(Players:GetPlayers()) do
		if p ~= localPlayer then
			table.insert(others, p)
		end
	end

	if #others == 0 then
		local emptyF = Instance.new("Frame")
		emptyF.Size = UDim2.new(1, 0, 0, 120)
		emptyF.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
		emptyF.BorderSizePixel = 0
		emptyF.ZIndex = 12
		emptyF.Parent = giftScroll
		newCorner(emptyF, 6)
		giftScroll.CanvasSize = UDim2.new(0, 0, 0, 130)
		return
	end

	for _, p in ipairs(others) do
		local row = Instance.new("Frame")
		row.Size = UDim2.new(1, 0, 0, 52)
		row.BackgroundColor3 = Color3.fromRGB(30, 50, 30)
		row.BorderSizePixel = 0
		row.ZIndex = 12
		row.Parent = giftScroll
		newCorner(row, 6)
		newStroke(row, Color3.fromRGB(50,80,50), 1)

		local avatar = Instance.new("ImageLabel")
		avatar.Size = UDim2.new(0, 38, 0, 38)
		avatar.Position = UDim2.new(0, 8, 0.5, -19)
		avatar.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
		avatar.BorderSizePixel = 0
		avatar.Image = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. p.UserId .. "&width=420&height=420&format=png"
		avatar.ZIndex = 13
		avatar.Parent = row
		newCorner(avatar, 4)

		local nameLabel = Instance.new("TextLabel")
		nameLabel.Size = UDim2.new(1, -100, 1, 0)
		nameLabel.Position = UDim2.new(0, 54, 0, 0)
		nameLabel.BackgroundTransparency = 1
		nameLabel.Text = p.Name
		nameLabel.TextColor3 = Color3.new(1,1,1)
		nameLabel.Font = Enum.Font.GothamBold
		nameLabel.TextSize = 14
		nameLabel.TextXAlignment = Enum.TextXAlignment.Left
		nameLabel.ZIndex = 13
		nameLabel.Parent = row

		local giftBtn = Instance.new("TextButton")
		giftBtn.Size = UDim2.new(0, 36, 0, 36)
		giftBtn.Position = UDim2.new(1, -44, 0.5, -18)
		giftBtn.BackgroundColor3 = Color3.fromRGB(28, 68, 28)
		giftBtn.BorderSizePixel = 0
		giftBtn.Text = "[G]"
		giftBtn.TextColor3 = Color3.new(1,1,1)
		giftBtn.Font = Enum.Font.GothamBold
		giftBtn.TextSize = 11
		giftBtn.ZIndex = 13
		giftBtn.Parent = row
		newCorner(giftBtn, 5)
		newStroke(giftBtn, Color3.fromRGB(76,175,80), 2)

		-- Click gift button: save player, close gift, reopen shop
		local pRef = p
		giftBtn.MouseButton1Click:Connect(function()
			selectedPlayer = pRef.Name
			giftFrame.Visible = false
			shopFrame.Visible = true
		end)
	end

	giftScroll.CanvasSize = UDim2.new(0, 0, 0, math.max(130, #others * 62))
end

-- =============================================
-- CONNECTIONS
-- =============================================

-- Open shop
openBtn.MouseButton1Click:Connect(function()
	shopFrame.Visible = true
end)

-- Close shop
shopCloseBtn.MouseButton1Click:Connect(function()
	shopFrame.Visible = false
end)

-- Open gift player list
giftPlayerBtn.MouseButton1Click:Connect(function()
	populateGiftList()
	shopFrame.Visible = false
	giftFrame.Visible = true
end)

-- Close gift -> back to shop
giftClose.MouseButton1Click:Connect(function()
	giftFrame.Visible = false
	shopFrame.Visible = true
end)

-- Admin buy button -> open buy frame
adminBuyBtn.MouseButton1Click:Connect(function()
	currentItemName = "ADMIN PANEL"
	currentItemPrice = 7499
	buyItemNameLabel.Text = "[GIFT] ADMIN PANEL"
	buyItemPriceLabel.Text = "R$ " .. formatNumber(currentItemPrice)
	balanceLabel.Text = "R$ " .. formatNumber(balance)
	shopFrame.Visible = false
	buyFrame.Visible = true
end)

-- 2X Money buy button -> open buy frame
moneyBuyBtn.MouseButton1Click:Connect(function()
	currentItemName = "2X MONEY"
	currentItemPrice = 119
	buyItemNameLabel.Text = "[GIFT] 2X MONEY"
	buyItemPriceLabel.Text = "R$ " .. formatNumber(currentItemPrice)
	balanceLabel.Text = "R$ " .. formatNumber(balance)
	shopFrame.Visible = false
	buyFrame.Visible = true
end)

-- VIP buy button -> open buy frame
vipBuyBtn.MouseButton1Click:Connect(function()
	currentItemName = "VIP"
	currentItemPrice = 199
	buyItemNameLabel.Text = "[GIFT] VIP"
	buyItemPriceLabel.Text = "R$ " .. formatNumber(currentItemPrice)
	balanceLabel.Text = "R$ " .. formatNumber(balance)
	shopFrame.Visible = false
	buyFrame.Visible = true
end)

-- Close buy -> back to shop
buyClose.MouseButton1Click:Connect(function()
	buyFrame.Visible = false
	shopFrame.Visible = true
end)

-- Confirm purchase
buyConfirmBtn.MouseButton1Click:Connect(function()
	if balance >= currentItemPrice then
		balance = balance - currentItemPrice
	end
	buyFrame.Visible = false
	local recipientName = selectedPlayer or "Unknown"
	completeText.Text = "You have successfully gifted [GIFT] " .. currentItemName .. " to " .. recipientName .. "."
	completeFrame.Visible = true
end)

-- Close complete
completeClose.MouseButton1Click:Connect(function()
	completeFrame.Visible = false
end)

okBtn.MouseButton1Click:Connect(function()
	completeFrame.Visible = false
end)
