// ********************
// INITIALIZATION
// ********************

if (hasInterface) then {
	call compile preProcessFileLineNumbers "dzn_tSFramework\Modules\tSNotesSettings\Settings.sqf";
	
	tSF_fnc_noteSettings_saveViewDistance = {
		profileNamespace setVariable ["tSF_ViewDistance", [viewDistance, getObjectViewDistance select 0]];
		
		hintSilent parseText format [
			"<t color='#86CC5E'>View distance saved to profile:</t> %1 (%2) <t color='#86CC5E'>m</t>"
			, viewDistance
			, getObjectViewDistance select 0
		];

	};
	
	#define	ADD_NOTES	call compile preProcessFileLineNumbers "dzn_tSFramework\Modules\tSNotesSettings\NotesSettings.sqf"
	
	waitUntil { !isNull findDisplay 52 || getClientState == "BRIEFING SHOWN" || time > 0 };
	ADD_NOTES;
	
	[] spawn {
		sleep 1;
		
		private _viewDistance = profileNamespace getVariable ["tSF_ViewDistance", [3000, 2600]];
		setViewDistance (_viewDistance select 0);
		setObjectViewDistance [_viewDistance select 1, 100];
	};
	
	// If not added accidentally, re-add
	if !(player diarySubjectExists "tSF_NotesSettingsPage") then {
		ADD_NOTES;
		
		// If cannot be added until mission start - add after.
		waitUntil { time > 3 };
		if !(player diarySubjectExists "tSF_NotesSettingsPage") then { ADD_NOTES; };
	};
};
