-- txt.lua
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
		if count > 0 and count % 3 == 0 then result = "," .. result end
		result = s:sub(i, i) .. result
		count = count + 1
	end
	return result
end

local function Corner(p, r)
	local c = Instance.new("UICorner")
	c.CornerRadius = UDim.new(0, r or 6)
	c.Parent = p
end

local function Stroke(p, col, t)
	local s = Instance.new("UIStroke")
	s.Color = col
	s.Thickness = t or 2
	s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	s.Parent = s
	s.Parent = p
end

local sg = Instance.new("ScreenGui")
sg.Name = "ShopGUI"
sg.ResetOnSpawn = false
sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
sg.IgnoreGuiInset = true
sg.Parent = localPlayer:WaitForChild("PlayerGui")

-- ============================================================
-- OPEN BUTTON
-- ============================================================
local openBtn = Instance.new("TextButton")
openBtn.Size = UDim2.new(0, 42, 0, 110)
openBtn.Position = UDim2.new(0, 6, 0.5, -55)
openBtn.BackgroundColor3 = Color3.fromRGB(40, 130, 40)
openBtn.BorderSizePixel = 0
openBtn.Text = "SHOP"
openBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
openBtn.Font = Enum.Font.GothamBlack
openBtn.TextSize = 14
openBtn.ZIndex = 5
openBtn.Parent = sg
Corner(openBtn, 6)

-- ============================================================
-- SHOP FRAME
-- Image 1: dark teal-green background, slightly lighter card backgrounds
-- Header bar is same dark color
-- ============================================================
local shopBG = Color3.fromRGB(13, 43, 26)       -- very dark green-teal (main background)
local cardBG = Color3.fromRGB(16, 54, 32)        -- slightly lighter for cards
local cardBG2 = Color3.fromRGB(11, 38, 22)       -- admin panel card bg (darker)
local greenBtn = Color3.fromRGB(50, 160, 50)     -- bright green buttons
local headerBG = Color3.fromRGB(13, 43, 26)      -- same as main bg

local shopFrame = Instance.new("Frame")
shopFrame.Size = UDim2.new(0, 520, 0, 410)
shopFrame.Position = UDim2.new(0.5, -260, 0.5, -205)
shopFrame.BackgroundColor3 = shopBG
shopFrame.BorderSizePixel = 0
shopFrame.Visible = false
shopFrame.ZIndex = 10
shopFrame.Parent = sg
Corner(shopFrame, 8)

-- header row
local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 50)
header.BackgroundColor3 = headerBG
header.BorderSizePixel = 0
header.ZIndex = 11
header.Parent = shopFrame

-- SHOP label
local shopLbl = Instance.new("TextLabel")
shopLbl.Size = UDim2.new(0, 100, 1, 0)
shopLbl.Position = UDim2.new(0, 10, 0, 0)
shopLbl.BackgroundTransparency = 1
shopLbl.Text = "SHOP"
shopLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
shopLbl.Font = Enum.Font.GothamBlack
shopLbl.TextSize = 26
shopLbl.ZIndex = 12
shopLbl.Parent = header

-- GEAR tab (brown/tan color from image)
local gearTab = Instance.new("TextButton")
gearTab.Size = UDim2.new(0, 108, 0, 34)
gearTab.Position = UDim2.new(0, 104, 0.5, -17)
gearTab.BackgroundColor3 = Color3.fromRGB(155, 100, 20)
gearTab.BorderSizePixel = 0
gearTab.Text = "GEAR"
gearTab.TextColor3 = Color3.fromRGB(255, 255, 255)
gearTab.Font = Enum.Font.GothamBold
gearTab.TextSize = 14
gearTab.ZIndex = 12
gearTab.Parent = header
Corner(gearTab, 5)

-- GAMEPASSES tab (medium green from image)
local gpTab = Instance.new("TextButton")
gpTab.Size = UDim2.new(0, 148, 0, 34)
gpTab.Position = UDim2.new(0, 220, 0.5, -17)
gpTab.BackgroundColor3 = Color3.fromRGB(45, 110, 45)
gpTab.BorderSizePixel = 0
gpTab.Text = "GAMEPASSES"
gpTab.TextColor3 = Color3.fromRGB(255, 255, 255)
gpTab.Font = Enum.Font.GothamBold
gpTab.TextSize = 14
gpTab.ZIndex = 12
gpTab.Parent = header
Corner(gpTab, 5)

-- MONEY tab (bright green from image)
local moneyTab = Instance.new("TextButton")
moneyTab.Size = UDim2.new(0, 100, 0, 34)
moneyTab.Position = UDim2.new(0, 376, 0.5, -17)
moneyTab.BackgroundColor3 = Color3.fromRGB(50, 160, 50)
moneyTab.BorderSizePixel = 0
moneyTab.Text = "MONEY"
moneyTab.TextColor3 = Color3.fromRGB(255, 255, 255)
moneyTab.Font = Enum.Font.GothamBold
moneyTab.TextSize = 14
moneyTab.ZIndex = 12
moneyTab.Parent = header
Corner(moneyTab, 5)

