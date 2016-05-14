// ********************
// INITIALIZATION
// ********************

if (hasInterface) then {
	call compile preProcessFileLineNumbers "dzn_tSFramework\Modules\tSNotes\Settings.sqf";
	#define	ADD_NOTES	call compile preProcessFileLineNumbers "dzn_tSFramework\Modules\tSNotes\Notes.sqf"

	waitUntil { !isNull findDisplay 52 || getClientState == "BRIEFING SHOWN" || time > 0 };
	ADD_NOTES;
	
	// If not added accidentally, re-add
	if !(player diarySubjectExists "tSF_Notespage") then {
		ADD_NOTES;
		
		// If cannot be added until mission start - add after.
		waitUntil { time > 3 };
		if !(player diarySubjectExists "tSF_Notespage") then { ADD_NOTES; };
	};
};
