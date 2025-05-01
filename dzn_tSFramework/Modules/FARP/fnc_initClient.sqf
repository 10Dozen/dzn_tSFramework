#include "script_component.hpp"

/*
    Initialize Component Object and it's features.
    (_self)

    Params: none
    Returns:
        nothing
*/

__CLIENT_ONLY__
__EXIT_ON_SETTINGS_PARSE_ERROR__

params ["_farpsLogics"];
DEBUG_1("Params: %1", _this);

LOG("Client init started");

// -- Locally process logics and generate FARP objects
_self call [F(processLogics), [_farpsLogics, false]];
{
    private _farpIdx = _forEachIndex;
    // -- Add actions to FARP compositions
    ((synchronizedObjects _x) select {_x getVariable [OBJECT_INTERACTIBLE_FLAG, false]}) apply {
        _x addAction [
            "<t color='#9bbc2f' size='1.2'>FARP</t>",
            { COB call [F(accessFARP), _arguments]; },
            [_farpIdx],
            8, true, true, "", "true", 6
        ];
    };
} forEach _farpsLogics;

SET_COMPONENT_STATUS_OK(_self);
LOG("Client initialized");
