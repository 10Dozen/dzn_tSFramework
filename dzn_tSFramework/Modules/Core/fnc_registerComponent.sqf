#include "script_component.hpp"

/*
    Registers component in tSF and in dzn_RCE.
    Registration is done after component object is created, 
    but before initClient/initServer executed.

    (_self)

    Params:
        _componentName (STRING) - name of the component.
        _cob (HASHMAPOBJECT) - component object.
    Returns:
        none

    tSF_Core_Component call ["fnc_isModuleEnabled", "FARP"]; // true

    Alternative usage - macros in Component.sqf: REGISTER_COMPONENT
*/
params ["_componentName", "_cob"];

[_componentName, _cob] call dzn_fnc_registerRCE;

_self get Q(Components) set [_componentName, _cob];
