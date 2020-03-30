#include "data\script_component.hpp"

/* Dependency:
 *    - Modules/Authorization
 *    - Modules/ACEActions
 */

GVAR(initTimeout) = 5;
GVAR(initCondition) = { true }; // Overall condition of module init

/* Allow authorized units to teleport from tSF_AirborneSupport_ReturnPoint to their Squad
 */
GVAR(AllowTeleport) = true;

/* Available actions
 */
GVAR(ReturnToBase) = true;
GVAR(CallIn) = true;
GVAR(RequestPickup) = true;

GVAR(CallIn_MinDistance) = 100; // meters
GVAR(Handler_CheckTimeout) = 3; // seconds

/* Vehicle availabness options
 */
GVAR(DamageLimit) = 0.75;
GVAR(FuelLimit) = 0.15;

/* Requires LR radio
 */
GVAR(RequiredLRRadio) = true;

/* AI Pilot
 */
GVAR(PilotClass) = "B_helipilot_F";
GVAR(PilotKit) = "";
