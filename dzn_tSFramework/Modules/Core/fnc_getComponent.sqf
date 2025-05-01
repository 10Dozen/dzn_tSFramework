#include "script_component.hpp"

/*
    Returns registered component by it's registered name.
    Registration is done after component object is created, 
    but before initClient/initServer executed.

    (_self)

    Params:
        _componentName (STRING) - name of the component.
    Returns:
        _cob (HASHMAPOBJECT) - component object or NIL.

    _farpCob = tSF_Core_Component call ["fnc_getComponent", "FARP"];

    Alternative usage - macros in Component.sqf: TSF_COMPONENT(FARP)
*/

params ["_componentName"];

_self get Q(Components) get _componentName
