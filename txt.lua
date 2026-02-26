-- ============================================================
-- ROBLOX BUY ITEM GUI + CONTROL PANEL
-- LocalScript — Place inside StarterPlayerScripts
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
-- COLORS — pixel-matched from the uploaded screenshot
-- Card        = dark blue-gray  RGB(42, 42, 62)
-- ALL text    = pure white
-- Buy button  = indigo/purple-blue  RGB(88, 101, 242)
-- Divider     = slightly lighter than card
-- ============================================================
local C_CARD      = Color3.fromRGB(42,  42,  62)    -- dark blue-gray card
local C_DIVIDER   = Color3.fromRGB(65,  65,  90)    -- subtle divider
local C_WHITE     = Color3.fromRGB(255, 255, 255)   -- ALL text everywhere
local C_ICON      = Color3.fromRGB(55,  55,  80)    -- HD icon background
local C_BTN_DARK  = Color3.fromRGB(55,  65,  160)   -- button starts dark blue
local C_BTN_LIGHT = Color3.fromRGB(88,  101, 242)   -- sweep reveals this purple-blue
local C_BTN_PRESS = Color3.fromRGB(40,  50,  130)   -- pressed darker blue

-- ============================================================
-- HELPER: comma-format  66245 → "66,245"
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
-- BUY GUI  ScreenGui
-- ============================================================
local BuyGui            = Instance.new("ScreenGui")
BuyGui.Name             = "BuyItemGui"
BuyGui.ResetOnSpawn     = false
BuyGui.ZIndexBehavior   = Enum.ZIndexBehavior.Sibling
BuyGui.Enabled          = false   -- never auto-opens
BuyGui.Parent           = PlayerGui

-- Semi-transparent dark backdrop
local Backdrop              = Instance.new("Frame")
Backdrop.Size               = UDim2.new(1, 0, 1, 0)
Backdrop.BackgroundColor3   = Color3.fromRGB(0, 0, 0)
Backdrop.BackgroundTransparency = 0.5
Backdrop.BorderSizePixel    = 0
Backdrop.ZIndex             = 1
Backdrop.Parent             = BuyGui

-- ── MAIN BUY CARD ──────────────────────────────────────────
-- Wide card matching original: 420px wide, 190px tall
local Card                  = Instance.new("Frame")
Card.Name                   = "Card"
Card.Size                   = UDim2.new(0, 420, 0, 190)
Card.Position               = UDim2.new(0.5, -210, 0.5, -95)
Card.BackgroundColor3       = C_CARD
Card.BorderSizePixel        = 0
Card.ZIndex                 = 2
Card.Parent                 = BuyGui
Instance.new("UICorner", Card).CornerRadius = UDim.new(0, 10)

-- ── TITLE ROW: "Buy item"  |  ⊙ 66,245  |  X ──────────────
local TitleLbl              = Instance.new("TextLabel")
TitleLbl.Size               = UDim2.new(0, 140, 0, 46)
TitleLbl.Position           = UDim2.new(0, 16, 0, 0)
TitleLbl.BackgroundTransparency = 1
TitleLbl.Text               = "Buy item"
TitleLbl.Font               = Enum.Font.GothamBold
TitleLbl.TextSize           = 19
TitleLbl.TextColor3         = C_WHITE
TitleLbl.TextXAlignment     = Enum.TextXAlignment.Left
TitleLbl.ZIndex             = 3
TitleLbl.Parent             = Card

local BalanceLbl            = Instance.new("TextLabel")
BalanceLbl.Name             = "BalanceLbl"
BalanceLbl.Size             = UDim2.new(0, 120, 0, 46)
BalanceLbl.Position         = UDim2.new(1, -170, 0, 0)
BalanceLbl.BackgroundTransparency = 1
BalanceLbl.Font             = Enum.Font.GothamBold
BalanceLbl.TextSize         = 15
BalanceLbl.TextColor3       = C_WHITE
BalanceLbl.TextXAlignment   = Enum.TextXAlignment.Right
BalanceLbl.ZIndex           = 3
BalanceLbl.Parent           = Card

local CloseBtn              = Instance.new("TextButton")
CloseBtn.Name               = "CloseBtn"
CloseBtn.Size               = UDim2.new(0, 36, 0, 46)
CloseBtn.Position           = UDim2.new(1, -40, 0, 0)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Text               = "X"
CloseBtn.Font               = Enum.Font.GothamBold
CloseBtn.TextSize           = 17
CloseBtn.TextColor3         = C_WHITE
CloseBtn.BorderSizePixel    = 0
CloseBtn.ZIndex             = 4
CloseBtn.Parent             = Card

