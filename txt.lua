-- ============================================================
-- ROBLOX BUY ITEM GUI + CONTROL PANEL  (LocalScript)
-- Place inside StarterPlayerScripts or StarterCharacterScripts
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
local sweepDone      = false

-- ============================================================
-- COLORS  (matched exactly from screenshot)
-- ============================================================
local C_CARD_BG     = Color3.fromRGB(30,  30,  30)   -- dark near-black card
local C_DIVIDER     = Color3.fromRGB(60,  60,  60)   -- subtle dark divider
local C_WHITE       = Color3.fromRGB(255, 255, 255)  -- all primary text
local C_SUBTEXT     = Color3.fromRGB(180, 180, 180)  -- secondary / price text
local C_BTN_BLUE    = Color3.fromRGB(74,  127, 212)  -- medium blue Buy / OK button
local C_BTN_CLICKED = Color3.fromRGB(40,  80,  170)  -- dark blue after click
local C_ICON_BG     = Color3.fromRGB(50,  50,  65)   -- dark square icon background
local C_CHECK_BG    = Color3.fromRGB(60,  60,  60)   -- checkmark circle background

-- ============================================================
-- HELPER: format number with commas
-- ============================================================
local function fmt(n)
	local s = tostring(math.floor(n))
	local result, count = "", 0
	for i = #s, 1, -1 do
		if count > 0 and count % 3 == 0 then result = "," .. result end
		result = s:sub(i, i) .. result
		count  = count + 1
	end
	return result
end

-- ============================================================
-- BUILD BUY GUI
-- ============================================================
local BuyGui          = Instance.new("ScreenGui")
BuyGui.Name           = "BuyItemGui"
BuyGui.ResetOnSpawn   = false
BuyGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
BuyGui.Enabled        = false   -- never auto-opens
BuyGui.Parent         = PlayerGui

-- Dim overlay behind card
local Backdrop            = Instance.new("Frame")
Backdrop.Size             = UDim2.new(1, 0, 1, 0)
Backdrop.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Backdrop.BackgroundTransparency = 0.5
Backdrop.BorderSizePixel  = 0
Backdrop.ZIndex           = 1
Backdrop.Parent           = BuyGui

-- ── BUY POPUP CARD ─────────────────────────────────────────
local MainFrame           = Instance.new("Frame")
MainFrame.Name            = "MainFrame"
MainFrame.Size            = UDim2.new(0, 340, 0, 190)
MainFrame.Position        = UDim2.new(0.5, -170, 0.5, -95)
MainFrame.BackgroundColor3 = C_CARD_BG
MainFrame.BorderSizePixel = 0
MainFrame.ZIndex          = 2
MainFrame.Parent          = BuyGui
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)

-- ── TITLE ROW ───────────────────────────────────────────────
local TitleRow            = Instance.new("Frame")
TitleRow.Size             = UDim2.new(1, 0, 0, 42)
TitleRow.BackgroundTransparency = 1
TitleRow.ZIndex           = 3
TitleRow.Parent           = MainFrame

-- "Buy item"
local TitleLbl            = Instance.new("TextLabel")
TitleLbl.Size             = UDim2.new(0, 120, 1, 0)
TitleLbl.Position         = UDim2.new(0, 14, 0, 0)
TitleLbl.BackgroundTransparency = 1
TitleLbl.Text             = "Buy item"
TitleLbl.Font             = Enum.Font.GothamBold
TitleLbl.TextSize         = 17
TitleLbl.TextColor3       = C_WHITE
TitleLbl.TextXAlignment   = Enum.TextXAlignment.Left
TitleLbl.ZIndex           = 4
TitleLbl.Parent           = TitleRow

-- Robux balance (⊙ number)
local BalanceLabel        = Instance.new("TextLabel")
BalanceLabel.Name         = "BalanceLabel"
BalanceLabel.Size         = UDim2.new(0, 110, 1, 0)
BalanceLabel.Position     = UDim2.new(1, -150, 0, 0)
BalanceLabel.BackgroundTransparency = 1
BalanceLabel.Font         = Enum.Font.GothamBold
BalanceLabel.TextSize     = 14
BalanceLabel.TextColor3   = C_WHITE
BalanceLabel.TextXAlignment = Enum.TextXAlignment.Right
BalanceLabel.ZIndex       = 4
BalanceLabel.Parent       = TitleRow

