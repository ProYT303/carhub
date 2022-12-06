
    local mt = getrawmetatable(game)
    setreadonly(mt,false)
    
    local namecall = mt.__namecall
    
    mt.__namecall = newcclosure(function(self, ...)
        local method = getnamecallmethod()
        local args = {...}
    
        if method == "FireServer" and tostring(self) == "RemoteEvent" then
           return
        end
        return namecall(self, table.unpack(args))
    end)
    setreadonly(mt,true)
    
    
    
    local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
    local Window = Library.CreateLib("Ultimate Driving", "BloodTheme")
    local Tab = Window:NewTab("Driving")
    local Section = Tab:NewSection("Driving")
    
    
    function SendNotification(Title, Message, Duration)
        game.StarterGui:SetCore("SendNotification", {
            Title = Title;
            Text = Message;
            Duration = Duration;
        })
    end
    Section:NewKeybind("KeybindText", "KeybindInfo", Enum.KeyCode.F, function()
        Library:ToggleUI()
    end)
    
    Section:NewToggle("Anti AFK", nil, function (s)
        local VirtualUser = game:GetService("VirtualUser")
        local Camera = workspace.CurrentCamera
    
        AntiAFK = s
        if AntiAFK then
            game.Players.LocalPlayer.Idled:Connect(function()
                game:GetService("VirtualUser")VirtualUser:CaptureController()
                VirtualUser:ClickButton2(Vector2.new(), Camera.CFrame)
            end)
             
        end
    end)
    Section:NewButton("Set current vehicle as default",nil,function()
        if not GetCurrentVehicle() then return SendNotification("Error","Spawn a vehicle first.",5) end
        getgenv().cartospawn = GetCurrentVehicle().Name
    end)
    Section:NewButton("Rejoin",nil,function(s)
        game:GetService('TeleportService'):Teleport(game.PlaceId, game.Players.LocalPlayer)
    end)
    function GetCurrentVehicle()
        for I,V in pairs(workspace._Main.Vehicles:GetChildren()) do
            if V:FindFirstChild("VehicleSeat") and V.VehicleSeat:FindFirstChild("Values") and V.VehicleSeat.Values:FindFirstChild("Owner") and  (V.VehicleSeat.Values.Owner.Value == game.Players.LocalPlayer.Name) then
                return V
            end
        end
    end
    function Respawn()
        if not getgenv().cartospawn then 
            return SendNotification("No car!","Select a car to spawn first using button",5) 
        end
        game:GetService("VirtualInputManager"):SendKeyEvent(true, 32, false, game)
        wait()
        game:GetService("VirtualInputManager"):SendKeyEvent(false, 32, false, game)
        
        game:GetService("ReplicatedStorage").Events.RemoteFunction:InvokeServer(unpack({
        [1] = "VehicleSpawn",
        [2] = {
            [1] = getgenv().cartospawn,
            [2] = game.Workspace._Main.VehicleShops.VehicleShop,
            [3] = false,
            [4] = false
        }
        })) 
        repeat wait() until GetCurrentVehicle() ~= nil
    end
    function VehicleTP(cframe)
        if GetCurrentVehicle() then 
            GetCurrentVehicle():SetPrimaryPartCFrame(cframe)
        else
           game.Players.LocalPlayer.Character:SetPrimaryPartCFrame(cframe) 
        end
    end
    function VelocityTP(cframe)
        local LocalPlayer = game.Players.LocalPlayer
        local Speed = (getgenv().Speed or 300)
        local Car = GetCurrentVehicle() 
        if not Car then return end
        local BodyGyro = Instance.new("BodyGyro",Car.PrimaryPart)
        BodyGyro.P = 1000
        BodyGyro.maxTorque = Vector3.new(9e9, 9e9, 9e9)
        BodyGyro.CFrame = Car.PrimaryPart.CFrame
        
        BodyVelocity = Instance.new("BodyVelocity", LocalPlayer.Character.HumanoidRootPart)
        BodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
    
        wait(0.1)
        Distance = (Car.PrimaryPart.Position - (cframe).p).Magnitude
        BodyVelocity.Velocity = CFrame.new(Car.PrimaryPart.Position, (cframe ).p).LookVector * Speed
    
        wait(Distance/Speed)
    
        BodyVelocity.Velocity = Vector3.new()
        wait(0.1)
        BodyVelocity:Destroy()
        BodyGyro:Destroy()
    end
    FarmPlaces = {
        [1] = {
            StartPos = CFrame.new(-9113.83789, 9.37722445, -7000.82666, -0.368603766, -1.75668404e-08, 0.929586589, 5.60597901e-10, 1, 1.91197671e-08, -0.929586589, 7.56874297e-09, -0.368603766),
            EndPos = CFrame.new(-15309.6201, 9.37722445, -4552.87939, -0.351125032, -7.00329963e-08, 0.93632859, -1.5823117e-08, 1, 6.88616169e-08, -0.93632859, 9.36340161e-09, -0.351125032)
        },
       [2] = {
            StartPos = CFrame.new(232.457626, 10.7724384, 2032.0968, 0.999996483, 0.000157465707, -0.00265269959, -9.75369985e-05, 0.999745131, 0.022576591, 0.00265557854, -0.022576252, 0.999741614),
            EndPos = CFrame.new(209.802536, 10.3724384, 688.682068, 0.999995053, 1.67621947e-05, 0.00314667937, 7.16562909e-06, 0.999971092, -0.00760398526, -0.00314671593, 0.00760397036, 0.999966145)
        },
       [3]= {
            StartPos = CFrame.new(-529.200989, 10.7979555, 12114.5547, 0.981197476, -2.37987958e-08, -0.193006411, -1.73531559e-13, 1, -1.23306606e-07, 0.193006411, 1.20988162e-07, 0.981197476),
            EndPos = CFrame.new(-377.006226, 10.9987574, 11207.2549, 0.985055208, 2.01745785e-08, -0.172238946, 9.90898509e-12, 1, 1.17188016e-07, 0.172238946, -1.15438368e-07, 0.985055208)
        },
    }
    
    AutofarmFunc = coroutine.create(function()
        while wait() do 
            for i = 1, 50 do 
                getgenv().daone = FarmPlaces[math.random(1,#FarmPlaces)]
                if not getgenv().aftoggle then coroutine.yield() end  
                VehicleTP(getgenv().daone.StartPos)
                wait(0.5)
                if not getgenv().aftoggle then coroutine.yield() end  
                VelocityTP(getgenv().daone.EndPos)
                wait(0.5)
                if not getgenv().aftoggle then coroutine.yield() end  
                VehicleTP(getgenv().daone.EndPos)
                wait(0.5)
                if not getgenv().aftoggle then coroutine.yield() end  
                VelocityTP(getgenv().daone.StartPos)
                wait(0.5)
            end
                wait()
                Respawn() 
        end
    end)
    Section:NewToggle("Autofarm",nil,function(s)
       getgenv().aftoggle = s;
        if getgenv().aftoggle then 
           coroutine.resume(AutofarmFunc)
           coroutine.resume(AutoRespawn)
        end
    end)
    Section:NewSlider("Speed",nil,10,1,function(s)
        getgenv().Speed = (s * 100)    
    end)
    Section:NewButton("Refuel",nil,function()
       GetCurrentVehicle().VehicleSeat.Values.Gas.Value = 10000 
    end)
    Section:NewSlider("Boost",nil,200,0,function(s)
        GetCurrentVehicle().VehicleSeat.BoostForce.Force = Vector3.new(0,0,tonumber(s))
    end)
    Section:NewButton("Spawn/Respawn Car",nil,function()
        Respawn() 
    end)
    local TruckerTab = Window:NewTab("Trucker")
    local TruckerSection = TruckerTab:NewSection("Trucker")
    TruckerSection:NewButton("Switch to trucker",nil,function()
            game:GetService("ReplicatedStorage").Events.Admin.ChangeTeam:InvokeServer("Trucker")
    end)
    
    function GetTeleportModel()
        local LocalPlayer = game.Players.LocalPlayer
        if LocalPlayer.Values.References.CarSeat.Value then
            return LocalPlayer.Values.References.CarSeat.Value.Parent
        end
        return LocalPlayer.Character
    end
    function TP(cframe)
        local c = workspace.Gravity
        workspace.Gravity = 50
        Car = GetTeleportModel()
        for i,v in pairs(Car:GetDescendants()) do 
            if v.ClassName == "Part" then 
                v.Anchored = true
            end
            if not v:IsDescendantOf(Car.Wheels) and v.ClassName == "Part" then 
                v.CanCollide = false
            end
        end
        Car:SetPrimaryPartCFrame(cframe)
        wait()
        for i,v in pairs(Car:GetDescendants()) do 
            if v.ClassName == "Part" then 
                v.Anchored = false
            end
        end
        wait(1)
        workspace.Gravity = c
    
    end
    function tween(cframe)
        local LocalPlayer = game.Players.LocalPlayer
        BodyVelocity = Instance.new("BodyVelocity", LocalPlayer.Character.HumanoidRootPart)
        BodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
        local BodyGyro = Instance.new("BodyGyro", LocalPlayer.Character.HumanoidRootPart)
        BodyGyro.P = 1000
        BodyGyro.maxTorque = Vector3.new(9e9, 9e9, 9e9)
        BodyGyro.CFrame = GetCurrentVehicle().PrimaryPart.CFrame
        GetTeleportModel():SetPrimaryPartCFrame( CFrame.new(GetCurrentVehicle().PrimaryPart.Position.X,GetCurrentVehicle().PrimaryPart.Position.Y + 500,GetCurrentVehicle().PrimaryPart.Position.Z))
        wait(0.1)
        Distance = (GetCurrentVehicle().PrimaryPart.Position - (CFrame.new(cframe.X,cframe.Y+500,cframe.Z).p)).Magnitude
        BodyVelocity.Velocity = CFrame.new(GetTeleportModel().PrimaryPart.Position, (CFrame.new(cframe.X,cframe.Y+500,cframe.Z)).p).LookVector * 170
    
        wait(Distance/170)
        BodyVelocity.Velocity = Vector3.new()
        wait(0.1)
        BodyVelocity:Destroy()
        BodyGyro:Destroy()
        TP(cframe)
    end
    function GetTruckSpawn()
        for i,v in pairs(game:GetService("Workspace")["_Main"].VehicleShops:GetChildren()) do 
            if v.Type.Value == "Trucker" then   
                return v 
            end
        end
    end
    --[[
    TruckerSection:NewButton("Spawn Nuke truck(MUST OWN)",nil,function()
        game.ReplicatedStorage.Events.RemoteFunction:InvokeServer(unpack({
            [1] = "VehicleSpawn",
            [2] = {
                [1] = "NukeTruck",
                [2] = GetTruckSpawn(),
                [3] = false,
                [4] = false
            }
        }))
        
    end)]]
    TruckerSection:NewButton("Spawn Box Truck",nil,function()
            game.ReplicatedStorage.Events.RemoteFunction:InvokeServer(unpack({
            [1] = "VehicleSpawn",
            [2] = {
                [1] = "BoxTruck",
                [2] = GetTruckSpawn(),
                [3] = false,
                [4] = false
            }
        }))
    end)
    local label = TruckerSection:NewLabel("Amount of jobs(box truck)(updates every 5s)")
    spawn(function()
        while wait(5) do 
               local jobs = {};
            for i,v in pairs(game.Players.LocalPlayer.Quests.Trucker.Available:GetChildren()) do 
                local v96, v97 = require(game.ReplicatedStorage.Modules.VerifyQuestAvailability)(game.Players.LocalPlayer, "Trucker", "Client", v.Good.Type.Value);
                local v98 = require(game.ReplicatedStorage.ResourceLibrary.Tables.CargoData)
                if v96 == false and v98[1][v.Good.Type.Value][10] == "Box" and v98[1][v.Good.Type.Value][8] == "General"  then 
                   table.insert(jobs,v) 
                end
            end
            label:UpdateLabel("Box truck jobs: " .. tostring(#jobs))
        end
    end)
    
    BoxTruckFarm = coroutine.create(function()
    while wait() do 
        print("Running truck farm")
        if not getgenv().boxtruckfarm then coroutine.yield() end 
            print("Running truck farm 2x")
    
               local jobs = {};
            
            for i,v in pairs(game.Players.LocalPlayer.Quests.Trucker.Available:GetChildren()) do 
                local v96, v97 = require(game.ReplicatedStorage.Modules.VerifyQuestAvailability)(game.Players.LocalPlayer, "Trucker", "Client", v.Good.Type.Value);
                local v98 = require(game.ReplicatedStorage.ResourceLibrary.Tables.CargoData)
                if v96 == false and v98[1][v.Good.Type.Value][10] == "Box" and v98[1][v.Good.Type.Value][8] == "General"  then 
                   table.insert(jobs,v) 
                end
            end
        game:GetService("ReplicatedStorage").Events.RemoteFunction:InvokeServer(unpack({
            [1] = "TruckShipping",
            [2] = {
                [1] = "StartQuest",
                [2] = jobs[math.random(1,#jobs)]
            }
        }))
        wait()
            TP(game.Workspace.NavigationBeam.Locator.CFrame * CFrame.new(-30, 10, 0) * CFrame.Angles(0, math.rad(90), 0))
            wait(3)
        game:GetService("ReplicatedStorage").Events.RemoteFunction:InvokeServer(unpack({
            [1] = "TruckShipping",
            [2] = {
                [1] = "LoadTruck"
            }
        }))
        wait()
                tween(game.Workspace.NavigationBeam.Locator.CFrame * CFrame.new(-30, 10, 0) * CFrame.Angles(0, math.rad(90), 0))
        wait(3)
        game:GetService("ReplicatedStorage").Events.RemoteFunction:InvokeServer(unpack({
            [1] = "TruckShipping",
            [2] = {
                [1] = "UnloadTruck"
            }
        }))
        wait(1)
        game.Players.LocalPlayer.PlayerGui.Trucking.CargoDelivered.Visible = false
    end
    end)
    
    TruckerSection:NewToggle("Box Truck Farm (Can only use the starter box truck)",nil,function(s)
        getgenv().boxtruckfarm = s
        if getgenv().boxtruckfarm then 
            coroutine.resume(BoxTruckFarm)
        end
    end)
    --[[
    
    NukeJob = coroutine.create(function()
    while wait() do 
        print("Running nuke truck farm")
        if not getgenv().nukejob then coroutine.yield() end 
        print("Running truck farm 2x")
    
        function GetNukeJob()
            for i,v in pairs(game.Players.LocalPlayer.Quests.Trucker.Available:GetChildren()) do 
                if v.Good.Type.Value == "Missile" then 
                   return v
                end
            end
        end
        if not GetNukeJob() then return SendNotification("Error","No nuke jobs found",5) end 
        game:GetService("ReplicatedStorage").Events.RemoteFunction:InvokeServer(unpack({
        [1] = "TruckShipping",
        [2] = {
            [1] = "StartQuest",
            [2] = GetNukeJob()
        }
        }))
        wait(1)
        TP(game.Workspace.NavigationBeam.Locator.CFrame * CFrame.new(-100, 0, 30) * CFrame.Angles(0, math.rad(100),0))
        wait(4)
        game:GetService("ReplicatedStorage").Events.RemoteFunction:InvokeServer(unpack({
            [1] = "TruckShipping",
            [2] = {
                [1] = "LoadTruck"
            }
        }))
        wait(1)
        tween(game.Workspace.NavigationBeam.Locator.CFrame * CFrame.new(0, 0, -80))
        wait(4)
        game:GetService("ReplicatedStorage").Events.RemoteFunction:InvokeServer(unpack({
            [1] = "TruckShipping",
            [2] = {
                [1] = "UnloadTruck"
            }
        }))
        wait(1)
    end
    end)
    TruckerSection:NewToggle("Auto Nuke Job(Require nuke truck)",nil,function(s)
        getgenv().nukejob = s
        if getgenv().nukejob then 
           coroutine.resume(NukeJob) 
        end
    end)
    
]]
    
