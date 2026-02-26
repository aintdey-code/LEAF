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
-- COLORS — matched pixel-perfect from the original screenshot
-- Card is MEDIUM GRAY (not black), backdrop is soft gray blur
-- ============================================================
local C_CARD       = Color3.fromRGB(52,  52,  52)   -- medium gray card (matches original)
local C_DIVIDER    = Color3.fromRGB(80,  80,  80)   -- slightly lighter divider line
local C_WHITE      = Color3.fromRGB(255, 255, 255)  -- all primary text
local C_SUBTEXT    = Color3.fromRGB(185, 185, 185)  -- price / secondary text
local C_BTN_DARK   = Color3.fromRGB(50,  80,  170)  -- DARK blue — button starts here
local C_BTN_LIGHT  = Color3.fromRGB(100, 149, 237)  -- LIGHT blue — sweep reveals this
local C_BTN_OK     = Color3.fromRGB(100, 149, 237)  -- OK button is already light blue
local C_BTN_CLICK  = Color3.fromRGB(35,  60,  145)  -- pressed dark blue
local C_ICON_BG    = Color3.fromRGB(65,  65,  80)   -- dark square icon bg
local C_CHECK_BG   = Color3.fromRGB(75,  75,  75)   -- checkmark circle bg

-- ============================================================
-- HELPER: comma-format number  66245 → "66,245"
-- ============================================================
local function fmt(n)
	local s            = tostring(math.floor(n))
	local result, cnt  = "", 0
	for i = #s, 1, -1 do
		if cnt > 0 and cnt % 3 == 0 then result = "," .. result end
		result = s:sub(i, i) .. result
		cnt    = cnt + 1
	end
	return result
end

-- ============================================================
-- BUY GUI  ScreenGui
-- ============================================================
local BuyGui            = Instance.new("ScreenGui")
BuyGui.Name             = "BuyItemGui"
BuyGui.ResetOnSpawn     = false
BuyGui.ZIndexBehavior   = Enum.ZIndexBehavior.Sibling
BuyGui.Enabled          = false        -- never auto-opens
BuyGui.Parent           = PlayerGui

-- Soft GRAY backdrop (not black — matches original blurred gray overlay)
local Backdrop              = Instance.new("Frame")
Backdrop.Size               = UDim2.new(1, 0, 1, 0)
Backdrop.BackgroundColor3   = Color3.fromRGB(80, 80, 80)
Backdrop.BackgroundTransparency = 0.4
Backdrop.BorderSizePixel    = 0
Backdrop.ZIndex             = 1
Backdrop.Parent             = BuyGui

-- ── BUY POPUP CARD ─────────────────────────────────────────
-- Taller card (220px) to match the original proportions
local MainFrame             = Instance.new("Frame")
MainFrame.Name              = "MainFrame"
MainFrame.Size              = UDim2.new(0, 340, 0, 220)
MainFrame.Position          = UDim2.new(0.5, -170, 0.5, -110)
MainFrame.BackgroundColor3  = C_CARD
MainFrame.BorderSizePixel   = 0
MainFrame.ZIndex            = 2
MainFrame.Parent            = BuyGui
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)

-- ── TITLE ROW ──────────────────────────────────────────────
local TitleRow              = Instance.new("Frame")
TitleRow.Size               = UDim2.new(1, 0, 0, 44)
TitleRow.Position           = UDim2.new(0, 0, 0, 0)
TitleRow.BackgroundTransparency = 1
TitleRow.ZIndex             = 3
TitleRow.Parent             = MainFrame

-- "Buy item" left label
local TitleLbl              = Instance.new("TextLabel")
TitleLbl.Size               = UDim2.new(0, 130, 1, 0)
TitleLbl.Position           = UDim2.new(0, 14, 0, 0)
TitleLbl.BackgroundTransparency = 1
TitleLbl.Text               = "Buy item"
TitleLbl.Font               = Enum.Font.GothamBold
TitleLbl.TextSize           = 18
TitleLbl.TextColor3         = C_WHITE
TitleLbl.TextXAlignment     = Enum.TextXAlignment.Left
TitleLbl.ZIndex             = 4
TitleLbl.Parent             = TitleRow

