// ********************
// INITIALIZATION
// ********************

if (hasInterface) then {
	call compile preProcessFileLineNumbers "dzn_tSFramework\Modules\tSNotesSettings\Settings.sqf";
	call compile preProcessFileLineNumbers "dzn_tSFramework\Modules\tSNotesSettings\NotesSettings.sqf";
	call compile preProcessFileLineNumbers "dzn_tSFramework\Modules\tSNotesSettings\Functions.sqf";
	
	if (tSF_noteSettings_enableThinLineMarkers) then { [] call dzn_fnc_tsf_initThinLineMarkers };
};
