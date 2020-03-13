#include "data\script_component.hpp"

/*
 *	Platoon Operational Markers (POM)
 *
 *	Local opartional markers (squads) for Platoon Leaders for additional mission control. 
 *
 *	Dependency:
 *		- Modules/Authorization
 */

GVAR(TopicName) = "tSF Operational Markers";
GVAR(GenerateMarkersFromGroups)	= true;

/*
 *	Preferences
 */
GVAR(InfantryMarker) = "b_inf";
GVAR(VehicleMarker) = "b_armor";
GVAR(InfantryLabels) = ["", "FT", "SQ", "Static"];
GVAR(VehicleLabels) = ["", "Car", "APC", "IFV", "Tank"];