-- Robux balance top-right  ⊙ 66,245
local BalanceLabel          = Instance.new("TextLabel")
BalanceLabel.Name           = "BalanceLabel"
BalanceLabel.Size           = UDim2.new(0, 110, 1, 0)
BalanceLabel.Position       = UDim2.new(1, -152, 0, 0)
BalanceLabel.BackgroundTransparency = 1
BalanceLabel.Font           = Enum.Font.GothamBold
BalanceLabel.TextSize       = 14
BalanceLabel.TextColor3     = C_WHITE
BalanceLabel.TextXAlignment = Enum.TextXAlignment.Right
BalanceLabel.ZIndex         = 4
BalanceLabel.Parent         = TitleRow

-- X close — plain white text, no background
local CloseBtn              = Instance.new("TextButton")
CloseBtn.Name               = "CloseBtn"
CloseBtn.Size               = UDim2.new(0, 30, 0, 30)
CloseBtn.Position           = UDim2.new(1, -36, 0.5, -15)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Text               = "X"
CloseBtn.Font               = Enum.Font.GothamBold
CloseBtn.TextSize           = 16
CloseBtn.TextColor3         = C_WHITE
CloseBtn.BorderSizePixel    = 0
CloseBtn.ZIndex             = 5
CloseBtn.Parent             = TitleRow

-- Divider line under title
local Div1                  = Instance.new("Frame")
Div1.Size                   = UDim2.new(1, 0, 0, 1)
Div1.Position               = UDim2.new(0, 0, 0, 44)
Div1.BackgroundColor3       = C_DIVIDER
Div1.BorderSizePixel        = 0
Div1.ZIndex                 = 3
Div1.Parent                 = MainFrame

-- ── ITEM ROW ───────────────────────────────────────────────
local ItemRow               = Instance.new("Frame")
ItemRow.Size                = UDim2.new(1, 0, 0, 90)
ItemRow.Position            = UDim2.new(0, 0, 0, 45)
ItemRow.BackgroundTransparency = 1
ItemRow.ZIndex              = 3
ItemRow.Parent              = MainFrame

-- HD Image icon (real Roblox asset)
local IconFrame             = Instance.new("Frame")
IconFrame.Size              = UDim2.new(0, 62, 0, 62)
IconFrame.Position          = UDim2.new(0, 14, 0.5, -31)
IconFrame.BackgroundColor3  = C_ICON_BG
IconFrame.BorderSizePixel   = 0
IconFrame.ZIndex            = 4
IconFrame.Parent            = ItemRow
Instance.new("UICorner", IconFrame).CornerRadius = UDim.new(0, 6)

local IconImg               = Instance.new("ImageLabel")
IconImg.Size                = UDim2.new(1, 0, 1, 0)
IconImg.BackgroundTransparency = 1
IconImg.Image               = "rbxassetid://136656557035530"
IconImg.ScaleType           = Enum.ScaleType.Fit
IconImg.ZIndex              = 5
IconImg.Parent              = IconFrame

-- Item name  [GIFT] ADMIN PANEL
local ItemNameLbl           = Instance.new("TextLabel")
ItemNameLbl.Size            = UDim2.new(1, -90, 0, 28)
ItemNameLbl.Position        = UDim2.new(0, 86, 0, 18)
ItemNameLbl.BackgroundTransparency = 1
ItemNameLbl.Text            = "[GIFT] ADMIN PANEL"
ItemNameLbl.Font            = Enum.Font.GothamBold
ItemNameLbl.TextSize        = 14
ItemNameLbl.TextColor3      = C_WHITE
ItemNameLbl.TextXAlignment  = Enum.TextXAlignment.Left
ItemNameLbl.ZIndex          = 4
ItemNameLbl.Parent          = ItemRow

-- Item price  ⊙ 7,499
local ItemPriceLbl          = Instance.new("TextLabel")
ItemPriceLbl.Size           = UDim2.new(1, -90, 0, 22)
ItemPriceLbl.Position       = UDim2.new(0, 86, 0, 48)
ItemPriceLbl.BackgroundTransparency = 1
ItemPriceLbl.Text           = "\u{E002} 7,499"
ItemPriceLbl.Font           = Enum.Font.Gotham
ItemPriceLbl.TextSize       = 13
ItemPriceLbl.TextColor3     = C_SUBTEXT
ItemPriceLbl.TextXAlignment = Enum.TextXAlignment.Left
ItemPriceLbl.ZIndex         = 4
ItemPriceLbl.Parent         = ItemRow

