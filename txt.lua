-- ============================================================
-- ROBLOX BUY ITEM GUI + CONTROL PANEL  (LocalScript)
-- Place inside StarterPlayerScripts
-- ============================================================

local Players          = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService     = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui   = LocalPlayer:WaitForChild("PlayerGui")

-- ============================================================
-- STATE
-- ============================================================
local balance        = 66245
local ITEM_COST      = 7499
local selectedPlayer = ""
local keybind        = Enum.KeyCode.F
local guiOpen        = false

-- ============================================================
-- COLORS
-- Card   = medium gray  (matches original screenshot exactly)
-- Text   = pure white   (ALL text everywhere)
-- Button = medium blue → sweep turns it from dark blue to light blue
-- ============================================================
local GRAY        = Color3.fromRGB(58, 58, 58)    -- card background
local WHITE       = Color3.fromRGB(255, 255, 255) -- ALL text
local DIVIDER     = Color3.fromRGB(90, 90, 90)    -- divider lines
local ICON_BG     = Color3.fromRGB(75, 75, 75)    -- HD icon background
local BTN_DARK    = Color3.fromRGB(50, 80, 170)   -- button starts dark blue
local BTN_LIGHT   = Color3.fromRGB(100, 149, 237) -- sweep reveals light blue
local BTN_PRESS   = Color3.fromRGB(35, 60, 140)   -- clicked = darker blue

-- ============================================================
-- HELPER: comma-format  66245 → "66,245"
-- ============================================================
local function fmt(n)
	local s = tostring(math.floor(n))
	local r, c = "", 0
	for i = #s, 1, -1 do
		if c > 0 and c % 3 == 0 then r = "," .. r end
		r = s:sub(i,i) .. r
		c = c + 1
	end
	return r
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

-- Backdrop
local Backdrop = Instance.new("Frame")
Backdrop.Size  = UDim2.new(1,0,1,0)
Backdrop.BackgroundColor3 = Color3.fromRGB(0,0,0)
Backdrop.BackgroundTransparency = 0.55
Backdrop.BorderSizePixel = 0
Backdrop.ZIndex = 1
Backdrop.Parent = BuyGui

-- ── MAIN CARD ──────────────────────────────────────────────
-- Medium gray, rounded, taller to match original proportions
local Card = Instance.new("Frame")
Card.Name  = "Card"
Card.Size  = UDim2.new(0, 330, 0, 215)
Card.Position = UDim2.new(0.5, -165, 0.5, -107)
Card.BackgroundColor3 = GRAY
Card.BorderSizePixel  = 0
Card.ZIndex = 2
Card.Parent = BuyGui
Instance.new("UICorner", Card).CornerRadius = UDim.new(0, 8)

-- ── TITLE ROW ──────────────────────────────────────────────
-- "Buy item"  |  ⊙ 66,245  |  X

local TitleLbl = Instance.new("TextLabel")
TitleLbl.Size  = UDim2.new(0, 120, 0, 44)
TitleLbl.Position = UDim2.new(0, 12, 0, 0)
TitleLbl.BackgroundTransparency = 1
TitleLbl.Text  = "Buy item"
TitleLbl.Font  = Enum.Font.GothamBold
TitleLbl.TextSize = 18
TitleLbl.TextColor3 = WHITE
TitleLbl.TextXAlignment = Enum.TextXAlignment.Left
TitleLbl.ZIndex = 3
TitleLbl.Parent = Card

local BalanceLbl = Instance.new("TextLabel")
BalanceLbl.Name  = "BalanceLbl"
BalanceLbl.Size  = UDim2.new(0, 105, 0, 44)
BalanceLbl.Position = UDim2.new(1, -148, 0, 0)
BalanceLbl.BackgroundTransparency = 1
BalanceLbl.Font  = Enum.Font.GothamBold
BalanceLbl.TextSize = 14
BalanceLbl.TextColor3 = WHITE
BalanceLbl.TextXAlignment = Enum.TextXAlignment.Right
BalanceLbl.ZIndex = 3
BalanceLbl.Parent = Card

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size  = UDim2.new(0, 32, 0, 44)
CloseBtn.Position = UDim2.new(1, -36, 0, 0)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Text  = "X"
CloseBtn.Font  = Enum.Font.GothamBold
CloseBtn.TextSize = 16
CloseBtn.TextColor3 = WHITE
CloseBtn.BorderSizePixel = 0
CloseBtn.ZIndex = 3
CloseBtn.Parent = Card

