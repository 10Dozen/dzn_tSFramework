#include "script_component.hpp"

/*
	    Adds keybinds for ViewDistance control
	    (_self)
	
	    params:
	        none.
	    Returns:
	        nothing
*/

[
	TSF_CBASETTINGS_SECTION,
	QGVAR(Keybind_VD_PresetNext),
	"Следующая дальность видимости",
	nil,
	{
		COB call [F(changeViewDistancePreset), 1];
	},
	[nil, [false, false, false]]
] call CBA_fnc_addKeybind;

[
	TSF_CBASETTINGS_SECTION,
	QGVAR(Keybind_VD_PresetPrev),
	"Предыдущая дальность видимости",
	nil,
	{
		COB call [F(changeViewDistancePreset), -1];
	},
	[nil, [false, false, false]]
] call CBA_fnc_addKeybind;
