-- ============================================================
-- ROBLOX BUY ITEM GUI + CONTROL PANEL
-- LocalScript — Place inside StarterPlayerScripts
-- ============================================================

local Players          = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService     = game:GetService("TweenService")
local Debris           = game:GetService("Debris")

local LocalPlayer = Players.LocalPlayer
local PlayerGui   = LocalPlayer:WaitForChild("PlayerGui")

-- ============================================================
-- STATE
-- ============================================================
local balance        = 66245
local currentCost    = 7499   -- tracks which price was used (7499 or 2999)
local guiOpen        = false
local panelMinimized = false
local ITEM_NAME      = "[GIFT] Admin Command"
local keybind        = Enum.KeyCode.F

-- ============================================================
-- COLORS
-- ============================================================
local C_CARD      = Color3.fromRGB(55,  55,  70)
local C_WHITE     = Color3.fromRGB(255, 255, 255)
local C_ICON      = Color3.fromRGB(55,  55,  70)
local C_BTN_DARK  = Color3.fromRGB(55,  65,  160)
local C_BTN_LIGHT = Color3.fromRGB(88,  101, 242)

local CARD_W      = 460
local CARD_H      = 220
local CARD_CENTER = UDim2.new(0.5, -CARD_W/2, 0.5, -CARD_H/2)
local SUCC_W      = 460
local SUCC_H      = 220
local SUCC_CENTER = UDim2.new(0.5, -SUCC_W/2, 0.5, -SUCC_H/2)
local PANEL_W     = 210
local PANEL_H     = 240

-- ============================================================
-- HELPER
-- ============================================================
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

-- ============================================================
-- PLAY SOUND — works on both PC and mobile
-- ============================================================
local function playPurchaseSound()
	local snd = Instance.new("Sound")
	snd.SoundId = "rbxassetid://89446320629366"
	snd.Volume  = 1
	-- Parent to workspace so it plays on both PC and mobile
	snd.Parent  = workspace
	snd:Play()
	Debris:AddItem(snd, 10)
end

-- ============================================================
-- DETECT GIFTED PLAYER
-- ============================================================
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

-- ============================================================
-- BUY GUI
-- ============================================================
local BuyGui          = Instance.new("ScreenGui")
BuyGui.Name           = "BuyItemGui"
BuyGui.ResetOnSpawn   = false
BuyGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
BuyGui.Enabled        = false
BuyGui.Parent         = PlayerGui

local Backdrop            = Instance.new("Frame")
Backdrop.Size             = UDim2.new(1, 0, 1, 0)
Backdrop.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Backdrop.BackgroundTransparency = 0.52
Backdrop.BorderSizePixel  = 0
Backdrop.ZIndex           = 1
Backdrop.Parent           = BuyGui

local Card                = Instance.new("Frame")
Card.Name                 = "Card"
Card.Size                 = UDim2.new(0, CARD_W, 0, CARD_H)
Card.Position             = CARD_CENTER
Card.BackgroundColor3     = C_CARD
Card.BorderSizePixel      = 0
Card.ZIndex               = 2
Card.Parent               = BuyGui
Instance.new("UICorner", Card).CornerRadius = UDim.new(0, 12)

local TitleLbl            = Instance.new("TextLabel")
TitleLbl.Size             = UDim2.new(0, 150, 0, 50)
TitleLbl.Position         = UDim2.new(0, 18, 0, 0)
TitleLbl.BackgroundTransparency = 1
TitleLbl.Text             = "Buy item"
TitleLbl.Font             = Enum.Font.GothamBold
TitleLbl.TextSize         = 20
TitleLbl.TextColor3       = C_WHITE
TitleLbl.TextXAlignment   = Enum.TextXAlignment.Left
TitleLbl.ZIndex           = 3
TitleLbl.Parent           = Card

local BalanceLbl          = Instance.new("TextLabel")
BalanceLbl.Name           = "BalanceLbl"
BalanceLbl.Size           = UDim2.new(0, 130, 0, 50)
BalanceLbl.Position       = UDim2.new(1, -182, 0, 0)
BalanceLbl.BackgroundTransparency = 1
BalanceLbl.Font           = Enum.Font.GothamBold
BalanceLbl.TextSize       = 16
BalanceLbl.TextColor3     = C_WHITE
BalanceLbl.TextXAlignment = Enum.TextXAlignment.Right
BalanceLbl.ZIndex         = 3
BalanceLbl.Parent         = Card