-- Divider line above button
local Div2                  = Instance.new("Frame")
Div2.Size                   = UDim2.new(1, 0, 0, 1)
Div2.Position               = UDim2.new(0, 0, 0, 135)
Div2.BackgroundColor3       = C_DIVIDER
Div2.BorderSizePixel        = 0
Div2.ZIndex                 = 3
Div2.Parent                 = MainFrame

-- ── BUY BUTTON ─────────────────────────────────────────────
-- Starts DARK BLUE. Sweep animation wipes it to LIGHT BLUE left→right.
-- Button is locked (Active=false) during the 3-second sweep.
local BuyBtn                = Instance.new("TextButton")
BuyBtn.Name                 = "BuyBtn"
BuyBtn.Size                 = UDim2.new(1, -28, 0, 46)
BuyBtn.Position             = UDim2.new(0, 14, 0, 143)
BuyBtn.BackgroundColor3     = C_BTN_DARK   -- starts dark blue
BuyBtn.Text                 = "Buy"
BuyBtn.Font                 = Enum.Font.GothamBold
BuyBtn.TextSize             = 16
BuyBtn.TextColor3           = C_WHITE
BuyBtn.BorderSizePixel      = 0
BuyBtn.AutoButtonColor      = false
BuyBtn.Active               = false        -- locked until sweep finishes
BuyBtn.ZIndex               = 4
BuyBtn.Parent               = MainFrame
Instance.new("UICorner", BuyBtn).CornerRadius = UDim.new(0, 8)

-- ── SWEEP OVERLAY ──────────────────────────────────────────
-- The sweep works by placing a LIGHT BLUE cover frame OVER the
-- dark-blue button. It starts at width=0 on the left and tweens
-- to full width over 3 seconds, revealing light blue left→right.
-- This gives the exact "dark blue swept into light blue" effect.
local SweepCover            = Instance.new("Frame")
SweepCover.Name             = "SweepCover"
SweepCover.Size             = UDim2.new(0, 0, 1, 0)    -- starts 0 width
SweepCover.Position         = UDim2.new(0, 0, 0, 0)
SweepCover.BackgroundColor3 = C_BTN_LIGHT              -- light blue
SweepCover.BorderSizePixel  = 0
SweepCover.ZIndex           = 5                        -- above BuyBtn
SweepCover.ClipsDescendants = false
SweepCover.Parent           = BuyBtn                   -- child of button = clips automatically

-- "Buy" text label on top of sweep (so text stays visible over both colors)
local BuyBtnLabel           = Instance.new("TextLabel")
BuyBtnLabel.Size            = UDim2.new(1, 0, 1, 0)
BuyBtnLabel.BackgroundTransparency = 1
BuyBtnLabel.Text            = "Buy"
BuyBtnLabel.Font            = Enum.Font.GothamBold
BuyBtnLabel.TextSize        = 16
BuyBtnLabel.TextColor3      = C_WHITE
BuyBtnLabel.ZIndex          = 6                        -- above SweepCover
BuyBtnLabel.Parent          = BuyBtn
BuyBtn.Text                 = ""                       -- clear original text (label takes over)

-- ============================================================
-- SUCCESS POPUP  (same medium-gray card)
-- ============================================================
local SuccessFrame          = Instance.new("Frame")
SuccessFrame.Name           = "SuccessFrame"
SuccessFrame.Size           = UDim2.new(0, 340, 0, 210)
SuccessFrame.Position       = UDim2.new(0.5, -170, 0.5, -105)
SuccessFrame.BackgroundColor3 = C_CARD
SuccessFrame.BorderSizePixel  = 0
SuccessFrame.Visible        = false
SuccessFrame.ZIndex         = 10
SuccessFrame.Parent         = BuyGui
Instance.new("UICorner", SuccessFrame).CornerRadius = UDim.new(0, 10)

-- Success title row
local STitleRow             = Instance.new("Frame")
STitleRow.Size              = UDim2.new(1, 0, 0, 44)
STitleRow.BackgroundTransparency = 1
STitleRow.ZIndex            = 11
STitleRow.Parent            = SuccessFrame