-- Divider under title
local D1 = Instance.new("Frame")
D1.Size  = UDim2.new(1,0,0,1)
D1.Position = UDim2.new(0,0,0,44)
D1.BackgroundColor3 = DIVIDER
D1.BorderSizePixel  = 0
D1.ZIndex = 3
D1.Parent = Card

-- ── ITEM ROW ───────────────────────────────────────────────
-- HD image icon + item name + price

local IconFrame = Instance.new("Frame")
IconFrame.Size  = UDim2.new(0, 58, 0, 58)
IconFrame.Position = UDim2.new(0, 12, 0, 54)
IconFrame.BackgroundColor3 = ICON_BG
IconFrame.BorderSizePixel  = 0
IconFrame.ZIndex = 3
IconFrame.Parent = Card
Instance.new("UICorner", IconFrame).CornerRadius = UDim.new(0, 6)

local IconImg = Instance.new("ImageLabel")
IconImg.Size  = UDim2.new(1,0,1,0)
IconImg.BackgroundTransparency = 1
IconImg.Image = "rbxassetid://136656557035530"
IconImg.ScaleType = Enum.ScaleType.Fit
IconImg.ZIndex = 4
IconImg.Parent = IconFrame

local ItemName = Instance.new("TextLabel")
ItemName.Size  = UDim2.new(1, -82, 0, 26)
ItemName.Position = UDim2.new(0, 80, 0, 58)
ItemName.BackgroundTransparency = 1
ItemName.Text  = "[GIFT] ADMIN PANEL"
ItemName.Font  = Enum.Font.GothamBold
ItemName.TextSize = 14
ItemName.TextColor3 = WHITE
ItemName.TextXAlignment = Enum.TextXAlignment.Left
ItemName.ZIndex = 3
ItemName.Parent = Card

local ItemPrice = Instance.new("TextLabel")
ItemPrice.Size  = UDim2.new(1, -82, 0, 22)
ItemPrice.Position = UDim2.new(0, 80, 0, 86)
ItemPrice.BackgroundTransparency = 1
ItemPrice.Text  = "\u{E002} 7,499"
ItemPrice.Font  = Enum.Font.Gotham
ItemPrice.TextSize = 13
ItemPrice.TextColor3 = WHITE
ItemPrice.TextXAlignment = Enum.TextXAlignment.Left
ItemPrice.ZIndex = 3
ItemPrice.Parent = Card

-- Divider above button
local D2 = Instance.new("Frame")
D2.Size  = UDim2.new(1,0,0,1)
D2.Position = UDim2.new(0,0,0,126)
D2.BackgroundColor3 = DIVIDER
D2.BorderSizePixel  = 0
D2.ZIndex = 3
D2.Parent = Card

-- ── BUY BUTTON ─────────────────────────────────────────────
-- Starts DARK BLUE. SweepCover (light blue) expands left→right
-- over 3 seconds, turning it light blue. Locked until done.

local BuyBtn = Instance.new("TextButton")
BuyBtn.Name  = "BuyBtn"
BuyBtn.Size  = UDim2.new(1, -24, 0, 46)
BuyBtn.Position = UDim2.new(0, 12, 0, 135)
BuyBtn.BackgroundColor3 = BTN_DARK
BuyBtn.Text  = ""
BuyBtn.BorderSizePixel  = 0
BuyBtn.AutoButtonColor  = false
BuyBtn.Active = false
BuyBtn.ZIndex = 3
BuyBtn.Parent = Card
Instance.new("UICorner", BuyBtn).CornerRadius = UDim.new(0, 8)

