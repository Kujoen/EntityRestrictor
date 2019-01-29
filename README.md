# EntityRestrictor
A Module for GMOD servers. 
Place in folder named entityrestrictor.  
Allows restricting players from using vehicles, weapons or tools.  
The restricting command has the following format: 
    
    /restrict playerId restrictionType restrictionLength | restrictionReason

    playerId = userId, first column when typing "status" in console

    restrictionType:
        * A - Vehicles
        * W - Weapons
        * B - Tools

    restrictionLength: time in hours

    restrictionReason: Must follow after the "|"




In the config file you can specify which vehicles/weapons are supposed to be restricted. Additionally you can just say all tools/weapons are to be restricted.





License (Apache 2.0):
>!  Copyright [2019] [Kujoen - https://github.com/Kujoen]
Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at
    http://www.apache.org/licenses/LICENSE-2.0
Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.^