-- X close button (red from image)
local shopClose = Instance.new("TextButton")
shopClose.Size = UDim2.new(0, 40, 0, 34)
shopClose.Position = UDim2.new(1, -48, 0.5, -17)
shopClose.BackgroundColor3 = Color3.fromRGB(200, 40, 40)
shopClose.BorderSizePixel = 0
shopClose.Text = "X"
shopClose.TextColor3 = Color3.fromRGB(255, 255, 255)
shopClose.Font = Enum.Font.GothamBold
shopClose.TextSize = 18
shopClose.ZIndex = 12
shopClose.Parent = header
Corner(shopClose, 5)

-- GAMEPASSES section label (white text, same dark bg)
local gpSectionLbl = Instance.new("TextLabel")
gpSectionLbl.Size = UDim2.new(1, 0, 0, 32)
gpSectionLbl.Position = UDim2.new(0, 0, 0, 50)
gpSectionLbl.BackgroundColor3 = shopBG
gpSectionLbl.BorderSizePixel = 0
gpSectionLbl.Text = "GAMEPASSES"
gpSectionLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
gpSectionLbl.Font = Enum.Font.GothamBlack
gpSectionLbl.TextSize = 18
gpSectionLbl.ZIndex = 11
gpSectionLbl.Parent = shopFrame

-- ============================================================
-- ADMIN PANEL CARD (image 1: darker card, white title, rainbow subtitle, gray AP box, strikethrough worth, green price btn)
-- ============================================================
local adminCard = Instance.new("Frame")
adminCard.Size = UDim2.new(1, -20, 0, 94)
adminCard.Position = UDim2.new(0, 10, 0, 88)
adminCard.BackgroundColor3 = cardBG2
adminCard.BorderSizePixel = 0
adminCard.ZIndex = 11
adminCard.Parent = shopFrame
Corner(adminCard, 7)

-- ADMIN PANEL white bold text
local adminTitleLbl = Instance.new("TextLabel")
adminTitleLbl.Size = UDim2.new(0, 220, 0, 26)
adminTitleLbl.Position = UDim2.new(0, 10, 0, 8)
adminTitleLbl.BackgroundTransparency = 1
adminTitleLbl.Text = "ADMIN PANEL"
adminTitleLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
adminTitleLbl.Font = Enum.Font.GothamBlack
adminTitleLbl.TextSize = 18
adminTitleLbl.TextXAlignment = Enum.TextXAlignment.Left
adminTitleLbl.ZIndex = 12
adminTitleLbl.Parent = adminCard

-- Get Admin Commands rainbow animated
local rainbowLbl = Instance.new("TextLabel")
rainbowLbl.Size = UDim2.new(0, 220, 0, 20)
rainbowLbl.Position = UDim2.new(0, 10, 0, 34)
rainbowLbl.BackgroundTransparency = 1
rainbowLbl.Text = "Get Admin Commands"
rainbowLbl.TextColor3 = Color3.fromRGB(255, 80, 80)
rainbowLbl.Font = Enum.Font.GothamBold
rainbowLbl.TextSize = 13
rainbowLbl.TextXAlignment = Enum.TextXAlignment.Left
rainbowLbl.ZIndex = 12
rainbowLbl.Parent = adminCard

-- Type ;cmds text
local cmdsTxt = Instance.new("TextLabel")
cmdsTxt.Size = UDim2.new(0, 220, 0, 30)
cmdsTxt.Position = UDim2.new(0, 10, 0, 54)
cmdsTxt.BackgroundTransparency = 1
cmdsTxt.Text = "Type ;cmds in chat for\na list of commands!"
cmdsTxt.TextColor3 = Color3.fromRGB(220, 220, 220)
cmdsTxt.Font = Enum.Font.Gotham
cmdsTxt.TextSize = 11
cmdsTxt.TextXAlignment = Enum.TextXAlignment.Left
cmdsTxt.ZIndex = 12
cmdsTxt.Parent = adminCard

-- AP gray box (metallic silver-gray like image)
local apFrame = Instance.new("Frame")
apFrame.Size = UDim2.new(0, 68, 0, 68)
apFrame.Position = UDim2.new(0, 232, 0, 13)
apFrame.BackgroundColor3 = Color3.fromRGB(160, 160, 165)
apFrame.BorderSizePixel = 0
apFrame.ZIndex = 12
apFrame.Parent = adminCard
Corner(apFrame, 6)

local apLbl = Instance.new("TextLabel")
apLbl.Size = UDim2.new(1, 0, 1, 0)
apLbl.BackgroundTransparency = 1
apLbl.Text = "AP"
apLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
apLbl.Font = Enum.Font.GothamBlack
apLbl.TextSize = 28
apLbl.ZIndex = 13
apLbl.Parent = apFrame

