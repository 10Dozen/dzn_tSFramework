#include "script_component.hpp"

[
	{ time > GVAR(initTimeout) && GVAR(initCondition) }
	, {
		LOG("Client init started");
	
		[
			[
				[GVAR(LineText1), GVAR(LineStyle1)],
				[GVAR(LineText2), GVAR(LineStyle2)],
				[GVAR(LineText3), GVAR(LineStyle3)]
			],
			GVAR(ShowCurrentTime),
			GVAR(TextPosition),
			GVAR(DisplayTime)
		] call FUNC(ShowIntroText);

		LOG("Client initialized");
	}
	, []
] call CBA_fnc_waitUntilAndExecute;
