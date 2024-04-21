#include "script_component.hpp"

/*
    Briefing component creates briefing topics. Also provides roster topic with
    list of the players in the squads.
*/

private _declaration = [
    COMPONENT_TYPE,
    PREP_COMPONENT_SETTINGS,

    PREP_COMPONENT_FUNCTION(init),
    PREP_COMPONENT_FUNCTION(addBriefingTopics),
    PREP_COMPONENT_FUNCTION(initRoster),
    PREP_COMPONENT_FUNCTION(updateRoster),
    PREP_COMPONENT_FUNCTION(formatUnitRosterLine),

    [Q(RosterRecord), diaryRecordNull]
];

COB = createHashMapObject [_declaration];
COB call [F(init)];
