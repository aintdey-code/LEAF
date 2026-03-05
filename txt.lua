local Players      = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Debris       = game:GetService("Debris")
local CoreGui      = game:GetService("CoreGui")
local player       = Players.LocalPlayer
local playerGui    = player:WaitForChild("PlayerGui")

local ROBUX_CHAR = utf8.char(0xE002)

-- balance can be changed via control panel
local balance    = 66245
local panelVisible = false
local PANEL_W    = 210
local PANEL_H    = 120

local C_CARD      = Color3.fromRGB(28, 28, 40)
local C_WHITE     = Color3.fromRGB(255, 255, 255)
local C_BTN_DARK  = Color3.fromRGB(55,  65, 160)
local C_BTN_LIGHT = Color3.fromRGB(88, 101, 242)

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

-- CONTROL PANEL
local CtrlGui = Instance.new("ScreenGui")
CtrlGui.Name         = "ControlPanel"
CtrlGui.ResetOnSpawn = false
CtrlGui.Parent       = playerGui

local Panel = Instance.new("Frame")
Panel.Name             = "Panel"
Panel.Size             = UDim2.new(0, PANEL_W, 0, PANEL_H)
Panel.Position         = UDim2.new(0, 10, 0.5, -PANEL_H/2)
Panel.BackgroundColor3 = Color3.fromRGB(28,28,42)
Panel.BorderSizePixel  = 0
Panel.ZIndex           = 20
Panel.Visible          = false
Panel.Parent           = CtrlGui
Instance.new("UICorner", Panel).CornerRadius = UDim.new(0, 10)

local PTBar = Instance.new("Frame")
PTBar.Size             = UDim2.new(1,0,0,38)
PTBar.BackgroundColor3 = Color3.fromRGB(45,45,68)
PTBar.BorderSizePixel  = 0
PTBar.ZIndex           = 21
PTBar.Parent           = Panel
Instance.new("UICorner", PTBar).CornerRadius = UDim.new(0, 10)

local PTLbl = Instance.new("TextLabel")
PTLbl.Size                   = UDim2.new(1,0,1,0)
PTLbl.BackgroundTransparency = 1
PTLbl.Text                   = "Control Panel"
PTLbl.Font                   = Enum.Font.GothamBold
PTLbl.TextSize               = 13
PTLbl.TextColor3             = C_WHITE
PTLbl.ZIndex                 = 22
PTLbl.Parent                 = PTBar

local BalLbl = Instance.new("TextLabel")
BalLbl.Size                   = UDim2.new(1,-16,0,16)
BalLbl.Position               = UDim2.new(0,8,0,44)
BalLbl.BackgroundTransparency = 1
BalLbl.Text                   = "Balance"
BalLbl.Font                   = Enum.Font.Gotham
BalLbl.TextSize               = 11
BalLbl.TextColor3             = Color3.fromRGB(175,175,200)
BalLbl.TextXAlignment         = Enum.TextXAlignment.Left
BalLbl.ZIndex                 = 22
BalLbl.Parent                 = Panel

local BalanceBox = Instance.new("TextBox")
BalanceBox.Size             = UDim2.new(1,-16,0,28)
BalanceBox.Position         = UDim2.new(0,8,0,61)
BalanceBox.BackgroundColor3 = Color3.fromRGB(42,42,62)
BalanceBox.Text             = tostring(balance)
BalanceBox.Font             = Enum.Font.Gotham
BalanceBox.TextSize         = 13
BalanceBox.TextColor3       = C_WHITE
BalanceBox.BorderSizePixel  = 0
BalanceBox.ZIndex           = 22
BalanceBox.Parent           = Panel
Instance.new("UICorner", BalanceBox).CornerRadius = UDim.new(0, 5)

local function togglePanel()
	panelVisible  = not panelVisible
	Panel.Visible = panelVisible
end

BalanceBox.FocusLost:Connect(function()
	local v = tonumber(BalanceBox.Text)
	if v and v >= 0 then
		balance = math.floor(v)
	else
		BalanceBox.Text = tostring(balance)
	end
end)

UserInputService.InputBegan:Connect(function(inp, gp)
	if gp then return end
	if inp.KeyCode == Enum.KeyCode.J then togglePanel() end
end)

