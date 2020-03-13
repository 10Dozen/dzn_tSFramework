#include "script_component.hpp"

/*
 Respawn_west marker
 tSF_ScenarioData
 Headless client (HC)
 Zeus module for admin
 CCP if ccp activated
 FARP if farp activated
*/

FUNC(testEntities) = {
	// Test respawn_west (or other respawn) markers
	private _hasRespawn = (allMapMarkers findIf { 
		private _mrkName = _x;
		["respawn_west","respawn_east","respawn_guerrila","respawn"] findIf { _x == _mrkName } > -1
	}) > -1;
	private _hasScenarioLogic = !isNil "tSF_Scenario_Logic";
	private _hasHC = !isNil "HC";
	private _hasZeus = !isNil "tSF_Zeus";
	private _hasCCP = !isNil "tSF_CCP";
	private _hasFARP = !isNil "tSF_FARP";

	private _fnc_fail = {
		LOG("[ERROR] " + _this);
		["TaskFailed",["",_this]] call BIS_fnc_showNotification;
	};

	if (!_hasRespawn) then { "No Respawn Marker" call _fnc_fail; };
	if (!_hasScenarioLogic) then { "Scenario is not set up!" call _fnc_fail; };
	if (!_hasHC) then { "No Headless Client set!" call _fnc_fail; };
	if (!_hasZeus) then { "No Zeus Module set!" call _fnc_fail; };
	if (tSF_module_CCP && !_hasCCP) then { "No CCP set!" call _fnc_fail; };
	if (tSF_module_FARP && !_hasFARP) then { "No FARP set!" call _fnc_fail; };
};