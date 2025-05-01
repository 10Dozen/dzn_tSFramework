#include "script_component.hpp"

if (isMultiplayer && !(player call FUNC(isAuthorizedUser))) exitWith {};
LOG("Client init started - authorized");

GVAR(CurrentMrk) = "";
GVAR(Markers) = [];
GVAR(ProtectedPOMs) = [];
GVAR(MarkerLastID) = 0;

/*
 *	Generate Operational Markerks
 */
if (GVAR(GenerateMarkersFromGroups)) then {
	private _poms = [];
	{	
		private _grpPOM = ["Infantry", groupId (group _x), side _x, true, getPos leader _x];
		
		if !(_grpPOM in _poms) then {
			_poms pushBack _grpPOM;
			_grpPOM call FUNC(addPOM);
		};	
	} forEach (call BIS_fnc_listPlayers);
};

/*
 *	Run handlers
 */
[{ !isNull MAP_CTRL }, {
	[] call FUNC(addEventHandlers);
	[] call FUNC(addTopic);
	
	LOG("Client initialized");
}] call CBA_fnc_waitUntilAndExecute;
