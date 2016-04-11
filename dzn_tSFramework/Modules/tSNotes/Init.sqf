// ********************
// INITIALIZATION
// ********************

call compile preProcessFileLineNumbers "dzn_tSFramework\Modules\tSNotes\Settings.sqf";
if (hasInterface) then {
	call compile preProcessFileLineNumbers "dzn_tSFramework\Modules\tSNotes\Notes.sqf";
};
