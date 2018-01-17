/*
 *	Dependency:
 *		- Modules/ACEActions
 */
 
 /*
 *	List of Authorized users:
 *		"Admin"			- game admin
 *		@RoleDescription	- all players with appropriate role description
 *		"Any"			- any player
 *
 */
tSF_ArtillerySupport_AuthorizedUsers = [
	"Admin"
	,"Platoon Leader"
	,"Platoon Sergeant"
	,"Командир взвода"
	,"Зам. командира взвода"
	,"FO"
	,"КАО"
];


tSF_ArtillerySupport_initTimeout 				= 0;

tSF_ArtillerySupport_FiremissionPreparationTimeout	= 15;		// Timeout before any shot will be mae\de
tSF_ArtillerySupport_BatteryReloadTime 			= 30*60;	// Timeout for reloading all firemissions

tSF_ArtillerySupport_AdjustFireExpirationTimeout	= 5*30;	// Expirtation Timeout of firemission request during Adjust Fire phase
/*
	@FiremissionsProperties 
	[ @DisplayName, @NumberAvailable, @ListfRounds ]
*/
tSF_ArtillerySupport_FiremissionsProperties = [
	["HE", 6, ["8Rnd_82mm_Mo_shells"]]
	, ["SMK", 9, ["8Rnd_82mm_Mo_Smoke_white"]]
	, ["ILLUM", 9, ["8Rnd_82mm_Mo_Flare_white"]]
];

/*
 *	AI Crew
 */ 
tSF_ArtillerySupport_CrewClassname 	= "B_Soldier_unarmed_F";
tSF_ArtillerySupport_CrewKitname 		= "";