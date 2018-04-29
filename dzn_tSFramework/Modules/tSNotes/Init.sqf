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
	
	uiSleep 5;
	
	if (!isNil "tSF_module_CCP" && {tSF_module_CCP}) then { _textLines pushBack "- CCP"; };
	if (!isNil "tSF_module_FARP" && {tSF_module_FARP}) then { _textLines pushBack "- FARP"; };
	if (!isNil "tSF_module_AirborneSupport" && {tSF_module_AirborneSupport}) then { _textLines pushBack "- Airborne Support"; };
	if (!isNil "tSF_module_POM" && {tSF_module_POM}) then { _textLines pushBack "- Platoon Markers"; };
	
	waitUntil { !isNil "tSF_module_MissionDefaults" };
	if (!isNil "tSF_MissionDefaults_EnableCutieCalc" && {tSF_MissionDefaults_EnableCutieCalc}) then { _textLines pushBack "- Marker-Calculator"; };
	if (!isNil "tSF_MissionDefaults_EnableMarkerPhoneticAutocompletion" && {tSF_MissionDefaults_EnableMarkerPhoneticAutocompletion}) then { _textLines pushBack "- Phonetic marker auto-completion"; };
	
	private _topic = ["tSF_Notespage", ["Framework", _textLines joinString "<br />" ]];
	player createDiaryRecord _topic;
};