-- Divider under title
local D1                    = Instance.new("Frame")
D1.Size                     = UDim2.new(1, 0, 0, 1)
D1.Position                 = UDim2.new(0, 0, 0, 46)
D1.BackgroundColor3         = C_DIVIDER
D1.BorderSizePixel          = 0
D1.ZIndex                   = 3
D1.Parent                   = Card

-- ── ITEM ROW ───────────────────────────────────────────────
-- HD image icon (left) + item name + price (right of icon)

local IconFrame             = Instance.new("Frame")
IconFrame.Size              = UDim2.new(0, 60, 0, 60)
IconFrame.Position          = UDim2.new(0, 16, 0, 54)
IconFrame.BackgroundColor3  = C_ICON
IconFrame.BorderSizePixel   = 0
IconFrame.ZIndex            = 3
IconFrame.Parent            = Card
Instance.new("UICorner", IconFrame).CornerRadius = UDim.new(0, 6)

local IconImg               = Instance.new("ImageLabel")
IconImg.Size                = UDim2.new(1, 0, 1, 0)
IconImg.BackgroundTransparency = 1
IconImg.Image               = "rbxassetid://136656557035530"
IconImg.ScaleType           = Enum.ScaleType.Fit
IconImg.ZIndex              = 4
IconImg.Parent              = IconFrame

-- Item name  — white bold
local ItemName              = Instance.new("TextLabel")
ItemName.Size               = UDim2.new(1, -92, 0, 26)
ItemName.Position           = UDim2.new(0, 88, 0, 58)
ItemName.BackgroundTransparency = 1
ItemName.Text               = "[GIFT] ADMIN PANEL"
ItemName.Font               = Enum.Font.GothamBold
ItemName.TextSize           = 15
ItemName.TextColor3         = C_WHITE
ItemName.TextXAlignment     = Enum.TextXAlignment.Left
ItemName.ZIndex             = 3
ItemName.Parent             = Card

-- Item price  ⊙ 7,499  — white
local ItemPrice             = Instance.new("TextLabel")
ItemPrice.Size              = UDim2.new(1, -92, 0, 22)
ItemPrice.Position          = UDim2.new(0, 88, 0, 86)
ItemPrice.BackgroundTransparency = 1
ItemPrice.Text              = "\u{E002} 7,499"
ItemPrice.Font              = Enum.Font.Gotham
ItemPrice.TextSize          = 14
ItemPrice.TextColor3        = C_WHITE
ItemPrice.TextXAlignment    = Enum.TextXAlignment.Left
ItemPrice.ZIndex            = 3
ItemPrice.Parent            = Card

-- Divider above button
local D2                    = Instance.new("Frame")
D2.Size                     = UDim2.new(1, 0, 0, 1)
D2.Position                 = UDim2.new(0, 0, 0, 128)
D2.BackgroundColor3         = C_DIVIDER
D2.BorderSizePixel          = 0
D2.ZIndex                   = 3
D2.Parent                   = Card

-- ── BUY BUTTON ─────────────────────────────────────────────
-- Starts DARK BLUE. SweepCover (purple-blue) expands left→right
-- over 3 seconds revealing the lighter color. Locked until done.

local BuyBtn                = Instance.new("TextButton")
BuyBtn.Name                 = "BuyBtn"
BuyBtn.Size                 = UDim2.new(1, -28, 0, 44)
BuyBtn.Position             = UDim2.new(0, 14, 0, 136)
BuyBtn.BackgroundColor3     = C_BTN_DARK
BuyBtn.Text                 = ""
BuyBtn.BorderSizePixel      = 0
BuyBtn.AutoButtonColor      = false
BuyBtn.Active               = false
BuyBtn.ZIndex               = 3
BuyBtn.Parent               = Card
Instance.new("UICorner", BuyBtn).CornerRadius = UDim.new(0, 8)

-- SweepCover: light purple-blue cover, starts at 0 width, sweeps to full
local SweepCover            = Instance.new("Frame")
SweepCover.Name             = "SweepCover"
SweepCover.Size             = UDim2.new(0, 0, 1, 0)
SweepCover.Position         = UDim2.new(0, 0, 0, 0)
SweepCover.BackgroundColor3 = C_BTN_LIGHT
SweepCover.BorderSizePixel  = 0
SweepCover.ZIndex           = 4
SweepCover.Parent           = BuyBtn  -- child clips inside button corners

