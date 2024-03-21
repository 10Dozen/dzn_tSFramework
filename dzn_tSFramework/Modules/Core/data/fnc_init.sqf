#include "script_component.hpp"

/*
    Initialize Component Object and it's features.
    Params:
        none
    Returns:
        nothing
*/
__EXIT_ON_SETTINGS_PARSE_ERROR__

private _settings = _self get Q(Settings);
_settings deleteAt "#SOURCE";
_settings deleteAt "#ERRORS";

private _legacyModules = _self get Q(LegacyModules);

{
    DEBUG_2("[Init] _x=%1, _y=%2", _x, _y);
    if (!_y) then { continue; };

    if (_x in _legacyModules) then {
        [] execVM format ['dzn_tSFramework\Modules\%1\Init.sqf', _x];
    } else {
        [] call compileScript [format ['dzn_tSFramework\Modules\%1\data\PreInit.sqf', _x]];
    };
} forEach (_self get Q(Settings));
