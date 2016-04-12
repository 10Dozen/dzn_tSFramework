// **************************
// 	DZN TS FRAMEWORK v0.1
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
tSF_module_CCP = true;
tSF_module_Briefing = false;
tSF_module_tSNotes = false;
tSF_module_tSNotesSettings = false;


// **************************
//  INIT
// **************************
if (tSF_module_CCP) then { [] execVM "dzn_tSFramework\Modules\CCP\Init.sqf"; };
if (tSF_module_Briefing) then { [] execVM "dzn_tSFramework\Modules\Briefing\Init.sqf"; };
if (tSF_module_tSNotes) then { [] execVM "dzn_tSFramework\Modules\tSNotes\Init.sqf"; };
if (tSF_module_tSNotesSettings) then { [] execVM "dzn_tSFramework\Modules\tSNotesSettings\Init.sqf"; };
