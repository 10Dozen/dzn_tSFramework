tSF_Support_initTimeout	=	5;

tSF_Support_RTB_CheckTimeout	=	5;

/*
 *	List of Authorized users:
 *		"Admin"		- game admin
 *		@RoleDescription	- all players with appropriate role description
 *		"Any"			- any player
 *
 */
tSF_Support_AuthorizedUsers	= ["Admin","Support Officer"];

/*
 *	Allow authorized units to teleport from tSF_Support_ReturnPoint to their Squad
 */
tSF_Support_AllowTeleport	= false;

/*
 *	Available actions
 */

tSF_Support_ReturnToBase	= true;
tSF_Support_CallIn		= false;
tSF_Support_Teleport		= true;

/*
 *	AI Pilot 
 */
 
tSF_Support_PilotClass 		= "B_helipilot_F";
tSF_Support_PilotKit		= "kit_pilot";