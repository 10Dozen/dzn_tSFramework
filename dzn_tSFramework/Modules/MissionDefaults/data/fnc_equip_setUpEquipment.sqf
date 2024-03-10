#include "script_component.hpp"

/*
    Applies equipment related defaults:
    - auto use Earplugs
    - put weapon on safe
*/

private _settings = _self get Q(Settings) get Q(Equipment);

if (_settings getOrDefault [Q(PutWeaponOnSafe), false]) then {
    // Put default weapon on safe
    [ACE_player, currentWeapon ACE_player, true] call ace_safemode_fnc_setWeaponSafety;
};

// Schedule equipment adjust after dzn_gear kit assigned
[
    { !isNil {player getVariable "dzn_gear_done"} },
    {
        params ["_useEarplugs", "_weaponOnSafe"];
        if (_useEarplugs) then {
            player call ace_hearing_fnc_putInEarplugs;
        };
        if (_weaponOnSafe) then {
            [ACE_player, currentWeapon ACE_player, true] call ace_safemode_fnc_setWeaponSafety;
        };
    },
    [
        _settings getOrDefault [Q(EarplugAutoUse), false],
        _settings getOrDefault [Q(PutWeaponOnSafe), false]
    ]
] call CBA_fnc_waitUntilAndExecute;