-- X close button  (plain white text, transparent background)
local CloseBtn            = Instance.new("TextButton")
CloseBtn.Name             = "CloseBtn"
CloseBtn.Size             = UDim2.new(0, 30, 0, 30)
CloseBtn.Position         = UDim2.new(1, -36, 0.5, -15)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Text             = "X"
CloseBtn.Font             = Enum.Font.GothamBold
CloseBtn.TextSize         = 16
CloseBtn.TextColor3       = C_WHITE
CloseBtn.BorderSizePixel  = 0
CloseBtn.ZIndex           = 5
CloseBtn.Parent           = TitleRow

-- Divider
local Div1                = Instance.new("Frame")
Div1.Size                 = UDim2.new(1, 0, 0, 1)
Div1.Position             = UDim2.new(0, 0, 0, 42)
Div1.BackgroundColor3     = C_DIVIDER
Div1.BorderSizePixel      = 0
Div1.ZIndex               = 3
Div1.Parent               = MainFrame

-- ── ITEM ROW ────────────────────────────────────────────────
local ItemRow             = Instance.new("Frame")
ItemRow.Size              = UDim2.new(1, 0, 0, 78)
ItemRow.Position          = UDim2.new(0, 0, 0, 43)
ItemRow.BackgroundTransparency = 1
ItemRow.ZIndex            = 3
ItemRow.Parent            = MainFrame

-- Dark square icon with "HD" text
local IconFrame           = Instance.new("Frame")
IconFrame.Size            = UDim2.new(0, 54, 0, 54)
IconFrame.Position        = UDim2.new(0, 14, 0.5, -27)
IconFrame.BackgroundColor3 = C_ICON_BG
IconFrame.BorderSizePixel = 0
IconFrame.ZIndex          = 4
IconFrame.Parent          = ItemRow
Instance.new("UICorner", IconFrame).CornerRadius = UDim.new(0, 6)

local IconHD              = Instance.new("TextLabel")
IconHD.Size               = UDim2.new(1, 0, 1, 0)
IconHD.BackgroundTransparency = 1
IconHD.Text               = "HD"
IconHD.Font               = Enum.Font.GothamBold
IconHD.TextSize           = 20
IconHD.TextColor3         = C_WHITE
IconHD.ZIndex             = 5
IconHD.Parent             = IconFrame

-- Item name (white)
local ItemNameLbl         = Instance.new("TextLabel")
ItemNameLbl.Size          = UDim2.new(1, -82, 0, 26)
ItemNameLbl.Position      = UDim2.new(0, 78, 0, 14)
ItemNameLbl.BackgroundTransparency = 1
ItemNameLbl.Text          = "[GIFT] ADMIN PANEL"
ItemNameLbl.Font          = Enum.Font.GothamBold
ItemNameLbl.TextSize      = 14
ItemNameLbl.TextColor3    = C_WHITE
ItemNameLbl.TextXAlignment = Enum.TextXAlignment.Left
ItemNameLbl.ZIndex        = 4
ItemNameLbl.Parent        = ItemRow

-- Item price (⊙ 7,499 — grey-white subtext)
local ItemPriceLbl        = Instance.new("TextLabel")
ItemPriceLbl.Size         = UDim2.new(1, -82, 0, 22)
ItemPriceLbl.Position     = UDim2.new(0, 78, 0, 40)
ItemPriceLbl.BackgroundTransparency = 1
ItemPriceLbl.Text         = "\u{E002} 7,499"
ItemPriceLbl.Font         = Enum.Font.Gotham
ItemPriceLbl.TextSize     = 13
ItemPriceLbl.TextColor3   = C_SUBTEXT
ItemPriceLbl.TextXAlignment = Enum.TextXAlignment.Left
ItemPriceLbl.ZIndex       = 4
ItemPriceLbl.Parent       = ItemRow

