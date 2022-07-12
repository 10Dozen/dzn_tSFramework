#include "script_component.hpp"
/*
	Stops handlers and clears markers on the end of the briefing.
	Should be executed only on clients.

	Params: none
	Return: none
*/

// Unset handlers
removeMissionEventHandler ["MarkerCreated", GVAR(markerCreatedHandler)];
removeMissionEventHandler ["MarkerDeleted", GVAR(markerDeletedHandler)];

// Remove all markers (it will be recreated on server)
deleteMarker GVAR(DefaultMrk);
{ deleteMarker _x } forEach GVAR(AllowedZonesMarkers);
deleteMarker (CCP_LOGIC getVariable [QGVAR(Marker), nil]);
