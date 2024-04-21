#include "script_component.hpp"

/*
    Adds briefing topics.

    Params:
        none
    Returns:
        nothing
*/

diag_log "addBriefingTopics";
[] call compileScript [Q(COMPONENT_PATH(tSF_briefing.sqf))];
