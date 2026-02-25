-- Place this LocalScript inside StarterGui
-- It creates the entire Shop GUI from scratch via code

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local localPlayer = Players.LocalPlayer

-- ============================================================
-- BALANCE (starts at 211,500, deducted on purchase)
-- ============================================================
local balance = 211500
local selectedPlayer = nil
local currentItemName = ""
local currentItemPrice = 0

-- ============================================================
-- HELPER: Format number with commas
-- ============================================================
local function formatNumber(n)
	local s = tostring(math.floor(n))
	local result = ""
	local count = 0
	for i = #s, 1, -1 do
		if count > 0 and count % 3 == 0 then
			result = "," .. result
		end
		result = s:sub(i,i) .. result
		count = count + 1
	end
	return result
end

-- ============================================================
-- HELPER: Create instance shorthand
-- ============================================================
local function create(class, props, parent)
	local obj = Instance.new(class)
	for k,v in pairs(props) do
		obj[k] = v
	end
	if parent then obj.Parent = parent end
	return obj
end

-- ============================================================
-- SCREEN GUI
-- ============================================================
local screenGui = create("ScreenGui", {
	Name = "ShopGUI",
	ResetOnSpawn = false,
	ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
}, localPlayer.PlayerGui)

-- ============================================================
-- OPEN BUTTON (left side)
-- ============================================================
local openBtn = create("TextButton", {
	Name = "OpenBtn",
	Size = UDim2.new(0, 38, 0, 120),
	Position = UDim2.new(0, 10, 0.5, -60),
	BackgroundColor3 = Color3.fromRGB(45, 120, 45),
	BorderSizePixel = 0,
	Text = "SHOP",
	TextColor3 = Color3.new(1,1,1),
	Font = Enum.Font.GothamBold,
	TextSize = 14,
	ZIndex = 2,
}, screenGui)
create("UICorner", {CornerRadius = UDim.new(0,8)}, openBtn)
create("UIStroke", {Color = Color3.fromRGB(30,90,30), Thickness = 2}, openBtn)

-- ============================================================
-- SHOP FRAME
-- ============================================================
local shopFrame = create("Frame", {
	Name = "ShopFrame",
	Size = UDim2.new(0, 520, 0, 430),
	Position = UDim2.new(0.5, -260, 0.5, -215),
	BackgroundColor3 = Color3.fromRGB(20, 50, 20),
	BorderSizePixel = 0,
	Visible = false,
	ZIndex = 5,
}, screenGui)
create("UICorner", {CornerRadius = UDim.new(0,8)}, shopFrame)
create("UIStroke", {Color = Color3.fromRGB(76,175,80), Thickness = 3}, shopFrame)

-- Header bar
local shopHeader = create("Frame", {
	Size = UDim2.new(1,0,0,50),
	BackgroundColor3 = Color3.fromRGB(20,50,20),
	BorderSizePixel = 0,
	ZIndex = 6,
}, shopFrame)

create("TextLabel", {
	Size = UDim2.new(0,90,1,0),
	Position = UDim2.new(0,8,0,0),
	BackgroundTransparency = 1,
	Text = "SHOP",
	TextColor3 = Color3.new(1,1,1),
	Font = Enum.Font.GothamBlack,
	TextSize = 26,
	ZIndex = 7,
}, shopHeader)

-- Tab buttons
local tabData = {
	{text="GEAR",       color=Color3.fromRGB(160,110,30), x=100},
	{text="GAMEPASSES", color=Color3.fromRGB(50,100,50),  x=195},
	{text="MONEY",      color=Color3.fromRGB(60,160,60),  x=330},
}
for _, t in ipairs(tabData) do
	local tb = create("TextButton", {
		Size = UDim2.new(0, 120, 0, 32),
		Position = UDim2.new(0, t.x, 0.5, -16),
		BackgroundColor3 = t.color,
		BorderSizePixel = 0,
		Text = t.text,
		TextColor3 = Color3.new(1,1,1),
		Font = Enum.Font.GothamBold,
		TextSize = 13,
		ZIndex = 7,
	}, shopHeader)
	create("UICorner", {CornerRadius = UDim.new(0,6)}, tb)
