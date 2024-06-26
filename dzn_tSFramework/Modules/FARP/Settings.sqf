
tSF_FARP_Composition			= "NATO HEMMT RFA";	// Name of default composition; See 'FARP Compositions.sqf' for names


// General availability of assets
tSF_FARP_Repair_Allowed			= true;
tSF_FARP_Refuel_Allowed			= true;
tSF_FARP_Rearm_Allowed			= true;
tSF_FARP_Gear_Allowed = true;

// Repair settings
tSF_FARP_Repair_Simple = true;
tSF_FARP_Repair_ProportionalMode	= true;	// Should repair time depeneds on damage or always same time
tSF_FARP_Repair_TimeMultiplier	= 10; 		// seconds per 1% if tSF_FARP_RepairProportionalMode is true; overall repair time on false
tSF_FARP_Repair_ResoucesLevel	= -1; 	// limit of the repaired %; if negative - unlimited
tSF_FARP_Repair_NonRepairable	= ["","hitwindshield_1","hitwindshield_2","HitGlass1","HitGlass2","HitGlass3","HitGlass4","HitGlass5","HitGlass6","HitBody","HitHull","HitRGlass","HitLGlass"];

// Refuel settings
tSF_FARP_Refuel_Simple = true;
tSF_FARP_Refuel_ProportionalMode = false;
tSF_FARP_Refuel_TimeMultiplier	= 1;
tSF_FARP_Refuel_ResoucesLevel	= -1;

// Rearm settings
tSF_FARP_Rearm_Simple		= true;
tSF_FARP_Rearm_ProportionalMode	= false;
tSF_FARP_Rearm_TimeMultiplier	= 45;
tSF_FARP_Rearm_ResoucesLevel	= -1;

// Cargo kit renewal
tSF_FARP_Gear_ProportionalMode     = false;
tSF_FARP_Gear_TimeMultiplier       = [ // seconds per 1 item if tSF_FARP_Gear_ProportionalMode is true; otherwise SUM of values is used
    5, // WEAPON_LOAD_TIME
    1, // MAGAZINE_LOAD_TIME
    1, // ITEM_LOAD_TIME
    2  // BACKPACK_LOAD_TIME
];

// Assets
tSF_FARP_Assets_BasicList			= [
    /* [@Item, @CountAddedPerRequest] */
    ["ACE_Wheel", 1],
    ["ACE_Track", 1],
    ["ACE_Banana", 3]
];
tSF_FARP_Assets_AllowPrimayMagazine	= true;
tSF_FARP_Assets_AllowNVG			= true;
tSF_FARP_Assets_AllowRenewKit		= true;
tSF_FARP_Assets_RenewKitTime		= 10;

// Texts
tSF_FARP_STR_ShortName		= "FARP";
tSF_FARP_STR_FullName		= "Forward Arming Refueling Point";

tSF_FARP_STR_NotAllowedText		= "This area is not secured to deploy %1 there. Choose different location.";
tSF_FARP_STR_AlreadySet		= "%1 location was already set (remove previous one to change location).";
tSF_FARP_STR_SuccessSet  		= "%1 will be deployed at selected location";
