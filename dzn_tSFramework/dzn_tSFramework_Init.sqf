// **************************
//
// 	DZN TS FRAMEWORK v1.91
//
// **************************

// **************************
//  MODULES
// **************************
tSF_module_MissionDefaults = true;
tSF_module_JIPTeleport = true;
tSF_module_MissionConditions = true;

tSF_module_IntroText = true;
tSF_module_Briefing = true;
tSF_module_tSNotes = true;
tSF_module_tSNotesSettings = true;

tSF_module_CCP = true;
tSF_module_FARP = true;
tSF_module_Interactives = false;
tSF_module_ACEActions = true;
tSF_module_AirborneSupport = false;

tSF_module_EditorVehicleCrew = false;
tSF_module_EditorUnitBehavior = false;
tSF_module_EditorRadioSettings = false;

tSF_module_POM = true;
tSF_module_tSAdminTools = true;


// **************************
//  INIT
// **************************
[
	"MissionDefaults"
	, "JIPTeleport"
	, "MissionConditions"
	
	, "IntroText"
	, "Briefing"
	, "tSNotes"
	, "tSNotesSettings"
	, "POM"
	
	, "CCP"
	, "FARP"
	, "AirborneSupport"
	, "Interactives"
	, "ACEActions"
	
	, "EditorVehicleCrew"
	, "EditorUnitBehavior"
	, "EditorRadioSettings"	
	, "tSAdminTools"
] apply {	
	call compile format ["if (tSF_module_%1) then { [] execVM 'dzn_tSFramework\Modules\%1\Init.sqf' }", _x]
};
