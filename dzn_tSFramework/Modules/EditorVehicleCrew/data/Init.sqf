#include "script_component.hpp"

[
	{ time > GVAR(initTimeout) && GVAR(initCondition) }
	, {
		LOG("Server/Headless init started");

		[] call FUNC(processEVCLogics);

		LOG("Server/Headless initialized");
	}
	, []
] call CBA_fnc_waitUntilAndExecute;