-- Divider 2
local Div2                = Instance.new("Frame")
Div2.Size                 = UDim2.new(1, 0, 0, 1)
Div2.Position             = UDim2.new(0, 0, 0, 121)
Div2.BackgroundColor3     = C_DIVIDER
Div2.BorderSizePixel      = 0
Div2.ZIndex               = 3
Div2.Parent               = MainFrame

-- ── BUY BUTTON ──────────────────────────────────────────────
local BuyBtn              = Instance.new("TextButton")
BuyBtn.Name               = "BuyBtn"
BuyBtn.Size               = UDim2.new(1, -28, 0, 42)
BuyBtn.Position           = UDim2.new(0, 14, 0, 129)
BuyBtn.BackgroundColor3   = C_BTN_BLUE
BuyBtn.Text               = "Buy"
BuyBtn.Font               = Enum.Font.GothamBold
BuyBtn.TextSize           = 15
BuyBtn.TextColor3         = C_WHITE
BuyBtn.BorderSizePixel    = 0
BuyBtn.AutoButtonColor    = false
BuyBtn.Active             = false   -- LOCKED until sweep finishes
BuyBtn.ZIndex             = 4
BuyBtn.Parent             = MainFrame
Instance.new("UICorner", BuyBtn).CornerRadius = UDim.new(0, 8)

-- ── SWEEP SHIMMER  (clipped inside button area) ─────────────
-- SweepHolder is positioned over the Buy button exactly.
-- ClipsDescendants = true keeps shimmer inside button bounds.
local SweepHolder         = Instance.new("Frame")
SweepHolder.Name          = "SweepHolder"
SweepHolder.Size          = UDim2.new(1, -28, 0, 42)
SweepHolder.Position      = UDim2.new(0, 14, 0, 129)
SweepHolder.BackgroundTransparency = 1
SweepHolder.ClipsDescendants = true
SweepHolder.ZIndex        = 5   -- sits above BuyBtn, below title text
SweepHolder.Parent        = MainFrame

local SweepBar            = Instance.new("Frame")
SweepBar.Name             = "SweepBar"
SweepBar.Size             = UDim2.new(0, 55, 1, 0)
SweepBar.Position         = UDim2.new(0, -65, 0, 0)   -- starts off-left
SweepBar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
SweepBar.BackgroundTransparency = 0.35
SweepBar.BorderSizePixel  = 0
SweepBar.ZIndex           = 6
SweepBar.Parent           = SweepHolder

-- Soft fade-in / fade-out edges on the shimmer
local SweepGrad           = Instance.new("UIGradient")
SweepGrad.Rotation        = 0
SweepGrad.Transparency    = NumberSequence.new({
	NumberSequenceKeypoint.new(0,   1),
	NumberSequenceKeypoint.new(0.25, 0.25),
	NumberSequenceKeypoint.new(0.5,  0),
	NumberSequenceKeypoint.new(0.75, 0.25),
	NumberSequenceKeypoint.new(1,   1),
})
SweepGrad.Parent          = SweepBar

-- ============================================================
-- BUILD SUCCESS POPUP  (same dark card style)
-- ============================================================
local SuccessFrame        = Instance.new("Frame")
SuccessFrame.Name         = "SuccessFrame"
SuccessFrame.Size         = UDim2.new(0, 340, 0, 185)
SuccessFrame.Position     = UDim2.new(0.5, -170, 0.5, -92)
SuccessFrame.BackgroundColor3 = C_CARD_BG
SuccessFrame.BorderSizePixel  = 0
SuccessFrame.Visible      = false
SuccessFrame.ZIndex       = 10
SuccessFrame.Parent       = BuyGui
Instance.new("UICorner", SuccessFrame).CornerRadius = UDim.new(0, 10)

-- Success title row
local STitleRow           = Instance.new("Frame")
STitleRow.Size            = UDim2.new(1, 0, 0, 42)
STitleRow.BackgroundTransparency = 1
STitleRow.ZIndex          = 11
STitleRow.Parent          = SuccessFrame

