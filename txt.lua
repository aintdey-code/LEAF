local Players            = game:GetService("Players")
local UserInputService   = game:GetService("UserInputService")
local TweenService       = game:GetService("TweenService")
local Debris             = game:GetService("Debris")
local MarketplaceService = game:GetService("MarketplaceService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui   = LocalPlayer:WaitForChild("PlayerGui")

local ITEM_TYPES = {
	["1227013099"] = Enum.InfoType.GamePass,
	["3290152611"] = Enum.InfoType.Product,
	["3290152552"] = Enum.InfoType.Product,
	["3290152513"] = Enum.InfoType.Product,
	["3290152459"] = Enum.InfoType.Product,
}

local INFO_CACHE = {}

local balance        = 66245
local currentCost    = 0
local currentName    = ""
local guiOpen        = false
local panelVisible   = false

local detectedPlayer = ""

local C_CARD      = Color3.fromRGB(55,  55,  70)
local C_WHITE     = Color3.fromRGB(255, 255, 255)
local C_ICON      = Color3.fromRGB(55,  55,  70)
local C_BTN_DARK  = Color3.fromRGB(55,  65,  160)
local C_BTN_LIGHT = Color3.fromRGB(88,  101, 242)

local CARD_W      = 460
local CARD_H      = 220
-- lowered: was -60, now -20 (slightly above center, between old and raised)
local CARD_CENTER = UDim2.new(0.5, -CARD_W/2, 0.5, -CARD_H/2 - 20)
local SUCC_W      = 460
local SUCC_H      = 220
local SUCC_CENTER = UDim2.new(0.5, -SUCC_W/2, 0.5, -SUCC_H/2 - 20)
local PANEL_W     = 210
local PANEL_H     = 120

local function fmt(n)
	local s = tostring(math.floor(n))
	local r, c = "", 0
	for i = #s, 1, -1 do
		if c > 0 and c % 3 == 0 then r = "," .. r end
		r = s:sub(i, i) .. r
		c = c + 1
	end
	return r
end

local function playPurchaseSound()
	local snd = Instance.new("Sound")
	snd.SoundId = "rbxassetid://89446320629366"
	snd.Volume  = 1
	snd.Parent  = workspace
	snd:Play()
	Debris:AddItem(snd, 10)
end

local function getItemInfo(itemId)
	if INFO_CACHE[itemId] then return INFO_CACHE[itemId] end
	local infoType = ITEM_TYPES[itemId]
	if not infoType then return nil end
	local ok, info = pcall(function()
		return MarketplaceService:GetProductInfo(tonumber(itemId), infoType)
	end)
	if ok and info then
		INFO_CACHE[itemId] = info
		return info
	end
	return nil
end

local SKIP = {
	Template=true, UIListLayout=true, UIPadding=true,
	UIGridLayout=true, UICorner=true, ScrollingFrame=true,
	UIStroke=true, UIScale=true,
}

local function getGiftTargetPlayer()
	local function safeFind(parent, name)
		local ok, r = pcall(function() return parent:WaitForChild(name, 1) end)
		return ok and r or nil
	end
	local g1 = safeFind(PlayerGui, "GiftPlayer")  if not g1 then return "" end
	local g2 = safeFind(g1, "GiftPlayer")         if not g2 then return "" end
	local mn = safeFind(g2, "Main")               if not mn then return "" end
	local ls = safeFind(mn, "List")               if not ls then return "" end
	for _, entry in ipairs(ls:GetChildren()) do
		local ok, isGui = pcall(function() return entry:IsA("GuiObject") end)
		if ok and isGui and not SKIP[entry.Name] then
			local visOk, vis = pcall(function() return entry.Visible end)
			if visOk and vis ~= false and entry:FindFirstChild("Gift") then
				return entry.Name
			end
		end
	end
	return ""
end

local function isGifting()
	-- Check ScreenGui enabled
	local giftGui = PlayerGui:FindFirstChild("GiftPlayer")
	if not giftGui then return false end
	local okE, en = pcall(function() return giftGui.Enabled end)
	if not okE or not en then return false end
	-- Check inner frame visible
	local giftFrame = giftGui:FindFirstChild("GiftPlayer")
	if not giftFrame then return false end
	local okV, vis = pcall(function() return giftFrame.Visible end)
	if not okV or not vis then return false end
	-- Must have a player actually selected
	return getGiftTargetPlayer() ~= ""
end

local function readItemData(item)
	local gifting = isGifting()
	local iconLabel = item:FindFirstChild("Icon")
	local image = iconLabel and iconLabel.Image or ""
	local info = getItemInfo(item.Name)
	if not info then
		return { name = gifting and "[GIFT] Unknown" or "Unknown", price = 0, priceText = "Free", image = image }
	end
	local baseName  = info.Name or "Unknown"
	local price     = info.PriceInRobux or 0
	local name      = gifting and ("[GIFT] " .. baseName) or baseName
	local priceText = price > 0 and ("\u{E002} " .. fmt(price)) or "Free"
	return { name = name, price = price, priceText = priceText, image = image }
end

-- BUY GUI
local BuyGui = Instance.new("ScreenGui")
BuyGui.Name = "BuyItemGui"
BuyGui.ResetOnSpawn = false
BuyGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
BuyGui.Enabled = false
BuyGui.Parent = PlayerGui

local Backdrop = Instance.new("Frame")
Backdrop.Size = UDim2.new(1,0,1,0)
Backdrop.BackgroundColor3 = Color3.fromRGB(0,0,0)
Backdrop.BackgroundTransparency = 0.52
Backdrop.BorderSizePixel = 0
Backdrop.ZIndex = 1
Backdrop.Parent = BuyGui

local Card = Instance.new("Frame")
Card.Name = "Card"
Card.Size = UDim2.new(0, CARD_W, 0, CARD_H)
Card.Position = CARD_CENTER
Card.BackgroundColor3 = C_CARD
Card.BorderSizePixel = 0
Card.ZIndex = 2
Card.Parent = BuyGui
Instance.new("UICorner", Card).CornerRadius = UDim.new(0, 12)

local TitleLbl = Instance.new("TextLabel")
TitleLbl.Size = UDim2.new(0,150,0,50)
TitleLbl.Position = UDim2.new(0,18,0,0)
TitleLbl.BackgroundTransparency = 1
TitleLbl.Text = "Buy item"
TitleLbl.Font = Enum.Font.GothamBold
TitleLbl.TextSize = 20
TitleLbl.TextColor3 = C_WHITE
TitleLbl.TextXAlignment = Enum.TextXAlignment.Left
TitleLbl.ZIndex = 3
TitleLbl.Parent = Card

local BalanceLbl = Instance.new("TextLabel")
BalanceLbl.Name = "BalanceLbl"
BalanceLbl.Size = UDim2.new(0,130,0,50)
BalanceLbl.Position = UDim2.new(1,-182,0,0)
BalanceLbl.BackgroundTransparency = 1
BalanceLbl.Font = Enum.Font.GothamBold
BalanceLbl.TextSize = 16
BalanceLbl.TextColor3 = C_WHITE
BalanceLbl.TextXAlignment = Enum.TextXAlignment.Right
BalanceLbl.ZIndex = 3
BalanceLbl.Parent = Card

local CloseBtn = Instance.new("TextButton")
CloseBtn.Name = "CloseBtn"
CloseBtn.Size = UDim2.new(0,40,0,50)
CloseBtn.Position = UDim2.new(1,-44,0,0)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Text = "X"
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 18
CloseBtn.TextColor3 = C_WHITE
CloseBtn.BorderSizePixel = 0
CloseBtn.ZIndex = 4
CloseBtn.Parent = Card

local IconFrame = Instance.new("Frame")
IconFrame.Size = UDim2.new(0,80,0,80)
IconFrame.Position = UDim2.new(0,14,0,54)
IconFrame.BackgroundColor3 = C_ICON
IconFrame.BorderSizePixel = 0
IconFrame.ZIndex = 3
IconFrame.Parent = Card
Instance.new("UICorner", IconFrame).CornerRadius = UDim.new(0, 8)

local IconImg = Instance.new("ImageLabel")
IconImg.Name = "IconImg"
IconImg.Size = UDim2.new(1,0,1,0)
IconImg.BackgroundTransparency = 1
IconImg.Image = ""
IconImg.ScaleType = Enum.ScaleType.Fit
IconImg.ZIndex = 4
IconImg.Parent = IconFrame

local ItemName = Instance.new("TextLabel")
ItemName.Name = "ItemName"
ItemName.Size = UDim2.new(1,-110,0,20)
ItemName.Position = UDim2.new(0,106,0,70)
ItemName.BackgroundTransparency = 1
ItemName.Text = ""
ItemName.Font = Enum.Font.GothamBold
ItemName.TextSize = 15
ItemName.TextColor3 = C_WHITE
ItemName.TextXAlignment = Enum.TextXAlignment.Left
ItemName.TextTruncate = Enum.TextTruncate.AtEnd
ItemName.ZIndex = 3
ItemName.Parent = Card

local ItemPrice = Instance.new("TextLabel")
ItemPrice.Name = "ItemPrice"
ItemPrice.Size = UDim2.new(1,-110,0,20)
ItemPrice.Position = UDim2.new(0,106,0,100)
ItemPrice.BackgroundTransparency = 1
ItemPrice.Text = ""
ItemPrice.Font = Enum.Font.Gotham
ItemPrice.TextSize = 14
ItemPrice.TextColor3 = C_WHITE
ItemPrice.TextXAlignment = Enum.TextXAlignment.Left
ItemPrice.ZIndex = 3
ItemPrice.Parent = Card

local BuyBtn = Instance.new("TextButton")
BuyBtn.Name = "BuyBtn"
BuyBtn.Size = UDim2.new(1,-28,0,48)
BuyBtn.Position = UDim2.new(0,14,0,158)
BuyBtn.BackgroundColor3 = C_BTN_DARK
BuyBtn.Text = ""
BuyBtn.BorderSizePixel = 0
BuyBtn.AutoButtonColor = false
BuyBtn.Active = false
BuyBtn.ZIndex = 3
BuyBtn.Parent = Card
Instance.new("UICorner", BuyBtn).CornerRadius = UDim.new(0, 10)

local SweepCover = Instance.new("Frame")
SweepCover.Name = "SweepCover"
SweepCover.Size = UDim2.new(0,0,1,0)
SweepCover.BackgroundColor3 = C_BTN_LIGHT
SweepCover.BorderSizePixel = 0
SweepCover.ZIndex = 4
SweepCover.Parent = BuyBtn
Instance.new("UICorner", SweepCover).CornerRadius = UDim.new(0, 10)

local BuyLbl = Instance.new("TextLabel")
BuyLbl.Size = UDim2.new(1,0,1,0)
BuyLbl.BackgroundTransparency = 1
BuyLbl.Text = "Buy"
BuyLbl.Font = Enum.Font.GothamBold
BuyLbl.TextSize = 18
BuyLbl.TextColor3 = C_WHITE
BuyLbl.ZIndex = 5
BuyLbl.Parent = BuyBtn

-- SUCCESS POPUP
local SuccessCard = Instance.new("Frame")
SuccessCard.Name = "SuccessCard"
SuccessCard.Size = UDim2.new(0, SUCC_W, 0, SUCC_H)
SuccessCard.Position = SUCC_CENTER
SuccessCard.BackgroundColor3 = C_CARD
SuccessCard.BorderSizePixel = 0
SuccessCard.Visible = false
SuccessCard.ZIndex = 10
SuccessCard.Parent = BuyGui
Instance.new("UICorner", SuccessCard).CornerRadius = UDim.new(0, 12)

local STitleLbl = Instance.new("TextLabel")
STitleLbl.Size = UDim2.new(1,-52,0,50)
STitleLbl.Position = UDim2.new(0,18,0,0)
STitleLbl.BackgroundTransparency = 1
STitleLbl.Text = "Purchase completed"
STitleLbl.Font = Enum.Font.GothamBold
STitleLbl.TextSize = 19
STitleLbl.TextColor3 = C_WHITE
STitleLbl.TextXAlignment = Enum.TextXAlignment.Left
STitleLbl.ZIndex = 11
STitleLbl.Parent = SuccessCard

local SCloseBtn = Instance.new("TextButton")
SCloseBtn.Name = "SCloseBtn"
SCloseBtn.Size = UDim2.new(0,40,0,50)
SCloseBtn.Position = UDim2.new(1,-44,0,0)
SCloseBtn.BackgroundTransparency = 1
SCloseBtn.Text = "X"
SCloseBtn.Font = Enum.Font.GothamBold
SCloseBtn.TextSize = 18
SCloseBtn.TextColor3 = C_WHITE
SCloseBtn.BorderSizePixel = 0
SCloseBtn.ZIndex = 12
SCloseBtn.Parent = SuccessCard

local CheckImg = Instance.new("ImageLabel")
CheckImg.Size = UDim2.new(0,60,0,60)
CheckImg.Position = UDim2.new(0.5,-30,0,44)
CheckImg.BackgroundTransparency = 1
CheckImg.Image = "rbxassetid://135084016839600"
CheckImg.ScaleType = Enum.ScaleType.Fit
CheckImg.ZIndex = 12
CheckImg.Parent = SuccessCard

local SMsg = Instance.new("TextLabel")
SMsg.Name = "SMsg"
SMsg.Size = UDim2.new(1,-36,0,32)
SMsg.Position = UDim2.new(0,18,0,116)
SMsg.BackgroundTransparency = 1
SMsg.Text = ""
SMsg.Font = Enum.Font.Gotham
SMsg.TextSize = 14
SMsg.TextColor3 = C_WHITE
SMsg.TextWrapped = true
SMsg.TextYAlignment = Enum.TextYAlignment.Center
SMsg.ZIndex = 12
SMsg.Parent = SuccessCard

local OKBtn = Instance.new("TextButton")
OKBtn.Name = "OKBtn"
OKBtn.Size = UDim2.new(1,-28,0,48)
OKBtn.Position = UDim2.new(0,14,0,158)
OKBtn.BackgroundColor3 = C_BTN_LIGHT
OKBtn.Text = "OK"
OKBtn.Font = Enum.Font.GothamBold
OKBtn.TextSize = 18
OKBtn.TextColor3 = C_WHITE
OKBtn.BorderSizePixel = 0
OKBtn.AutoButtonColor = false
OKBtn.ZIndex = 12
OKBtn.Parent = SuccessCard
Instance.new("UICorner", OKBtn).CornerRadius = UDim.new(0, 10)

-- GREEN TEXT
local GiftedGui = Instance.new("ScreenGui")
GiftedGui.Name = "GiftedNotif"
GiftedGui.ResetOnSpawn = false
GiftedGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
GiftedGui.Parent = PlayerGui

local GiftedLbl = Instance.new("TextLabel")
GiftedLbl.Size = UDim2.new(1,0,0,50)
GiftedLbl.Position = UDim2.new(0,0,1,-160)
GiftedLbl.BackgroundTransparency = 1
GiftedLbl.Text = ""
GiftedLbl.Font = Enum.Font.GothamBold
GiftedLbl.TextSize = 26
GiftedLbl.TextColor3 = Color3.fromRGB(0,220,80)
GiftedLbl.TextXAlignment = Enum.TextXAlignment.Center
GiftedLbl.TextStrokeTransparency = 0.4
GiftedLbl.ZIndex = 50
GiftedLbl.Visible = false
GiftedLbl.Parent = GiftedGui

-- CONTROL PANEL — hidden by default, J key or .C to toggle, no tab button
local CtrlGui = Instance.new("ScreenGui")
CtrlGui.Name = "ControlPanel"
CtrlGui.ResetOnSpawn = false
CtrlGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
CtrlGui.Parent = PlayerGui

local Panel = Instance.new("Frame")
Panel.Name = "Panel"
Panel.Size = UDim2.new(0, PANEL_W, 0, PANEL_H)
Panel.Position = UDim2.new(0, 10, 0.5, -PANEL_H/2)
Panel.BackgroundColor3 = Color3.fromRGB(28,28,42)
Panel.BorderSizePixel = 0
Panel.ZIndex = 20
Panel.Visible = false
Panel.Parent = CtrlGui
Instance.new("UICorner", Panel).CornerRadius = UDim.new(0, 10)

local PTBar = Instance.new("Frame")
PTBar.Size = UDim2.new(1,0,0,38)
PTBar.BackgroundColor3 = Color3.fromRGB(45,45,68)
PTBar.BorderSizePixel = 0
PTBar.ZIndex = 21
PTBar.Parent = Panel
Instance.new("UICorner", PTBar).CornerRadius = UDim.new(0, 10)

local PTLbl = Instance.new("TextLabel")
PTLbl.Size = UDim2.new(1,0,1,0)
PTLbl.BackgroundTransparency = 1
PTLbl.Text = "Control Panel"
PTLbl.Font = Enum.Font.GothamBold
PTLbl.TextSize = 13
PTLbl.TextColor3 = C_WHITE
PTLbl.ZIndex = 22
PTLbl.Parent = PTBar

local BalLbl = Instance.new("TextLabel")
BalLbl.Size = UDim2.new(1,-16,0,16)
BalLbl.Position = UDim2.new(0,8,0,44)
BalLbl.BackgroundTransparency = 1
BalLbl.Text = "Balance"
BalLbl.Font = Enum.Font.Gotham
BalLbl.TextSize = 11
BalLbl.TextColor3 = Color3.fromRGB(175,175,200)
BalLbl.TextXAlignment = Enum.TextXAlignment.Left
BalLbl.ZIndex = 22
BalLbl.Parent = Panel

local BalanceBox = Instance.new("TextBox")
BalanceBox.Size = UDim2.new(1,-16,0,28)
BalanceBox.Position = UDim2.new(0,8,0,61)
BalanceBox.BackgroundColor3 = Color3.fromRGB(42,42,62)
BalanceBox.Text = tostring(balance)
BalanceBox.Font = Enum.Font.Gotham
BalanceBox.TextSize = 13
BalanceBox.TextColor3 = C_WHITE
BalanceBox.PlaceholderColor3 = Color3.fromRGB(110,110,130)
BalanceBox.BorderSizePixel = 0
BalanceBox.ZIndex = 22
BalanceBox.Parent = Panel
Instance.new("UICorner", BalanceBox).CornerRadius = UDim.new(0, 5)

local function togglePanel()
	panelVisible = not panelVisible
	Panel.Visible = panelVisible
end

-- CORE FUNCTIONS
local function refreshBalance()
	BalanceLbl.Text = "\u{E002} " .. fmt(balance)
end

local function deductBalance()
	if balance < currentCost then return false end
	balance = balance - currentCost
	refreshBalance()
	BalanceBox.Text = tostring(balance)
	return true
end

local function playSweep()
	BuyBtn.Active = false
	BuyBtn.BackgroundColor3 = C_BTN_DARK
	SweepCover.BackgroundColor3 = C_BTN_LIGHT
	SweepCover.Size = UDim2.new(0,0,1,0)
	local t = TweenService:Create(SweepCover, TweenInfo.new(3, Enum.EasingStyle.Linear, Enum.EasingDirection.In), {Size = UDim2.new(1,0,1,0)})
	t:Play()
	t.Completed:Connect(function() BuyBtn.Active = true end)
end

local function slideUp(frame, finalPos)
	frame.Position = UDim2.new(finalPos.X.Scale, finalPos.X.Offset, finalPos.Y.Scale, finalPos.Y.Offset + 250)
	TweenService:Create(frame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position = finalPos}):Play()
