#include "script_component.hpp"

if (!hasInterface) exitWith {};

[
	{ !isNil QEGVAR(Authorization,Initialized) }
	, {
		LOG("Pre-Initialization condition met - start component initialization");
		INIT_SETTING;
		INIT_FUNCTIONS;

		INIT_CLIENT;
	}
] call CBA_fnc_waitUntilAndExecute;