-- Worth text with line through it
local worthLbl = Instance.new("TextLabel")
worthLbl.Size = UDim2.new(0, 140, 0, 20)
worthLbl.Position = UDim2.new(0, 312, 0, 8)
worthLbl.BackgroundTransparency = 1
worthLbl.Text = "Worth  9999"
worthLbl.TextColor3 = Color3.fromRGB(200, 200, 200)
worthLbl.Font = Enum.Font.GothamBold
worthLbl.TextSize = 13
worthLbl.ZIndex = 12
worthLbl.Parent = adminCard

-- strikethrough line over Worth label
local strikeLine = Instance.new("Frame")
strikeLine.Size = UDim2.new(0, 136, 0, 2)
strikeLine.Position = UDim2.new(0, 314, 0, 17)
strikeLine.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
strikeLine.BorderSizePixel = 0
strikeLine.ZIndex = 13
strikeLine.Parent = adminCard

-- Green price button (7,499)
local adminBuyBtn = Instance.new("TextButton")
adminBuyBtn.Size = UDim2.new(0, 122, 0, 38)
adminBuyBtn.Position = UDim2.new(0, 314, 0, 38)
adminBuyBtn.BackgroundColor3 = greenBtn
adminBuyBtn.BorderSizePixel = 0
adminBuyBtn.Text = "R$ 7,499"
adminBuyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
adminBuyBtn.Font = Enum.Font.GothamBold
adminBuyBtn.TextSize = 17
adminBuyBtn.ZIndex = 12
adminBuyBtn.Parent = adminCard
Corner(adminBuyBtn, 6)

-- ============================================================
-- 2X MONEY CARD (left half, image 1)
-- ============================================================
local moneyCard = Instance.new("Frame")
moneyCard.Size = UDim2.new(0, 240, 0, 84)
moneyCard.Position = UDim2.new(0, 10, 0, 194)
moneyCard.BackgroundColor3 = cardBG2
moneyCard.BorderSizePixel = 0
moneyCard.ZIndex = 11
moneyCard.Parent = shopFrame
Corner(moneyCard, 7)

-- cash icon area
local cashIconLbl = Instance.new("TextLabel")
cashIconLbl.Size = UDim2.new(0, 52, 0, 52)
cashIconLbl.Position = UDim2.new(0, 6, 0.5, -26)
cashIconLbl.BackgroundTransparency = 1
cashIconLbl.Text = "$"
cashIconLbl.TextColor3 = Color3.fromRGB(50, 210, 50)
cashIconLbl.Font = Enum.Font.GothamBlack
cashIconLbl.TextSize = 36
cashIconLbl.ZIndex = 12
cashIconLbl.Parent = moneyCard

local x2Lbl = Instance.new("TextLabel")
x2Lbl.Size = UDim2.new(0, 28, 0, 18)
x2Lbl.Position = UDim2.new(0, 30, 0.5, 8)
x2Lbl.BackgroundColor3 = Color3.fromRGB(180, 30, 30)
x2Lbl.BorderSizePixel = 0
x2Lbl.Text = "x2"
x2Lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
x2Lbl.Font = Enum.Font.GothamBold
x2Lbl.TextSize = 11
x2Lbl.ZIndex = 13
x2Lbl.Parent = moneyCard
Corner(x2Lbl, 3)

local moneyTitle = Instance.new("TextLabel")
moneyTitle.Size = UDim2.new(0, 148, 0, 24)
moneyTitle.Position = UDim2.new(0, 64, 0, 8)
moneyTitle.BackgroundTransparency = 1
moneyTitle.Text = "2X MONEY"
moneyTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
moneyTitle.Font = Enum.Font.GothamBlack
moneyTitle.TextSize = 16
moneyTitle.TextXAlignment = Enum.TextXAlignment.Left
moneyTitle.ZIndex = 12
moneyTitle.Parent = moneyCard

local moneyDesc = Instance.new("TextLabel")
moneyDesc.Size = UDim2.new(0, 148, 0, 26)
moneyDesc.Position = UDim2.new(0, 64, 0, 30)
moneyDesc.BackgroundTransparency = 1
moneyDesc.Text = "Earn twice as\nmuch money!"
moneyDesc.TextColor3 = Color3.fromRGB(210, 210, 210)
moneyDesc.Font = Enum.Font.Gotham
moneyDesc.TextSize = 11
moneyDesc.TextXAlignment = Enum.TextXAlignment.Left
moneyDesc.ZIndex = 12
moneyDesc.Parent = moneyCard

local moneyBuyBtn = Instance.new("TextButton")
moneyBuyBtn.Size = UDim2.new(0, 100, 0, 30)
moneyBuyBtn.Position = UDim2.new(0, 64, 0, 52)
moneyBuyBtn.BackgroundColor3 = greenBtn
moneyBuyBtn.BorderSizePixel = 0
moneyBuyBtn.Text = "R$ 119"
moneyBuyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
moneyBuyBtn.Font = Enum.Font.GothamBold
moneyBuyBtn.TextSize = 15
moneyBuyBtn.ZIndex = 12
moneyBuyBtn.Parent = moneyCard
Corner(moneyBuyBtn, 6)

