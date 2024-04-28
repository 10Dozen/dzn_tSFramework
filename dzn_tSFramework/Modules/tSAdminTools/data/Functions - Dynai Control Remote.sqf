/*
    Functions to extend Dynai API with remote exec options
*/

tSF_adminTools_DC_checkZoneStateRemote = {
    params ["_zonename"];
    private _zone = missionNamespace getVariable _zonename;
    private _isAlerted = _zone getVariable "dzn_dynai_isZoneAlerted";
    private _isActive = _zone call dzn_fnc_dynai_isActive;

    [_zone, _isActive, _isAlerted] remoteExec ["tSF_adminTools_DC_checkZoneStateClient", remoteExecutedOwner];
};

tSF_adminTools_DC_evaluateZoneConditionRemote = {
    params ["_zonename"];

    private _condition = (dzn_dynai_zoneProperties select (
        dzn_dynai_zoneProperties findIf { _x # 0 == _zonename }
    )) # 7;

    [
        _zonename, str(_condition), [] call _condition
    ] remoteExec ["tSF_adminTools_DC_evaluateZoneConditionClient", remoteExecutedOwner];
};

tSF_adminTools_DC_showHideZoneRemote = {
    params ["_zonename"];
    private _zone = missionNamespace getVariable _zonename;
    private _props = [_zone, "prop"] call dzn_fnc_dynai_getZoneVar;

    [_zonename, _zone, _props] remoteExec ["tSF_adminTools_DC_showHideZoneClient", remoteExecutedOwner];
};

tSF_adminTools_DC_showZoneInfoRemote = {
    params ["_zonename"];
    private _zone = missionNamespace getVariable _zonename;
    ([_zone, "prop"] call dzn_fnc_dynai_getZoneVar) params [
        ""
        , "_side"
        , "_isActive"
        , ""
        , "_keypoints"
        , "_template"
        , "_behaviour"
        , "_cond"
    ];

    private _unitsInGroups = ([_zone, "groups"] call dzn_fnc_dynai_getZoneVar) apply { {alive _x} count (units _x) };
    private _grpsWithUnits = { _x > 0 } count _unitsInGroups;
    private _totalUnitsCount = 0;
    { _totalUnitsCount = _totalUnitsCount + _x; } forEach _unitsInGroups;

    [
        _zonename, _side, _isActive, _keypoints,
        _template, _behaviour, str(_cond),
        _grpsWithUnits, _totalUnitsCount
    ] remoteExec ["tSF_adminTools_DC_showZoneInfoClient", remoteExecutedOwner];
};