local CloseBtn            = Instance.new("TextButton")
CloseBtn.Name             = "CloseBtn"
CloseBtn.Size             = UDim2.new(0, 40, 0, 50)
CloseBtn.Position         = UDim2.new(1, -44, 0, 0)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Text             = "X"
CloseBtn.Font             = Enum.Font.GothamBold
CloseBtn.TextSize         = 18
CloseBtn.TextColor3       = C_WHITE
CloseBtn.BorderSizePixel  = 0
CloseBtn.ZIndex           = 4
CloseBtn.Parent           = Card

-- Icon 80x80, center Y = 54 + 40 = 94
local IconFrame           = Instance.new("Frame")
IconFrame.Size            = UDim2.new(0, 80, 0, 80)
IconFrame.Position        = UDim2.new(0, 14, 0, 54)
IconFrame.BackgroundColor3 = C_ICON
IconFrame.BorderSizePixel = 0
IconFrame.ZIndex          = 3
IconFrame.Parent          = Card
Instance.new("UICorner", IconFrame).CornerRadius = UDim.new(0, 8)

local IconImg             = Instance.new("ImageLabel")
IconImg.Size              = UDim2.new(1, 0, 1, 0)
IconImg.BackgroundTransparency = 1
IconImg.Image             = "rbxassetid://100337222375957"
IconImg.ScaleType         = Enum.ScaleType.Fit
IconImg.ZIndex            = 4
IconImg.Parent            = IconFrame

-- Name above icon center (Y=70)
local ItemName            = Instance.new("TextLabel")
ItemName.Size             = UDim2.new(1, -110, 0, 20)
ItemName.Position         = UDim2.new(0, 106, 0, 70)
ItemName.BackgroundTransparency = 1
ItemName.Text             = ITEM_NAME
ItemName.Font             = Enum.Font.GothamBold
ItemName.TextSize         = 15
ItemName.TextColor3       = C_WHITE
ItemName.TextXAlignment   = Enum.TextXAlignment.Left
ItemName.ZIndex           = 3
ItemName.Parent           = Card

-- Price below icon center (Y=100), updated dynamically per keybind
local ItemPrice           = Instance.new("TextLabel")
ItemPrice.Name            = "ItemPrice"
ItemPrice.Size            = UDim2.new(1, -110, 0, 20)
ItemPrice.Position        = UDim2.new(0, 106, 0, 100)
ItemPrice.BackgroundTransparency = 1
ItemPrice.Text            = "\u{E002} 7,499"
ItemPrice.Font            = Enum.Font.Gotham
ItemPrice.TextSize        = 14
ItemPrice.TextColor3      = C_WHITE
ItemPrice.TextXAlignment  = Enum.TextXAlignment.Left
ItemPrice.ZIndex          = 3
ItemPrice.Parent          = Card

local BuyBtn              = Instance.new("TextButton")
BuyBtn.Name               = "BuyBtn"
BuyBtn.Size               = UDim2.new(1, -28, 0, 48)
BuyBtn.Position           = UDim2.new(0, 14, 0, 158)
BuyBtn.BackgroundColor3   = C_BTN_DARK
BuyBtn.Text               = ""
BuyBtn.BorderSizePixel    = 0
BuyBtn.AutoButtonColor    = false
BuyBtn.Active             = false
BuyBtn.ZIndex             = 3
BuyBtn.Parent             = Card
Instance.new("UICorner", BuyBtn).CornerRadius = UDim.new(0, 10)

local SweepCover          = Instance.new("Frame")
SweepCover.Name           = "SweepCover"
SweepCover.Size           = UDim2.new(0, 0, 1, 0)
SweepCover.BackgroundColor3 = C_BTN_LIGHT
SweepCover.BorderSizePixel  = 0
SweepCover.ZIndex         = 4
SweepCover.Parent         = BuyBtn
Instance.new("UICorner", SweepCover).CornerRadius = UDim.new(0, 10)

local BuyLbl              = Instance.new("TextLabel")
BuyLbl.Size               = UDim2.new(1, 0, 1, 0)
BuyLbl.BackgroundTransparency = 1
BuyLbl.Text               = "Buy"
BuyLbl.Font               = Enum.Font.GothamBold
BuyLbl.TextSize           = 18
BuyLbl.TextColor3         = C_WHITE
BuyLbl.ZIndex             = 5
BuyLbl.Parent             = BuyBtn