-- "Buy" text always on top
local BuyLbl                = Instance.new("TextLabel")
BuyLbl.Size                 = UDim2.new(1, 0, 1, 0)
BuyLbl.BackgroundTransparency = 1
BuyLbl.Text                 = "Buy"
BuyLbl.Font                 = Enum.Font.GothamBold
BuyLbl.TextSize             = 17
BuyLbl.TextColor3           = C_WHITE
BuyLbl.ZIndex               = 5
BuyLbl.Parent               = BuyBtn

-- ============================================================
-- SUCCESS POPUP  (same dark blue-gray card, all white text)
-- ============================================================
local SuccessCard           = Instance.new("Frame")
SuccessCard.Name            = "SuccessCard"
SuccessCard.Size            = UDim2.new(0, 420, 0, 210)
SuccessCard.Position        = UDim2.new(0.5, -210, 0.5, -105)
SuccessCard.BackgroundColor3 = C_CARD
SuccessCard.BorderSizePixel = 0
SuccessCard.Visible         = false
SuccessCard.ZIndex          = 10
SuccessCard.Parent          = BuyGui
Instance.new("UICorner", SuccessCard).CornerRadius = UDim.new(0, 10)

-- Success title row
local STitleLbl             = Instance.new("TextLabel")
STitleLbl.Size              = UDim2.new(1, -52, 0, 46)
STitleLbl.Position          = UDim2.new(0, 16, 0, 0)
STitleLbl.BackgroundTransparency = 1
STitleLbl.Text              = "Purchase completed"
STitleLbl.Font              = Enum.Font.GothamBold
STitleLbl.TextSize          = 18
STitleLbl.TextColor3        = C_WHITE
STitleLbl.TextXAlignment    = Enum.TextXAlignment.Left
STitleLbl.ZIndex            = 11
STitleLbl.Parent            = SuccessCard

local SCloseBtn             = Instance.new("TextButton")
SCloseBtn.Name              = "SCloseBtn"
SCloseBtn.Size              = UDim2.new(0, 36, 0, 46)
SCloseBtn.Position          = UDim2.new(1, -40, 0, 0)
SCloseBtn.BackgroundTransparency = 1
SCloseBtn.Text              = "X"
SCloseBtn.Font              = Enum.Font.GothamBold
SCloseBtn.TextSize          = 17
SCloseBtn.TextColor3        = C_WHITE
SCloseBtn.BorderSizePixel   = 0
SCloseBtn.ZIndex            = 12
SCloseBtn.Parent            = SuccessCard

local SD                    = Instance.new("Frame")
SD.Size                     = UDim2.new(1, 0, 0, 1)
SD.Position                 = UDim2.new(0, 0, 0, 46)
SD.BackgroundColor3         = C_DIVIDER
SD.BorderSizePixel          = 0
SD.ZIndex                   = 11
SD.Parent                   = SuccessCard

-- Checkmark circle
local CheckCircle           = Instance.new("Frame")
CheckCircle.Size            = UDim2.new(0, 40, 0, 40)
CheckCircle.Position        = UDim2.new(0.5, -20, 0, 54)
CheckCircle.BackgroundColor3 = C_DIVIDER
CheckCircle.BorderSizePixel = 0
CheckCircle.ZIndex          = 12
CheckCircle.Parent          = SuccessCard
Instance.new("UICorner", CheckCircle).CornerRadius = UDim.new(1, 0)

local CheckLbl              = Instance.new("TextLabel")
CheckLbl.Size               = UDim2.new(1, 0, 1, 0)
CheckLbl.BackgroundTransparency = 1
CheckLbl.Text               = "✓"
CheckLbl.Font               = Enum.Font.GothamBold
CheckLbl.TextSize           = 22
CheckLbl.TextColor3         = C_WHITE
CheckLbl.ZIndex             = 13
CheckLbl.Parent             = CheckCircle

-- Success message — white
local SMsg                  = Instance.new("TextLabel")
SMsg.Name                   = "SMsg"
SMsg.Size                   = UDim2.new(1, -32, 0, 34)
SMsg.Position               = UDim2.new(0, 16, 0, 102)
SMsg.BackgroundTransparency = 1
SMsg.Text                   = ""
SMsg.Font                   = Enum.Font.Gotham
SMsg.TextSize               = 13
SMsg.TextColor3             = C_WHITE
SMsg.TextWrapped            = true
SMsg.ZIndex                 = 12
SMsg.Parent                 = SuccessCard

