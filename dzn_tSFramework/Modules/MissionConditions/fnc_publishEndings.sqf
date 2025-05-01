#include "script_component.hpp"

/*
    Publishes list of endings name-description pairs to be used by other modules.

    (_self)

    Params:
        none
    Returns:
        _endings (ARRAY) - list of endings in format [@Name(STRING), @Title(STRING), @Description(STRING)]
*/

GVAR(Endings) = SETTING(_self,Conditions) apply {
    [
        _x get Q(name),
        _x getOrDefault [Q(title), Q(name)],
        _x getOrDefault [Q(description), ""]
    ]
};
publicVariable QGVAR(Endings);
