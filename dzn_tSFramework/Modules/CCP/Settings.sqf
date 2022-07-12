#include "data\script_component.hpp"

/* Dependency: No
 */

GVAR(TimeToHeal)   = 10;  // Timeout before healed
GVAR(TimeToHold)   = 10;  // Timeout before finishing MediCare cycle
GVAR(HelipadClass) = "Land_HelipadEmpty_F";  // e.g. "Land_HelipadEmpty_F", "Land_HelipadCircle_F", "Land_HelipadSquare_F", "Land_HelipadCivil_F"

// Name of default composition; See 'DefaultCompositions.sqf' for names. Use this if not set via 3DEN Tool
GVAR(CompositionDefault)  = "Civil SUV";
