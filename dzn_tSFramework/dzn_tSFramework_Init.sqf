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
tSF_CCP = false;
tSF_Briefing = false;
tSF_TSNotes = false;



// **************************
//  INIT
// **************************
if (tSF_CCP) then { [] execVM "dzn_tSFramework\Modules\CCP\Init.sqf"; };
if (tSF_Briefing) then { [] execVM "dzn_tSFramework\Modules\Briefing\Init.sqf"; };
if (tSF_TSNotes) then { [] execVM "dzn_tSFramework\Modules\TSNotes\Init.sqf"; };
