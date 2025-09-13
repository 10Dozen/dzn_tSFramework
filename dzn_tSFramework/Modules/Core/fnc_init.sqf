#include "script_component.hpp"

/*
    Initialize Component Object and it's features.
    Params:
        none
    Returns:
        nothing
*/
params ["_gearEditMode"];

private _settings = _self get Q(Settings);
_settings deleteAt "#SOURCE";
_settings deleteAt "#ERRORS";

// -- Run Gear and Dynai using settings from \Config dir
[_gearEditMode, nil, DZN_GEAR_SETTINGS_PATH] call compileScript [DZN_GEAR_INIT_PATH];
[DZN_DYNAI_SETTINGS_PATH] call compileScript [DZN_DYNAI_INIT_PATH];

// -- Run tSF modules
private _legacyModules = _self get Q(LegacyModules);

{
    DEBUG_2("[Init] _x=%1, _y=%2", _x, _y);
    if (!_y) then { continue; };

    if (_x in _legacyModules) then {
        [] execVM format ['dzn_tSFramework\Modules\%1\Init.sqf', _x];
    } else {
        _self call [F(startComponent), [_x]];
    };
} forEach (_self get Q(Settings));
