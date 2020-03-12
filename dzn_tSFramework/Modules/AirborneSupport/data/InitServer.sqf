#include "script_component.hpp"

[
	GVAR(initCondition)
	, {
		LOG("Server init started");
		GVAR(Vehicles) = []; // [@Vehicle, @Name]
		GVAR(ReturnPoints) = [];
		
		[] call FUNC(processLogics);
		publicVariable QGVAR(Vehicles);
		publicVariable QGVAR(ReturnPoints);

		LOG("Server initialized");
	}
	, []
	, GVAR(initTimeout)
] call CBA_fnc_waitUntilAndExecute;