end

-- Close button
local shopClose = create("TextButton", {
	Size = UDim2.new(0,38,0,34),
	Position = UDim2.new(1,-46,0.5,-17),
	BackgroundColor3 = Color3.fromRGB(200,40,40),
	BorderSizePixel = 0,
	Text = "X",
	TextColor3 = Color3.new(1,1,1),
	Font = Enum.Font.GothamBold,
	TextSize = 16,
	ZIndex = 7,
}, shopHeader)
create("UICorner", {CornerRadius = UDim.new(0,6)}, shopClose)

-- GAMEPASSES label
create("TextLabel", {
	Size = UDim2.new(1,0,0,32),
	Position = UDim2.new(0,0,0,50),
	BackgroundColor3 = Color3.fromRGB(20,50,20),
	BorderSizePixel = 0,
	Text = "GAMEPASSES",
	TextColor3 = Color3.new(1,1,1),
	Font = Enum.Font.GothamBlack,
	TextSize = 18,
	ZIndex = 6,
}, shopFrame)

-- ============================================================
-- ADMIN PANEL CARD
-- ============================================================
local adminCard = create("Frame", {
	Size = UDim2.new(1,-24,0,90),
	Position = UDim2.new(0,12,0,90),
	BackgroundColor3 = Color3.fromRGB(12,35,12),
	BorderSizePixel = 0,
	ZIndex = 6,
}, shopFrame)
create("UICorner", {CornerRadius = UDim.new(0,8)}, adminCard)
create("UIStroke", {Color = Color3.fromRGB(40,80,40), Thickness = 2}, adminCard)

-- Admin Panel title
create("TextLabel", {
	Size = UDim2.new(0,200,0,24),
	Position = UDim2.new(0,10,0,8),
	BackgroundTransparency = 1,
	Text = "ADMIN PANEL",
	TextColor3 = Color3.new(1,1,1),
	Font = Enum.Font.GothamBlack,
	TextSize = 17,
	ZIndex = 7,
}, adminCard)

-- Rainbow "Get Admin Commands" label (animated via script)
local rainbowLabel = create("TextLabel", {
	Size = UDim2.new(0,200,0,20),
	Position = UDim2.new(0,10,0,32),
	BackgroundTransparency = 1,
	Text = "Get Admin Commands",
	TextColor3 = Color3.fromRGB(255,80,80),
	Font = Enum.Font.GothamBold,
	TextSize = 13,
	ZIndex = 7,
}, adminCard)

-- cmds text
create("TextLabel", {
	Size = UDim2.new(0,200,0,28),
	Position = UDim2.new(0,10,0,52),
	BackgroundTransparency = 1,
	Text = "Type ;cmds in chat for\na list of commands!",
	TextColor3 = Color3.fromRGB(200,200,200),
	Font = Enum.Font.Gotham,
	TextSize = 11,
	TextXAlignment = Enum.TextXAlignment.Left,
	ZIndex = 7,
}, adminCard)

-- AP logo box
local apBox = create("Frame", {
	Size = UDim2.new(0,60,0,60),
	Position = UDim2.new(0,220,0,15),
	BackgroundColor3 = Color3.fromRGB(120,120,120),
	BorderSizePixel = 0,
	ZIndex = 7,
}, adminCard)
create("UICorner", {CornerRadius = UDim.new(0,4)}, apBox)
create("TextLabel", {
	Size = UDim2.new(1,0,1,0),
	BackgroundTransparency = 1,
	Text = "AP",
	TextColor3 = Color3.new(1,1,1),
	Font = Enum.Font.GothamBlack,
	TextSize = 22,
	ZIndex = 8,
}, apBox)

-- Worth (strikethrough look)
create("TextLabel", {
	Size = UDim2.new(0,130,0,20),
	Position = UDim2.new(0,310,0,10),
	BackgroundTransparency = 1,
	Text = "Worth  ⊙ 9999",
	TextColor3 = Color3.fromRGB(180,180,180),
	Font = Enum.Font.GothamBold,
	TextSize = 12,
	TextDecoration = Enum.TextDecoration.Strikethrough,
	ZIndex = 7,
}, adminCard)