-- ============================================================
-- VIP CARD (right half, image 1)
-- ============================================================
local vipCard = Instance.new("Frame")
vipCard.Size = UDim2.new(0, 240, 0, 84)
vipCard.Position = UDim2.new(0, 270, 0, 194)
vipCard.BackgroundColor3 = cardBG2
vipCard.BorderSizePixel = 0
vipCard.ZIndex = 11
vipCard.Parent = shopFrame
Corner(vipCard, 7)

-- VIP in orange-gold like image
local vipIconLbl = Instance.new("TextLabel")
vipIconLbl.Size = UDim2.new(0, 60, 0, 60)
vipIconLbl.Position = UDim2.new(0, 6, 0.5, -30)
vipIconLbl.BackgroundTransparency = 1
vipIconLbl.Text = "VIP"
vipIconLbl.TextColor3 = Color3.fromRGB(240, 160, 20)
vipIconLbl.Font = Enum.Font.GothamBlack
vipIconLbl.TextSize = 28
vipIconLbl.ZIndex = 12
vipIconLbl.Parent = vipCard

local vipTitle = Instance.new("TextLabel")
vipTitle.Size = UDim2.new(0, 155, 0, 24)
vipTitle.Position = UDim2.new(0, 72, 0, 8)
vipTitle.BackgroundTransparency = 1
vipTitle.Text = "VIP"
vipTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
vipTitle.Font = Enum.Font.GothamBlack
vipTitle.TextSize = 16
vipTitle.TextXAlignment = Enum.TextXAlignment.Left
vipTitle.ZIndex = 12
vipTitle.Parent = vipCard

local vipDesc = Instance.new("TextLabel")
vipDesc.Size = UDim2.new(0, 155, 0, 26)
vipDesc.Position = UDim2.new(0, 72, 0, 30)
vipDesc.BackgroundTransparency = 1
vipDesc.Text = "Many benefits\nincluding multi!"
vipDesc.TextColor3 = Color3.fromRGB(210, 210, 210)
vipDesc.Font = Enum.Font.Gotham
vipDesc.TextSize = 11
vipDesc.TextXAlignment = Enum.TextXAlignment.Left
vipDesc.ZIndex = 12
vipDesc.Parent = vipCard

local vipBuyBtn = Instance.new("TextButton")
vipBuyBtn.Size = UDim2.new(0, 100, 0, 30)
vipBuyBtn.Position = UDim2.new(0, 72, 0, 52)
vipBuyBtn.BackgroundColor3 = greenBtn
vipBuyBtn.BorderSizePixel = 0
vipBuyBtn.Text = "R$ 199"
vipBuyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
vipBuyBtn.Font = Enum.Font.GothamBold
vipBuyBtn.TextSize = 15
vipBuyBtn.ZIndex = 12
vipBuyBtn.Parent = vipCard
Corner(vipBuyBtn, 6)

-- ============================================================
-- STARTER PACK bar (dark, white bold text like image)
-- ============================================================
local starterBar = Instance.new("Frame")
starterBar.Size = UDim2.new(1, -20, 0, 36)
starterBar.Position = UDim2.new(0, 10, 0, 290)
starterBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
starterBar.BorderSizePixel = 0
starterBar.ZIndex = 11
starterBar.Parent = shopFrame
Corner(starterBar, 6)

local starterLbl = Instance.new("TextLabel")
starterLbl.Size = UDim2.new(1, 0, 1, 0)
starterLbl.BackgroundTransparency = 1
starterLbl.Text = "STARTER PACK"
starterLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
starterLbl.Font = Enum.Font.GothamBlack
starterLbl.TextSize = 18
starterLbl.ZIndex = 12
starterLbl.Parent = starterBar

-- Gift Player button (dark green with gift icon, bottom right like image)
local giftPlayerBtn = Instance.new("TextButton")
giftPlayerBtn.Size = UDim2.new(0, 150, 0, 38)
giftPlayerBtn.Position = UDim2.new(1, -162, 0, 340)
giftPlayerBtn.BackgroundColor3 = Color3.fromRGB(20, 55, 20)
giftPlayerBtn.BorderSizePixel = 0
giftPlayerBtn.Text = "Gift Player"
giftPlayerBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
giftPlayerBtn.Font = Enum.Font.GothamBold
giftPlayerBtn.TextSize = 15
giftPlayerBtn.ZIndex = 12
giftPlayerBtn.Parent = shopFrame
Corner(giftPlayerBtn, 6)

