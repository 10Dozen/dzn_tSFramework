#include "data\script_component.hpp"

/* Dependency: No
 */

// Delay before initializations
GVAR(initTimeout)     = 5;
GVAR(initCondition)   = { true };

/*
 * Allows to override existing vehicles 'Isolated' property by applying value from the module's config.
 * On TRUE -- always overrides Isolated parameters of vehicle by module's config
 * On FALSE -- do not override Isolated parameters if vehicle class already has TFAR LR radio (and actual isolated settings)
 */
GVAR(OverrideIsolatedConfigValue) = false;

 /*
 * Radio Configs
 *
 * Add TFAR radio for vehicles synced with ERS GameLogic. Config in format
 *    [ @ConfigName, [ @Side, @LR_Class, @LR_Range, @VehicleIsolatedCoef] ]
 *    see https://github.com/michail-nikolaev/task-force-arma-3-radio/wiki/API%3A-Variables
 *
 *    @ConfigName (string) - some unique name of the config.
 *    @Side (side) - side to apply config too
 *    @LR_Class (string) -- classname of the radio to apply (see TFAR wiki for details)
 *    @LR_Range (number) -- range of radio transmit/receive, in meters
 *    @VehicleIsolatedCoef (number) -- coef of vehicle isolation from 0 (open) to 1 (closed),
 *    affects outside/inside voices while in vehicle/outside.
 */

LR_RADIO_CONFIG_TABLE

	["BLUFOR",  [west, BLUFOR_LR_CLASS, 30000, 0.5]]
	,["OPFOR",  [east, OPFOR_LR_CLASS, 30000, 0.5]]
	,["INDEP",  [resistance, INDEP_LR_CLASS, 30000, 0.5]]

	/*
        Custom config example:
        ,[
            "MyCustomConfig", // config name
            [
                west, // side
                "TFAR_anarc210", // long range radio class to use
                50000, // long range radio distance (in meters)
                0.8 // vehicle isolated coeficeint (how hard it reduces voices from outside)
            ]
         ]
	*/

LR_RADIO_CONFIG_TABLE_END
