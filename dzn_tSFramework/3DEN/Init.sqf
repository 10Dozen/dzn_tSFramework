#include "Functions Utillity.sqf";
#include "Functions Playable Units.sqf";
#include "Functions DynAI.sqf";
#include "Functions tSF.sqf";
#include "Functions Scenario.sqf";
#include "Functions Compositions.sqf";
#include "Squads and Platoons Structures.sqf";
#include "Compositions.sqf";

// 313 is Eden Display
disableSerialization;

dzn_tSF_3DEN_keyIsDown = false;
dzn_tSF_3DEN_toolDisplayed = false;
dzn_tSF_3DEN_SelectedUnits = [];
dzn_tSF_3DEN_Parameter = [];

dzn_tSF_3DEN_DynaiCore = objNull;
dzn_tSF_3DEN_SupportReturnPointCore = objNull;
dzn_tSF_3DEN_DynaiZoneId = 0;
dzn_tSF_3DEN_Zeus = objNull;
dzn_tSF_3DEN_BaseTrg = objNull;
dzn_tSF_3DEN_CCP = objNull;
dzn_tSF_3DEN_FARP = objNull;
dzn_tSF_3DEN_ScnearioLogic = objNull;
dzn_tSF_3DEN_CoverMap = objNull;
dzn_tSF_3DEN_Headless = objNull;

dzn_tSF_3DEN_UnitsLayer = objNull;
dzn_tSF_3DEN_tSFLayer = objNull;
dzn_tSF_3DEN_GearLayer = objNull;
dzn_tSF_3DEN_DynaiLayer = objNull;
dzn_tSF_3DEN_MiscLayer = objNull;
dzn_tSF_3DEN_SupporterLayer = objNull;

dzn_tSF_3DEN_DynaiSubfolders = [];
dzn_tSF_3DEN_ToDoListFolder = objNull;
dzn_tSF_3DEN_KeyBindings = "<br />
tSF Tool - ""Ctrl"" + ""Space"" to use<br />
<br />
Snap To Surface - ""Ctrl"" + ""Q""<br />
Mark To Do item as done - ""Shift"" + ""D""<br />
<br />
Show key bindings - ""F8""";

(findDisplay 313) displayAddEventHandler ["KeyDown", "_this call dzn_tSF_3DEN_onKeyPress"];
["tSF 3DEN Tools Activated<br />Press ""F8"" to see keybindings", 0, 30, true] call BIS_fnc_3DENNotification;
