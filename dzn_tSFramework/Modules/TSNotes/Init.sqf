// ********************
// INITIALIZATION
// ********************

call compile preProcessFileLineNumbers "dzn_tSFramework\Modules\TSNotes\Settings.sqf";
if (hasInterface) then {
	call compile preProcessFileLineNumbers "dzn_tSFramework\Modules\TSNotes\Notes.sqf";
};
