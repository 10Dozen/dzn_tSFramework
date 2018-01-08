tSF_AdminTools_TopicName = "tS Admin Tools";

// List of mission ending and ability to run selected endings
// Can be also called via function:     call tSF_End
tSF_AdminTool_EnableMissionEndings = true;

// List of Gear Assignments Table kits and ability to assign selected endings
tSF_AdminTool_EnableGATTool = true;


/*
 *	Rapid Artillery Screen
 */
tSF_AdminTools_RapidArtillery_Enabled = true;

tSF_AdminTools_RapidArtillery_TargetClass = "Ares_Module_Behaviour_Create_Artillery_Target";
tSF_AdminTools_RapidArtillery_ArtillerySettings = [
	["82mm Mortar"	, ["Sh_82mm_AMOS", "Smoke_82mm_AMOS_White", "Flare_82mm_AMOS_White"]]
	, ["105mm Howitzer"	, ["rhs_ammo_m1_he", "Smoke_120mm_AMOS_White", "Flare_82mm_AMOS_White"]]
	, ["152mm Howitzer"	, ["Sh_155mm_AMOS", "Smoke_120mm_AMOS_White", "Flare_82mm_AMOS_White"]]
];

tSF_AdminTools_RapidArtillery_AllowedRounds = ["HE", "SMOKE", "ILLUM"];

/*

[B Alpha 1-1:1 (10Dozen),"mortar_155mm_AMOS","mortar_155mm_AMOS","Single1","Sh_155mm_AMOS","32Rnd_155mm_Mo_shells",100096: shell.p3d,B Alpha 1-1:1 (10Dozen)]
[B Alpha 1-1:1 (10Dozen),"mortar_155mm_AMOS","mortar_155mm_AMOS","Single1","Smoke_120mm_AMOS_White","6Rnd_155mm_Mo_smoke",100202: shell.p3d,B Alpha 1-1:1 (10Dozen)]
[B Alpha 1-1:1 (10Dozen),"RHS_weap_M119","RHS_weap_M119","Single1","rhs_ammo_m1_he","RHS_mag_m1_he_12",<NULL-object>,B Alpha 1-1:1 (10Dozen)]