-- Buy button (Admin Panel) - price 7,499
local adminBuyBtn = create("TextButton", {
	Size = UDim2.new(0,110,0,34),
	Position = UDim2.new(0,315,0,38),
	BackgroundColor3 = Color3.fromRGB(60,160,60),
	BorderSizePixel = 0,
	Text = "⊙ 7,499",
	TextColor3 = Color3.new(1,1,1),
	Font = Enum.Font.GothamBold,
	TextSize = 16,
	ZIndex = 7,
}, adminCard)
create("UICorner", {CornerRadius = UDim.new(0,6)}, adminBuyBtn)

-- ============================================================
-- 2X MONEY CARD
-- ============================================================
local moneyCard = create("Frame", {
	Size = UDim2.new(0, 235, 0, 80),
	Position = UDim2.new(0,12,0,192),
	BackgroundColor3 = Color3.fromRGB(12,35,12),
	BorderSizePixel = 0,
	ZIndex = 6,
}, shopFrame)
create("UICorner", {CornerRadius = UDim.new(0,8)}, moneyCard)
create("UIStroke", {Color = Color3.fromRGB(40,80,40), Thickness = 2}, moneyCard)

create("TextLabel", {
	Size = UDim2.new(0,44,0,44),
	Position = UDim2.new(0,8,0,8),
	BackgroundTransparency = 1,
	Text = "💵",
	TextSize = 30,
	ZIndex = 7,
}, moneyCard)
create("TextLabel", {
	Size = UDim2.new(0,20,0,16),
	Position = UDim2.new(0,34,0,34),
	BackgroundColor3 = Color3.fromRGB(180,0,0),
	BorderSizePixel = 0,
	Text = "x2",
	TextColor3 = Color3.new(1,1,1),
	Font = Enum.Font.GothamBold,
	TextSize = 10,
	ZIndex = 8,
}, moneyCard)
create("UICorner", {CornerRadius = UDim.new(0,3)}, moneyCard:FindFirstChild("TextLabel") or moneyCard)

create("TextLabel", {
	Size = UDim2.new(0,140,0,20),
	Position = UDim2.new(0,62,0,6),
	BackgroundTransparency = 1,
	Text = "2X MONEY",
	TextColor3 = Color3.new(1,1,1),
	Font = Enum.Font.GothamBlack,
	TextSize = 15,
	ZIndex = 7,
}, moneyCard)
create("TextLabel", {
	Size = UDim2.new(0,140,0,22),
	Position = UDim2.new(0,62,0,26),
	BackgroundTransparency = 1,
	Text = "Earn twice as\nmuch money!",
	TextColor3 = Color3.fromRGB(180,180,180),
	Font = Enum.Font.Gotham,
	TextSize = 11,
	TextXAlignment = Enum.TextXAlignment.Left,
	ZIndex = 7,
}, moneyCard)

local moneyBuyBtn = create("TextButton", {
	Size = UDim2.new(0,90,0,28),
	Position = UDim2.new(0,62,0,50),
	BackgroundColor3 = Color3.fromRGB(60,160,60),
	BorderSizePixel = 0,
	Text = "⊙ 119",
	TextColor3 = Color3.new(1,1,1),
	Font = Enum.Font.GothamBold,
	TextSize = 14,
	ZIndex = 7,
}, moneyCard)
create("UICorner", {CornerRadius = UDim.new(0,6)}, moneyBuyBtn)

-- ============================================================
-- VIP CARD
-- ============================================================
local vipCard = create("Frame", {
	Size = UDim2.new(0, 235, 0, 80),
	Position = UDim2.new(0,273,0,192),
	BackgroundColor3 = Color3.fromRGB(12,35,12),
	BorderSizePixel = 0,
	ZIndex = 6,
}, shopFrame)
create("UICorner", {CornerRadius = UDim.new(0,8)}, vipCard)
create("UIStroke", {Color = Color3.fromRGB(40,80,40), Thickness = 2}, vipCard)

