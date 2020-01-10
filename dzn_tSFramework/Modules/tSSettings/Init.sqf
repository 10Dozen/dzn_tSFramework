// ********************
// INITIALIZATION
// ********************

if (hasInterface) then {
	call compile preProcessFileLineNumbers "dzn_tSFramework\Modules\tSSettings\Settings.sqf";
	
	tSF_fnc_noteSettings_setViewDistance = {
		params ["_vd", "_ovd"];

		setViewDistance _vd;
		setObjectViewDistance _ovd;

		hintSilent parseText format [
			"<t color='#86CC5E'>View distance:</t> %1 (%2) <t color='#86CC5E'>m</t>"
			, _vd
			, _ovd
		];
	};

	tSF_fnc_noteSettings_saveViewDistance = {
		profileNamespace setVariable ["tSF_ViewDistance", [viewDistance, getObjectViewDistance select 0]];
		
		hintSilent parseText format [
			"<t color='#86CC5E'>View distance saved to profile:</t> %1 (%2) <t color='#86CC5E'>m</t>"
			, viewDistance
			, getObjectViewDistance select 0
		];
	};
	
	tSF_fnc_noteSettings_setTerrainGrid = {
		hintSilent parseText format [
			"<t color='#86CC5E'>Terrain Grid set to </t>%1"
			, _this
		];
	
		setTerrainGrid (switch (_this) do {
			case "No grass": { 50 };
			case "Default": { 25 };
			case "Normal": { 12.5 };
			case "High": { 6.25 };
			case "Very High": { 3.125 };
		});
	};
	
	#define	ADD_NOTES	call compile preProcessFileLineNumbers "dzn_tSFramework\Modules\tSSettings\NotesSettings.sqf"
	
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