local STitleLbl           = Instance.new("TextLabel")
STitleLbl.Size            = UDim2.new(1, -44, 1, 0)
STitleLbl.Position        = UDim2.new(0, 14, 0, 0)
STitleLbl.BackgroundTransparency = 1
STitleLbl.Text            = "Purchase completed"
STitleLbl.Font            = Enum.Font.GothamBold
STitleLbl.TextSize        = 16
STitleLbl.TextColor3      = C_WHITE
STitleLbl.TextXAlignment  = Enum.TextXAlignment.Left
STitleLbl.ZIndex          = 12
STitleLbl.Parent          = STitleRow

-- X close (plain white text)
local SCloseBtn           = Instance.new("TextButton")
SCloseBtn.Size            = UDim2.new(0, 30, 0, 30)
SCloseBtn.Position        = UDim2.new(1, -36, 0.5, -15)
SCloseBtn.BackgroundTransparency = 1
SCloseBtn.Text            = "X"
SCloseBtn.Font            = Enum.Font.GothamBold
SCloseBtn.TextSize        = 16
SCloseBtn.TextColor3      = C_WHITE
SCloseBtn.BorderSizePixel = 0
SCloseBtn.ZIndex          = 13
SCloseBtn.Parent          = STitleRow

-- Divider
local SDiv                = Instance.new("Frame")
SDiv.Size                 = UDim2.new(1, 0, 0, 1)
SDiv.Position             = UDim2.new(0, 0, 0, 42)
SDiv.BackgroundColor3     = C_DIVIDER
SDiv.BorderSizePixel      = 0
SDiv.ZIndex               = 11
SDiv.Parent               = SuccessFrame

-- Checkmark circle
local CheckCircle         = Instance.new("Frame")
CheckCircle.Size          = UDim2.new(0, 38, 0, 38)
CheckCircle.Position      = UDim2.new(0.5, -19, 0, 50)
CheckCircle.BackgroundColor3 = C_CHECK_BG
CheckCircle.BorderSizePixel  = 0
CheckCircle.ZIndex        = 12
CheckCircle.Parent        = SuccessFrame
Instance.new("UICorner", CheckCircle).CornerRadius = UDim.new(1, 0)

local CheckMark           = Instance.new("TextLabel")
CheckMark.Size            = UDim2.new(1, 0, 1, 0)
CheckMark.BackgroundTransparency = 1
CheckMark.Text            = "✓"
CheckMark.Font            = Enum.Font.GothamBold
CheckMark.TextSize        = 20
CheckMark.TextColor3      = C_WHITE
CheckMark.ZIndex          = 13
CheckMark.Parent          = CheckCircle

-- Success message (white-ish subtext)
local SMsg                = Instance.new("TextLabel")
SMsg.Name                 = "SMsg"
SMsg.Size                 = UDim2.new(1, -28, 0, 30)
SMsg.Position             = UDim2.new(0, 14, 0, 96)
SMsg.BackgroundTransparency = 1
SMsg.Text                 = ""
SMsg.Font                 = Enum.Font.Gotham
SMsg.TextSize             = 12
SMsg.TextColor3           = C_SUBTEXT
SMsg.TextWrapped          = true
SMsg.ZIndex               = 12
SMsg.Parent               = SuccessFrame

-- OK button  (same exact blue as Buy button — already clickable, no sweep)
local OKBtn               = Instance.new("TextButton")
OKBtn.Name                = "OKBtn"
OKBtn.Size                = UDim2.new(1, -28, 0, 38)
OKBtn.Position            = UDim2.new(0, 14, 0, 133)
OKBtn.BackgroundColor3    = C_BTN_BLUE
OKBtn.Text                = "OK"
OKBtn.Font                = Enum.Font.GothamBold
OKBtn.TextSize            = 15
OKBtn.TextColor3          = C_WHITE
OKBtn.BorderSizePixel     = 0
OKBtn.AutoButtonColor     = false
OKBtn.ZIndex              = 12
OKBtn.Parent              = SuccessFrame
Instance.new("UICorner", OKBtn).CornerRadius = UDim.new(0, 8)

