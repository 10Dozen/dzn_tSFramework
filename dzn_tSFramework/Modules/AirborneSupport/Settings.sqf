/*
 *	Dependency:
 *		- Modules/Authorization
 *		- Modules/ACEActions
 */

tSF_AirborneSupport_initTimeout		= 5;
tSF_AirborneSupport_initCondition = { true }; // Overall condition of module init

/*
 *	Allow authorized units to teleport from tSF_AirborneSupport_ReturnPoint to their Squad
 */
tSF_AirborneSupport_Teleport		= true;

/*
 *	Available actions
 */
tSF_AirborneSupport_ReturnToBase		= true;
tSF_AirborneSupport_CallIn			= true;
tSF_AirborneSupport_RequestPickup		= true;

tSF_AirborneSupport_CallIn_MinDistance = 300; // meters
tSF_AirborneSupport_Handler_CheckTimeout = 3; // seconds

/*
 *	Vehicle availabness options
 */

tSF_AirborneSupport_DamageLimit		= 0.75;
tSF_AirborneSupport_FuelLimit		= 0.15;

/*
 *	AI Pilot
 */

tSF_AirborneSupport_PilotClass 		= "B_helipilot_F";
tSF_AirborneSupport_PilotKit		= "";