-- ============================================================
-- SUCCESS POPUP
-- ============================================================
local SuccessCard         = Instance.new("Frame")
SuccessCard.Name          = "SuccessCard"
SuccessCard.Size          = UDim2.new(0, SUCC_W, 0, SUCC_H)
SuccessCard.Position      = SUCC_CENTER
SuccessCard.BackgroundColor3 = C_CARD
SuccessCard.BorderSizePixel  = 0
SuccessCard.Visible       = false
SuccessCard.ZIndex        = 10
SuccessCard.Parent        = BuyGui
Instance.new("UICorner", SuccessCard).CornerRadius = UDim.new(0, 12)

local STitleLbl           = Instance.new("TextLabel")
STitleLbl.Size            = UDim2.new(1, -52, 0, 50)
STitleLbl.Position        = UDim2.new(0, 18, 0, 0)
STitleLbl.BackgroundTransparency = 1
STitleLbl.Text            = "Purchase completed"
STitleLbl.Font            = Enum.Font.GothamBold
STitleLbl.TextSize        = 19
STitleLbl.TextColor3      = C_WHITE
STitleLbl.TextXAlignment  = Enum.TextXAlignment.Left
STitleLbl.ZIndex          = 11
STitleLbl.Parent          = SuccessCard

local SCloseBtn           = Instance.new("TextButton")
SCloseBtn.Name            = "SCloseBtn"
SCloseBtn.Size            = UDim2.new(0, 40, 0, 50)
SCloseBtn.Position        = UDim2.new(1, -44, 0, 0)
SCloseBtn.BackgroundTransparency = 1
SCloseBtn.Text            = "X"
SCloseBtn.Font            = Enum.Font.GothamBold
SCloseBtn.TextSize        = 18
SCloseBtn.TextColor3      = C_WHITE
SCloseBtn.BorderSizePixel = 0
SCloseBtn.ZIndex          = 12
SCloseBtn.Parent          = SuccessCard

-- Bigger checkmark
local CheckImg            = Instance.new("ImageLabel")
CheckImg.Size             = UDim2.new(0, 60, 0, 60)
CheckImg.Position         = UDim2.new(0.5, -30, 0, 44)
CheckImg.BackgroundTransparency = 1
CheckImg.Image            = "rbxassetid://135084016839600"
CheckImg.ScaleType        = Enum.ScaleType.Fit
CheckImg.ZIndex           = 12
CheckImg.Parent           = SuccessCard

-- Bigger + lower message
local SMsg                = Instance.new("TextLabel")
SMsg.Name                 = "SMsg"
SMsg.Size                 = UDim2.new(1, -36, 0, 32)
SMsg.Position             = UDim2.new(0, 18, 0, 116)
SMsg.BackgroundTransparency = 1
SMsg.Text                 = ""
SMsg.Font                 = Enum.Font.Gotham
SMsg.TextSize             = 14
SMsg.TextColor3           = C_WHITE
SMsg.TextWrapped          = true
SMsg.TextYAlignment       = Enum.TextYAlignment.Center
SMsg.ZIndex               = 12
SMsg.Parent               = SuccessCard

local OKBtn               = Instance.new("TextButton")
OKBtn.Name                = "OKBtn"
OKBtn.Size                = UDim2.new(1, -28, 0, 48)
OKBtn.Position            = UDim2.new(0, 14, 0, 158)
OKBtn.BackgroundColor3    = C_BTN_LIGHT
OKBtn.Text                = "OK"
OKBtn.Font                = Enum.Font.GothamBold
OKBtn.TextSize            = 18
OKBtn.TextColor3          = C_WHITE
OKBtn.BorderSizePixel     = 0
OKBtn.AutoButtonColor     = false
OKBtn.ZIndex              = 12
OKBtn.Parent              = SuccessCard
Instance.new("UICorner", OKBtn).CornerRadius = UDim.new(0, 10)

-- ============================================================
-- GREEN GIFTED TEXT
-- ============================================================
local GiftedGui           = Instance.new("ScreenGui")
GiftedGui.Name            = "GiftedNotif"
GiftedGui.ResetOnSpawn    = false
GiftedGui.ZIndexBehavior  = Enum.ZIndexBehavior.Sibling
GiftedGui.Parent          = PlayerGui

