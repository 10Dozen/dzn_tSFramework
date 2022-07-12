#include "script_component.hpp"

LOG('Client init started.');
// Handle briefing time CCP position selection
[] call FUNC(handlePositionSelection);

[
	{ MISSION_STARTED },
	{ [] call FUNC(finishPositionSelection); }
] call CBA_fnc_waitUntilAndExecute;

LOG('Client init done.');
