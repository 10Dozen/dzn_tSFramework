![img](http://tacticalshift.ru/tsf_10d.png)
------
##### Version: 2.00
Tactical Shift Framework

##### Getting Started
See [Google Slides](https://vk.com/away.php?utf=1&to=https%3A%2F%2Fdocs.google.com%2Fpresentation%2Fd%2F1-hwUq2sYlP9BzIy4GzOBALAaTHpBOzPOXhZyXPhatXQ%2Fedit%3Fusp%3Dsharing) and [Modules](https://docs.google.com/presentation/d/13p3Mz7pnrZPh3XKO3-B73k0_0E6bkZo6aWEgm2z6kso/edit?usp=sharing).

#### Content
##### 3DEN Tool
Editor tool that allows to create scenarios quick and accurate. Check [3DEN Tools Wiki](https://github.com/10Dozen/dzn_tSFramework/wiki/3DEN-Tools) for details.

##### Briefing
Briefing helper tool to create briefings in standard way.

##### Interactives & ACE Actions framework 
Framework to apply custom code to specific objects or classes on client/server/both. Also allows to apply code for each new instance of objects of given class.

##### CCP
Casualties Collection Point module allows to set CCP during the briefing. At CCP players may be healed after some time (ACE3). 

##### FARP
Forward Area Refueling/Rearming Point module allows to set FARP during the briefing. At FARP vehicles may be rearmed, refueled and repaired after some time.

##### Intro Text
Shows formatted intro text for each player.

##### Mission Conditions
Conditions that lead mission to Debriefing screen. CfgDebriefing classes helper.

##### Mission Defaults
Some default mission pre-sets (like player score).
- Freeze time on mission start option.
- Weapon Safe mode on start
- Earplugs In on start
- Player rating
- Calculator (via marker started with @, e.g. '@4000/5.5' -> 727.27')
- Phonetic Alphabet Markers (e.g. auto-replace of 'Obj A!' -> 'Obj Alpha', 'КП З!' - 'КП Зоя'

##### Airborne Support
Airborne vehicles pickup and return to base by AI or player pilots.
<br />See slides: https://docs.google.com/presentation/d/1HpwSKT82IjZVIXdV2aGlPYcjGPoMyzE-BrmvPIbmkzI/edit?usp=sharing

##### Artillery Support
Artillery compositions that can be used for firemissions served by AI.
<br />See slides: https://docs.google.com/presentation/d/1bxc_cWJFGv_U2zxG9GgvuXOnDtyNHzKI6N9rEPQbHSk/edit?usp=sharing

##### tS Notes
Game and TTP notes for each players

##### tS Notes Settings
Client-side settings like View Distance

##### tS Admin Tools
Admin-enabled ability to:
- finish mission by one of the endings (from Diary or via tSF_End function)
- assign gear kit to remote players
- GSO Screen with teleport for GSO and Players
- Rapid Artillery screen
- GSO Respawn screen

##### Editor Unit Behavior
Make editor placed unit to 'Surrender' on player's approach.

##### Editor Vehicle Crew
Add crew to editor placed vehicle according set up crew config.

##### JIP Teleport
Allows JIP players to teleport to their's squad leader.

##### Conversations
Allows to attach 'conversation' dialogs to objects.

##### Platoon Operational Markers
Allows Platoon Leader to add, set up and drag markers (visible for platoon leader obly) during the missions.

##### tSF File Sweeper
Batch script that clears all files that are not used by Arma 3 when mission is played (html-helpers, 3den tool). Run it before mission export.

##### dzn BRV Scripts
dzn BRV Scripts for AAR Viewer added to repo.