-- Light blue cover that sweeps in from left (child clips to button)
local SweepCover = Instance.new("Frame")
SweepCover.Name  = "SweepCover"
SweepCover.Size  = UDim2.new(0, 0, 1, 0)   -- starts 0 width
SweepCover.Position = UDim2.new(0, 0, 0, 0)
SweepCover.BackgroundColor3 = BTN_LIGHT
SweepCover.BorderSizePixel  = 0
SweepCover.ZIndex = 4
SweepCover.Parent = BuyBtn   -- child of button so it clips inside corners

-- "Buy" text sits on top of everything (always visible)
local BuyLbl = Instance.new("TextLabel")
BuyLbl.Size  = UDim2.new(1,0,1,0)
BuyLbl.BackgroundTransparency = 1
BuyLbl.Text  = "Buy"
BuyLbl.Font  = Enum.Font.GothamBold
BuyLbl.TextSize = 16
BuyLbl.TextColor3 = WHITE
BuyLbl.ZIndex = 5
BuyLbl.Parent = BuyBtn

-- ============================================================
-- SUCCESS POPUP  (same gray card, all white text)
-- ============================================================
local SuccessCard = Instance.new("Frame")
SuccessCard.Name  = "SuccessCard"
SuccessCard.Size  = UDim2.new(0, 330, 0, 210)
SuccessCard.Position = UDim2.new(0.5, -165, 0.5, -105)
SuccessCard.BackgroundColor3 = GRAY
SuccessCard.BorderSizePixel  = 0
SuccessCard.Visible = false
SuccessCard.ZIndex  = 10
SuccessCard.Parent  = BuyGui
Instance.new("UICorner", SuccessCard).CornerRadius = UDim.new(0, 8)

local STitleLbl = Instance.new("TextLabel")
STitleLbl.Size  = UDim2.new(1, -44, 0, 44)
STitleLbl.Position = UDim2.new(0, 12, 0, 0)
STitleLbl.BackgroundTransparency = 1
STitleLbl.Text  = "Purchase completed"
STitleLbl.Font  = Enum.Font.GothamBold
STitleLbl.TextSize = 17
STitleLbl.TextColor3 = WHITE
STitleLbl.TextXAlignment = Enum.TextXAlignment.Left
STitleLbl.ZIndex = 11
STitleLbl.Parent = SuccessCard

local SCloseBtn = Instance.new("TextButton")
SCloseBtn.Size  = UDim2.new(0, 32, 0, 44)
SCloseBtn.Position = UDim2.new(1, -36, 0, 0)
SCloseBtn.BackgroundTransparency = 1
SCloseBtn.Text  = "X"
SCloseBtn.Font  = Enum.Font.GothamBold
SCloseBtn.TextSize = 16
SCloseBtn.TextColor3 = WHITE
SCloseBtn.BorderSizePixel = 0
SCloseBtn.ZIndex = 12
SCloseBtn.Parent = SuccessCard

local SD = Instance.new("Frame")
SD.Size  = UDim2.new(1,0,0,1)
SD.Position = UDim2.new(0,0,0,44)
SD.BackgroundColor3 = DIVIDER
SD.BorderSizePixel  = 0
SD.ZIndex = 11
SD.Parent = SuccessCard

-- Checkmark circle
local CheckCircle = Instance.new("Frame")
CheckCircle.Size  = UDim2.new(0, 38, 0, 38)
CheckCircle.Position = UDim2.new(0.5, -19, 0, 52)
CheckCircle.BackgroundColor3 = DIVIDER
CheckCircle.BorderSizePixel  = 0
CheckCircle.ZIndex = 12
CheckCircle.Parent = SuccessCard
Instance.new("UICorner", CheckCircle).CornerRadius = UDim.new(1, 0)

local CheckLbl = Instance.new("TextLabel")
CheckLbl.Size  = UDim2.new(1,0,1,0)
CheckLbl.BackgroundTransparency = 1
CheckLbl.Text  = "✓"
CheckLbl.Font  = Enum.Font.GothamBold
CheckLbl.TextSize = 20
CheckLbl.TextColor3 = WHITE
CheckLbl.ZIndex = 13
CheckLbl.Parent = CheckCircle