local GiftedLbl           = Instance.new("TextLabel")
GiftedLbl.Name            = "GiftedLbl"
GiftedLbl.Size            = UDim2.new(1, 0, 0, 50)
GiftedLbl.Position        = UDim2.new(0, 0, 1, -160)
GiftedLbl.BackgroundTransparency = 1
GiftedLbl.Text            = ""
GiftedLbl.Font            = Enum.Font.GothamBold
GiftedLbl.TextSize        = 26
GiftedLbl.TextColor3      = Color3.fromRGB(0, 220, 80)
GiftedLbl.TextXAlignment  = Enum.TextXAlignment.Center
GiftedLbl.TextStrokeTransparency = 0.4
GiftedLbl.ZIndex          = 50
GiftedLbl.Visible         = false
GiftedLbl.Parent          = GiftedGui

-- ============================================================
-- CONTROL PANEL
-- ============================================================
local CtrlGui             = Instance.new("ScreenGui")
CtrlGui.Name              = "ControlPanel"
CtrlGui.ResetOnSpawn      = false
CtrlGui.ZIndexBehavior    = Enum.ZIndexBehavior.Sibling
CtrlGui.Parent            = PlayerGui

local MinimizeTab         = Instance.new("TextButton")
MinimizeTab.Name          = "MinimizeTab"
MinimizeTab.Size          = UDim2.new(0, 30, 0, 60)
MinimizeTab.Position      = UDim2.new(0, 0, 0.5, -30)
MinimizeTab.BackgroundColor3 = Color3.fromRGB(45, 45, 68)
MinimizeTab.Text          = ">"
MinimizeTab.Font          = Enum.Font.GothamBold
MinimizeTab.TextSize      = 16
MinimizeTab.TextColor3    = C_WHITE
MinimizeTab.BorderSizePixel = 0
MinimizeTab.AutoButtonColor = false
MinimizeTab.ZIndex        = 25
MinimizeTab.Parent        = CtrlGui
Instance.new("UICorner", MinimizeTab).CornerRadius = UDim.new(0, 6)

local Panel               = Instance.new("Frame")
Panel.Name                = "Panel"
Panel.Size                = UDim2.new(0, 0, 0, PANEL_H)
Panel.Position            = UDim2.new(0, 32, 0.5, -PANEL_H/2)
Panel.BackgroundColor3    = Color3.fromRGB(28, 28, 42)
Panel.BorderSizePixel     = 0
Panel.ZIndex              = 20
Panel.ClipsDescendants    = true
Panel.Parent              = CtrlGui
Instance.new("UICorner", Panel).CornerRadius = UDim.new(0, 10)

local PTBar               = Instance.new("Frame")
PTBar.Size                = UDim2.new(1, 0, 0, 38)
PTBar.BackgroundColor3    = Color3.fromRGB(45, 45, 68)
PTBar.BorderSizePixel     = 0
PTBar.ZIndex              = 21
PTBar.Parent              = Panel
Instance.new("UICorner", PTBar).CornerRadius = UDim.new(0, 10)

local PTLbl               = Instance.new("TextLabel")
PTLbl.Size                = UDim2.new(1, 0, 1, 0)
PTLbl.BackgroundTransparency = 1
PTLbl.Text                = "Control Panel"
PTLbl.Font                = Enum.Font.GothamBold
PTLbl.TextSize            = 13
PTLbl.TextColor3          = C_WHITE
PTLbl.ZIndex              = 22
PTLbl.Parent              = PTBar

local function makeBox(yPos, labelText, defaultText)
	local lbl             = Instance.new("TextLabel")
	lbl.Size              = UDim2.new(1, -16, 0, 16)
	lbl.Position          = UDim2.new(0, 8, 0, yPos)
	lbl.BackgroundTransparency = 1
	lbl.Text              = labelText
	lbl.Font              = Enum.Font.Gotham
	lbl.TextSize          = 11
	lbl.TextColor3        = Color3.fromRGB(175, 175, 200)
	lbl.TextXAlignment    = Enum.TextXAlignment.Left
	lbl.ZIndex            = 22
	lbl.Parent            = Panel
	local box             = Instance.new("TextBox")
	box.Size              = UDim2.new(1, -16, 0, 28)
	box.Position          = UDim2.new(0, 8, 0, yPos + 17)
	box.BackgroundColor3  = Color3.fromRGB(42, 42, 62)
	box.Text              = defaultText
	box.Font              = Enum.Font.Gotham
	box.TextSize          = 13
	box.TextColor3        = C_WHITE
	box.PlaceholderColor3 = Color3.fromRGB(110, 110, 130)
	box.BorderSizePixel   = 0
	box.ZIndex            = 22
	box.Parent            = Panel
	Instance.new("UICorner", box).CornerRadius = UDim.new(0, 5)
	return box
end

