/*
	TODO:
	-- Delay between rounds for virtual firemission is not working

*/

/*
 *	Dependency:
 *		- Modules/Authorization
 *		- Modules/ACEActions
 */
tSF_ArtillerySupport_initTimeout 			= 0;

tSF_ArtillerySupport_FiremissionPreparationTimeout	= 15;		// Timeout before any shot will be mae\de
tSF_ArtillerySupport_BatteryReloadTime 			= 30*60;	// Timeout for reloading all firemissions

tSF_ArtillerySupport_AdjustFireExpirationTimeout	= 5*30;	// Expirtation Timeout of firemission request during Adjust Fire phase
/*
 *	Firemissions properties 
 *	[ @DisplayName, @NumberAvailable, @RoundClassnames ]
 */
tSF_ArtillerySupport_FiremissionsProperties = [
	["HE", 2, ["8Rnd_82mm_Mo_shells", "rhs_mag_3vo18_10"]]
	, ["SMK", 9, ["8Rnd_82mm_Mo_Smoke_white", "rhs_mag_d832du_10"]]
	, ["ILLUM", 9, ["8Rnd_82mm_Mo_Flare_white", "rhs_mag_3vs25m_10"]]
];

/*
	Sholef: 
		"32Rnd_155mm_Mo_shells","4Rnd_155mm_Mo_guided","6Rnd_155mm_Mo_mine","2Rnd_155mm_Mo_Cluster","6Rnd_155mm_Mo_smoke","2Rnd_155mm_Mo_LG","6Rnd_155mm_Mo_AT_mine"
	2S9 Sochor: 
		"32Rnd_155mm_Mo_shells_O","2Rnd_155mm_Mo_guided_O","6Rnd_155mm_Mo_mine_O","2Rnd_155mm_Mo_Cluster_O","6Rnd_155mm_Mo_smoke_O","4Rnd_155mm_Mo_LG_O","6Rnd_155mm_Mo_AT_mine_O"
	MRLS Seara, KAMAZ MRLS:
		"12Rnd_230mm_rockets"
*/

/*
 *	Virtual artillery rounds by type, in format:
 *	[@Artillery Battery confign name, [@MinRangge,@MaxRange], [ @DisplayName, @NumberAvailable, @RoundClassnames ]]
 *
 *	@NumberAvailable = -1 means not avaialble and no reloading needed
 */
#define HE_RNDS(X,Y) ["HE",X,Y]
#define SMK_RNDS(X,Y) ["SMK",X,Y]
#define ILLUM_RNDS(X,Y) ["ILLUM",X,Y]

tSF_ArtillerySupport_VirtualFiremissionsProperties = [
	["82mm Mortar", [300, 4000], [HE_RNDS(2,"8Rnd_82mm_Mo_shells"), SMK_RNDS(9,"8Rnd_82mm_Mo_Smoke_white"), ILLUM_RNDS(9,"8Rnd_82mm_Mo_Flare_white")]]
	,["155mm Howitzer", [400, 24000], [HE_RNDS(6,"32Rnd_155mm_Mo_shells"), SMK_RNDS(9,"6Rnd_155mm_Mo_smoke"), ILLUM_RNDS(-1,"")]]
	,["MRLS", [700, 24000],[HE_RNDS(6,"12Rnd_230mm_rockets"), SMK_RNDS(-1,""), ILLUM_RNDS(-1,"")]]
	,["105mm Howitzer", [200, 12000],[]]
];

// Default ETA in seconds for min range (~300m) and max range (4000)
tSF_ArtillerySupport_VirtualFiremissionsMinETA = 25;
tSF_ArtillerySupport_VirtualFiremissionsMaxETA = 50;

// Guns per battery
tSF_ArtillerySupport_VirtualFiremissionsGunsCount = 1;

/*
 *	AI Crew
 */ 
tSF_ArtillerySupport_CrewClassname 	= "B_Soldier_unarmed_F";
tSF_ArtillerySupport_CrewKitname 	= "";
