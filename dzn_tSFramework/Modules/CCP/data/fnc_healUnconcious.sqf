#include "script_component.hpp"

/*
	Checks for unconscious players at CCP location and starts medicare.

	Params: none
	Return: none
*/

allPlayers select {
	alive _x
	&& _x getVariable ["ACE_isUnconscious", false]
	&& !(_x getVariable [QGVAR(isHealing), false])
	&& _x distance CCP_LOGIC <= CCP_PLAYER_SEARCH_RADIUS
} apply {
	[_x] call FUNC(doMedicare);
};
