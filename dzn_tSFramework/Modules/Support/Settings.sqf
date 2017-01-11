/*
 *	Dependency:
 *		- Modules/InteractivesACE
 */

tSF_Support_initTimeout	=	5;

/*
 *	List of Authorized users:
 *		"Admin"			- game admin
 *		@RoleDescription	- all players with appropriate role description
 *		"Any"			- any player
 *
 */
tSF_Support_AuthorizedUsers	= ["Admin","Platoon Sergeant","Зам. командира взвода","Support Officer"];

/*
 *	Allow authorized units to teleport from tSF_Support_ReturnPoint to their Squad
 */
tSF_Support_Teleport			= true;

/*
 *	Available actions
 */

tSF_Support_ReturnToBase		= true;
tSF_Support_CallIn			= true;
tSF_Support_RequestPickup		= true;

tSF_Support_CallIn_MinDistance	= 300; // meters

tSF_Support_Handler_CheckTimeout	= 3; // seconds
 
/*
 *	Vehicle availabness options
 */
 
tSF_Support_DamageLimit			= 0.75;
tSF_Support_FuelLimit			= 0.15;
// tSF_Support_AllowBaseRefuel		= false;


/*
 *	AI Pilot 
 */
 
tSF_Support_PilotClass 		= "B_helipilot_F";
tSF_Support_PilotKit			= "";