-- Success message — WHITE
local SMsg = Instance.new("TextLabel")
SMsg.Name  = "SMsg"
SMsg.Size  = UDim2.new(1, -24, 0, 32)
SMsg.Position = UDim2.new(0, 12, 0, 98)
SMsg.BackgroundTransparency = 1
SMsg.Text  = ""
SMsg.Font  = Enum.Font.Gotham
SMsg.TextSize = 12
SMsg.TextColor3 = WHITE
SMsg.TextWrapped = true
SMsg.ZIndex = 12
SMsg.Parent = SuccessCard

-- OK button — light blue, white text
local OKBtn = Instance.new("TextButton")
OKBtn.Name  = "OKBtn"
OKBtn.Size  = UDim2.new(1, -24, 0, 44)
OKBtn.Position = UDim2.new(0, 12, 0, 152)
OKBtn.BackgroundColor3 = BTN_LIGHT
OKBtn.Text  = "OK"
OKBtn.Font  = Enum.Font.GothamBold
OKBtn.TextSize = 16
OKBtn.TextColor3 = WHITE
OKBtn.BorderSizePixel = 0
OKBtn.AutoButtonColor = false
OKBtn.ZIndex = 12
OKBtn.Parent = SuccessCard
Instance.new("UICorner", OKBtn).CornerRadius = UDim.new(0, 8)

-- ============================================================
-- CONTROL PANEL
-- ============================================================
local CtrlGui = Instance.new("ScreenGui")
CtrlGui.Name  = "ControlPanel"
CtrlGui.ResetOnSpawn   = false
CtrlGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
CtrlGui.Parent = PlayerGui

local Panel = Instance.new("Frame")
Panel.Size  = UDim2.new(0, 200, 0, 340)
Panel.Position = UDim2.new(0, 10, 0.5, -170)
Panel.BackgroundColor3 = Color3.fromRGB(30, 30, 42)
Panel.BorderSizePixel  = 0
Panel.ZIndex = 20
Panel.Parent = CtrlGui
Instance.new("UICorner", Panel).CornerRadius = UDim.new(0, 10)

local PTBar = Instance.new("Frame")
PTBar.Size  = UDim2.new(1,0,0,36)
PTBar.BackgroundColor3 = Color3.fromRGB(45, 45, 65)
PTBar.BorderSizePixel  = 0
PTBar.ZIndex = 21
PTBar.Parent = Panel
Instance.new("UICorner", PTBar).CornerRadius = UDim.new(0, 10)

local PTLbl = Instance.new("TextLabel")
PTLbl.Size  = UDim2.new(1,0,1,0)
PTLbl.BackgroundTransparency = 1
PTLbl.Text  = "🎮  Control Panel"
PTLbl.Font  = Enum.Font.GothamBold
PTLbl.TextSize = 13
PTLbl.TextColor3 = WHITE
PTLbl.ZIndex = 22
PTLbl.Parent = PTBar

local function makeBox(yPos, label, default)
	local lbl = Instance.new("TextLabel")
	lbl.Size  = UDim2.new(1,-16,0,16)
	lbl.Position = UDim2.new(0,8,0,yPos)
	lbl.BackgroundTransparency = 1
	lbl.Text  = label
	lbl.Font  = Enum.Font.Gotham
	lbl.TextSize = 11
	lbl.TextColor3 = Color3.fromRGB(180,180,180)
	lbl.TextXAlignment = Enum.TextXAlignment.Left
	lbl.ZIndex = 22
	lbl.Parent = Panel

	local box = Instance.new("TextBox")
	box.Size  = UDim2.new(1,-16,0,28)
	box.Position = UDim2.new(0,8,0,yPos+17)
	box.BackgroundColor3 = Color3.fromRGB(45,45,62)
	box.Text  = default
	box.Font  = Enum.Font.Gotham
	box.TextSize = 13
	box.TextColor3 = WHITE
	box.PlaceholderColor3 = Color3.fromRGB(110,110,130)
	box.BorderSizePixel = 0
	box.ZIndex = 22
	box.Parent = Panel
	Instance.new("UICorner", box).CornerRadius = UDim.new(0,5)
	return box
