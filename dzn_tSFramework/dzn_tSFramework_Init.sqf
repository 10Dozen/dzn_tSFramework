#include "Modules\script_macro.hpp"

// **************************
//
// 	DZN TS FRAMEWORK
//
// **************************
tSF_Version = "v2.04";

// **************************
//  MODULES
// **************************
tSF_module_IntroText = true;
tSF_module_Briefing = true;
tSF_module_tSNotes = true;
tSF_module_tSSettings = true;

tSF_module_MissionDefaults = true;
tSF_module_JIPTeleport = true;
tSF_module_MissionConditions = true;

tSF_module_CCP = true;
tSF_module_FARP = true;

tSF_module_Interactives = false;
tSF_module_ACEActions = true;

tSF_module_Authorization = true;
tSF_module_AirborneSupport = false;
tSF_module_ArtillerySupport = false;
tSF_module_POM = false;

tSF_module_EditorVehicleCrew = false;
tSF_module_EditorUnitBehavior = false;
tSF_module_EditorRadioSettings = false;

tSF_module_tSAdminTools = true;

tSF_module_Conversations = false;

// **************************
//  INIT
// **************************
[
	"MissionDefaults"
	, "JIPTeleport"
	, "MissionConditions"
	
	/*, "IntroText"*/
	, "Briefing"
	, "tSNotes"
	, "tSSettings"
	/*, "POM"*/
	
	, "CCP"
	, "FARP"
	/*, "Authorization"*/
	/*, "AirborneSupport"*/
	, "ArtillerySupport"
	, "Interactives"
	, "ACEActions"
	
	, "EditorVehicleCrew"
	, "EditorUnitBehavior"
	, "EditorRadioSettings"
	, "tSAdminTools"
	
	, "Conversations"
] apply {	
	call compile format ["if (tSF_module_%1) then { [] execVM 'dzn_tSFramework\Modules\%1\Init.sqf' }", _x]
};

RUN_MODULE(Authorization);
RUN_MODULE(IntroText);
RUN_MODULE(AirborneSupport);
RUN_MODULE(POM);
