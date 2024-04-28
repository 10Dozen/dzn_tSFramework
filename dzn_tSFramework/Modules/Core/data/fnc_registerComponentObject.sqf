#include "script_component.hpp"

/*
    Registers component object under it's component name.
    Module name is case insensitive.

    (_self)

    Params:
        _componentName (STRING) - name of the component to register.
        _componentObject (HASHMAP) - COB itself.

    Returns:
        nothing

    tSF_Core_Component call ["fnc_registerComponentObject", ["FARP", tSF_FARP_Component]];
*/

params ["_componentName", "_componentObject"];

(_self get Q(Components)) set [toLower _componentName, _componentObject];
