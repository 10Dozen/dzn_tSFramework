#include "script_component.hpp"

/*
    Applies equipment related defaults:
    - auto use Earplugs
    - put weapon on safe

    (_self)

    Params:
        none
    Returns:
        nothing
*/

private _settings = SETTING(_self,Equipment);

// Put default weapon on safe
if (_settings getOrDefault [Q(PutWeaponOnSafe), false]) then {
    [player, currentWeapon player, true] call ace_safemode_fnc_setWeaponSafety;
};

if (_settings getOrDefault [Q(EarplugAutoUse), false]) then {
    player call ace_hearing_fnc_putInEarplugs;
};

// Schedule equipment adjust after dzn_gear kit assigned
[
    { DZN_GEAR_APPLIED(player) },
    {
        params ["_useEarplugs", "_weaponOnSafe"];
        if (_useEarplugs) then {
            player call ace_hearing_fnc_putInEarplugs;
        };
        if (_weaponOnSafe) then {
            [player, currentWeapon player, true] call ace_safemode_fnc_setWeaponSafety;
        };
    },
    [
        _settings getOrDefault [Q(EarplugAutoUse), false],
        _settings getOrDefault [Q(PutWeaponOnSafe), false]
    ]
] call CBA_fnc_waitUntilAndExecute;