local STitleLbl             = Instance.new("TextLabel")
STitleLbl.Size              = UDim2.new(1, -44, 1, 0)
STitleLbl.Position          = UDim2.new(0, 14, 0, 0)
STitleLbl.BackgroundTransparency = 1
STitleLbl.Text              = "Purchase completed"
STitleLbl.Font              = Enum.Font.GothamBold
STitleLbl.TextSize          = 17
STitleLbl.TextColor3        = C_WHITE
STitleLbl.TextXAlignment    = Enum.TextXAlignment.Left
STitleLbl.ZIndex            = 12
STitleLbl.Parent            = STitleRow

-- X close — plain white text
local SCloseBtn             = Instance.new("TextButton")
SCloseBtn.Size              = UDim2.new(0, 30, 0, 30)
SCloseBtn.Position          = UDim2.new(1, -36, 0.5, -15)
SCloseBtn.BackgroundTransparency = 1
SCloseBtn.Text              = "X"
SCloseBtn.Font              = Enum.Font.GothamBold
SCloseBtn.TextSize          = 16
SCloseBtn.TextColor3        = C_WHITE
SCloseBtn.BorderSizePixel   = 0
SCloseBtn.ZIndex            = 13
SCloseBtn.Parent            = STitleRow

-- Divider
local SDiv                  = Instance.new("Frame")
SDiv.Size                   = UDim2.new(1, 0, 0, 1)
SDiv.Position               = UDim2.new(0, 0, 0, 44)
SDiv.BackgroundColor3       = C_DIVIDER
SDiv.BorderSizePixel        = 0
SDiv.ZIndex                 = 11
SDiv.Parent                 = SuccessFrame

-- Checkmark circle
local CheckCircle           = Instance.new("Frame")
CheckCircle.Size            = UDim2.new(0, 40, 0, 40)
CheckCircle.Position        = UDim2.new(0.5, -20, 0, 54)
CheckCircle.BackgroundColor3 = C_CHECK_BG
CheckCircle.BorderSizePixel = 0
CheckCircle.ZIndex          = 12
CheckCircle.Parent          = SuccessFrame
Instance.new("UICorner", CheckCircle).CornerRadius = UDim.new(1, 0)

local CheckMark             = Instance.new("TextLabel")
CheckMark.Size              = UDim2.new(1, 0, 1, 0)
CheckMark.BackgroundTransparency = 1
CheckMark.Text              = "✓"
CheckMark.Font              = Enum.Font.GothamBold
CheckMark.TextSize          = 22
CheckMark.TextColor3        = C_WHITE
CheckMark.ZIndex            = 13
CheckMark.Parent            = CheckCircle

-- Success message text
local SMsg                  = Instance.new("TextLabel")
SMsg.Name                   = "SMsg"
SMsg.Size                   = UDim2.new(1, -28, 0, 32)
SMsg.Position               = UDim2.new(0, 14, 0, 102)
SMsg.BackgroundTransparency = 1
SMsg.Text                   = ""
SMsg.Font                   = Enum.Font.Gotham
SMsg.TextSize               = 12
SMsg.TextColor3             = C_SUBTEXT
SMsg.TextWrapped            = true
SMsg.ZIndex                 = 12
SMsg.Parent                 = SuccessFrame

-- OK button — already light blue, no sweep needed
local OKBtn                 = Instance.new("TextButton")
OKBtn.Name                  = "OKBtn"
OKBtn.Size                  = UDim2.new(1, -28, 0, 44)
OKBtn.Position              = UDim2.new(0, 14, 0, 152)
OKBtn.BackgroundColor3      = C_BTN_OK
OKBtn.Text                  = "OK"
OKBtn.Font                  = Enum.Font.GothamBold
OKBtn.TextSize              = 15
OKBtn.TextColor3            = C_WHITE
OKBtn.BorderSizePixel       = 0
OKBtn.AutoButtonColor       = false
OKBtn.ZIndex                = 12
OKBtn.Parent                = SuccessFrame
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
Panel.Size                  = UDim2.new(0, 200, 0, 340)
Panel.Position              = UDim2.new(0, 10, 0.5, -170)
Panel.BackgroundColor3      = Color3.fromRGB(35, 35, 48)
Panel.BorderSizePixel       = 0
Panel.ZIndex                = 20
Panel.Parent                = CtrlGui
Instance.new("UICorner", Panel).CornerRadius = UDim.new(0, 10)

