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

tSF_AdminTools_RapidArtillery_TargetClass = ["Ares_Module_Behaviour_Create_Artillery_Target"];
tSF_AdminTools_RapidArtillery_ArtillerySettings = [
	["82mm Mortar"	, ["Sh_82mm_AMOS", "Smoke_82mm_AMOS_White", "Flare_82mm_AMOS_White"]]
	, ["105mm Howitzer"	, ["rhs_ammo_m1_he", "Smoke_120mm_AMOS_White", "Flare_82mm_AMOS_White"]]
	, ["152mm Howitzer"	, ["Sh_155mm_AMOS", "Smoke_120mm_AMOS_White", "Flare_82mm_AMOS_White"]]
];

tSF_AdminTools_RapidArtillery_AllowedRounds = ["HE", "SMOKE", "ILLUM"];