-- ============================================================
-- GIFT PLAYER FRAME
-- Image 2: WHITE/LIGHT GRAY background popup, dark header with "GIFT PLAYER" white text, X red btn
-- player rows are dark green cards, empty area is medium gray
-- ============================================================
local giftFrame = Instance.new("Frame")
giftFrame.Size = UDim2.new(0, 360, 0, 320)
giftFrame.Position = UDim2.new(0.5, -180, 0.5, -160)
giftFrame.BackgroundColor3 = Color3.fromRGB(200, 205, 200)  -- light gray like image 2
giftFrame.BorderSizePixel = 0
giftFrame.Visible = false
giftFrame.ZIndex = 20
giftFrame.Parent = sg
Corner(giftFrame, 8)

-- Gift header: dark gray like image 2
local giftHeader = Instance.new("Frame")
giftHeader.Size = UDim2.new(1, 0, 0, 46)
giftHeader.BackgroundColor3 = Color3.fromRGB(55, 60, 55)
giftHeader.BorderSizePixel = 0
giftHeader.ZIndex = 21
giftHeader.Parent = giftFrame
Corner(giftHeader, 6)

local giftTitleLbl = Instance.new("TextLabel")
giftTitleLbl.Size = UDim2.new(1, -60, 1, 0)
giftTitleLbl.Position = UDim2.new(0, 10, 0, 0)
giftTitleLbl.BackgroundTransparency = 1
giftTitleLbl.Text = "GIFT PLAYER"
giftTitleLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
giftTitleLbl.Font = Enum.Font.GothamBlack
giftTitleLbl.TextSize = 18
giftTitleLbl.ZIndex = 22
giftTitleLbl.Parent = giftHeader

local giftClose = Instance.new("TextButton")
giftClose.Size = UDim2.new(0, 34, 0, 30)
giftClose.Position = UDim2.new(1, -40, 0.5, -15)
giftClose.BackgroundColor3 = Color3.fromRGB(200, 40, 40)
giftClose.BorderSizePixel = 0
giftClose.Text = "X"
giftClose.TextColor3 = Color3.fromRGB(255, 255, 255)
giftClose.Font = Enum.Font.GothamBold
giftClose.TextSize = 16
giftClose.ZIndex = 22
giftClose.Parent = giftHeader
Corner(giftClose, 5)

-- Scroll area for players
local giftScroll = Instance.new("ScrollingFrame")
giftScroll.Size = UDim2.new(1, -16, 1, -56)
giftScroll.Position = UDim2.new(0, 8, 0, 52)
giftScroll.BackgroundColor3 = Color3.fromRGB(160, 165, 160)  -- medium gray like image 2 empty area
giftScroll.BorderSizePixel = 0
giftScroll.ScrollBarThickness = 4
giftScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
giftScroll.ZIndex = 21
giftScroll.Parent = giftFrame
Corner(giftScroll, 4)

local giftLayout = Instance.new("UIListLayout")
giftLayout.SortOrder = Enum.SortOrder.LayoutOrder
giftLayout.Padding = UDim.new(0, 6)
giftLayout.Parent = giftScroll

local giftPad = Instance.new("UIPadding")
giftPad.PaddingTop = UDim.new(0, 6)
giftPad.PaddingLeft = UDim.new(0, 4)
giftPad.PaddingRight = UDim.new(0, 4)
giftPad.Parent = giftScroll

