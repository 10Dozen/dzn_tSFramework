// **************************
// 	DZN TS FRAMEWORK v1.6
//
//	Initialized when:
//	{ }
//
//	Server-side initialized when:
//	{  }
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
tSF_module_Interactives = true;
tSF_module_InteractivesACE = true;
tSF_module_Support = true;

tSF_module_EditorVehicleCrew = true;
tSF_module_EditorUnitBehavior = true;
tSF_module_EditorRadioSettings = true;

tSF_module_tSAdminTools = true;


// **************************
//  INIT
// **************************
if (tSF_module_MissionDefaults) then { [] execVM "dzn_tSFramework\Modules\MissionDefaults\Init.sqf"; };
if (tSF_module_JIPTeleport) then { [] execVM "dzn_tSFramework\Modules\JIPTeleport\Init.sqf"; };
if (tSF_module_MissionConditions) then { [] execVM "dzn_tSFramework\Modules\MissionConditions\Init.sqf"; };

if (tSF_module_IntroText) then { [] execVM "dzn_tSFramework\Modules\IntroText\Init.sqf"; };
if (tSF_module_Briefing) then { [] execVM "dzn_tSFramework\Modules\Briefing\Init.sqf"; };
if (tSF_module_tSNotes) then { [] execVM "dzn_tSFramework\Modules\tSNotes\Init.sqf"; };
if (tSF_module_tSNotesSettings) then { [] execVM "dzn_tSFramework\Modules\tSNotesSettings\Init.sqf"; };

if (tSF_module_CCP) then { [] execVM "dzn_tSFramework\Modules\CCP\Init.sqf"; };
if (tSF_module_Interactives) then { [] execVM "dzn_tSFramework\Modules\Interactives\Init.sqf"; };
if (tSF_module_InteractivesACE) then { [] execVM "dzn_tSFramework\Modules\InteractivesACE\Init.sqf"; };
if (tSF_module_Support) then { [] execVM "dzn_tSFramework\Modules\Support\Init.sqf"; };

if (tSF_module_EditorVehicleCrew) then { [] execVM "dzn_tSFramework\Modules\EditorVehicleCrew\Init.sqf"; };
if (tSF_module_EditorUnitBehavior) then { [] execVM "dzn_tSFramework\Modules\EditorUnitBehavior\Init.sqf"; };
if (tSF_module_EditorRadioSettings) then { [] execVM "dzn_tSFramework\Modules\EditorRadioSettings\Init.sqf"; };

if (tSF_module_tSAdminTools) then { [] execVM "dzn_tSFramework\Modules\tSAdminTools\Init.sqf"; };