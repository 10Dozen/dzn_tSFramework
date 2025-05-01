#include "script_component.hpp"

/*
    Starts vehicle service on given farp.

    (_self) (ServerSide)

    Params:
        _farpIdx (NUMBER) - id of the FARP.
        _vehicle (OBJECT) - vehicle to service.
        _serviceFlags (NUMBER) - bin flags of [Repair, Refuel, Rearm, Reset Gear] (e.g. 1111 -> 15, 0001 -> 1 - repair only)

    Returns:
        nothing
*/


// Get FARP by IDX
// Check requested service is available (there are any resources left)
//      Calculate service cost for vehicle type
//      Calculate service time
//
// Check vehicle is in FARP zone (incl. Z)
//   and No Crew
//   and Engine Off
// Lock vehicle
// Update FARPs resources level (via setVariable [..., ..., true])
// Update vehicle with "isServiced" var (via setVariable [..., ..., true]) ???