local BalanceBox = makeBox(46,  "Balance", tostring(balance))
local KeybindBox = makeBox(104, "Keybind (e.g. F)", "F")

local OpenBtn             = Instance.new("TextButton")
OpenBtn.Name              = "OpenBtn"
OpenBtn.Size              = UDim2.new(1, -16, 0, 34)
OpenBtn.Position          = UDim2.new(0, 8, 0, 162)
OpenBtn.BackgroundColor3  = C_BTN_LIGHT
OpenBtn.Text              = "Open Shop"
OpenBtn.Font              = Enum.Font.GothamBold
OpenBtn.TextSize          = 13
OpenBtn.TextColor3        = C_WHITE
OpenBtn.BorderSizePixel   = 0
OpenBtn.AutoButtonColor   = false
OpenBtn.ZIndex            = 22
OpenBtn.Parent            = Panel
Instance.new("UICorner", OpenBtn).CornerRadius = UDim.new(0, 7)

-- ============================================================
-- MINIMIZE / EXPAND
-- ============================================================
local function setPanel(minimized)
	panelMinimized = minimized
	if minimized then
		TweenService:Create(Panel, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {
			Size = UDim2.new(0, 0, 0, PANEL_H)
		}):Play()
		MinimizeTab.Text = ">"
		TweenService:Create(MinimizeTab, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {
			Position = UDim2.new(0, 0, 0.5, -30)
		}):Play()
	else
		TweenService:Create(Panel, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {
			Size = UDim2.new(0, PANEL_W, 0, PANEL_H)
		}):Play()
		MinimizeTab.Text = "<"
		TweenService:Create(MinimizeTab, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {
			Position = UDim2.new(0, PANEL_W + 32, 0.5, -30)
		}):Play()
	end
end

setPanel(true)
MinimizeTab.MouseButton1Click:Connect(function()
	setPanel(not panelMinimized)
end)

-- ============================================================
-- CORE FUNCTIONS
-- ============================================================

local function refreshBalance()
	BalanceLbl.Text = "\u{E002} " .. fmt(balance)
end

-- Deduct based on currentCost (7499 or 2999)
local function deductBalance()
	if balance < currentCost then return false end
	balance = balance - currentCost
	refreshBalance()
	BalanceBox.Text = tostring(balance)
	return true
end

local function playSweep()
	BuyBtn.Active               = false
	BuyBtn.BackgroundColor3     = C_BTN_DARK
	SweepCover.BackgroundColor3 = C_BTN_LIGHT
	SweepCover.Size             = UDim2.new(0, 0, 1, 0)
	local t = TweenService:Create(
		SweepCover,
		TweenInfo.new(3, Enum.EasingStyle.Linear, Enum.EasingDirection.In),
		{ Size = UDim2.new(1, 0, 1, 0) }
	)
	t:Play()
	t.Completed:Connect(function()
		BuyBtn.Active = true
	end)
end

local function slideUp(frame, finalPos)
	frame.Position = UDim2.new(
		finalPos.X.Scale, finalPos.X.Offset,
		finalPos.Y.Scale, finalPos.Y.Offset + 250
	)
	TweenService:Create(frame,
		TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
		{ Position = finalPos }
	):Play()
end

local function showGiftedText(playerName)
	GiftedLbl.Text    = "You gifted " .. ITEM_NAME .. " to " .. playerName
	GiftedLbl.Visible = true
	task.delay(5, function()
		GiftedLbl.Visible = false
		GiftedLbl.Text    = ""
	end)
end

-- Open gui with specific cost (7499 or 2999)
local function openGui(cost)
	if guiOpen then return end
	currentCost = cost or 7499
	-- Update displayed price to match
	if currentCost == 2999 then
		ItemPrice.Text = "\u{E002} 2,999"
	else
		ItemPrice.Text = "\u{E002} 7,499"
	end
	guiOpen             = true
	refreshBalance()
	SuccessCard.Visible = false
	Card.Visible        = true
	BuyGui.Enabled      = true
	slideUp(Card, CARD_CENTER)
	playSweep()
	OKBtn.BackgroundColor3 = C_BTN_LIGHT
end

local function closeGui()
	guiOpen             = false
	BuyGui.Enabled      = false
	Card.Visible        = false
	SuccessCard.Visible = false
end

local detectedPlayerName = ""

