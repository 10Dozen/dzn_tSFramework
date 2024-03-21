#include "script_component.hpp"

/*
    Adds pre-defined topics according to settings.
    (_self)

    Params:
        0: _view (NUMBER) - view distance.
        1: _objectView (NUMBER) - object view distance.
    Returns:
        nothing
*/

(profileNamespace getVariable [
    PROFILE_VD_VAR,
    [DEFAULT_VIEW_DISTANCE, DEFAULT_OBJECT_VIEW_DISTANCE]
]) params ["_view","_objectView"];

setViewDistance _view;
setObjectViewDistance _objectView;