end

local function showGiftedText(playerName, productName)
	GiftedLbl.Text = "You gifted " .. productName .. " to " .. playerName
	GiftedLbl.Visible = true
	task.delay(5, function()
		GiftedLbl.Visible = false
		GiftedLbl.Text = ""
	end)
end

local function openGui(data)
	if guiOpen then return end  -- FIXED: block if already open
	guiOpen = true
	currentCost = data.price
	currentName = data.name
	IconImg.Image = data.image
	ItemName.Text = data.name
	ItemPrice.Text = data.priceText
	refreshBalance()
	SuccessCard.Visible = false
	Card.Visible = true
	BuyGui.Enabled = true
	slideUp(Card, CARD_CENTER)
	playSweep()
	OKBtn.BackgroundColor3 = C_BTN_LIGHT
end

local function closeGui()
	guiOpen = false
	BuyGui.Enabled = false
	Card.Visible = false
	SuccessCard.Visible = false
end

-- Track active purchase to prevent spam
local purchaseActive = false

local function showSuccess()
	if purchaseActive then return end
	purchaseActive = true
	local gifting = detectedPlayer ~= ""
	local name = gifting and detectedPlayer or ""
	local productName = (currentName ~= "") and currentName or "item"
	if gifting then
		-- currentName already has [GIFT] prefix from readItemData
		SMsg.Text = "You have successfully purchased " .. productName .. " to " .. name .. "."
	else
		SMsg.Text = "You have successfully purchased " .. productName .. "."
	end
	Card.Visible = false
	SuccessCard.Visible = true
	slideUp(SuccessCard, SUCC_CENTER)
	if gifting then showGiftedText(name, productName) end