local PanelTitleBar         = Instance.new("Frame")
PanelTitleBar.Size          = UDim2.new(1, 0, 0, 38)
PanelTitleBar.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
PanelTitleBar.BorderSizePixel  = 0
PanelTitleBar.ZIndex        = 21
PanelTitleBar.Parent        = Panel
Instance.new("UICorner", PanelTitleBar).CornerRadius = UDim.new(0, 10)

local PanelTitleLbl         = Instance.new("TextLabel")
PanelTitleLbl.Size          = UDim2.new(1, 0, 1, 0)
PanelTitleLbl.BackgroundTransparency = 1
PanelTitleLbl.Text          = "🎮  Control Panel"
PanelTitleLbl.Font          = Enum.Font.GothamBold
PanelTitleLbl.TextSize      = 13
PanelTitleLbl.TextColor3    = Color3.fromRGB(190, 190, 255)
PanelTitleLbl.ZIndex        = 22
PanelTitleLbl.Parent        = PanelTitleBar

local function makeBox(yPos, labelText, defaultText)
	local lbl                 = Instance.new("TextLabel")
	lbl.Size                  = UDim2.new(1, -16, 0, 16)
	lbl.Position              = UDim2.new(0, 8, 0, yPos)
	lbl.BackgroundTransparency = 1
	lbl.Text                  = labelText
	lbl.Font                  = Enum.Font.Gotham
	lbl.TextSize              = 11
	lbl.TextColor3            = Color3.fromRGB(150, 150, 175)
	lbl.TextXAlignment        = Enum.TextXAlignment.Left
	lbl.ZIndex                = 22
	lbl.Parent                = Panel

	local box                 = Instance.new("TextBox")
	box.Size                  = UDim2.new(1, -16, 0, 28)
	box.Position              = UDim2.new(0, 8, 0, yPos + 17)
	box.BackgroundColor3      = Color3.fromRGB(45, 45, 62)
	box.Text                  = defaultText
	box.Font                  = Enum.Font.Gotham
	box.TextSize              = 13
	box.TextColor3            = Color3.fromRGB(235, 235, 255)
	box.PlaceholderColor3     = Color3.fromRGB(100, 100, 120)
	box.BorderSizePixel       = 0
	box.ZIndex                = 22
	box.Parent                = Panel
	Instance.new("UICorner", box).CornerRadius = UDim.new(0, 5)
	return box
end

local BalanceBox  = makeBox(46,  "Balance",          tostring(balance))
local KeybindBox  = makeBox(104, "Keybind (e.g. F)", "F")

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
DropLbl.TextColor3          = Color3.fromRGB(150, 150, 175)
DropLbl.TextXAlignment      = Enum.TextXAlignment.Left
DropLbl.ZIndex              = 22
DropLbl.Parent              = Panel

local DropSelected          = Instance.new("TextButton")
DropSelected.Name           = "DropSelected"
DropSelected.Size           = UDim2.new(1, -16, 0, 28)
DropSelected.Position       = UDim2.new(0, 8, 0, 225)
DropSelected.BackgroundColor3 = Color3.fromRGB(45, 45, 62)
DropSelected.Text           = "— Select Player —"
DropSelected.Font           = Enum.Font.Gotham
DropSelected.TextSize       = 12
DropSelected.TextColor3     = Color3.fromRGB(200, 200, 220)
DropSelected.BorderSizePixel = 0
DropSelected.ZIndex         = 23
DropSelected.Parent         = Panel
Instance.new("UICorner", DropSelected).CornerRadius = UDim.new(0, 5)

local DropList              = Instance.new("Frame")
DropList.Name               = "DropList"
DropList.Size               = UDim2.new(1, -16, 0, 0)
DropList.Position           = UDim2.new(0, 8, 0, 254)
DropList.BackgroundColor3   = Color3.fromRGB(52, 52, 72)
DropList.BorderSizePixel    = 0
DropList.ClipsDescendants   = true
DropList.Visible            = false
DropList.ZIndex             = 30
DropList.Parent             = Panel
Instance.new("UICorner", DropList).CornerRadius = UDim.new(0, 5)

