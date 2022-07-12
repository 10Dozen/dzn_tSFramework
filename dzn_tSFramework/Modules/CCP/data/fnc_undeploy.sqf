#include "script_component.hpp"
/*
	Undeploys CCP composition and spawn vehicle instead (the same class as was used in composition).

	Params: none
	Return: none
*/

if (!isServer) exitWith {
	[] remoteExec [QFUNC(undeploy), 2];
};

// Colelct pos/dir data from composition
private _composition = CCP_LOGIC getVariable QGVAR(CompositionObjects);

private _cVehicle = _composition # 0;
private _vehicleClass = typeOf _cVehicle;
private _vehiclePos = getPosWorld _cVehicle;
private _vehicleVectorDirUp = [vectorDir _cVehicle, vectorUp _cVehicle];

// Delete composition
{ deleteVehicle _x } forEach _composition;
CCP_LOGIC setVariable [QGVAR(CompositionObjects), nil, true];

// Remove marker
deleteMarker (CCP_LOGIC getVariable QGVAR(Marker));
CCP_LOGIC setVariable [QGVAR(Marker), nil, true];

// Re-create vehicle
[{
	params ["_vehicleClass", "_vehiclePos", "_vehicleVectorDirUp"];
	private _veh = _vehicleClass createVehicle [0,0,100];

	_veh setPosWorld _vehiclePos;
	_veh setVectorDirAndUp _vehicleVectorDirUp;

	clearWeaponCargoGlobal _veh;
	clearMagazineCargoGlobal _veh;
	clearBackpackCargoGlobal _veh;
	clearItemCargoGlobal _veh;

	// Init deploy action on clients
	[_veh] remoteExec [QFUNC(initDeployAction)];

	(format ["CCP undeployed!", _pos call dzn_fnc_getMapGrid]) remoteExec ["systemChat"];
}, [_vehicleClass, _vehiclePos, _vehicleVectorDirUp]] call CBA_fnc_execNextFrame;
