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
include("entityrestrictor/sv_er_config.lua")
include("entityrestrictor/sv_er_commands.lua")
include("entityrestrictor/sv_er_hooks.lua")

if file.Exists("entityrestrictor", "DATA") != true then 
    file.CreateDir("entityrestrictor")
end 

-- Init credit Timer
timer.Create("EntityRestrictorCreditsTimer", 600, 0 ,function() PrintMessage(HUD_PRINTTALK,"This server is using kujoen's EntityRestrictor v1.0 | github.com/Kujoen/EntityRestrictor") end)