-- OK button — same purple-blue as final Buy button state
local OKBtn                 = Instance.new("TextButton")
OKBtn.Name                  = "OKBtn"
OKBtn.Size                  = UDim2.new(1, -28, 0, 44)
OKBtn.Position              = UDim2.new(0, 14, 0, 152)
OKBtn.BackgroundColor3      = C_BTN_LIGHT
OKBtn.Text                  = "OK"
OKBtn.Font                  = Enum.Font.GothamBold
OKBtn.TextSize              = 17
OKBtn.TextColor3            = C_WHITE
OKBtn.BorderSizePixel       = 0
OKBtn.AutoButtonColor       = false
OKBtn.ZIndex                = 12
OKBtn.Parent                = SuccessCard
Instance.new("UICorner", OKBtn).CornerRadius = UDim.new(0, 8)

-- ============================================================
-- CONTROL PANEL  (separate always-visible ScreenGui)
-- ============================================================
local CtrlGui               = Instance.new("ScreenGui")
CtrlGui.Name                = "ControlPanel"
CtrlGui.ResetOnSpawn        = false
CtrlGui.ZIndexBehavior      = Enum.ZIndexBehavior.Sibling
CtrlGui.Parent              = PlayerGui

local Panel                 = Instance.new("Frame")
Panel.Name                  = "Panel"
Panel.Size                  = UDim2.new(0, 210, 0, 345)
Panel.Position              = UDim2.new(0, 10, 0.5, -172)
Panel.BackgroundColor3      = Color3.fromRGB(28, 28, 42)
Panel.BorderSizePixel       = 0
Panel.ZIndex                = 20
Panel.Parent                = CtrlGui
Instance.new("UICorner", Panel).CornerRadius = UDim.new(0, 10)

local PTBar                 = Instance.new("Frame")
PTBar.Size                  = UDim2.new(1, 0, 0, 38)
PTBar.BackgroundColor3      = Color3.fromRGB(45, 45, 68)
PTBar.BorderSizePixel       = 0
PTBar.ZIndex                = 21
PTBar.Parent                = Panel
Instance.new("UICorner", PTBar).CornerRadius = UDim.new(0, 10)

local PTLbl                 = Instance.new("TextLabel")
PTLbl.Size                  = UDim2.new(1, 0, 1, 0)
PTLbl.BackgroundTransparency = 1
PTLbl.Text                  = "🎮  Control Panel"
PTLbl.Font                  = Enum.Font.GothamBold
PTLbl.TextSize              = 13
PTLbl.TextColor3            = C_WHITE
PTLbl.ZIndex                = 22
PTLbl.Parent                = PTBar

-- Helper: labelled TextBox
local function makeBox(yPos, labelText, defaultText)
	local lbl                 = Instance.new("TextLabel")
	lbl.Size                  = UDim2.new(1, -16, 0, 16)
	lbl.Position              = UDim2.new(0, 8, 0, yPos)
	lbl.BackgroundTransparency = 1
	lbl.Text                  = labelText
	lbl.Font                  = Enum.Font.Gotham
	lbl.TextSize              = 11
	lbl.TextColor3            = Color3.fromRGB(175, 175, 195)
	lbl.TextXAlignment        = Enum.TextXAlignment.Left
	lbl.ZIndex                = 22
	lbl.Parent                = Panel

	local box                 = Instance.new("TextBox")
	box.Size                  = UDim2.new(1, -16, 0, 28)
	box.Position              = UDim2.new(0, 8, 0, yPos + 17)
	box.BackgroundColor3      = Color3.fromRGB(42, 42, 62)
	box.Text                  = defaultText
	box.Font                  = Enum.Font.Gotham
	box.TextSize              = 13
	box.TextColor3            = C_WHITE
	box.PlaceholderColor3     = Color3.fromRGB(110, 110, 130)
	box.BorderSizePixel       = 0
	box.ZIndex                = 22
	box.Parent                = Panel
	Instance.new("UICorner", box).CornerRadius = UDim.new(0, 5)
	return box
end

local BalanceBox            = makeBox(46,  "Balance",          tostring(balance))
local KeybindBox            = makeBox(104, "Keybind (e.g. F)", "F")

