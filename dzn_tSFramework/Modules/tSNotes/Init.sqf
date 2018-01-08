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
	
	// Create framework features note
	private _textLines = ["<font color='#12C4FF' size='14'>Доступно:</font>"];	
	if (tSF_module_CCP) then { _textLines pushBack "- CCP"; };
	if (tSF_module_FARP) then { _textLines pushBack "- FARP"; };
	if (tSF_module_AirborneSupport) then { _textLines pushBack "- Airborne Support"; };
	if (tSF_module_POM) then { _textLines pushBack "- Platoon Markers"; };
	if (tSF_MissionDefaults_EnableCutieCalc) then { _textLines pushBack "- Marker-Calculator"; };
	if (tSF_MissionDefaults_EnableMarkerPhoneticAutocompletion) then { _textLines pushBack "- Phonetic marker auto-completion"; };
	
	private _topic = ["tSF_Notespage", ["Framework", _textLines joinString "<br />" ]];
	player createDiaryRecord _topic;
};