end

-- HOOK BUY BUTTONS
local hookedButtons = {}

local function hookBuyButton(btn, item)
	if hookedButtons[btn] then return end
	if not ITEM_TYPES[item.Name] then return end
	hookedButtons[btn] = true
	btn.Active = false
	btn.AutoButtonColor = false

	-- mobile safe: track start pos, cancel if dragged more than 20px
	local pressing = false
	local startPos = nil

	btn.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1
			or input.UserInputType == Enum.UserInputType.Touch then
			pressing = true
			startPos = Vector2.new(input.Position.X, input.Position.Y)
		end
	end)

	btn.InputChanged:Connect(function(input)
		if pressing and startPos and (input.UserInputType == Enum.UserInputType.MouseMovement
			or input.UserInputType == Enum.UserInputType.Touch) then
			local dist = (Vector2.new(input.Position.X, input.Position.Y) - startPos).Magnitude
			if dist > 20 then
				pressing = false
			end
		end
	end)

	btn.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1
			or input.UserInputType == Enum.UserInputType.Touch then
			if pressing then
				pressing = false
				task.spawn(function()
					local data = readItemData(item)
					openGui(data)
				end)
			end
			pressing = false
			startPos = nil
		end
	end)
end

local function hookAll(shopGui)
	task.spawn(function()
		local ok1, shopFrame = pcall(function() return shopGui:WaitForChild("Shop", 10) end)
		if not ok1 or not shopFrame then return end
		local ok2, content = pcall(function() return shopFrame:WaitForChild("Content", 10) end)
		if not ok2 or not content then return end
		local ok3, list = pcall(function() return content:WaitForChild("List", 10) end)
		if not ok3 or not list then return end

		local function hookItem(item)
			for _, child in ipairs(item:GetDescendants()) do
				if child:IsA("TextButton") or child:IsA("ImageButton") then
					hookBuyButton(child, item)
				end
			end
			item.DescendantAdded:Connect(function(child)
				if child:IsA("TextButton") or child:IsA("ImageButton") then
					hookBuyButton(child, item)
				end
			end)
		end

		local function hookSubList(subList)
			for _, item in ipairs(subList:GetChildren()) do hookItem(item) end
			subList.ChildAdded:Connect(hookItem)
		end

		for _, subList in ipairs(list:GetChildren()) do
			if subList:IsA("GuiObject") then hookSubList(subList) end
		end
		list.ChildAdded:Connect(function(subList)
			if subList:IsA("GuiObject") then hookSubList(subList) end
		end)
	end)
