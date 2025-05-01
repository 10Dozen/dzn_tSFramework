#include "script_component.hpp"

/*
    FARP component handles:
    - FARP location seletion
    - FARP composition creation
    - FARP Menu handling
    - Servicing

    tSF 3DEN Tool handles some default compositions info
*/

private _declaration = [
    COMPONENT_TYPE,
    PREP_COMPONENT_SETTINGS,

    PREP_COMPONENT_FUNCTION(initServer),
    PREP_COMPONENT_FUNCTION(processLogics),
    PREP_COMPONENT_FUNCTION(handleBriefing),
    PREP_COMPONENT_FUNCTION(handleMissionStart),

    PREP_COMPONENT_FUNCTION(initClient),
    PREP_COMPONENT_FUNCTION(accessFARP),
    PREP_COMPONENT_FUNCTION(openMenu),

    [Q(FARPs), []],
    [Q(BriefingHandlerEH), -1],

    [Q(Compositions), []], // -- Compositions types

    [Q(FARPObjectDeclaration), [
        ["#type", "IFARP"],
        [Q(Logic), objNull],
        [Q(Name), ""],
        [Q(Config), nil],
        [Q(Composition), ""],
        [Q(Classes), []],
        [Q(SyncedObjects), []],
        [Q(Marker), ""],
        [Q(AreaMarkers), []],
        [Q(MarkerLastPosition), []]
    ]]
];

// Init:
COB = CREATE_AND_REGISTER_COMPONENT(_declaration);
COB call [F(initClient)];
COB call [F(initServer)];
