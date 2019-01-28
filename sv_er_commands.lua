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
--                                          MAIN  HOOK                                                    |
--                                                                                                        |
----------------------------------------------------------------------------------------------------------|

--Command has form: /restrict [P] A/W/B [Z] | reason
local function er_commandhook(ply, message, team)

    -- PERMISSIONS ---------------------------------------------------------|
    local hasPermissions = false

    if (isAllowAdmin == true and ply:IsAdmin()) then
        hasPermissions = true
    end
    
    if ply:IsSuperAdmin() then 
        hasPermissions = true
    end
    ------------------------------------------------------------------------|


    if hasPermissions == true then 
        
        -- Jump out if not restriction command
        local i = string.find(message, "/restrict")

        if i != nil then 

            -- INIT ----------------------------------------------------------|
            local hasReason = false

            local fullCommand = string.Split(message, "|")

            local restrictionReason = fullCommand[2]

            local restrictionCommands = string.Split(fullCommand[1], " ")

            local commandKeyword = restrictionCommands[1]
            local targetPlayerId = restrictionCommands[2]
            local restrictionTypes = restrictionCommands[3]
            local restrictionLength = restrictionCommands[4] 
            ------------------------------------------------------------------|

            -- Check for restriction reason, it doesn't have to be set
            if isValidMessageSegment(restrictionReason) then
                hasReason = true
            end 

            if commandKeyword == "/restrict" then

                if isValidMessageSegment(targetPlayerId) then 

                    local plyToRestrict

                    for k ,v in pairs(player.GetAll()) do
                        if (v:UserID() == tonumber(targetPlayerId)) then 
                            plyToRestrict = v   
                        end
                    end

                    if plyToRestrict != nil then 

                        if isValidMessageSegment(tonumber(restrictionLength)) then
                            -- Convert into seconds
                            restrictionLength = tonumber(restrictionLength) * 3600

                            if isValidMessageSegment(restrictionTypes) then 
                                local timeStamp = os.time()
                                
                                -- Vehicles
                                if string.find(restrictionTypes, "A") then 
                                    restrictVehicles(ply, plyToRestrict, restrictionLength, timeStamp, hasReason, restrictionReason)
                                end 

                                -- Weapons 
                                if string.find(restrictionTypes, "W") then 
                                    restrictWeapons(ply, plyToRestrict, restrictionLength, timeStamp, hasReason, restrictionReason)
                                end 

                                --BuildTools
                                if string.find(restrictionTypes, "B") then 
                                    restrictBuildtools(ply, plyToRestrict, restrictionLength, timeStamp, hasReason, restrictionReason)
                                end 
                            end 
                        end 
                    end 
                end
            end 
        end
    end 
end

hook.Add("PlayerSay", "er_commandhook", er_commandhook)

----------------------------------------------------------------------------------------------------------|
----------------------------------------------------------------------------------------------------------|

function isValidMessageSegment(messageSegment)
    if (messageSegment != nil && messageSegment != '') then 
        return true
    else 
        return false 
    end
end

----------------------------------------------------------------------------------------------------------|
--                                                                                                        |  
-- RESTRICTION HANDLING                                                                                   |
-- Restrictions saved as: timestamp_length_adminNick_reason                                               |  
----------------------------------------------------------------------------------------------------------|

function restrictVehicles(admin, targetPly, restrictionLength, curTimeStamp, hasReason, reason)
    initializeRestriction(admin, targetPly, restrictionLength, curTimeStamp, hasReason, reason, "vehicles", "A")

    -- KICK PLAYER OUT OF ANY CURRENT VEHICLES
    if targetPly:InVehicle() then 
        targetPly:ExitVehicle()
    end
end

function restrictWeapons(admin, targetPly, restrictionLength, curTimeStamp, hasReason, reason)
    initializeRestriction(admin, targetPly, restrictionLength, curTimeStamp, hasReason, reason, "weapons", "W")

    -- REMOVE WEAPON FROM INVENTORY
    if isBanAllWeapons then 
        for k, v in pairs(targetPly:GetWeapons()) do
            v:Remove()
        end
    else 
        for kbWep, bWep in pairs(bannedWeapons) do
            for kWep, wep in pairs(targetPly:GetWeapons()) do
                if wep:GetClass() == bWep then 
                    wep:Remove()
                end
            end
        end
    end
end

function restrictBuildtools(admin, targetPly, restrictionLength, curTimeStamp, hasReason, reason)
    initializeRestriction(admin, targetPly, restrictionLength, curTimeStamp, hasReason, reason, "Tools", "B")

    local gravGunName = "weapon_physcannon"
    local physGunName = "weapon_physgun"
    local toolGunName = "gmod_tool"

    -- REMOVE TOOLS FROM INVENTORY
    for kWep, wep in pairs(targetPly:GetWeapons()) do
        if wep:GetClass() == gravGunName && isRestrictGravityGun == true then 
            wep:Remove()
        end

        if wep:GetClass() == physGunName && isRestrictPhysicsGun == true then 
            wep:Remove()
        end 

        if wep:GetClass() == toolGunName && isRestrictToolGun == true then 
            wep:Remove()
        end
    end
end

----------------------------------------------------------------------------------------------------------|
----------------------------------------------------------------------------------------------------------|

function initializeRestriction(admin, targetPly, restrictionLength, curTimeStamp, hasReason, reason, type, typeFlag)
    -- SAVE THE RESTRICTION TO DATA
    local playerSteamID = string.Replace(tostring(targetPly:SteamID()), ":", "_")
    if hasReason then 
        file.Write("entityrestrictor/"..playerSteamID.."_"..typeFlag..".txt", curTimeStamp.."_"..restrictionLength.."_"..admin:Nick().."_"..reason)
    else 
        file.Write("entityrestrictor/"..playerSteamID.."_"..typeFlag..".txt", curTimeStamp.."_"..restrictionLength.."_"..admin:Nick())
    end 
    


    -- PRINT TO CHAT
    PrintMessage(HUD_PRINTTALK, targetPly:Nick().." has been restricted by "..admin:Nick().." from using "..type.." for "..tostring(restrictionLength / 3600).." hours.")
    if hasReason then 
        PrintMessage(HUD_PRINTTALK, "Reason: "..reason)
    end
end

----------------------------------------------------------------------------------------------------------|