-- ============================================================
-- BUILD CONTROL PANEL  (separate always-visible ScreenGui)
-- ============================================================
local CtrlGui             = Instance.new("ScreenGui")
CtrlGui.Name              = "ControlPanel"
CtrlGui.ResetOnSpawn      = false
CtrlGui.ZIndexBehavior    = Enum.ZIndexBehavior.Sibling
CtrlGui.Parent            = PlayerGui

local Panel               = Instance.new("Frame")
Panel.Name                = "Panel"
Panel.Size                = UDim2.new(0, 200, 0, 340)
Panel.Position            = UDim2.new(0, 10, 0.5, -170)
Panel.BackgroundColor3    = Color3.fromRGB(22, 22, 32)
Panel.BorderSizePixel     = 0
Panel.ZIndex              = 20
Panel.Parent              = CtrlGui
Instance.new("UICorner", Panel).CornerRadius = UDim.new(0, 10)

-- Panel title bar
local PanelTitleBar       = Instance.new("Frame")
PanelTitleBar.Size        = UDim2.new(1, 0, 0, 38)
PanelTitleBar.BackgroundColor3 = Color3.fromRGB(36, 36, 55)
PanelTitleBar.BorderSizePixel  = 0
PanelTitleBar.ZIndex      = 21
PanelTitleBar.Parent      = Panel
Instance.new("UICorner", PanelTitleBar).CornerRadius = UDim.new(0, 10)

local PanelTitleLbl       = Instance.new("TextLabel")
PanelTitleLbl.Size        = UDim2.new(1, 0, 1, 0)
PanelTitleLbl.BackgroundTransparency = 1
PanelTitleLbl.Text        = "🎮  Control Panel"
PanelTitleLbl.Font        = Enum.Font.GothamBold
PanelTitleLbl.TextSize    = 13
PanelTitleLbl.TextColor3  = Color3.fromRGB(190, 190, 255)
PanelTitleLbl.ZIndex      = 22
PanelTitleLbl.Parent      = PanelTitleBar

-- Helper: create labelled TextBox inside Panel
local function makeBox(yPos, labelText, defaultText)
	local lbl             = Instance.new("TextLabel")
	lbl.Size              = UDim2.new(1, -16, 0, 16)
	lbl.Position          = UDim2.new(0, 8, 0, yPos)
	lbl.BackgroundTransparency = 1
	lbl.Text              = labelText
	lbl.Font              = Enum.Font.Gotham
	lbl.TextSize          = 11
	lbl.TextColor3        = Color3.fromRGB(150, 150, 175)
	lbl.TextXAlignment    = Enum.TextXAlignment.Left
	lbl.ZIndex            = 22
	lbl.Parent            = Panel

	local box             = Instance.new("TextBox")
	box.Size              = UDim2.new(1, -16, 0, 28)
	box.Position          = UDim2.new(0, 8, 0, yPos + 17)
	box.BackgroundColor3  = Color3.fromRGB(40, 40, 58)
	box.Text              = defaultText
	box.Font              = Enum.Font.Gotham
	box.TextSize          = 13
	box.TextColor3        = Color3.fromRGB(235, 235, 255)
	box.PlaceholderColor3 = Color3.fromRGB(100, 100, 120)
	box.BorderSizePixel   = 0
	box.ZIndex            = 22
	box.Parent            = Panel
	Instance.new("UICorner", box).CornerRadius = UDim.new(0, 5)
	return box
end

local BalanceBox  = makeBox(46,  "Balance",           tostring(balance))
local KeybindBox  = makeBox(104, "Keybind (e.g. F)",  "F")

-- Open Shop button
local OpenBtn             = Instance.new("TextButton")
OpenBtn.Name              = "OpenBtn"
OpenBtn.Size              = UDim2.new(1, -16, 0, 34)
OpenBtn.Position          = UDim2.new(0, 8, 0, 162)
OpenBtn.BackgroundColor3  = C_BTN_BLUE
OpenBtn.Text              = "Open Shop"
OpenBtn.Font              = Enum.Font.GothamBold
OpenBtn.TextSize          = 13
OpenBtn.TextColor3        = C_WHITE
OpenBtn.BorderSizePixel   = 0
OpenBtn.AutoButtonColor   = false
OpenBtn.ZIndex            = 22
OpenBtn.Parent            = Panel
Instance.new("UICorner", OpenBtn).CornerRadius = UDim.new(0, 7)

