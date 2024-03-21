#include "script_component.hpp"

/*
    Returns list of endings based on mission conditions.

    (_self)

    Params:
        none
    Returns:
        _endings (ARRAY) - list of endings in format [@Name(STRING), @Description(STRING)]
*/

SETTING(_self,Conditions) apply {
    [
        _x get Q(name),
        _x getOrDefault [Q(description), ""]
    ]
}
