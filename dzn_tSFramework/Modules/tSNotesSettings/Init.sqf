// ********************
// INITIALIZATION
// ********************

if (hasInterface) then {
	call compile preProcessFileLineNumbers "dzn_tSFramework\Modules\tSNotesSettings\Settings.sqf";
	call compile preProcessFileLineNumbers "dzn_tSFramework\Modules\tSNotesSettings\Functions.sqf";
	if (tSF_noteSettings_enableThinLineMarkers) then { [] call dzn_fnc_tsf_initThinLineMarkers };
	
	#define	ADD_NOTES	call compile preProcessFileLineNumbers "dzn_tSFramework\Modules\tSNotesSettings\NotesSettings.sqf"
	
	waitUntil { !isNull findDisplay 52 || getClientState == "BRIEFING SHOWN" || time > 0 };
	ADD_NOTES;

	// If not added accidentally, re-add
	if !(player diarySubjectExists "tSF_NotesSettingsPage") then {
		ADD_NOTES;
		
		// If cannot be added until mission start - add after.
		waitUntil { time > 3 };
		if !(player diarySubjectExists "tSF_NotesSettingsPage") then { ADD_NOTES; };
	};
};