create("TextLabel", {
	Size = UDim2.new(0,50,0,44),
	Position = UDim2.new(0,8,0,8),
	BackgroundTransparency = 1,
	Text = "VIP",
	TextColor3 = Color3.fromRGB(255,215,0),
	Font = Enum.Font.GothamBlack,
	TextSize = 26,
	ZIndex = 7,
}, vipCard)
create("TextLabel", {
	Size = UDim2.new(0,150,0,20),
	Position = UDim2.new(0,65,0,6),
	BackgroundTransparency = 1,
	Text = "VIP",
	TextColor3 = Color3.new(1,1,1),
	Font = Enum.Font.GothamBlack,
	TextSize = 15,
	ZIndex = 7,
}, vipCard)
create("TextLabel", {
	Size = UDim2.new(0,150,0,22),
	Position = UDim2.new(0,65,0,26),
	BackgroundTransparency = 1,
	Text = "Many benefits\nincluding multi!",
	TextColor3 = Color3.fromRGB(180,180,180),
	Font = Enum.Font.Gotham,
	TextSize = 11,
	TextXAlignment = Enum.TextXAlignment.Left,
	ZIndex = 7,
}, vipCard)

local vipBuyBtn = create("TextButton", {
	Size = UDim2.new(0,90,0,28),
	Position = UDim2.new(0,65,0,50),
	BackgroundColor3 = Color3.fromRGB(60,160,60),
	BorderSizePixel = 0,
	Text = "⊙ 199",
	TextColor3 = Color3.new(1,1,1),
	Font = Enum.Font.GothamBold,
	TextSize = 14,
	ZIndex = 7,
}, vipCard)
create("UICorner", {CornerRadius = UDim.new(0,6)}, vipBuyBtn)

-- ============================================================
-- STARTER PACK BAR
-- ============================================================
local starterBar = create("Frame", {
	Size = UDim2.new(1,-24,0,38),
	Position = UDim2.new(0,12,0,284),
	BackgroundColor3 = Color3.fromRGB(50,50,50),
	BorderSizePixel = 0,
	ZIndex = 6,
}, shopFrame)
create("UICorner", {CornerRadius = UDim.new(0,6)}, starterBar)
create("UIStroke", {Color = Color3.fromRGB(80,80,80), Thickness = 2}, starterBar)
create("TextLabel", {
	Size = UDim2.new(1,0,1,0),
	BackgroundTransparency = 1,
	Text = "STARTER PACK",
	TextColor3 = Color3.new(1,1,1),
	Font = Enum.Font.GothamBlack,
	TextSize = 17,
	ZIndex = 7,
}, starterBar)

-- Gift Player Button
local giftPlayerBtn = create("TextButton", {
	Size = UDim2.new(0,140,0,36),
	Position = UDim2.new(1,-152,0,334),
	BackgroundColor3 = Color3.fromRGB(30,70,30),
	BorderSizePixel = 0,
	Text = "🎁  Gift Player",
	TextColor3 = Color3.new(1,1,1),
	Font = Enum.Font.GothamBold,
	TextSize = 14,
	ZIndex = 7,
}, shopFrame)
create("UICorner", {CornerRadius = UDim.new(0,6)}, giftPlayerBtn)
create("UIStroke", {Color = Color3.fromRGB(76,175,80), Thickness = 2}, giftPlayerBtn)

-- ============================================================
-- GIFT PLAYER FRAME
-- ============================================================
local giftFrame = create("Frame", {
	Name = "GiftFrame",
	Size = UDim2.new(0,340,0,280),
	Position = UDim2.new(0.5,-170,0.5,-140),
	BackgroundColor3 = Color3.fromRGB(28,44,28),
	BorderSizePixel = 0,
	Visible = false,
	ZIndex = 10,
}, screenGui)
create("UICorner", {CornerRadius = UDim.new(0,8)}, giftFrame)
create("UIStroke", {Color = Color3.fromRGB(76,175,80), Thickness = 3}, giftFrame)

