#include "script_component.hpp"

[
	{ time > GVAR(initTimeout) && GVAR(initCondition) }
	, {
		LOG("Server init started");
		GVAR(Vehicles) = []; // [@Vehicle, @Name]
		GVAR(ReturnPoints) = [];
		
		[] call FUNC(processLogics);
		publicVariable QGVAR(Vehicles);
		publicVariable QGVAR(ReturnPoints);

		LOG("Server initialized");
	}
] call CBA_fnc_waitUntilAndExecute;
