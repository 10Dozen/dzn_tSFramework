// ********************
// INITIALIZATION
// ********************

call compile preProcessFileLineNumbers "dzn_tSFramework\Modules\tSNotesSettings\Settings.sqf";
if (hasInterface) then {
	call compile preProcessFileLineNumbers "dzn_tSFramework\Modules\tSNotesSettings\NotesSettings.sqf";
};
