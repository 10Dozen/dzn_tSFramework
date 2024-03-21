#include "script_component.hpp"

/*
    Restores previously saved view distance setting.
    (_self)

    Params:
        none
    Returns:
        nothing
*/

(profileNamespace getVariable [
    PROFILE_VD_VAR,
    [DEFAULT_VIEW_DISTANCE, DEFAULT_OBJECT_VIEW_DISTANCE]
]) params ["_view","_objectView"];

setViewDistance _view;
setObjectViewDistance _objectView;
