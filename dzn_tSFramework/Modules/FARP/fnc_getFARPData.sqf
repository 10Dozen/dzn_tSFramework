#include "script_component.hpp"

/*
    Returns FARP data:
    - Current vehicles in service and reamining time

    (_self) (ServerSide)

    Params:
        _farpIdx (NUMBER) - id of the FARP.

    Returns:
        nothing
*/

params ["_farpID"];
DEBUG_1("Params: %1", _this);

private _farp = (_self get Q(FARPs)) select _farpID;
private _logic = _farp get Q(Logic);

// -- Scan vehicles in FARP area:
// --
// -- Add to list with [_object(obj), _isServiced(bool), _originalServiceTime(seconds), _serviceTimeLeft(seconds)]



// -- Return list of services vehicles and stuff
(_self get Q(VehiclesInArea))
