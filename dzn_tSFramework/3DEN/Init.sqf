call compile preProcessFileLineNumbers "dzn_tSFramework\3DEN\Functions.sqf";

// 313 is Eden Display
disableSerialization;

dzn_tSF_3DEN_keyIsDown = false;
dzn_tSF_3DEN_toolDisplayed = false;
dzn_tSF_3DEN_SelectedUnits = [];
dzn_tSF_3DEN_Parameter = [];

dzn_tSF_3DEN_SquadLastNumber = 0;
dzn_tSF_3DEN_DynaiCore = objNull;
dzn_tSF_3DEN_DynaiZoneId = 0;
dzn_tSF_3DEN_Zeus = objNull;
dzn_tSF_3DEN_BaseTrg = objNull;
dzn_tSF_3DEN_CCP = objNull;

dzn_tSF_3DEN_UnitsLayer = objNull;
dzn_tSF_3DEN_tSFLayer = objNull;
dzn_tSF_3DEN_GearLayer = objNull;
dzn_tSF_3DEN_DynaiLayer = objNull;
dzn_tSF_3DEN_MiscLayer = objNull;

(findDisplay 313) displayAddEventHandler ["KeyDown", "_handled = _this call dzn_tSF_3DEN_onKeyPress;"];
["tSF Tools Activated - Press ""Ctrl + 'Space"" to use", 0, 30, true] call BIS_fnc_3DENNotification;