end

local BalanceBox = makeBox(44,  "Balance",          tostring(balance))
local KeybindBox = makeBox(102, "Keybind (e.g. F)", "F")

local OpenBtn = Instance.new("TextButton")
OpenBtn.Size  = UDim2.new(1,-16,0,34)
OpenBtn.Position = UDim2.new(0,8,0,160)
OpenBtn.BackgroundColor3 = BTN_LIGHT
OpenBtn.Text  = "Open Shop"
OpenBtn.Font  = Enum.Font.GothamBold
OpenBtn.TextSize = 13
OpenBtn.TextColor3 = WHITE
OpenBtn.BorderSizePixel = 0
OpenBtn.AutoButtonColor = false
OpenBtn.ZIndex = 22
OpenBtn.Parent = Panel
Instance.new("UICorner", OpenBtn).CornerRadius = UDim.new(0,7)

local DropLbl = Instance.new("TextLabel")
DropLbl.Size  = UDim2.new(1,-16,0,16)
DropLbl.Position = UDim2.new(0,8,0,206)
DropLbl.BackgroundTransparency = 1
DropLbl.Text  = "Gift to Player"
DropLbl.Font  = Enum.Font.Gotham
DropLbl.TextSize = 11
DropLbl.TextColor3 = Color3.fromRGB(180,180,180)
DropLbl.TextXAlignment = Enum.TextXAlignment.Left
DropLbl.ZIndex = 22
DropLbl.Parent = Panel

local DropSelected = Instance.new("TextButton")
DropSelected.Size  = UDim2.new(1,-16,0,28)
DropSelected.Position = UDim2.new(0,8,0,223)
DropSelected.BackgroundColor3 = Color3.fromRGB(45,45,62)
DropSelected.Text  = "— Select Player —"
DropSelected.Font  = Enum.Font.Gotham
DropSelected.TextSize = 12
DropSelected.TextColor3 = WHITE
DropSelected.BorderSizePixel = 0
DropSelected.ZIndex = 23
DropSelected.Parent = Panel
Instance.new("UICorner", DropSelected).CornerRadius = UDim.new(0,5)

local DropList = Instance.new("Frame")
DropList.Size  = UDim2.new(1,-16,0,0)
DropList.Position = UDim2.new(0,8,0,252)
DropList.BackgroundColor3 = Color3.fromRGB(50,50,72)
DropList.BorderSizePixel  = 0
DropList.ClipsDescendants = true
DropList.Visible = false
DropList.ZIndex  = 30
DropList.Parent  = Panel
Instance.new("UICorner", DropList).CornerRadius = UDim.new(0,5)

local DLayout = Instance.new("UIListLayout")
DLayout.SortOrder = Enum.SortOrder.LayoutOrder
DLayout.Padding   = UDim.new(0,1)
DLayout.Parent    = DropList

-- ============================================================
-- FUNCTIONS
-- ============================================================

local function refreshBalance()
	BalanceLbl.Text = "\u{E002} " .. fmt(balance)
end

local function deductBalance()
	if balance < ITEM_COST then return false end
	balance = balance - ITEM_COST
	refreshBalance()
	BalanceBox.Text = tostring(balance)
	return true
end

-- Sweep: SweepCover starts at width 0 (dark blue button shows)
-- Expands to full width over 3 seconds (light blue covers dark blue)
-- After 3 seconds Buy button unlocks
local function playSweep()
	BuyBtn.Active           = false
	BuyBtn.BackgroundColor3 = BTN_DARK
	SweepCover.BackgroundColor3 = BTN_LIGHT
	SweepCover.Size         = UDim2.new(0, 0, 1, 0)

	local t = TweenService:Create(
		SweepCover,
		TweenInfo.new(3, Enum.EasingStyle.Linear),
		{ Size = UDim2.new(1, 0, 1, 0) }
	)
	t:Play()
	t.Completed:Connect(function()
		BuyBtn.Active = true
	end)