-- ============================================================
-- BUY ITEM FRAME
-- Image 3: dark charcoal background (#2a2a2a), white text, blue buy button
-- ============================================================
local buyFrame = Instance.new("Frame")
buyFrame.Size = UDim2.new(0, 380, 0, 175)
buyFrame.Position = UDim2.new(0.5, -190, 0.5, -87)
buyFrame.BackgroundColor3 = Color3.fromRGB(38, 38, 42)   -- dark charcoal like image 3
buyFrame.BorderSizePixel = 0
buyFrame.Visible = false
buyFrame.ZIndex = 30
buyFrame.Parent = sg
Corner(buyFrame, 10)

local buyHeader = Instance.new("Frame")
buyHeader.Size = UDim2.new(1, 0, 0, 44)
buyHeader.BackgroundColor3 = Color3.fromRGB(28, 28, 32)  -- slightly darker header
buyHeader.BorderSizePixel = 0
buyHeader.ZIndex = 31
buyHeader.Parent = buyFrame
Corner(buyHeader, 8)

local buyTitleLbl = Instance.new("TextLabel")
buyTitleLbl.Size = UDim2.new(0, 100, 1, 0)
buyTitleLbl.Position = UDim2.new(0, 12, 0, 0)
buyTitleLbl.BackgroundTransparency = 1
buyTitleLbl.Text = "Buy item"
buyTitleLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
buyTitleLbl.Font = Enum.Font.GothamBold
buyTitleLbl.TextSize = 16
buyTitleLbl.TextXAlignment = Enum.TextXAlignment.Left
buyTitleLbl.ZIndex = 32
buyTitleLbl.Parent = buyHeader

-- Robux balance top right of buy frame header
local balanceLbl = Instance.new("TextLabel")
balanceLbl.Size = UDim2.new(0, 130, 1, 0)
balanceLbl.Position = UDim2.new(1, -190, 0, 0)
balanceLbl.BackgroundTransparency = 1
balanceLbl.Text = "R$ " .. formatNumber(balance)
balanceLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
balanceLbl.Font = Enum.Font.GothamBold
balanceLbl.TextSize = 14
balanceLbl.TextXAlignment = Enum.TextXAlignment.Right
balanceLbl.ZIndex = 32
balanceLbl.Parent = buyHeader

local buyClose = Instance.new("TextButton")
buyClose.Size = UDim2.new(0, 30, 0, 26)
buyClose.Position = UDim2.new(1, -36, 0.5, -13)
buyClose.BackgroundTransparency = 1
buyClose.BorderSizePixel = 0
buyClose.Text = "X"
buyClose.TextColor3 = Color3.fromRGB(200, 200, 200)
buyClose.Font = Enum.Font.GothamBold
buyClose.TextSize = 16
buyClose.ZIndex = 32
buyClose.Parent = buyHeader

-- HD gray box
local hdBox = Instance.new("Frame")
hdBox.Size = UDim2.new(0, 58, 0, 58)
hdBox.Position = UDim2.new(0, 14, 0, 54)
hdBox.BackgroundColor3 = Color3.fromRGB(80, 82, 86)
hdBox.BorderSizePixel = 0
hdBox.ZIndex = 31
hdBox.Parent = buyFrame
Corner(hdBox, 8)

local hdLbl = Instance.new("TextLabel")
hdLbl.Size = UDim2.new(1, 0, 1, 0)
hdLbl.BackgroundTransparency = 1
hdLbl.Text = "HD"
hdLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
hdLbl.Font = Enum.Font.GothamBlack
hdLbl.TextSize = 22
hdLbl.ZIndex = 32
hdLbl.Parent = hdBox

local buyItemName = Instance.new("TextLabel")
buyItemName.Size = UDim2.new(0, 270, 0, 26)
buyItemName.Position = UDim2.new(0, 82, 0, 54)
buyItemName.BackgroundTransparency = 1
buyItemName.Text = "[GIFT] ADMIN PANEL"
buyItemName.TextColor3 = Color3.fromRGB(255, 255, 255)
buyItemName.Font = Enum.Font.GothamBold
buyItemName.TextSize = 15
buyItemName.TextXAlignment = Enum.TextXAlignment.Left
buyItemName.ZIndex = 31
buyItemName.Parent = buyFrame

local buyItemPrice = Instance.new("TextLabel")
buyItemPrice.Size = UDim2.new(0, 270, 0, 22)
buyItemPrice.Position = UDim2.new(0, 82, 0, 80)
buyItemPrice.BackgroundTransparency = 1
buyItemPrice.Text = "R$ 7,499"
buyItemPrice.TextColor3 = Color3.fromRGB(210, 210, 210)
buyItemPrice.Font = Enum.Font.GothamBold
buyItemPrice.TextSize = 13
buyItemPrice.TextXAlignment = Enum.TextXAlignment.Left
buyItemPrice.ZIndex = 31
buyItemPrice.Parent = buyFrame

-- Blue BUY button like image 3
local buyConfirmBtn = Instance.new("TextButton")
buyConfirmBtn.Size = UDim2.new(1, -28, 0, 40)
buyConfirmBtn.Position = UDim2.new(0, 14, 0, 122)
buyConfirmBtn.BackgroundColor3 = Color3.fromRGB(80, 120, 255)
buyConfirmBtn.BorderSizePixel = 0
buyConfirmBtn.Text = "Buy"
buyConfirmBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
buyConfirmBtn.Font = Enum.Font.GothamBlack
buyConfirmBtn.TextSize = 18
buyConfirmBtn.ZIndex = 31
buyConfirmBtn.Parent = buyFrame
Corner(buyConfirmBtn, 8)

-- ============================================================
-- PURCHASE COMPLETE FRAME
-- Image 4: dark charcoal background, white text, circle checkmark, blue OK button
-- ============================================================
local completeFrame = Instance.new("Frame")
completeFrame.Size = UDim2.new(0, 380, 0, 225)
completeFrame.Position = UDim2.new(0.5, -190, 0.5, -112)
completeFrame.BackgroundColor3 = Color3.fromRGB(38, 38, 42)
completeFrame.BorderSizePixel = 0
completeFrame.Visible = false
completeFrame.ZIndex = 40
completeFrame.Parent = sg
Corner(completeFrame, 10)

local completeHeader = Instance.new("Frame")
completeHeader.Size = UDim2.new(1, 0, 0, 44)
completeHeader.BackgroundColor3 = Color3.fromRGB(28, 28, 32)
completeHeader.BorderSizePixel = 0
completeHeader.ZIndex = 41
completeHeader.Parent = completeFrame
Corner(completeHeader, 8)

local completeTitleLbl = Instance.new("TextLabel")
completeTitleLbl.Size = UDim2.new(1, -50, 1, 0)
completeTitleLbl.Position = UDim2.new(0, 12, 0, 0)
completeTitleLbl.BackgroundTransparency = 1
completeTitleLbl.Text = "Purchase completed"
completeTitleLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
completeTitleLbl.Font = Enum.Font.GothamBold
completeTitleLbl.TextSize = 16
completeTitleLbl.TextXAlignment = Enum.TextXAlignment.Left
completeTitleLbl.ZIndex = 42
completeTitleLbl.Parent = completeHeader

local completeClose = Instance.new("TextButton")
completeClose.Size = UDim2.new(0, 30, 0, 26)
completeClose.Position = UDim2.new(1, -36, 0.5, -13)
completeClose.BackgroundTransparency = 1
completeClose.BorderSizePixel = 0
completeClose.Text = "X"
completeClose.TextColor3 = Color3.fromRGB(200, 200, 200)
completeClose.Font = Enum.Font.GothamBold
completeClose.TextSize = 16
completeClose.ZIndex = 42
completeClose.Parent = completeHeader

-- Circle checkmark (gray ring with checkmark inside like image 4)
local checkCircle = Instance.new("Frame")
checkCircle.Size = UDim2.new(0, 62, 0, 62)
checkCircle.Position = UDim2.new(0.5, -31, 0, 54)
checkCircle.BackgroundTransparency = 1
checkCircle.ZIndex = 41
checkCircle.Parent = completeFrame
Corner(checkCircle, 31)

local checkStroke = Instance.new("UIStroke")
checkStroke.Color = Color3.fromRGB(160, 160, 165)
checkStroke.Thickness = 3
checkStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
checkStroke.Parent = checkCircle

local checkLbl = Instance.new("TextLabel")
checkLbl.Size = UDim2.new(1, 0, 1, 0)
checkLbl.BackgroundTransparency = 1
checkLbl.Text = "V"
checkLbl.TextColor3 = Color3.fromRGB(160, 160, 165)
checkLbl.Font = Enum.Font.GothamBlack
checkLbl.TextSize = 30
checkLbl.ZIndex = 42
checkLbl.Parent = checkCircle

local completeBodyTxt = Instance.new("TextLabel")
completeBodyTxt.Size = UDim2.new(1, -30, 0, 46)
completeBodyTxt.Position = UDim2.new(0, 15, 0, 124)
completeBodyTxt.BackgroundTransparency = 1
completeBodyTxt.Text = "You have successfully gifted [GIFT] ADMIN PANEL to PlayerName."
completeBodyTxt.TextColor3 = Color3.fromRGB(220, 220, 220)
completeBodyTxt.Font = Enum.Font.Gotham
completeBodyTxt.TextSize = 13
completeBodyTxt.TextWrapped = true
completeBodyTxt.ZIndex = 41
completeBodyTxt.Parent = completeFrame

local okBtn = Instance.new("TextButton")
okBtn.Size = UDim2.new(1, -28, 0, 40)
okBtn.Position = UDim2.new(0, 14, 0, 176)
okBtn.BackgroundColor3 = Color3.fromRGB(80, 120, 255)
okBtn.BorderSizePixel = 0
okBtn.Text = "OK"
okBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
okBtn.Font = Enum.Font.GothamBlack
okBtn.TextSize = 18
okBtn.ZIndex = 41
okBtn.Parent = completeFrame
Corner(okBtn, 8)

-- ============================================================
-- RAINBOW ANIMATION
-- ============================================================
local rColors = {
	Color3.fromRGB(255,0,0),
	Color3.fromRGB(255,120,0),
	Color3.fromRGB(255,255,0),
	Color3.fromRGB(0,255,0),
	Color3.fromRGB(0,140,255),
	Color3.fromRGB(160,0,255),
	Color3.fromRGB(255,0,160),
}
local rT = 0
RunService.Heartbeat:Connect(function(dt)
	rT = rT + dt * 2.5
	local n = #rColors
	local i = math.floor(rT) % n + 1
	local j = i % n + 1
	rainbowLbl.TextColor3 = rColors[i]:Lerp(rColors[j], rT % 1)
end)

-- ============================================================
-- POPULATE GIFT LIST
-- ============================================================
local function populateGiftList()
	for _, ch in ipairs(giftScroll:GetChildren()) do
		if ch:IsA("Frame") then ch:Destroy() end
	end

	local others = {}
	for _, p in ipairs(Players:GetPlayers()) do
		if p ~= localPlayer then table.insert(others, p) end
	end

	if #others == 0 then
		-- empty gray frame like image 2
		local ef = Instance.new("Frame")
		ef.Size = UDim2.new(1, 0, 0, 160)
		ef.BackgroundColor3 = Color3.fromRGB(140, 145, 140)
		ef.BorderSizePixel = 0
		ef.ZIndex = 22
		ef.Parent = giftScroll
		Corner(ef, 4)
		giftScroll.CanvasSize = UDim2.new(0, 0, 0, 166)
		return
	end

	for _, p in ipairs(others) do
		-- Each row: dark green card like image 2, player avatar, name, gift btn (green square)
		local row = Instance.new("Frame")
		row.Size = UDim2.new(1, 0, 0, 54)
		row.BackgroundColor3 = Color3.fromRGB(30, 60, 35)
		row.BorderSizePixel = 0
		row.ZIndex = 22
		row.Parent = giftScroll
		Corner(row, 6)

		local av = Instance.new("ImageLabel")
		av.Size = UDim2.new(0, 40, 0, 40)
		av.Position = UDim2.new(0, 8, 0.5, -20)
		av.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
		av.BorderSizePixel = 0
		av.Image = "https://www.roblox.com/headshot-thumbnail/image?userId="..p.UserId.."&width=420&height=420&format=png"
		av.ZIndex = 23
		av.Parent = row
		Corner(av, 4)

		local nameLbl = Instance.new("TextLabel")
		nameLbl.Size = UDim2.new(1, -110, 1, 0)
		nameLbl.Position = UDim2.new(0, 56, 0, 0)
		nameLbl.BackgroundTransparency = 1
		nameLbl.Text = p.Name
		nameLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
		nameLbl.Font = Enum.Font.GothamBold
		nameLbl.TextSize = 14
		nameLbl.TextXAlignment = Enum.TextXAlignment.Left
		nameLbl.ZIndex = 23
		nameLbl.Parent = row

		-- Gift button: green square like image 2
		local gBtn = Instance.new("TextButton")
		gBtn.Size = UDim2.new(0, 38, 0, 38)
		gBtn.Position = UDim2.new(1, -46, 0.5, -19)
		gBtn.BackgroundColor3 = Color3.fromRGB(50, 160, 50)
		gBtn.BorderSizePixel = 0
		gBtn.Text = "[G]"
		gBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
		gBtn.Font = Enum.Font.GothamBold
		gBtn.TextSize = 12
		gBtn.ZIndex = 23
		gBtn.Parent = row
		Corner(gBtn, 5)

		local pRef = p
		gBtn.MouseButton1Click:Connect(function()
			selectedPlayer = pRef.Name
			giftFrame.Visible = false
			shopFrame.Visible = true
		end)
	end

	giftScroll.CanvasSize = UDim2.new(0, 0, 0, math.max(166, #others * 60))
end

-- ============================================================
-- BUTTON CONNECTIONS
-- ============================================================
openBtn.MouseButton1Click:Connect(function()
	shopFrame.Visible = true
end)

shopClose.MouseButton1Click:Connect(function()
	shopFrame.Visible = false
end)

giftPlayerBtn.MouseButton1Click:Connect(function()
	populateGiftList()
	shopFrame.Visible = false
	giftFrame.Visible = true
end)

giftClose.MouseButton1Click:Connect(function()
	giftFrame.Visible = false
	shopFrame.Visible = true
end)

adminBuyBtn.MouseButton1Click:Connect(function()
	currentItemName = "ADMIN PANEL"
	currentItemPrice = 7499
	buyItemName.Text = "[GIFT] ADMIN PANEL"
	buyItemPrice.Text = "R$ " .. formatNumber(currentItemPrice)
	balanceLbl.Text = "R$ " .. formatNumber(balance)
	shopFrame.Visible = false
	buyFrame.Visible = true
end)

moneyBuyBtn.MouseButton1Click:Connect(function()
	currentItemName = "2X MONEY"
	currentItemPrice = 119
	buyItemName.Text = "[GIFT] 2X MONEY"
	buyItemPrice.Text = "R$ " .. formatNumber(currentItemPrice)
	balanceLbl.Text = "R$ " .. formatNumber(balance)
	shopFrame.Visible = false
	buyFrame.Visible = true
end)

vipBuyBtn.MouseButton1Click:Connect(function()
	currentItemName = "VIP"
	currentItemPrice = 199
	buyItemName.Text = "[GIFT] VIP"
	buyItemPrice.Text = "R$ " .. formatNumber(currentItemPrice)
	balanceLbl.Text = "R$ " .. formatNumber(balance)
	shopFrame.Visible = false
	buyFrame.Visible = true
end)

buyClose.MouseButton1Click:Connect(function()
	buyFrame.Visible = false
	shopFrame.Visible = true
end)

buyConfirmBtn.MouseButton1Click:Connect(function()
	if balance >= currentItemPrice then
		balance = balance - currentItemPrice
	end
	buyFrame.Visible = false
	completeBodyTxt.Text = "You have successfully gifted [GIFT] " .. currentItemName .. " to " .. (selectedPlayer or "Unknown") .. "."
	completeFrame.Visible = true
end)

completeClose.MouseButton1Click:Connect(function()
	completeFrame.Visible = false
end)

okBtn.MouseButton1Click:Connect(function()
	completeFrame.Visible = false
end)
