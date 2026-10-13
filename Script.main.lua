-- Hapus GUI lama jika sudah ada agar tidak menumpuk
local oldGui = game.CoreGui:FindFirstChild("AutoFollowCustomUI")
if oldGui then oldGui:Destroy() end

-- Mempersiapkan Layanan Roblox
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local localPlayer = Players.LocalPlayer

-- Membuat Interface ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AutoFollowCustomUI"
ScreenGui.Parent = game.CoreGui
ScreenGui.ResetOnSpawn = false

-- Panel Utama Menu
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 260, 0, 220)
MainFrame.Position = UDim2.new(0.1, 0, 0.3, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 10)
Corner.Parent = MainFrame

-- Judul Menu
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Text = "AUTO COMPANION PRO"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.BackgroundColor3 = Color3.fromRGB(50, 50, 65)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 16
Title.Parent = MainFrame
local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 10)
TitleCorner.Parent = Title

-- Tombol Pemilih Target (Dropdown Trigger)
local DropdownBtn = Instance.new("TextButton")
DropdownBtn.Size = UDim2.new(0, 220, 0, 35)
DropdownBtn.Position = UDim2.new(0, 20, 0, 45)
DropdownBtn.Text = "PILIH TARGET: [Belum Ada]"
DropdownBtn.BackgroundColor3 = Color3.fromRGB(55, 55, 70)
DropdownBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
DropdownBtn.Font = Enum.Font.SourceSansBold
DropdownBtn.TextSize = 14
DropdownBtn.Parent = MainFrame
local DropCorner = Instance.new("UICorner")
DropCorner.CornerRadius = UDim.new(0, 5)
DropCorner.Parent = DropdownBtn

-- Kontainer List Nama (Scrolling Frame)
local DropdownScroll = Instance.new("ScrollingFrame")
DropdownScroll.Size = UDim2.new(0, 220, 0, 120)
DropdownScroll.Position = UDim2.new(0, 20, 0, 80)
DropdownScroll.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
DropdownScroll.Visible = false
DropdownScroll.ZIndex = 5
DropdownScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
DropdownScroll.ScrollBarThickness = 6
DropdownScroll.Parent = MainFrame
local ScrollCorner = Instance.new("UICorner")
ScrollCorner.CornerRadius = UDim.new(0, 5)
ScrollCorner.Parent = DropdownScroll

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Parent = DropdownScroll
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- Tombol Pengatur Speed (-)
local BtnMinus = Instance.new("TextButton")
BtnMinus.Size = UDim2.new(0, 40, 0, 30)
BtnMinus.Position = UDim2.new(0, 20, 0, 95)
BtnMinus.Text = "-"
BtnMinus.BackgroundColor3 = Color3.fromRGB(70, 70, 85)
BtnMinus.TextColor3 = Color3.fromRGB(255, 255, 255)
BtnMinus.TextSize = 20
BtnMinus.Parent = MainFrame

-- Indikator Speed
local SpeedLabel = Instance.new("TextLabel")
SpeedLabel.Size = UDim2.new(0, 140, 0, 30)
SpeedLabel.Position = UDim2.new(0, 60, 0, 95)
SpeedLabel.Text = "Speed: 16"
SpeedLabel.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
SpeedLabel.TextColor3 = Color3.fromRGB(0, 255, 150)
SpeedLabel.Font = Enum.Font.SourceSansBold
SpeedLabel.TextSize = 16
SpeedLabel.Parent = MainFrame

-- Tombol Pengatur Speed (+)
local BtnPlus = Instance.new("TextButton")
BtnPlus.Size = UDim2.new(0, 40, 0, 30)
BtnPlus.Position = UDim2.new(0, 200, 0, 95)
BtnPlus.Text = "+"
BtnPlus.BackgroundColor3 = Color3.fromRGB(70, 70, 85)
BtnPlus.TextColor3 = Color3.fromRGB(255, 255, 255)
BtnPlus.TextSize = 20
BtnPlus.Parent = MainFrame

-- Tombol Utama PLAY / STOP
local BtnToggle = Instance.new("TextButton")
BtnToggle.Size = UDim2.new(0, 220, 0, 40)
BtnToggle.Position = UDim2.new(0, 20, 0, 145)
BtnToggle.Text = "AUTO START (PLAY)"
BtnToggle.BackgroundColor3 = Color3.fromRGB(0, 180, 100)
BtnToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
BtnToggle.Font = Enum.Font.SourceSansBold
BtnToggle.TextSize = 18
BtnToggle.Parent = MainFrame
local BtnCorner = Instance.new("UICorner")
BtnCorner.CornerRadius = UDim.new(0, 8)
BtnCorner.Parent = BtnToggle

---------------------------------------------------------
-- SISTEM DROPDOWN & LOGIKA AUTOMATIS
---------------------------------------------------------
local targetPlayer = nil
local isFollowing = false
local currentSpeed = 16

