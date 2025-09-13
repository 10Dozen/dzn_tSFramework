#include "script_component.hpp"

/*
    Returns registered component state by it's registered name.
    States are:
        - NOT AVAILABLE
        - INIT
        - FAILED
        - OK

    *Registration is done after component object is created,
    but before initClient/initServer executed.

    (_self)

    Params:
        _componentName (STRING) - name of the component.
    Returns:
        _cob (HASHMAPOBJECT) - component object or NIL.

    _state = tSF_Core_Component call ["fnc_getComponentState", "FARP"];

    Alternative usage - macros: IS_TSF_COMPONENT_ACTIVE("FARP")
*/

params ["_componentName"];

private _enabled = false;
{
    if (_componentName == _x) exitWith { _isEnabled = _y; };
} forEach (_self get Q(Settings));

if (_componentName in [LEGACY_MODULES] || !_enabled) exitWith {
    [COMPONENT_STATUS_DISABLED, COMPONENT_STATUS_OK] select _enabled
};

private _component = _self get Q(Components) get _componentName;
if (isNil "_component") exitWith { COMPONENT_STATUS_DISABLED };

_component getOrDefault ["#status", COMPONENT_STATUS_DISABLED]