-- Gift header
local giftHeader = create("Frame", {
	Size = UDim2.new(1,0,0,44),
	BackgroundColor3 = Color3.fromRGB(18,34,18),
	BorderSizePixel = 0,
	ZIndex = 11,
}, giftFrame)
create("UICorner", {CornerRadius = UDim.new(0,6)}, giftHeader)
create("TextLabel", {
	Size = UDim2.new(1,0,1,0),
	BackgroundTransparency = 1,
	Text = "GIFT PLAYER",
	TextColor3 = Color3.new(1,1,1),
	Font = Enum.Font.GothamBlack,
	TextSize = 17,
	ZIndex = 12,
}, giftHeader)

local giftClose = create("TextButton", {
	Size = UDim2.new(0,32,0,28),
	Position = UDim2.new(1,-38,0.5,-14),
	BackgroundColor3 = Color3.fromRGB(200,40,40),
	BorderSizePixel = 0,
	Text = "X",
	TextColor3 = Color3.new(1,1,1),
	Font = Enum.Font.GothamBold,
	TextSize = 14,
	ZIndex = 12,
}, giftHeader)
create("UICorner", {CornerRadius = UDim.new(0,5)}, giftClose)

-- Gift body / player list area
local giftBody = create("ScrollingFrame", {
	Size = UDim2.new(1,-16,1,-60),
	Position = UDim2.new(0,8,0,50),
	BackgroundColor3 = Color3.fromRGB(18,30,18),
	BorderSizePixel = 0,
	ScrollBarThickness = 4,
	ZIndex = 11,
}, giftFrame)
create("UICorner", {CornerRadius = UDim.new(0,4)}, giftBody)
local giftListLayout = create("UIListLayout", {
	SortOrder = Enum.SortOrder.LayoutOrder,
	Padding = UDim.new(0,6),
}, giftBody)

-- ============================================================
-- BUY ITEM FRAME
-- ============================================================
local buyFrame = create("Frame", {
	Name = "BuyFrame",
	Size = UDim2.new(0,380,0,180),
	Position = UDim2.new(0.5,-190,0.5,-90),
	BackgroundColor3 = Color3.fromRGB(22,22,35),
	BorderSizePixel = 0,
	Visible = false,
	ZIndex = 15,
}, screenGui)
create("UICorner", {CornerRadius = UDim.new(0,10)}, buyFrame)
create("UIStroke", {Color = Color3.fromRGB(80,80,100), Thickness = 3}, buyFrame)

-- Buy header
local buyHeader = create("Frame", {
	Size = UDim2.new(1,0,0,44),
	BackgroundColor3 = Color3.fromRGB(16,16,26),
	BorderSizePixel = 0,
	ZIndex = 16,
}, buyFrame)
create("UICorner", {CornerRadius = UDim.new(0,8)}, buyHeader)

create("TextLabel", {
	Size = UDim2.new(0,100,1,0),
	Position = UDim2.new(0,10,0,0),
	BackgroundTransparency = 1,
	Text = "Buy item",
	TextColor3 = Color3.new(1,1,1),
	Font = Enum.Font.GothamBlack,
	TextSize = 16,
	ZIndex = 17,
}, buyHeader)

local balanceLabel = create("TextLabel", {
	Size = UDim2.new(0,120,1,0),
	Position = UDim2.new(0.5,-60,0,0),
	BackgroundTransparency = 1,
	Text = "⊙ " .. formatNumber(balance),
	TextColor3 = Color3.new(1,1,1),
	Font = Enum.Font.GothamBold,
	TextSize = 14,
	ZIndex = 17,
}, buyHeader)

local buyClose = create("TextButton", {
	Size = UDim2.new(0,30,0,26),
	Position = UDim2.new(1,-36,0.5,-13),
	BackgroundColor3 = Color3.fromRGB(200,40,40),
	BorderSizePixel = 0,
	Text = "X",
	TextColor3 = Color3.new(1,1,1),
	Font = Enum.Font.GothamBold,
	TextSize = 13,
	ZIndex = 17,
}, buyHeader)
create("UICorner", {CornerRadius = UDim.new(0,5)}, buyClose)

