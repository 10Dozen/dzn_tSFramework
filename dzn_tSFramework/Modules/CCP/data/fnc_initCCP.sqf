#include "script_component.hpp"

/*
	Adds client side actions to CCP objects.

	Params: none
	Return: none
*/

__CLIENT_ONLY__

// Add interactions with CCP objects
private _composition = CCP_LOGIC getVariable QGVAR(CompositionObjects);

_composition apply {
	private _cond = QUOTE(!(player getVariable [ARR_2(QQGVAR(isHealing),false)]));
	[_x, "<t color='#9bbc2f' size='1.2'>Get Medical Care</t>"
		, { [player] call FUNC(doMedicare); }
		, 5, _cond, 6
	] call dzn_fnc_addAction;

	// Heal unconcious players
	[_x , "<t color='#9bbc2f' size='1'>Provide first aid to uncon. patients</t>"
		, { [] call FUNC(healUnconcious); }
		, 5, _cond, 6
	] call dzn_fnc_addAction;

	// Heal AI option -- available only for AI squad leaders
	[_x , "<t color='#9bbc2f' size='1'>Provide first aid to my AI units</t>"
		, {
			(units group player) select { !isPlayer _x && alive _x} apply {
				[_x] call FUNC(doMedicare);
			};
		}
		, 5
		, QUOTE(!(player getVariable [ARR_2(QQGVAR(isHealing),false)]) && leader player == player && {!isPlayer _x && alive _x} count (units group player) > 0)
		, 6
	] call dzn_fnc_addAction;
};

// Undeploy action
[(_composition # 0), "Undeploy CCP"
	, { [] call FUNC(undeploy); }
	, 5
	, QUOTE({alive _x && _x getVariable [ARR_2(QQGVAR(isHealing),false)]} count allPlayers == 0)
	, 6
] call dzn_fnc_addAction;