local function showSuccess()
	local name = (detectedPlayerName ~= "") and detectedPlayerName or "Unknown"
	SMsg.Text           = "You have successfully bought " .. ITEM_NAME .. " to " .. name .. "."
	Card.Visible        = false
	SuccessCard.Visible = true
	slideUp(SuccessCard, SUCC_CENTER)
	showGiftedText(name)
end

local function parseKey(txt)
	local u = txt:upper():gsub("%s", "")
	local ok, kc = pcall(function() return Enum.KeyCode[u] end)
	if ok and kc then keybind = kc end
end

-- ============================================================
-- HOOK THE REAL SHOP BUY BUTTON
-- ============================================================
local function hookShop()
	task.spawn(function()
		local shopGui      = PlayerGui:WaitForChild("Shop", 30)
		if not shopGui then return end
		local shopFrame    = shopGui:WaitForChild("Shop", 10)
		if not shopFrame then return end
		local content      = shopFrame:WaitForChild("Content", 10)
		if not content then return end
		local list         = content:WaitForChild("List", 10)
		if not list then return end
		local gamepassList = list:WaitForChild("GamepassList", 10)
		if not gamepassList then return end
		local item         = gamepassList:WaitForChild("1227013099", 10)
		if not item then return end
		local buyBtn       = item:WaitForChild("Buy", 10)
		if not buyBtn then return end

		buyBtn.Active          = false
		buyBtn.AutoButtonColor = false

		-- Works for both PC (MouseButton1) and mobile (Touch)
		buyBtn.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1
				or input.UserInputType == Enum.UserInputType.Touch then
				openGui(7499)
			end
		end)
	end)
end

hookShop()
PlayerGui.ChildAdded:Connect(function(child)
	if child.Name == "Shop" then hookShop() end
end)

-- ============================================================
-- CONNECTIONS
-- ============================================================

OpenBtn.MouseButton1Click:Connect(function() openGui(7499) end)
CloseBtn.MouseButton1Click:Connect(closeGui)
SCloseBtn.MouseButton1Click:Connect(closeGui)

-- Buy button: detect player, play sound at 1.4s, show success at 1.5s
-- NO balance deduction here — deduct on OK
BuyBtn.MouseButton1Click:Connect(function()
	if not BuyBtn.Active then return end
	-- Detect player name at moment of click
	detectedPlayerName = getGiftTargetPlayer()

	-- Play sound at 1.4s
	task.delay(1.4, function()
		playPurchaseSound()
	end)

	-- Show success popup at 1.5s
	task.delay(1.5, function()
		showSuccess()
	end)
end)

-- Also handle Touch for BuyBtn (mobile)
BuyBtn.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.Touch then
		if not BuyBtn.Active then return end
		detectedPlayerName = getGiftTargetPlayer()
		task.delay(1.4, function()
			playPurchaseSound()
		end)
		task.delay(1.5, function()
			showSuccess()
		end)
	end
end)

-- OK button: deduct balance THEN close
OKBtn.MouseButton1Click:Connect(function()
	OKBtn.BackgroundColor3 = C_BTN_DARK
	-- Deduct using currentCost so 7499 or 2999 is correct
	deductBalance()
	task.delay(0.15, function()
		closeGui()
		OKBtn.BackgroundColor3 = C_BTN_LIGHT
	end)
end)

-- Also handle Touch for OKBtn (mobile)
OKBtn.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.Touch then
		OKBtn.BackgroundColor3 = C_BTN_DARK
		deductBalance()
		task.delay(0.15, function()
			closeGui()
			OKBtn.BackgroundColor3 = C_BTN_LIGHT
		end)
	end
end)

BalanceBox.FocusLost:Connect(function()
	local v = tonumber(BalanceBox.Text)
	if v and v >= 0 then
		balance         = math.floor(v)
		refreshBalance()
	else
		BalanceBox.Text = tostring(balance)
	end
end)

KeybindBox.FocusLost:Connect(function()
	parseKey(KeybindBox.Text)
end)

UserInputService.InputBegan:Connect(function(inp, gp)
	if gp then return end
	-- T = open with 7,499
	if inp.KeyCode == Enum.KeyCode.T then
		if guiOpen then closeGui() else openGui(7499) end
	end
	-- Y = open with 2,999
	if inp.KeyCode == Enum.KeyCode.Y then
		if guiOpen then closeGui() else openGui(2999) end
	end
	-- F1 = toggle control panel
	if inp.KeyCode == Enum.KeyCode.F1 then
		setPanel(not panelMinimized)
	end
end)

refreshBalance()

-- ============================================================
-- END OF SCRIPT
-- ============================================================