player.Chatted:Connect(function(msg)
	if msg:lower() == ".c" then togglePanel() end
end)

-- OUR GUI (replaces their createBuyUI)
local function createBuyUI(itemName, itemPrice, itemImageId, giftedTo)
	local price = tonumber((tostring(itemPrice):gsub("[^%d]", ""))) or 0

	-- destroy any existing popup
	if CoreGui:FindFirstChild("BuyItemGUI") then
		CoreGui.BuyItemGUI:Destroy()
	end

	local CARD_W = 460
	local CARD_H = 220
	local SUCC_W = 460
	local SUCC_H = 220

	local screenGui = Instance.new("ScreenGui")
	screenGui.Name           = "BuyItemGUI"
	screenGui.ResetOnSpawn   = false
	screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	screenGui.IgnoreGuiInset = true
	screenGui.DisplayOrder   = 999
	screenGui.Parent         = CoreGui

	local Backdrop = Instance.new("Frame", screenGui)
	Backdrop.Size                   = UDim2.new(1,0,1,0)
	Backdrop.BackgroundColor3       = Color3.fromRGB(0,0,0)
	Backdrop.BackgroundTransparency = 0.3
	Backdrop.BorderSizePixel        = 0
	Backdrop.ZIndex                 = 1

	local Card = Instance.new("Frame", screenGui)
	Card.Name             = "Card"
	Card.Size             = UDim2.new(0, CARD_W, 0, CARD_H)
	Card.AnchorPoint      = Vector2.new(0.5, 0.5)
	Card.Position         = UDim2.new(0.5, 0, -0.3, 0)
	Card.BackgroundColor3 = C_CARD
	Card.BorderSizePixel  = 0
	Card.ZIndex           = 2
	Instance.new("UICorner", Card).CornerRadius = UDim.new(0, 12)

	local TitleLbl = Instance.new("TextLabel", Card)
	TitleLbl.Size                   = UDim2.new(0,150,0,50)
	TitleLbl.Position               = UDim2.new(0,18,0,0)
	TitleLbl.BackgroundTransparency = 1
	TitleLbl.Text                   = "Buy item"
	TitleLbl.Font                   = Enum.Font.GothamBold
	TitleLbl.TextSize               = 20
	TitleLbl.TextColor3             = C_WHITE
	TitleLbl.TextXAlignment         = Enum.TextXAlignment.Left
	TitleLbl.ZIndex                 = 3

	local BalanceLbl = Instance.new("TextLabel", Card)
	BalanceLbl.Size                   = UDim2.new(0,130,0,50)
	BalanceLbl.Position               = UDim2.new(1,-182,0,0)
	BalanceLbl.BackgroundTransparency = 1
	BalanceLbl.Font                   = Enum.Font.GothamBold
	BalanceLbl.TextSize               = 16
	BalanceLbl.TextColor3             = C_WHITE
	BalanceLbl.TextXAlignment         = Enum.TextXAlignment.Right
	BalanceLbl.ZIndex                 = 3
	BalanceLbl.Text                   = ROBUX_CHAR .. " " .. fmt(balance)

	local CloseBtn = Instance.new("TextButton", Card)
	CloseBtn.Size                   = UDim2.new(0,40,0,50)
	CloseBtn.Position               = UDim2.new(1,-44,0,0)
	CloseBtn.BackgroundTransparency = 1
	CloseBtn.Text                   = "X"
	CloseBtn.Font                   = Enum.Font.GothamBold
	CloseBtn.TextSize               = 18
	CloseBtn.TextColor3             = C_WHITE
	CloseBtn.BorderSizePixel        = 0
	CloseBtn.ZIndex                 = 4

	local IconFrame = Instance.new("Frame", Card)
	IconFrame.Size                   = UDim2.new(0,100,0,100)
	IconFrame.Position               = UDim2.new(0,14,0,52)
	IconFrame.BackgroundTransparency = 1
	IconFrame.BorderSizePixel        = 0
	IconFrame.ZIndex                 = 3
	Instance.new("UICorner", IconFrame).CornerRadius = UDim.new(0, 8)

	local IconImg = Instance.new("ImageLabel", IconFrame)
	IconImg.Size                   = UDim2.new(1,0,1,0)
	IconImg.BackgroundTransparency = 1
	IconImg.Image                  = itemImageId or ""
	IconImg.ScaleType              = Enum.ScaleType.Fit
	IconImg.ZIndex                 = 4

	local ItemNameLbl = Instance.new("TextLabel", Card)
	ItemNameLbl.Size                   = UDim2.new(1,-130,0,24)
	ItemNameLbl.Position               = UDim2.new(0,126,0,68)
	ItemNameLbl.BackgroundTransparency = 1
	ItemNameLbl.Text                   = giftedTo and ("[GIFT] "..itemName) or itemName
	ItemNameLbl.Font                   = Enum.Font.GothamBold
	ItemNameLbl.TextSize               = 18
	ItemNameLbl.TextColor3             = C_WHITE
	ItemNameLbl.TextXAlignment         = Enum.TextXAlignment.Left
	ItemNameLbl.TextTruncate           = Enum.TextTruncate.AtEnd
	ItemNameLbl.ZIndex                 = 3

	local ItemPriceLbl = Instance.new("TextLabel", Card)
	ItemPriceLbl.Size                   = UDim2.new(1,-130,0,22)
	ItemPriceLbl.Position               = UDim2.new(0,126,0,98)
	ItemPriceLbl.BackgroundTransparency = 1
	ItemPriceLbl.Text                   = price > 0 and (ROBUX_CHAR .. " " .. fmt(price)) or "Free"
	ItemPriceLbl.Font                   = Enum.Font.Gotham
	ItemPriceLbl.TextSize               = 17
	ItemPriceLbl.TextColor3             = C_WHITE
	ItemPriceLbl.TextXAlignment         = Enum.TextXAlignment.Left
	ItemPriceLbl.ZIndex                 = 3

	local BuyBtn = Instance.new("TextButton", Card)
	BuyBtn.Size             = UDim2.new(1,-28,0,48)
	BuyBtn.Position         = UDim2.new(0,14,0,158)
	BuyBtn.BackgroundColor3 = C_BTN_DARK
	BuyBtn.Text             = ""
	BuyBtn.BorderSizePixel  = 0
	BuyBtn.AutoButtonColor  = false
	BuyBtn.Active           = false
	BuyBtn.ZIndex           = 3
	BuyBtn.ClipsDescendants = true
	Instance.new("UICorner", BuyBtn).CornerRadius = UDim.new(0, 10)

	local SweepCover = Instance.new("Frame", BuyBtn)
	SweepCover.Size             = UDim2.new(0,0,1,0)
	SweepCover.BackgroundColor3 = C_BTN_LIGHT
	SweepCover.BorderSizePixel  = 0
	SweepCover.ZIndex           = 4
	Instance.new("UICorner", SweepCover).CornerRadius = UDim.new(0, 10)

	local BuyLbl = Instance.new("TextLabel", BuyBtn)
	BuyLbl.Size                   = UDim2.new(1,0,1,0)
	BuyLbl.BackgroundTransparency = 1
	BuyLbl.Text                   = "Buy"
	BuyLbl.Font                   = Enum.Font.GothamBold
	BuyLbl.TextSize               = 18
	BuyLbl.TextColor3             = C_WHITE
	BuyLbl.ZIndex                 = 5

	-- SUCCESS CARD
	local SuccessCard = Instance.new("Frame", screenGui)
	SuccessCard.Name             = "SuccessCard"
	SuccessCard.Size             = UDim2.new(0, SUCC_W, 0, SUCC_H)
	SuccessCard.AnchorPoint      = Vector2.new(0.5, 0.5)
	SuccessCard.Position         = UDim2.new(0.5, 0, -0.4, 0)
	SuccessCard.BackgroundColor3 = C_CARD
	SuccessCard.BorderSizePixel  = 0
	SuccessCard.Visible          = false
	SuccessCard.ZIndex           = 10
	Instance.new("UICorner", SuccessCard).CornerRadius = UDim.new(0, 12)

	local STitleLbl = Instance.new("TextLabel", SuccessCard)
	STitleLbl.Size                   = UDim2.new(1,-52,0,50)
	STitleLbl.Position               = UDim2.new(0,18,0,0)
	STitleLbl.BackgroundTransparency = 1
	STitleLbl.Text                   = "Purchase completed"
	STitleLbl.Font                   = Enum.Font.GothamBold
	STitleLbl.TextSize               = 19
	STitleLbl.TextColor3             = C_WHITE
	STitleLbl.TextXAlignment         = Enum.TextXAlignment.Left
	STitleLbl.ZIndex                 = 11

	local SCloseBtn = Instance.new("TextButton", SuccessCard)
	SCloseBtn.Size                   = UDim2.new(0,40,0,50)
	SCloseBtn.Position               = UDim2.new(1,-44,0,0)
	SCloseBtn.BackgroundTransparency = 1
	SCloseBtn.Text                   = "X"
	SCloseBtn.Font                   = Enum.Font.GothamBold
	SCloseBtn.TextSize               = 18
	SCloseBtn.TextColor3             = C_WHITE
	SCloseBtn.BorderSizePixel        = 0
	SCloseBtn.ZIndex                 = 12

	local CheckImg = Instance.new("ImageLabel", SuccessCard)
	CheckImg.Size                   = UDim2.new(0,60,0,60)
	CheckImg.Position               = UDim2.new(0.5,-30,0,44)
	CheckImg.BackgroundTransparency = 1
	CheckImg.Image                  = "rbxassetid://135084016839600"
	CheckImg.ScaleType              = Enum.ScaleType.Fit
	CheckImg.ZIndex                 = 12

	local SMsg = Instance.new("TextLabel", SuccessCard)
	SMsg.Size                   = UDim2.new(1,-36,0,32)
	SMsg.Position               = UDim2.new(0,18,0,116)
	SMsg.BackgroundTransparency = 1
	SMsg.Font                   = Enum.Font.Gotham
	SMsg.TextSize               = 14
	SMsg.TextColor3             = C_WHITE
	SMsg.TextWrapped            = true
	SMsg.TextYAlignment         = Enum.TextYAlignment.Center
	SMsg.ZIndex                 = 12
	if giftedTo and giftedTo ~= "" then
		SMsg.Text = 'Successfully Gifted "'..itemName..'" to '..giftedTo..'!'
	else
		SMsg.Text = 'Successfully Purchased "'..itemName..'"!'
	end

	local OKBtn = Instance.new("TextButton", SuccessCard)
	OKBtn.Size             = UDim2.new(1,-28,0,48)
	OKBtn.Position         = UDim2.new(0,14,0,158)
	OKBtn.BackgroundColor3 = C_BTN_LIGHT
	OKBtn.Text             = "OK"
	OKBtn.Font             = Enum.Font.GothamBold
	OKBtn.TextSize         = 18
	OKBtn.TextColor3       = C_WHITE
	OKBtn.BorderSizePixel  = 0
	OKBtn.AutoButtonColor  = false
	OKBtn.ZIndex           = 12
	Instance.new("UICorner", OKBtn).CornerRadius = UDim.new(0, 10)

	-- LOGIC (their animation style: slide in, fill sweep, success slide in)
	local closing  = false
	local fillDone = false
	local buyDone  = false
	local fillTween = nil

	local function closeDown()
		if closing then return end
		closing = true
		if fillTween then fillTween:Cancel() end
		TweenService:Create(Card, TweenInfo.new(0.32, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {Position = UDim2.new(0.5,0,1.4,0)}):Play()
		TweenService:Create(Backdrop, TweenInfo.new(0.30), {BackgroundTransparency = 1}):Play()
		task.delay(0.33, function() screenGui:Destroy() end)
	end

	local function closeSuccess()
		if closing then return end
		closing = true
		TweenService:Create(SuccessCard, TweenInfo.new(0.32, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {Position = UDim2.new(0.5,0,1.4,0)}):Play()
		TweenService:Create(Backdrop, TweenInfo.new(0.30), {BackgroundTransparency = 1}):Play()
		task.delay(0.33, function()
			balance = math.max(0, balance - price)
			BalanceBox.Text = tostring(balance)
			screenGui:Destroy()
		end)
	end

	local function showSuccess()
		Card.Visible          = false
		SuccessCard.Visible   = true
		SuccessCard.Position  = UDim2.new(0.5, 0, -0.35, 0)
		TweenService:Create(SuccessCard, TweenInfo.new(0.38, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position = UDim2.new(0.5,0,0.5,0)}):Play()
		-- try game's own success sfx first, fallback to our sound
		local played = false
		pcall(function()
			local sfx = game:GetService("ReplicatedStorage").Sounds.Sfx.Success
			sfx:Play()
			played = true
		end)
		if not played then
			local snd = Instance.new("Sound")
			snd.SoundId = "rbxassetid://89446320629366"
			snd.Volume  = 1
			snd.Parent  = workspace
			snd:Play()
			Debris:AddItem(snd, 10)
		end
		-- gifted label
		if giftedTo and giftedTo ~= "" then
			if CoreGui:FindFirstChild("GiftLabelGUI") then CoreGui.GiftLabelGUI:Destroy() end
			local gGui = Instance.new("ScreenGui")
			gGui.Name           = "GiftLabelGUI"
			gGui.ResetOnSpawn   = false
			gGui.IgnoreGuiInset = true
			gGui.DisplayOrder   = 1000
			gGui.Parent         = CoreGui
			local gLabel = Instance.new("TextLabel", gGui)
			gLabel.Size                   = UDim2.new(1,0,0,40)
			gLabel.AnchorPoint            = Vector2.new(0.5,1)
			gLabel.Position               = UDim2.new(0.5,0,1,-64)
			gLabel.BackgroundTransparency = 1
			gLabel.RichText               = true
			gLabel.Text                   = '<font color="#92FF67">Successfully Gifted To '..giftedTo..'</font>'
			gLabel.Font                   = Enum.Font.GothamBold
			gLabel.TextSize               = 19
			gLabel.TextXAlignment         = Enum.TextXAlignment.Center
			gLabel.ZIndex                 = 5
			task.delay(5, function()
				if not gGui or not gGui.Parent then return end
				for i = 1, 20 do
					task.wait(0.05)
					if gLabel and gLabel.Parent then gLabel.TextTransparency = i/20 end
				end
				pcall(function() gGui:Destroy() end)
			end)
			screenGui.AncestryChanged:Connect(function()
				if not screenGui.Parent then pcall(function() gGui:Destroy() end) end
			end)
		end
	end

	-- slide in card, then start sweep
	local slideTween = TweenService:Create(Card, TweenInfo.new(0.42, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position = UDim2.new(0.5,0,0.5,0)})
	slideTween:Play()
	slideTween.Completed:Connect(function()
		if closing then return end
		fillTween = TweenService:Create(SweepCover, TweenInfo.new(1.5, Enum.EasingStyle.Linear), {Size = UDim2.new(1,0,1,0)})
		fillTween:Play()
		fillTween.Completed:Connect(function(state)
			if state ~= Enum.PlaybackState.Completed or closing then return end
			fillDone = true
			-- sweep done: button is now fully light blue, enable it
			BuyBtn.Active = true
		end)
	end)

	local function onBuyClick()
		if not fillDone or buyDone or closing then return end
		buyDone = true
		BuyBtn.Active = false
		BuyBtn.BackgroundColor3 = C_BTN_DARK
		task.delay(1.5, function()
			if closing then return end
			showSuccess()
		end)
	end

	CloseBtn.MouseButton1Click:Connect(closeDown)
	SCloseBtn.MouseButton1Click:Connect(closeSuccess)
	OKBtn.MouseButton1Click:Connect(closeSuccess)

	BuyBtn.MouseButton1Click:Connect(onBuyClick)
	BuyBtn.InputBegan:Connect(function(inp)
		if inp.UserInputType == Enum.UserInputType.Touch then onBuyClick() end
	end)

	Backdrop.InputBegan:Connect(function(inp)
		if inp.UserInputType == Enum.UserInputType.MouseButton1 then
			if SuccessCard.Visible then closeSuccess() else closeDown() end
		end
	end)
end

-- THEIR INJECTION (untouched)
local function injectItem(item)
	if item:FindFirstChild("__inj") then return end
	local buyObj = item:FindFirstChild("Buy")
	if not buyObj then return end
	local priceLbl    = buyObj:FindFirstChild("Price") or item:FindFirstChild("Price")
	local nameLbl     = item:FindFirstChild("ItemName") or item:FindFirstChild("Text")
	local iconObj     = item:FindFirstChild("Icon")
	local itemName    = (nameLbl  and nameLbl.Text)  or "Unknown"
	local itemPrice   = (priceLbl and priceLbl.Text) or "0"
	local itemImageId = (iconObj  and iconObj.Image) or ""
	local ghost = Instance.new("TextButton", buyObj)
	ghost.Name                   = "GhostBtn"
	ghost.Size                   = UDim2.new(1,0,1,0)
	ghost.Position               = UDim2.new(0,0,0,0)
	ghost.AnchorPoint            = Vector2.new(0,0)
	ghost.BackgroundTransparency = 1
	ghost.Text                   = ""
	ghost.AutoButtonColor        = false
	ghost.BorderSizePixel        = 0
	ghost.ZIndex                 = buyObj.ZIndex + 20
	local tag = Instance.new("BoolValue", item)
	tag.Name = "__inj"
	ghost.MouseButton1Click:Connect(function()
		local snd = Instance.new("Sound", game:GetService("SoundService"))
		snd.SoundId = "rbxassetid://75311202481026"
		snd.Volume = 1
		snd:Play()
		game:GetService("Debris"):AddItem(snd, 5)
		local giftedTo = nil
		pcall(function()
			local giftBtn = Players.LocalPlayer.PlayerGui.Shop.Shop.GiftPlayerSelect.Buttons.GiftButton
			local txt = giftBtn:FindFirstChild("Txt")
			if txt and txt:IsA("TextLabel") then
				if string.lower(txt.Text) == "back" then
					local playerNameLbl = Players.LocalPlayer.PlayerGui.Shop.Shop.GiftPlayerSelect.PlayerSelected.PlayerName
					if playerNameLbl then
						local ct = playerNameLbl:FindFirstChild("ContentText") or playerNameLbl
						giftedTo = ct.Text
					end
				end
			end
		end)
		createBuyUI(itemName, itemPrice, itemImageId, giftedTo)
	end)
end

local function injectContainer(container)
	for _, child in ipairs(container:GetChildren()) do
		if child:IsA("ImageLabel") or child:IsA("Frame") then
			pcall(injectItem, child)
		end
	end
	container.ChildAdded:Connect(function(child)
		task.wait(0.1)
		if child:IsA("ImageLabel") or child:IsA("Frame") then
			pcall(injectItem, child)
		end
	end)
end

local function injectAll()
	local shopGui = playerGui:FindFirstChild(player.DisplayName..".Shop")
		or playerGui:FindFirstChild(player.Name..".Shop")
		or playerGui:FindFirstChild("Shop")
	if not shopGui then return end
	local inner   = shopGui:FindFirstChild("Shop")
	local content = inner   and inner:FindFirstChild("Content")
	local list    = content and content:FindFirstChild("List")
	if not list then return end
	local itemsList = list:FindFirstChild("ItemsList")
	if itemsList then injectContainer(itemsList) end
	local gamepassList = list:FindFirstChild("GamepassList")
	if gamepassList then
		injectContainer(gamepassList)
		local main = gamepassList:FindFirstChild("Main")
		if main then injectContainer(main) end
	end
	local serverLuck = list:FindFirstChild("ServerLuck")
	if serverLuck then
		local slFrame = serverLuck:FindFirstChild("Frame")
		if slFrame then pcall(injectItem, slFrame) end
		serverLuck.ChildAdded:Connect(function(child)
			task.wait(0.1)
			if child.Name == "Frame" then pcall(injectItem, child) end
		end)
	end
end

task.spawn(function()
	local names = {player.DisplayName..".Shop", player.Name..".Shop", "Shop"}
	local found, waited = false, 0
	repeat
		task.wait(0.5); waited += 0.5
		for _, n in ipairs(names) do
			if playerGui:FindFirstChild(n) then found = true; break end
		end
	until found or waited >= 20
	if not found then return end
	task.wait(0.3)
	injectAll()
end)