-- Dropdown label
local DropLbl             = Instance.new("TextLabel")
DropLbl.Size              = UDim2.new(1, -16, 0, 16)
DropLbl.Position          = UDim2.new(0, 8, 0, 208)
DropLbl.BackgroundTransparency = 1
DropLbl.Text              = "Gift to Player"
DropLbl.Font              = Enum.Font.Gotham
DropLbl.TextSize          = 11
DropLbl.TextColor3        = Color3.fromRGB(150, 150, 175)
DropLbl.TextXAlignment    = Enum.TextXAlignment.Left
DropLbl.ZIndex            = 22
DropLbl.Parent            = Panel

-- Dropdown selected display
local DropSelected        = Instance.new("TextButton")
DropSelected.Name         = "DropSelected"
DropSelected.Size         = UDim2.new(1, -16, 0, 28)
DropSelected.Position     = UDim2.new(0, 8, 0, 225)
DropSelected.BackgroundColor3 = Color3.fromRGB(40, 40, 58)
DropSelected.Text         = "— Select Player —"
DropSelected.Font         = Enum.Font.Gotham
DropSelected.TextSize     = 12
DropSelected.TextColor3   = Color3.fromRGB(200, 200, 220)
DropSelected.BorderSizePixel = 0
DropSelected.ZIndex       = 23
DropSelected.Parent       = Panel
Instance.new("UICorner", DropSelected).CornerRadius = UDim.new(0, 5)

-- Dropdown list (expands downward, hidden until toggled)
local DropList            = Instance.new("Frame")
DropList.Name             = "DropList"
DropList.Size             = UDim2.new(1, -16, 0, 0)
DropList.Position         = UDim2.new(0, 8, 0, 254)
DropList.BackgroundColor3 = Color3.fromRGB(48, 48, 70)
DropList.BorderSizePixel  = 0
DropList.ClipsDescendants = true
DropList.Visible          = false
DropList.ZIndex           = 30
DropList.Parent           = Panel
Instance.new("UICorner", DropList).CornerRadius = UDim.new(0, 5)

local DropLayout          = Instance.new("UIListLayout")
DropLayout.SortOrder      = Enum.SortOrder.LayoutOrder
DropLayout.Padding        = UDim.new(0, 1)
DropLayout.Parent         = DropList

-- ============================================================
-- FUNCTIONS
-- ============================================================

-- Refresh the balance label inside the Buy GUI
local function refreshBalance()
	BalanceLabel.Text = "\u{E002} " .. fmt(balance)
end

-- Subtract cost; returns false if insufficient
local function deductBalance()
	if balance < ITEM_COST then return false end
	balance = balance - ITEM_COST
	refreshBalance()
	BalanceBox.Text = tostring(balance)
	return true
end

-- Sweep: bright shimmer slides left→right over Buy button in 3 seconds.
-- Buy button stays LOCKED (Active=false) during sweep.
-- After sweep completes Buy button becomes Active=true.
local function playSweep()
	sweepDone             = false
	BuyBtn.Active         = false
	BuyBtn.BackgroundColor3 = C_BTN_BLUE

	SweepBar.Position     = UDim2.new(0, -65, 0, 0)   -- reset to off-left

	local tween = TweenService:Create(
		SweepBar,
		TweenInfo.new(3, Enum.EasingStyle.Linear, Enum.EasingDirection.In),
		{ Position = UDim2.new(1, 10, 0, 0) }          -- slide to off-right
	)
	tween:Play()
	tween.Completed:Connect(function()
		sweepDone     = true
		BuyBtn.Active = true   -- UNLOCKED — now clickable
	end)
end

-- Open Buy GUI (never opens automatically)
local function openGui()
	if guiOpen then return end
	guiOpen = true
	refreshBalance()
	SuccessFrame.Visible = false
	MainFrame.Visible    = true
	BuyGui.Enabled       = true
	playSweep()
