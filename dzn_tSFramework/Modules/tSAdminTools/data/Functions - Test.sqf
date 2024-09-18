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
    private _playerSide = side player;
    private _hasPlayerSideRespawn = (markerType format ["respawn_%1", str (side player)]) != "";
	private _hasAnyRespawn = (allMapMarkers findIf {
		private _mrkName = _x;
		["respawn_west","respawn_east","respawn_guerrila","respawn"] findIf { _x == _mrkName } > -1
	}) > -1;

	private _hasScenarioLogic = !isNil "tSF_Scenario_Logic";
	// private _hasHC = !isNil "HC";
	private _hasZeus = !isNil "tSF_Zeus";
	private _hasCCP = !isNil "tSF_CCP";
	private _hasFARP = !isNil "tSF_FARP";

	private _fnc_fail = {
        ECOB(Core) call [F(reportError), ["Сценарий", _this, "воспользуйтесь tSF 3DEN Tool для исправления."]];
	};

    if (!_hasPlayerSideRespawn) then { (format ["Нет маркера респауна для стороны %1", _playerSide]) call _fnc_fail; };
	if (!_hasAnyRespawn) then { "Нет маркера респауна ни для одной из сторон" call _fnc_fail; };
	if (!_hasScenarioLogic) then { "Сценарий не настроен!" call _fnc_fail; };
	// if (!_hasHC) then { "No Headless Client set!" call _fnc_fail; };
	if (!_hasZeus) then { "Нет модуля Зевс!" call _fnc_fail; };
	if (TSF_MODULE_ENABLED(CCP) && !_hasCCP) then { "Не установлен CCP!" call _fnc_fail; };
	if (TSF_MODULE_ENABLED(FARP) && !_hasFARP) then { "Не установлен FARP!" call _fnc_fail; };
};
