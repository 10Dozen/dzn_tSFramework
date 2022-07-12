#include "script_component.hpp"

LOG('Server init started.');
[
	{ MISSION_STARTED },
	{ [] call FUNC(createCCP); }
] call CBA_fnc_waitUntilAndExecute;

LOG('Server init done.');
