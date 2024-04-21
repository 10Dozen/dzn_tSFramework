#include "script_component.hpp"

/*
    Returns brief info of unit's gear:
      - primary weapon (STRING)
      - launcher weapon (STRING)
      - has LR radio flag (BOOL)
      - has SW radio flag (BOOL)
    or empty array, if dzn_gear is not applied yet.

    (_self)

    Params:
        0: _unit (OBJECT) - unit to check it's group.

    Return:
        Array of elements in format:
        0: _primaryWeaponName(STRING)
        1: _launcherWeaponName(STRING)
        2: _hasLR (BOOL)
        3: _hasSR (BOOL)
*/

// --- dzn_gear not yet initialized
// if (isNil "dzn_gear_serverInitDone") exitWith { [] };

params ["_unit"];

// --- dzn_gear not yet applied kit to unit
// if (isNil { _unit getVariable "dzn_gear" }) exitWith { [] };

private _gearInfo = [];

private _loadout = getUnitLoadout _unit;

(_loadout # 0) params [["_pwClass", ""]];
(_loadout # 1) params [["_swClass", ""]];
(_loadout # 5) params [["_backpack", ""]];
private _assignedItems = _loadout # 9;

_gearInfo pushBack ([
    "",
    getText (configFile >> "CfgWeapons" >> _pwClass >> "displayName")
] select (_pwClass isNotEqualTo ""));

_gearInfo pushBack ([
    "",
    getText (configFile >> "CfgWeapons" >> _swClass >> "displayName")
] select (_swClass isNotEqualTo ""));

// -- Check that backpack is TFAR LR radio
_gearInfo pushBack (getNumber (configFile >> "CfgVehicles" >> _backpack >> "tf_hasLRradio") > 0);

// -- Check that backpack is TFAR LR radio
_gearInfo pushBack (_assignedItems findIf { _x == 'ItemRadio' || _x call TFAR_fnc_isRadio } > -1);

_gearInfo
