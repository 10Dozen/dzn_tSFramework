#include "script_component.hpp"

[
	{ time > GVAR(initTimeout) && GVAR(initCondition) }
	, {
		LOG("Server init started");

		[] call FUNC(processEVCLogics);

		LOG("Server initialized");
	}
	, []
] call CBA_fnc_waitUntilAndExecute;