end

-- Close everything
local function closeGui()
	guiOpen               = false
	sweepDone             = false
	BuyGui.Enabled        = false
	MainFrame.Visible     = false
	SuccessFrame.Visible  = false
end

-- Show success popup with dynamic username
local function showSuccess()
	local target  = (selectedPlayer ~= "") and selectedPlayer or "Unknown"
	SMsg.Text     = "You have successfully gifted [GIFT] ADMIN PANEL to " .. target .. "."
	MainFrame.Visible    = false
	SuccessFrame.Visible = true
end

-- Rebuild dropdown with current server players
local function refreshDropdown()
	for _, c in ipairs(DropList:GetChildren()) do
		if c:IsA("TextButton") then c:Destroy() end
	end

	local plist   = Players:GetPlayers()
	local rowH    = 28
	DropList.Size = UDim2.new(1, -16, 0, math.min(#plist * rowH, 112))

	for i, plr in ipairs(plist) do
		local btn             = Instance.new("TextButton")
		btn.Size              = UDim2.new(1, 0, 0, rowH)
		btn.BackgroundTransparency = 1
		btn.Text              = plr.Name
		btn.Font              = Enum.Font.Gotham
		btn.TextSize          = 12
		btn.TextColor3        = Color3.fromRGB(220, 220, 245)
		btn.LayoutOrder       = i
		btn.ZIndex            = 32
		btn.Parent            = DropList

		btn.MouseButton1Click:Connect(function()
			selectedPlayer    = plr.Name
			DropSelected.Text = plr.Name
			DropList.Visible  = false
		end)
	end
end

local function toggleDropdown()
	if DropList.Visible then
		DropList.Visible = false
	else
		refreshDropdown()
		DropList.Visible = true
	end
end

local function parseKeybind(text)
	local upper = text:upper():gsub("%s", "")
	local ok, kc = pcall(function() return Enum.KeyCode[upper] end)
	if ok and kc then keybind = kc end
end

-- ============================================================
-- CONNECTIONS
-- ============================================================

-- Control panel Open Shop button
OpenBtn.MouseButton1Click:Connect(function()
	openGui()
end)

-- Buy popup X close
CloseBtn.MouseButton1Click:Connect(function()
	closeGui()
end)

-- Buy button click
BuyBtn.MouseButton1Click:Connect(function()
	if not BuyBtn.Active then return end          -- blocked during sweep
	if balance < ITEM_COST then
		-- Flash red briefly if can't afford
		BuyBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
		task.delay(0.5, function()
			BuyBtn.BackgroundColor3 = C_BTN_BLUE
		end)
		return
	end
	BuyBtn.BackgroundColor3 = C_BTN_CLICKED      -- goes dark blue on click
	deductBalance()
	task.delay(0.12, showSuccess)
end)

-- OK button click
OKBtn.MouseButton1Click:Connect(function()
	OKBtn.BackgroundColor3 = C_BTN_CLICKED       -- goes dark blue on click
	task.delay(0.12, closeGui)
end)

-- Success popup X close
SCloseBtn.MouseButton1Click:Connect(function()
	closeGui()
end)

-- Balance TextBox: live update on focus lost
BalanceBox.FocusLost:Connect(function()
	local v = tonumber(BalanceBox.Text)
	if v and v >= 0 then
		balance = math.floor(v)
		refreshBalance()
	else
		BalanceBox.Text = tostring(balance)
	end
end)

-- Keybind TextBox: parse on focus lost
KeybindBox.FocusLost:Connect(function()
	parseKeybind(KeybindBox.Text)
end)

-- Dropdown toggle
DropSelected.MouseButton1Click:Connect(function()
	toggleDropdown()
end)

-- Global keybind listener
UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end
	if input.KeyCode == keybind then
		if guiOpen then closeGui() else openGui() end
	end
end)

-- Live-update dropdown when players join/leave
Players.PlayerAdded:Connect(function()
	if DropList.Visible then refreshDropdown() end
end)
Players.PlayerRemoving:Connect(function(plr)
	if selectedPlayer == plr.Name then
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