-- Item row
local hdBox = create("Frame", {
	Size = UDim2.new(0,56,0,56),
	Position = UDim2.new(0,16,0,54),
	BackgroundColor3 = Color3.fromRGB(90,90,90),
	BorderSizePixel = 0,
	ZIndex = 16,
}, buyFrame)
create("UICorner", {CornerRadius = UDim.new(0,6)}, hdBox)
create("TextLabel", {
	Size = UDim2.new(1,0,1,0),
	BackgroundTransparency = 1,
	Text = "HD",
	TextColor3 = Color3.new(1,1,1),
	Font = Enum.Font.GothamBlack,
	TextSize = 20,
	ZIndex = 17,
}, hdBox)

local buyItemNameLabel = create("TextLabel", {
	Size = UDim2.new(0,270,0,24),
	Position = UDim2.new(0,84,0,58),
	BackgroundTransparency = 1,
	Text = "[GIFT] ADMIN PANEL",
	TextColor3 = Color3.new(1,1,1),
	Font = Enum.Font.GothamBold,
	TextSize = 14,
	TextXAlignment = Enum.TextXAlignment.Left,
	ZIndex = 16,
}, buyFrame)

local buyItemPriceLabel = create("TextLabel", {
	Size = UDim2.new(0,270,0,20),
	Position = UDim2.new(0,84,0,82),
	BackgroundTransparency = 1,
	Text = "⊙ 7,499",
	TextColor3 = Color3.new(1,1,1),
	Font = Enum.Font.GothamBold,
	TextSize = 13,
	TextXAlignment = Enum.TextXAlignment.Left,
	ZIndex = 16,
}, buyFrame)

local buyConfirmBtn = create("TextButton", {
	Size = UDim2.new(1,-32,0,40),
	Position = UDim2.new(0,16,0,126),
	BackgroundColor3 = Color3.fromRGB(60,100,240),
	BorderSizePixel = 0,
	Text = "Buy",
	TextColor3 = Color3.new(1,1,1),
	Font = Enum.Font.GothamBlack,
	TextSize = 18,
	ZIndex = 16,
}, buyFrame)
create("UICorner", {CornerRadius = UDim.new(0,8)}, buyConfirmBtn)

-- ============================================================
-- PURCHASE COMPLETE FRAME
-- ============================================================
local completeFrame = create("Frame", {
	Name = "CompleteFrame",
	Size = UDim2.new(0,380,0,220),
	Position = UDim2.new(0.5,-190,0.5,-110),
	BackgroundColor3 = Color3.fromRGB(22,22,35),
	BorderSizePixel = 0,
	Visible = false,
	ZIndex = 20,
}, screenGui)
create("UICorner", {CornerRadius = UDim.new(0,10)}, completeFrame)
create("UIStroke", {Color = Color3.fromRGB(80,80,100), Thickness = 3}, completeFrame)

local completeHeader = create("Frame", {
	Size = UDim2.new(1,0,0,44),
	BackgroundColor3 = Color3.fromRGB(16,16,26),
	BorderSizePixel = 0,
	ZIndex = 21,
}, completeFrame)
create("UICorner", {CornerRadius = UDim.new(0,8)}, completeHeader)
create("TextLabel", {
	Size = UDim2.new(1,-50,1,0),
	Position = UDim2.new(0,10,0,0),
	BackgroundTransparency = 1,
	Text = "Purchase completed",
	TextColor3 = Color3.new(1,1,1),
	Font = Enum.Font.GothamBlack,
	TextSize = 16,
	ZIndex = 22,
}, completeHeader)

local completeClose = create("TextButton", {
	Size = UDim2.new(0,30,0,26),
	Position = UDim2.new(1,-36,0.5,-13),
	BackgroundColor3 = Color3.fromRGB(200,40,40),
	BorderSizePixel = 0,
	Text = "X",
	TextColor3 = Color3.new(1,1,1),
	Font = Enum.Font.GothamBold,
	TextSize = 13,
	ZIndex = 22,
}, completeHeader)
create("UICorner", {CornerRadius = UDim.new(0,5)}, completeClose)

