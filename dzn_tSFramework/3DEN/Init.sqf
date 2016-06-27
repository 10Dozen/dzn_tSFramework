call compile preProcessFileLineNumbers "dzn_tSFramework\3DEN\Functions.sqf";

// 313 is Eden Display
disableSerialization;

dzn_tsf_3DEN_keyIsDown = false;
dzn_tsf_3DEN_toolDisplayed = false;
dzn_tsf_3DEN_SelectedUnits = [];

dzn_tsf_3DEN_SquadLastNumber = 0;
dzn_tsf_3DEN_DynaiCore = objNull;
dzn_tsf_3DEN_DynaiZoneId = 0;
dzn_tsf_3DEN_Zeus = objNull;
dzn_tsf_3DEN_BaseTrg = objNull;
dzn_tsf_3DEN_CCP = objNull;

dzn_tsf_3DEN_UnitsLayer = objNull;
dzn_tsf_3DEN_tSFLayer = objNull;
dzn_tsf_3DEN_GearLayer = objNull;
dzn_tsf_3DEN_DynaiLayer = objNull;

(findDisplay 313) displayAddEventHandler ["KeyDown", "_handled = _this call dzn_tsf_3DEN_onKeyPress;"];
["tSF Tools Activated - Press 'Ctrl' + 'Space' to use", 0, 15, true] call BIS_fnc_3DENNotification;
