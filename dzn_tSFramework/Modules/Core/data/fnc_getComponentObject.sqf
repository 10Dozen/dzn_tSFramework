#include "script_component.hpp"

/*
    Returns registered component object by component's name.
    Component name is case insensitive.

    (_self)

    Params:
        _componentName (STRING) - name of the component to find.

    Returns:
        _componentObject (HASHMAP)

    _cob = tSF_Core_Component call ["fnc_getComponentObject", "FARP"];
*/

(_self get Q(Components)) get (toLower _this);