-- Checkmark circle
local checkCircle = create("Frame", {
	Size = UDim2.new(0,60,0,60),
	Position = UDim2.new(0.5,-30,0,54),
	BackgroundTransparency = 1,
	BorderSizePixel = 0,
	ZIndex = 21,
}, completeFrame)
create("UICorner", {CornerRadius = UDim.new(0.5,0)}, checkCircle)
create("UIStroke", {Color = Color3.fromRGB(150,150,150), Thickness = 3}, checkCircle)
create("TextLabel", {
	Size = UDim2.new(1,0,1,0),
	BackgroundTransparency = 1,
	Text = "✓",
	TextColor3 = Color3.fromRGB(150,150,150),
	Font = Enum.Font.GothamBlack,
	TextSize = 28,
	ZIndex = 22,
}, checkCircle)

local completeText = create("TextLabel", {
	Size = UDim2.new(1,-30,0,40),
	Position = UDim2.new(0,15,0,124),
	BackgroundTransparency = 1,
	Text = "You have successfully gifted [GIFT] ADMIN PANEL to PlayerName.",
	TextColor3 = Color3.new(1,1,1),
	Font = Enum.Font.Gotham,
	TextSize = 13,
	TextWrapped = true,
	ZIndex = 21,
}, completeFrame)

local okBtn = create("TextButton", {
	Size = UDim2.new(1,-32,0,40),
	Position = UDim2.new(0,16,0,168),
	BackgroundColor3 = Color3.fromRGB(60,100,240),
	BorderSizePixel = 0,
	Text = "OK",
	TextColor3 = Color3.new(1,1,1),
	Font = Enum.Font.GothamBlack,
	TextSize = 18,
	ZIndex = 21,
}, completeFrame)
create("UICorner", {CornerRadius = UDim.new(0,8)}, okBtn)

-- ============================================================
-- RAINBOW ANIMATION (RunService)
-- ============================================================
local rainbowColors = {
	Color3.fromRGB(255,0,0),
	Color3.fromRGB(255,140,0),
	Color3.fromRGB(255,255,0),
	Color3.fromRGB(0,255,0),
	Color3.fromRGB(0,150,255),
	Color3.fromRGB(150,0,255),
	Color3.fromRGB(255,0,150),
}
local rainbowIndex = 0
RunService.Heartbeat:Connect(function(dt)
	rainbowIndex = rainbowIndex + dt * 3
	local i = math.floor(rainbowIndex) % #rainbowColors + 1
	local j = i % #rainbowColors + 1
	local frac = rainbowIndex % 1
	local c = rainbowColors[i]:Lerp(rainbowColors[j], frac)
	rainbowLabel.TextColor3 = c
end)

