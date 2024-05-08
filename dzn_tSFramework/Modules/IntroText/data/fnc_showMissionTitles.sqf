#include "script_component.hpp"

/*
	Displays (types) intro text lines
	in selected style.

	Params:
		none
	Returns:
		nothing
*/

params ["_dateTitle", "_locTitle", "_opTitle"]

private _spawnLocation = nil;
if (TSF_MODULE_ENABLED(Respawn)) then {
    (ECOB(Respawn) call [F(getCurrentSpawnLocation)]) params ["_locId","_locName"];
    _spawnLocation = _locName;
};

_self call [
    F(showTitles),
    [
        SETTING(_self,Date),
        SETTING(_self,Location),
        SETTING(_self,Operation),
        _locName
    ]
];