end

local function openGui()
	if guiOpen then return end
	guiOpen = true
	refreshBalance()
	SuccessCard.Visible = false
	Card.Visible        = true
	BuyGui.Enabled      = true
	playSweep()
end

local function closeGui()
	guiOpen = false
	BuyGui.Enabled      = false
	Card.Visible        = false
	SuccessCard.Visible = false
end

local function showSuccess()
	local name = selectedPlayer ~= "" and selectedPlayer or "Unknown"
	SMsg.Text  = "You have successfully gifted [GIFT] ADMIN PANEL to " .. name .. "."
	Card.Visible        = false
	SuccessCard.Visible = true
end

local function refreshDropdown()
	for _, c in ipairs(DropList:GetChildren()) do
		if c:IsA("TextButton") then c:Destroy() end
	end
	local plist = Players:GetPlayers()
	DropList.Size = UDim2.new(1,-16,0, math.min(#plist * 28, 112))
	for i, p in ipairs(plist) do
		local b = Instance.new("TextButton")
		b.Size  = UDim2.new(1,0,0,28)
		b.BackgroundTransparency = 1
		b.Text  = p.Name
		b.Font  = Enum.Font.Gotham
		b.TextSize = 12
		b.TextColor3 = WHITE
		b.LayoutOrder = i
		b.ZIndex = 32
		b.Parent = DropList
		b.MouseButton1Click:Connect(function()
			selectedPlayer    = p.Name
			DropSelected.Text = p.Name
			DropList.Visible  = false
		end)
	end
end

local function toggleDrop()
	if DropList.Visible then
		DropList.Visible = false
	else
		refreshDropdown()
		DropList.Visible = true
	end
end

local function parseKey(txt)
	local u = txt:upper():gsub("%s","")
	local ok, kc = pcall(function() return Enum.KeyCode[u] end)
	if ok and kc then keybind = kc end
end

-- ============================================================
-- CONNECTIONS
-- ============================================================

OpenBtn.MouseButton1Click:Connect(openGui)
CloseBtn.MouseButton1Click:Connect(closeGui)
SCloseBtn.MouseButton1Click:Connect(closeGui)

BuyBtn.MouseButton1Click:Connect(function()
	if not BuyBtn.Active then return end
	if balance < ITEM_COST then
		-- Flash red briefly
		BuyBtn.BackgroundColor3    = Color3.fromRGB(180,50,50)
		SweepCover.BackgroundColor3 = Color3.fromRGB(180,50,50)
		task.delay(0.5, function()
			BuyBtn.BackgroundColor3    = BTN_DARK
			SweepCover.BackgroundColor3 = BTN_LIGHT
		end)
		return
	end
	BuyBtn.BackgroundColor3    = BTN_PRESS
	SweepCover.BackgroundColor3 = BTN_PRESS
	deductBalance()
	task.delay(0.12, showSuccess)
end)

OKBtn.MouseButton1Click:Connect(function()
	OKBtn.BackgroundColor3 = BTN_PRESS
	task.delay(0.12, closeGui)
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

KeybindBox.FocusLost:Connect(function() parseKey(KeybindBox.Text) end)

DropSelected.MouseButton1Click:Connect(toggleDrop)

UserInputService.InputBegan:Connect(function(inp, gp)
	if gp then return end
	if inp.KeyCode == keybind then
		if guiOpen then closeGui() else openGui() end
	end
end)

Players.PlayerAdded:Connect(function()
	if DropList.Visible then refreshDropdown() end
end)
Players.PlayerRemoving:Connect(function(p)
	if selectedPlayer == p.Name then
		selectedPlayer    = ""
		DropSelected.Text = "— Select Player —"
	end
	if DropList.Visible then refreshDropdown() end
end)

refreshBalance()
-- ============================================================
-- END
-- ============================================================
