/*
 *	Dependency:
 *		- Modules/Authorization
 *		- Modules/ACEActions
 */
tSF_ArtillerySupport_initTimeout   = 0;
tSF_ArtillerySupport_initCondition = { true }; // Overall condition of module init

tSF_ArtillerySupport_FiremissionPreparationTimeout	= 15; // Timeout before any shot will be mae\de
tSF_ArtillerySupport_BatteryReloadTime 			= 30*60; // Timeout for reloading all firemissions
tSF_ArtillerySupport_AdjustFireExpirationTimeout	= 5*30;	// Expirtation Timeout of firemission request during Adjust Fire phase

/*
 *	AI Crew
 */ 
tSF_ArtillerySupport_CrewClassname 	= "B_Soldier_unarmed_F";
tSF_ArtillerySupport_CrewKitname 	= "";

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
 *	[
 *		@Artillery Battery confign name
 *		, [ @DisplayName, @NumberAvailable, @RoundClassname ] // Magazines map
 *		, [ @MinRange, @MaxRange ] // Range limits
 *		, [ @MinRangeETA, @MaxRangeETA ] // ETA min and max
 *		, @NumberOfGuns // Number of guns in battery
 *		, @ShotReloadTime // Time between shots, seconds
 *	]
 *
 *	Magazines map:
 *		@DisplayName -- name displayed in Request Firemission screen <STRING>
 *		@NumberAvailable -- number of firemissions available, -1 means not avaialble and no reloading needed <NUMBER>
 *		@RoundClassnames -- classname of round magazine <STRING>
 */
#define HE_RNDS(X,Y) ["HE",X,Y]
#define SMK_RNDS(X,Y) ["SMK",X,Y]
#define ILLUM_RNDS(X,Y) ["ILLUM",X,Y]

tSF_ArtillerySupport_VirtualFiremissionsProperties = [
	[
		"82mm Mortar"
		, [HE_RNDS(2,"8Rnd_82mm_Mo_shells"), SMK_RNDS(9,"8Rnd_82mm_Mo_Smoke_white"), ILLUM_RNDS(9,"8Rnd_82mm_Mo_Flare_white")]
		, [300, 4000]
		, [25, 50]
		, 3
		, 6
	]
	,[
		"155mm Howitzer"
		, [HE_RNDS(6,"32Rnd_155mm_Mo_shells"), SMK_RNDS(9,"6Rnd_155mm_Mo_smoke"), ILLUM_RNDS(-1,"")]
		, [400, 24000]
		, [25, 120]
		, 3
		, 6
	]
	,[
		"MRLS"
		,[HE_RNDS(6,"12Rnd_230mm_rockets"), ["CLUSTER",2,"12Rnd_230mm_rockets"], ILLUM_RNDS(-1,"")]
		, [700, 24000]
		, [25, 80]
		, 3
		, 1
	]
	,[
		"105mm Howitzer"
		, [HE_RNDS(2,"8Rnd_82mm_Mo_shells"), SMK_RNDS(9,"8Rnd_82mm_Mo_Smoke_white"), ILLUM_RNDS(9,"8Rnd_82mm_Mo_Flare_white")]
		, [300, 12000]
		, [25, 60]
		, 3
		, 6
	]
];
