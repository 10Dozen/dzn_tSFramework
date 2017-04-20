
tSF_FARP_Composition			= "FARP HEMTT NATO";	// Name of default composition; See 'FARP Compositions.sqf' for names


// General availability of assets
tSF_FARP_Repair_Allowed			= true;
tSF_FARP_Refuel_Allowed			= true;
tSF_FARP_Rearm_Allowed			= true;

// Repair settings
tSF_FARP_Repair_Auto			= true;	// scripted repair or manual via ace-menu
tSF_FARP_Repair_ProportionalMode	= true;	// Should repair time depeneds on damage or always same time
tSF_FARP_Repair_TimeMultiplier	= 10; 		// seconds per 1% if tSF_FARP_RepairProportionalMode is true; overall repair time on false
tSF_FARP_Repair_ResoucesLevel	= 200; 	// limit of the repaired %; if negative - unlimited
tSF_FARP_Repair_Threshold		= 20; 		// min. % of vehicle health that allowed to be fully fixed
tSF_FARP_Repair_NonRepairable	=  ["","hitwindshield_1","hitwindshield_2","HitGlass1","HitGlass2","HitGlass3","HitGlass4","HitGlass5","HitGlass6","HitBody","HitHull","HitRGlass","HitLGlass"];

// Refuel settings
tSF_FARP_Refuel_Auto			= true;	// scripted refuel or manual via ace-menu
tSF_FARP_Refuel_ProportionalMode	= true;	
tSF_FARP_Refuel_TimeMultiplier	= 10;
tSF_FARP_Refuel_ResoucesLevel	= 200; 

// Rearm settings
tSF_FARP_Rearm_Auto			= true;	// scripted rearm or manual via ace-menu
tSF_FARP_Rearm_ProportionalMode	= true;	
tSF_FARP_Rearm_TimeMultiplier	= 10;
tSF_FARP_Rearm_ResoucesLevel	= 200; 


// Texts
tSF_FARP_STR_NotAllowedText		= "This area is not secured to deploy FARP there. Choose different location.";
tSF_FARP_STR_AlreadySet		= "FARP location was already set (remove previous one to change location).";
tSF_FARP_STR_SuccessSet  		= "FARP will be deployed at selected location";
