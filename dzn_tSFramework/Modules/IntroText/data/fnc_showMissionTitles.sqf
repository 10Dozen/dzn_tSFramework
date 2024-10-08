#include "script_component.hpp"

/*
	Displays (types) intro text lines
	in selected style.

	Params:
		none
	Returns:
		nothing
*/

params ["_dateTitle", "_locTitle", "_opTitle"];

private _spawnLocationName = nil;

if (
    SETTING_2(_self,General,showRespawnLocationTitle) 
    && TSF_MODULE_ENABLED(Respawn)
) then {
    _spawnLocationName = ECOB(Respawn) call [F(getDefaultSpawnLocationName)];
};

_self call [
    F(showTitles),
    [
        SETTING(_self,Date),
        SETTING(_self,Location),
        SETTING(_self,Operation),
        _spawnLocationName
    ]
];