local DropLayout            = Instance.new("UIListLayout")
DropLayout.SortOrder        = Enum.SortOrder.LayoutOrder
DropLayout.Padding          = UDim.new(0, 1)
DropLayout.Parent           = DropList

-- ============================================================
-- FUNCTIONS
-- ============================================================

local function refreshBalance()
	BalanceLabel.Text = "\u{E002} " .. fmt(balance)
end

local function deductBalance()
	if balance < ITEM_COST then return false end
	balance         = balance - ITEM_COST
	refreshBalance()
	BalanceBox.Text = tostring(balance)
	return true
end

-- SWEEP: dark blue button → light blue sweeps in from left over 3 seconds.
-- SweepCover (light blue) starts at width 0 and expands to full width.
-- Buy button stays locked (Active=false) the whole time.
-- After 3 seconds: button is fully light blue and Active=true.
local function playSweep()
	BuyBtn.Active           = false
	BuyBtn.BackgroundColor3 = C_BTN_DARK   -- reset to dark blue
	SweepCover.Size         = UDim2.new(0, 0, 1, 0)   -- reset cover to 0 width

	local tween = TweenService:Create(
		SweepCover,
		TweenInfo.new(3, Enum.EasingStyle.Linear, Enum.EasingDirection.In),
		{ Size = UDim2.new(1, 0, 1, 0) }   -- expand to full width → fully light blue
	)
	tween:Play()
	tween.Completed:Connect(function()
		BuyBtn.Active = true   -- UNLOCKED — now clickable
	end)
end

local function openGui()
	if guiOpen then return end
	guiOpen = true
	refreshBalance()
	SuccessFrame.Visible = false
	MainFrame.Visible    = true
	BuyGui.Enabled       = true
	playSweep()
end

local function closeGui()
	guiOpen              = false
	BuyGui.Enabled       = false
	MainFrame.Visible    = false
	SuccessFrame.Visible = false
end

local function showSuccess()
	local target  = (selectedPlayer ~= "") and selectedPlayer or "Unknown"
	SMsg.Text     = "You have successfully gifted [GIFT] ADMIN PANEL to " .. target .. "."
	MainFrame.Visible    = false
	SuccessFrame.Visible = true
end

local function refreshDropdown()
	for _, c in ipairs(DropList:GetChildren()) do
		if c:IsA("TextButton") then c:Destroy() end
	end
	local plist   = Players:GetPlayers()
	DropList.Size = UDim2.new(1, -16, 0, math.min(#plist * 28, 112))
	for i, plr in ipairs(plist) do
		local btn             = Instance.new("TextButton")
		btn.Size              = UDim2.new(1, 0, 0, 28)
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

OpenBtn.MouseButton1Click:Connect(openGui)

CloseBtn.MouseButton1Click:Connect(closeGui)

BuyBtn.MouseButton1Click:Connect(function()
	if not BuyBtn.Active then return end
	if balance < ITEM_COST then
		-- Flash red — can't afford
		BuyBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
		SweepCover.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
		task.delay(0.5, function()
			BuyBtn.BackgroundColor3    = C_BTN_DARK
			SweepCover.BackgroundColor3 = C_BTN_LIGHT
		end)
		return
	end
	-- Turn dark blue on click, then show success
	BuyBtn.BackgroundColor3    = C_BTN_CLICK
	SweepCover.BackgroundColor3 = C_BTN_CLICK
	deductBalance()
	task.delay(0.12, showSuccess)
end)

OKBtn.MouseButton1Click:Connect(function()
	OKBtn.BackgroundColor3 = C_BTN_CLICK   -- dark blue on click
	task.delay(0.12, closeGui)
end)

SCloseBtn.MouseButton1Click:Connect(closeGui)

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
	parseKeybind(KeybindBox.Text)
end)

DropSelected.MouseButton1Click:Connect(toggleDropdown)

UserInputService.InputBegan:Connect(function(input, gp)
	if gp then return end
	if input.KeyCode == keybind then
		if guiOpen then closeGui() else openGui() end
	end
end)

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

-- Init
refreshBalance()

-- ============================================================
-- END OF SCRIPT
-- ============================================================
