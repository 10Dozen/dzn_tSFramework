#include "Modules\script_macro.hpp"

// **************************
//
// 	DZN TS FRAMEWORK
//
// **************************
tSF_Version = "v2.6";

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
tSF_module_FARP = false;

tSF_module_Interactives = false;
tSF_module_ACEActions = true;

tSF_module_Authorization = true;
tSF_module_AirborneSupport = true;
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

	, "Briefing"
	, "tSNotes"
	, "tSSettings"

	, "FARP"
	, "ArtillerySupport"
	, "Interactives"
	, "ACEActions"

	, "EditorUnitBehavior"
	, "tSAdminTools"

	, "Conversations"
] apply {
	call compile format ["if (tSF_module_%1) then { [] execVM 'dzn_tSFramework\Modules\%1\Init.sqf' }", _x]
};

INCLUDE_MODULE(tSFDiag);
INCLUDE_MODULE(Chatter);

RUN_MODULE(CCP);
RUN_MODULE(IntroText);
RUN_MODULE(Authorization);
RUN_MODULE(AirborneSupport);
RUN_MODULE(EditorVehicleCrew);
RUN_MODULE(EditorRadioSettings);
RUN_MODULE(POM);