-- ============================================================
-- POPULATE GIFT PLAYER LIST
-- ============================================================
local function populateGiftList()
	-- Clear old rows
	for _, child in ipairs(giftBody:GetChildren()) do
		if child:IsA("Frame") then child:Destroy() end
	end

	local playersInServer = Players:GetPlayers()
	-- Exclude local player from gift list (optional, remove if you want to include self)
	local others = {}
	for _, p in ipairs(playersInServer) do
		if p ~= localPlayer then
			table.insert(others, p)
		end
	end

	if #others == 0 then
		-- Show empty gray frame
		local emptyFrame = create("Frame", {
			Size = UDim2.new(1,0,0,100),
			BackgroundColor3 = Color3.fromRGB(25,35,25),
			BorderSizePixel = 0,
			ZIndex = 12,
		}, giftBody)
		create("UICorner", {CornerRadius = UDim.new(0,4)}, emptyFrame)
		giftBody.CanvasSize = UDim2.new(0,0,0,100)
		return
	end

	for _, p in ipairs(others) do
		local row = create("Frame", {
			Size = UDim2.new(1,0,0,52),
			BackgroundColor3 = Color3.fromRGB(30,50,30),
			BorderSizePixel = 0,
			ZIndex = 12,
		}, giftBody)
		create("UICorner", {CornerRadius = UDim.new(0,6)}, row)
		create("UIStroke", {Color = Color3.fromRGB(50,80,50), Thickness = 1}, row)

		-- Avatar image
		local avatarImg = create("ImageLabel", {
			Size = UDim2.new(0,38,0,38),
			Position = UDim2.new(0,8,0.5,-19),
			BackgroundColor3 = Color3.fromRGB(80,80,80),
			BorderSizePixel = 0,
			Image = "https://www.roblox.com/headshot-thumbnail/image?userId="..p.UserId.."&width=420&height=420&format=png",
			ZIndex = 13,
		}, row)
		create("UICorner", {CornerRadius = UDim.new(0,4)}, avatarImg)

		create("TextLabel", {
			Size = UDim2.new(1,-110,1,0),
			Position = UDim2.new(0,54,0,0),
			BackgroundTransparency = 1,
			Text = p.Name,
			TextColor3 = Color3.new(1,1,1),
			Font = Enum.Font.GothamBold,
			TextSize = 14,
			TextXAlignment = Enum.TextXAlignment.Left,
			ZIndex = 13,
		}, row)

		local giftBtn = create("TextButton", {
			Size = UDim2.new(0,36,0,36),
			Position = UDim2.new(1,-44,0.5,-18),
			BackgroundColor3 = Color3.fromRGB(30,70,30),
			BorderSizePixel = 0,
			Text = "🎁",
			TextSize = 18,
			ZIndex = 13,
		}, row)
		create("UICorner", {CornerRadius = UDim.new(0,5)}, giftBtn)
		create("UIStroke", {Color = Color3.fromRGB(76,175,80), Thickness = 2}, giftBtn)

		local playerRef = p
		giftBtn.MouseButton1Click:Connect(function()
			selectedPlayer = playerRef.Name
			giftFrame.Visible = false
			-- Update buy frame for selected item
			buyItemNameLabel.Text = "[GIFT] " .. currentItemName:upper()
			buyItemPriceLabel.Text = "⊙ " .. formatNumber(currentItemPrice)
			balanceLabel.Text = "⊙ " .. formatNumber(balance)
			buyFrame.Visible = true
		end)
	end

	giftBody.CanvasSize = UDim2.new(0,0,0, #others * 58)
end

-- ============================================================
-- OPEN SHOP
-- ============================================================
openBtn.MouseButton1Click:Connect(function()
	shopFrame.Visible = true
end)

shopClose.MouseButton1Click:Connect(function()
	shopFrame.Visible = false
end)

-- ============================================================
-- GIFT PLAYER BUTTON
-- ============================================================
giftPlayerBtn.MouseButton1Click:Connect(function()
	populateGiftList()
	giftFrame.Visible = true
end)

giftClose.MouseButton1Click:Connect(function()
	giftFrame.Visible = false
end)

-- ============================================================
-- BUY BUTTONS -> open Gift Player first
-- ============================================================
local function openGiftFrame(itemName, itemPrice)
	currentItemName = itemName
	currentItemPrice = itemPrice
	populateGiftList()
	shopFrame.Visible = false
	giftFrame.Visible = true
end

adminBuyBtn.MouseButton1Click:Connect(function()
	openGiftFrame("Admin Panel", 7499)
end)

moneyBuyBtn.MouseButton1Click:Connect(function()
	openGiftFrame("2X Money", 119)
end)

vipBuyBtn.MouseButton1Click:Connect(function()
	openGiftFrame("VIP", 199)
end)

-- ============================================================
-- BUY CLOSE
-- ============================================================
buyClose.MouseButton1Click:Connect(function()
	buyFrame.Visible = false
end)

-- ============================================================
-- CONFIRM BUY
-- ============================================================
buyConfirmBtn.MouseButton1Click:Connect(function()
	if balance >= currentItemPrice then
		balance = balance - currentItemPrice
		balanceLabel.Text = "⊙ " .. formatNumber(balance)
		buyFrame.Visible = false
		-- Show complete
		completeText.Text = "You have successfully gifted [GIFT] " ..
			currentItemName:upper() .. " to " .. (selectedPlayer or "Unknown") .. "."
		completeFrame.Visible = true
	end
end)

-- ============================================================
-- OK + COMPLETE CLOSE
-- ============================================================
okBtn.MouseButton1Click:Connect(function()
	completeFrame.Visible = false
end)

completeClose.MouseButton1Click:Connect(function()
	completeFrame.Visible = false
end)