end

local existing = PlayerGui:FindFirstChild("Shop")
if existing then hookAll(existing) end
PlayerGui.ChildAdded:Connect(function(child)
	if child.Name == "Shop" then hookAll(child) end
end)

CloseBtn.MouseButton1Click:Connect(closeGui)
SCloseBtn.MouseButton1Click:Connect(closeGui)

local function onBuyClick()
	if not BuyBtn.Active then return end
	-- FIXED: block if already triggered (prevents spam clicking Buy button in popup)
	if not guiOpen then return end
	detectedPlayer = getGiftTargetPlayer()
	BuyBtn.Active = false  -- disable immediately to prevent double trigger
	task.delay(1.4, playPurchaseSound)
	task.delay(1.5, showSuccess)
end

BuyBtn.MouseButton1Click:Connect(onBuyClick)
BuyBtn.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.Touch then onBuyClick() end
end)

local function onOKClick()
	OKBtn.BackgroundColor3 = C_BTN_DARK
	deductBalance()
	purchaseActive = false  -- reset so next purchase works
	task.delay(0.15, function()
		closeGui()
		OKBtn.BackgroundColor3 = C_BTN_LIGHT
	end)
end

OKBtn.MouseButton1Click:Connect(onOKClick)
OKBtn.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.Touch then onOKClick() end
end)

BalanceBox.FocusLost:Connect(function()
	local v = tonumber(BalanceBox.Text)
	if v and v >= 0 then
		balance = math.floor(v)
		refreshBalance()
	else
		BalanceBox.Text = tostring(balance)
	end
end)

-- J key or .C to toggle panel
UserInputService.InputBegan:Connect(function(inp, gp)
	if gp then return end
	if inp.KeyCode == Enum.KeyCode.J then
		togglePanel()
	end
end)

LocalPlayer.Chatted:Connect(function(msg)
	if msg:lower() == ".c" then
		togglePanel()
	end
end)

refreshBalance()