local OpenBtn               = Instance.new("TextButton")
OpenBtn.Name                = "OpenBtn"
OpenBtn.Size                = UDim2.new(1, -16, 0, 34)
OpenBtn.Position            = UDim2.new(0, 8, 0, 162)
OpenBtn.BackgroundColor3    = C_BTN_LIGHT
OpenBtn.Text                = "Open Shop"
OpenBtn.Font                = Enum.Font.GothamBold
OpenBtn.TextSize            = 13
OpenBtn.TextColor3          = C_WHITE
OpenBtn.BorderSizePixel     = 0
OpenBtn.AutoButtonColor     = false
OpenBtn.ZIndex              = 22
OpenBtn.Parent              = Panel
Instance.new("UICorner", OpenBtn).CornerRadius = UDim.new(0, 7)

local DropLbl               = Instance.new("TextLabel")
DropLbl.Size                = UDim2.new(1, -16, 0, 16)
DropLbl.Position            = UDim2.new(0, 8, 0, 208)
DropLbl.BackgroundTransparency = 1
DropLbl.Text                = "Gift to Player"
DropLbl.Font                = Enum.Font.Gotham
DropLbl.TextSize            = 11
DropLbl.TextColor3          = Color3.fromRGB(175, 175, 195)
DropLbl.TextXAlignment      = Enum.TextXAlignment.Left
DropLbl.ZIndex              = 22
DropLbl.Parent              = Panel

local DropSelected          = Instance.new("TextButton")
DropSelected.Name           = "DropSelected"
DropSelected.Size           = UDim2.new(1, -16, 0, 28)
DropSelected.Position       = UDim2.new(0, 8, 0, 225)
DropSelected.BackgroundColor3 = Color3.fromRGB(42, 42, 62)
DropSelected.Text           = "— Select Player —"
DropSelected.Font           = Enum.Font.Gotham
DropSelected.TextSize       = 12
DropSelected.TextColor3     = C_WHITE
DropSelected.BorderSizePixel = 0
DropSelected.ZIndex         = 23
DropSelected.Parent         = Panel
Instance.new("UICorner", DropSelected).CornerRadius = UDim.new(0, 5)

local DropList              = Instance.new("Frame")
DropList.Name               = "DropList"
DropList.Size               = UDim2.new(1, -16, 0, 0)
DropList.Position           = UDim2.new(0, 8, 0, 254)
DropList.BackgroundColor3   = Color3.fromRGB(50, 50, 75)
DropList.BorderSizePixel    = 0
DropList.ClipsDescendants   = true
DropList.Visible            = false
DropList.ZIndex             = 30
DropList.Parent             = Panel
Instance.new("UICorner", DropList).CornerRadius = UDim.new(0, 5)

local DLayout               = Instance.new("UIListLayout")
DLayout.SortOrder           = Enum.SortOrder.LayoutOrder
DLayout.Padding             = UDim.new(0, 1)
DLayout.Parent              = DropList

-- ============================================================
-- FUNCTIONS
-- ============================================================

-- Refresh BalanceLbl inside BuyGui with current balance
local function refreshBalance()
	BalanceLbl.Text = "\u{E002} " .. fmt(balance)
end

-- Subtract cost; syncs label and BalanceBox. Returns false if broke.
local function deductBalance()
	if balance < ITEM_COST then return false end
	balance         = balance - ITEM_COST
	refreshBalance()
	BalanceBox.Text = tostring(balance)
	return true
end

-- Sweep animation:
--   BuyBtn background = dark blue (C_BTN_DARK)
--   SweepCover starts at width 0, tweens to full width over 3 seconds
--   This makes it look like dark blue is being swept into light purple-blue
--   BuyBtn.Active = false the whole time; set to true after tween completes
local function playSweep()
	BuyBtn.Active               = false
	BuyBtn.BackgroundColor3     = C_BTN_DARK
	SweepCover.BackgroundColor3 = C_BTN_LIGHT
	SweepCover.Size             = UDim2.new(0, 0, 1, 0)   -- reset to 0 width

	local tween = TweenService:Create(
		SweepCover,
		TweenInfo.new(3, Enum.EasingStyle.Linear, Enum.EasingDirection.In),
		{ Size = UDim2.new(1, 0, 1, 0) }
	)
	tween:Play()
	tween.Completed:Connect(function()
		BuyBtn.Active = true   -- unlock after sweep finishes
	end)
end

