#include "script_component.hpp"

LOG("Pre-Initialization started");

[
	{ !isNil QEGVAR(Authorization,Initialized) }
	, {
		LOG("Pre-Initialization condition met - start component initialization");
		INIT_SETTING;
		INIT_FUNCTIONS;
		INIT_FILE(data,Functions Request);

		INIT_SERVER;
		INIT_CLIENT;
	}
] call CBA_fnc_waitUntilAndExecute;