-- Fungsi memperbarui daftar nama pemain di server
local function updateDropdown()
    -- Bersihkan daftar lama
    for _, child in ipairs(DropdownScroll:GetChildren()) do
        if child:IsA("TextButton") then child:Destroy() end
    end
    
    local count = 0
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= localPlayer then
            count = count + 1
            local PBtn = Instance.new("TextButton")
            PBtn.Size = UDim2.new(1, 0, 0, 30)
            PBtn.Text = p.DisplayName .. " (@" .. p.Name .. ")"
            PBtn.BackgroundColor3 = Color3.fromRGB(55, 55, 65)
            PBtn.TextColor3 = Color3.fromRGB(230, 230, 230)
            PBtn.Font = Enum.Font.SourceSans
            PBtn.TextSize = 14
            PBtn.ZIndex = 6
            PBtn.Parent = DropdownScroll
            
            PBtn.MouseButton1Click:Connect(function()
                targetPlayer = p
                DropdownBtn.Text = "TARGET: " .. p.DisplayName
                DropdownScroll.Visible = false
            end)
        end
    end
    DropdownScroll.CanvasSize = UDim2.new(0, 0, 0, count * 30)
end

-- Buka/tutup Dropdown saat ditekan
DropdownBtn.MouseButton1Click:Connect(function()
    DropdownScroll.Visible = not DropdownScroll.Visible
    if DropdownScroll.Visible then updateDropdown() end
end)

-- Update otomatis list jika ada orang masuk/keluar game
Players.PlayerAdded:Connect(updateDropdown)
Players.PlayerRemoving:Connect(function(p)
    if targetPlayer == p then
        targetPlayer = nil
        DropdownBtn.Text = "PILIH TARGET: [Belum Ada]"
        isFollowing = false
        BtnToggle.Text = "AUTO START (PLAY)"
        BtnToggle.BackgroundColor3 = Color3.fromRGB(0, 180, 100)
    end
    updateDropdown()
end)

-- Tombol Speed (+/-)
BtnPlus.MouseButton1Click:Connect(function()
    currentSpeed = math.min(currentSpeed + 5, 120)
    SpeedLabel.Text = "Speed: " .. tostring(currentSpeed)
end)

BtnMinus.MouseButton1Click:Connect(function()
    currentSpeed = math.max(currentSpeed - 5, 0)
    SpeedLabel.Text = "Speed: " .. tostring(currentSpeed)
end)

-- Tombol PLAY / STOP
BtnToggle.MouseButton1Click:Connect(function()
    if not targetPlayer then
        DropdownBtn.Text = "PILIH NAMA DULU!"
        return
    end
    
    isFollowing = not isFollowing
    if isFollowing then
        BtnToggle.Text = "AUTO STOP"
        BtnToggle.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
    else
        BtnToggle.Text = "AUTO START (PLAY)"
        BtnToggle.BackgroundColor3 = Color3.fromRGB(0, 180, 100)
        if localPlayer.Character and localPlayer.Character:FindFirstChildOfClass("Humanoid") then
            localPlayer.Character:FindFirstChildOfClass("Humanoid"):Move(Vector3.new(0, 0, 0))
        end
    end
end)

-- Loop Deteksi Jalan & Sistem Auto Jump Menggunakan Heartbeat (Lebih Responsif)
RunService.Heartbeat:Connect(function()
    if not isFollowing or not targetPlayer then return end
    
    local myChar = localPlayer.Character
    local targetChar = targetPlayer.Character
    
    if myChar and targetChar and myChar:FindFirstChild("HumanoidRootPart") and targetChar:FindFirstChild("HumanoidRootPart") then
        local myHRP = myChar.HumanoidRootPart
        local targetHRP = targetChar.HumanoidRootPart
        local humanoid = myChar:FindFirstChildOfClass("Humanoid")
        
        if humanoid and humanoid.Health > 0 then
            humanoid.WalkSpeed = currentSpeed
            
            -- Gerakkan karakter ke arah target
            humanoid:MoveTo(targetHRP.Position)
            
            -- SISTEM AUTO JUMP:
            -- 1. Cek perbedaan ketinggian vertikal (Sumbu Y)
            if (targetHRP.Position.Y - myHRP.Position.Y) > 2.5 then
                humanoid.Jump = true
            end
            
            -- 2. Raycasting untuk mendeteksi tembok/rintangan tepat di depan kaki
            local raycastParams = RaycastParams.new()
            raycastParams.FilterInstanceKind = Enum.RaycastFilterType.Exclude
            raycastParams.FilterDescendantsInstances = {myChar}
            
            -- Tembakkan sinar ke arah depan sejauh 3.5 stud
            local rayDirection = myHRP.CFrame.LookVector * 3.5
            local raycastResult = workspace:Raycast(myHRP.Position - Vector3.new(0, 1.5, 0), rayDirection, raycastParams)
            
            if raycastResult then
                humanoid.Jump = true
            end
        end
    end
end)

-- Inisialisasi daftar nama saat script pertama kali dijalankan
updateDropdown()