-- Open Buy GUI (only via button or keybind — never auto)
local function openGui()
	if guiOpen then return end
	guiOpen             = true
	refreshBalance()
	SuccessCard.Visible = false
	Card.Visible        = true
	BuyGui.Enabled      = true
	playSweep()
end

-- Close everything
local function closeGui()
	guiOpen             = false
	BuyGui.Enabled      = false
	Card.Visible        = false
	SuccessCard.Visible = false
end

-- Show success popup with dynamic selected player name
local function showSuccess()
	local name  = (selectedPlayer ~= "") and selectedPlayer or "Unknown"
	SMsg.Text   = "You have successfully gifted [GIFT] ADMIN PANEL to " .. name .. "."
	Card.Visible        = false
	SuccessCard.Visible = true
end

-- Rebuild dropdown list with current server players
local function refreshDropdown()
	for _, c in ipairs(DropList:GetChildren()) do
		if c:IsA("TextButton") then c:Destroy() end
	end
	local plist   = Players:GetPlayers()
	DropList.Size = UDim2.new(1, -16, 0, math.min(#plist * 28, 112))
	for i, p in ipairs(plist) do
		local btn             = Instance.new("TextButton")
		btn.Size              = UDim2.new(1, 0, 0, 28)
		btn.BackgroundTransparency = 1
		btn.Text              = p.Name
		btn.Font              = Enum.Font.Gotham
		btn.TextSize          = 12
		btn.TextColor3        = C_WHITE
		btn.LayoutOrder       = i
		btn.ZIndex            = 32
		btn.Parent            = DropList
		btn.MouseButton1Click:Connect(function()
			selectedPlayer    = p.Name
			DropSelected.Text = p.Name
			DropList.Visible  = false
		end)
	end
end

-- Toggle dropdown open/closed
local function toggleDrop()
	if DropList.Visible then
		DropList.Visible = false
	else
		refreshDropdown()
		DropList.Visible = true
	end
end

-- Parse keybind string into Enum.KeyCode
local function parseKey(txt)
	local u = txt:upper():gsub("%s", "")
	local ok, kc = pcall(function() return Enum.KeyCode[u] end)
	if ok and kc then keybind = kc end
end

-- ============================================================
-- CONNECTIONS
-- ============================================================

-- Control panel Open Shop button
OpenBtn.MouseButton1Click:Connect(openGui)

-- Buy popup X close button
CloseBtn.MouseButton1Click:Connect(closeGui)

-- Success popup X close button
SCloseBtn.MouseButton1Click:Connect(closeGui)

-- Buy button click handler
BuyBtn.MouseButton1Click:Connect(function()
	if not BuyBtn.Active then return end   -- still sweeping — ignore
	if balance < ITEM_COST then
		-- Can't afford: flash red briefly then restore
		BuyBtn.BackgroundColor3     = Color3.fromRGB(180, 50, 50)
		SweepCover.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
		task.delay(0.5, function()
			BuyBtn.BackgroundColor3     = C_BTN_DARK
			SweepCover.BackgroundColor3 = C_BTN_LIGHT
		end)
		return
	end
	-- Turn dark on click, deduct, show success
	BuyBtn.BackgroundColor3     = C_BTN_PRESS
	SweepCover.BackgroundColor3 = C_BTN_PRESS
	deductBalance()
	task.delay(0.12, showSuccess)
end)

-- OK button click handler
OKBtn.MouseButton1Click:Connect(function()
	OKBtn.BackgroundColor3 = C_BTN_PRESS   -- goes dark blue on click
	task.delay(0.12, closeGui)
end)

-- Balance TextBox: live update when focus lost
BalanceBox.FocusLost:Connect(function()
	local v = tonumber(BalanceBox.Text)
	if v and v >= 0 then
		balance         = math.floor(v)
		refreshBalance()
	else
		BalanceBox.Text = tostring(balance)
	end
end)

-- Keybind TextBox: parse on focus lost
KeybindBox.FocusLost:Connect(function()
	parseKey(KeybindBox.Text)
end)

-- Dropdown toggle
DropSelected.MouseButton1Click:Connect(toggleDrop)

-- Global keybind listener
UserInputService.InputBegan:Connect(function(inp, gp)
	if gp then return end
	if inp.KeyCode == keybind then
		if guiOpen then closeGui() else openGui() end
	end
end)

-- Auto-update dropdown when players join or leave
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

-- Initialise balance display
refreshBalance()

-- ============================================================
-- END OF SCRIPT
-- ============================================================
