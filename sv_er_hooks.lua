--[[
Copyright [2019] [Kujoen - https://github.com/Kujoen]

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
]]
----------------------------------------------------------------------------------------------------------|
--                                                                                                        |
--                                          VEHICLE                                                       |
--                                                                                                        |
----------------------------------------------------------------------------------------------------------|

local function er_vehiclecheck(ply, vhcl, rle) 
    --Check if associated restriction file exists
    local playerSteamID = string.Replace(tostring(ply:SteamID()), ":", "_")
    local fileName = "entityrestrictor/"..playerSteamID.."_A.txt"

    if file.Exists(fileName, "DATA") then 
        local restrictionDataRaw = file.Read(fileName, "DATA")
        local restrictionData = string.Split(restrictionDataRaw, "_")

        local restrictionTimeStamp = restrictionData[1]
        local restrictionLength = restrictionData[2]
        local restrictionAuthor = restrictionData[3]
        local restrictionReason = restrictionData[4]
        local requestedVehicle = vhcl:GetVehicleClass() 

        -- CHECK IF BAN HAS EXPIRED
        local currentTimeStamp = os.time()
        if restrictionTimeStamp + restrictionLength < currentTimeStamp then 
            file.Delete(fileName)
            return true 
        end 

        -- CHECK IF VEHICLE IS ILLEGAL
        if isBanAllVehicles then
            if restrictionReason != nil then
                ply:PrintMessage(HUD_PRINTCENTER, "You have been restricted from using this vehicle by "..restrictionAuthor.."\nRestriction lifted in "..(restrictionLength/3600).." hours\nRestriction reason: "..restrictionReason)
            else 
                ply:PrintMessage(HUD_PRINTCENTER, "You have been restricted from using this vehicle by "..restrictionAuthor.."\nRestriction lifted in "..(restrictionLength/3600).." hours")
            end
             
             return false
        else
            local isRestricted = false

            for k, v in pairs(bannedVehicles) do
                if v == requestedVehicle then 
                    isRestricted = true 
                end
            end

            if isRestricted then
                if restrictionReason != nil then
                    ply:PrintMessage(HUD_PRINTCENTER, "You have been restricted from using this vehicle by "..restrictionAuthor.."\nRestriction lifted in "..(restrictionLength/3600).." hours\nRestriction reason: "..restrictionReason)
                else 
                    ply:PrintMessage(HUD_PRINTCENTER, "You have been restricted from using this vehicle by "..restrictionAuthor.."\nRestriction lifted in "..(restrictionLength/3600).." hours")
                end
                return false
            else
                return true
            end
        end

    else  
        return true    
    end  
end

hook.Add("CanPlayerEnterVehicle", "er_vehiclecheck", er_vehiclecheck)
----------------------------------------------------------------------------------------------------------|
--                                                                                                        |
--                                          WEAPONS                                                       |
--                                                                                                        |
----------------------------------------------------------------------------------------------------------|

function er_weaponcheck(ply, wep)
    --Check if associated restriction file exists
    local playerSteamID = string.Replace(tostring(ply:SteamID()), ":", "_")
    local fileName = "entityrestrictor/"..playerSteamID.."_W.txt"

    if file.Exists(fileName, "DATA") then 
        local restrictionDataRaw = file.Read(fileName, "DATA")
        local restrictionData = string.Split(restrictionDataRaw, "_")

        local restrictionTimeStamp = restrictionData[1]
        local restrictionLength = restrictionData[2]
        local restrictionAuthor = restrictionData[3]
        local restrictionReason = restrictionData[4]
        local requestedWeapon = wep:GetClass()

        -- CHECK IF BAN HAS EXPIRED
        local currentTimeStamp = os.time()
        if restrictionTimeStamp + restrictionLength < currentTimeStamp then 
            file.Delete(fileName)
            return er_toolcheck(ply, wep)   
        end 

        -- CHECK IF WEAPON IS ILLEGAL
        if isBanAllWeapons then
            if restrictionReason != nil then
                ply:PrintMessage(HUD_PRINTCENTER, "You have been restricted from using this weapon by "..restrictionAuthor.."\nRestriction lifted in "..(restrictionLength/3600).." hours\nRestriction reason: "..restrictionReason)
            else 
                ply:PrintMessage(HUD_PRINTCENTER, "You have been restricted from using this weapon by "..restrictionAuthor.."\nRestriction lifted in "..(restrictionLength/3600).." hours")
            end
             
             return false
        else
            local isRestricted = false

            for k, v in pairs(bannedWeapons) do
                if v == requestedWeapon then 
                    isRestricted = true 
                end
            end

            if isRestricted then
                if restrictionReason != nil then
                    ply:PrintMessage(HUD_PRINTCENTER, "You have been restricted from using this weapon by "..restrictionAuthor.."\nRestriction lifted in "..(restrictionLength/3600).." hours\nRestriction reason: "..restrictionReason)
                else 
                    ply:PrintMessage(HUD_PRINTCENTER, "You have been restricted from using this weapon by "..restrictionAuthor.."\nRestriction lifted in "..(restrictionLength/3600).." hours")
                end
                return false
            else
                return er_toolcheck(ply, wep)
            end
        end
    else  
        return er_toolcheck(ply, wep)   
    end  
end

hook.Add("PlayerCanPickupWeapon", "er_weaponcheck", er_weaponcheck)
----------------------------------------------------------------------------------------------------------|
--                                                                                                        |
--                                          BUILDTOOLS                                                    |
--                                                                                                        |
----------------------------------------------------------------------------------------------------------|

-- This check is not hooked into a function, but called by weapon_check if no issues were found there

function er_toolcheck(ply, wep)
    --Check if associated restriction file exists
    local playerSteamID = string.Replace(tostring(ply:SteamID()), ":", "_")
    local fileName = "entityrestrictor/"..playerSteamID.."_B.txt"

    if file.Exists(fileName, "DATA") then 
        local restrictionDataRaw = file.Read(fileName, "DATA")
        local restrictionData = string.Split(restrictionDataRaw, "_")

        local restrictionTimeStamp = restrictionData[1]
        local restrictionLength = restrictionData[2]
        local restrictionAuthor = restrictionData[3]
        local restrictionReason = restrictionData[4]
        local requestedWeapon = wep:GetClass() 

        -- CHECK IF BAN HAS EXPIRED
        local currentTimeStamp = os.time()
        if restrictionTimeStamp + restrictionLength < currentTimeStamp then 
            file.Delete(fileName)
            return true 
        end 

        -- CHECK IF RESTRICTED TOOL
        local gravGunName = "weapon_physcannon"
        local physGunName = "weapon_physgun"
        local toolGunName = "gmod_tool"

        local isRestricted = false

        if wep:GetClass() == gravGunName && isRestrictGravityGun == true then 
            isRestricted = true
        end

        if wep:GetClass() == physGunName && isRestrictPhysicsGun == true then 
            isRestricted = true
        end 

        if wep:GetClass() == toolGunName && isRestrictToolGun == true then 
            isRestricted = true
        end

        if isRestricted then
            if restrictionReason != nil then
                ply:PrintMessage(HUD_PRINTCENTER, "You have been restricted from using this tool by "..restrictionAuthor.."\nRestriction lifted in "..(restrictionLength/3600).." hours\nRestriction reason: "..restrictionReason)
            else 
                ply:PrintMessage(HUD_PRINTCENTER, "You have been restricted from using this tool by "..restrictionAuthor.."\nRestriction lifted in "..(restrictionLength/3600).." hours")
            end
            return false
        else
            return true
        end
    
    else  
        return true    
    end  
end

----------------------------------------------------------------------------------------------------------|
----------------------------------------------------------------------------------------------------------|

