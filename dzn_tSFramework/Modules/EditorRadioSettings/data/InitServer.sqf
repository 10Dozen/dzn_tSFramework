#include "script_component.hpp"

[
	{ time > GVAR(initTimeout) && GVAR(initCondition) }
	, {
		LOG("Server init started");

		private _result = [] call FUNC(processERSLogics);

		_result params ["_logicsCount", "_assignementsSuccessCount"];
		LOG_2("Server initialized - %1 logics processed >> %2 assignements done.", _logicsCount, _assignementsSuccessCount);
	}
	, []
] call CBA_fnc_waitUntilAndExecute;
