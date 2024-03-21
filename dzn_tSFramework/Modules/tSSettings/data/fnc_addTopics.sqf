#include "script_component.hpp"

/*
    Adds pre-defined topics with settings according to settings.
    (_self)

    Params:
        none.
    Returns:
        nothing
*/

player createDiarySubject [SUBJECT_NAME, SETTING(_self,Title)];
private _topics = [];

// --- Static content topics
if (SETTING(_self,ViewDistance)) then {
    _topics pushBack [
        TOPIC_VIEW_DISTANCE_NAME, format [
            TOPIC_VIEW_DISTANCE_CONTENT,
            QCOB,
            F(changeViewDistance),
            F(maximizeObjectViewDistance),
            F(saveViewDistance),
            F(setViewDistance),
            F(setShadowDistance)
        ]
    ];
};

if (SETTING(_self,TerrainGrid)) then {
    _topics pushBack [
        TOPIC_TARRAIN_GRID_NAME,
        format [
            TOPIC_TARRAIN_GRID_CONTENT,
            QCOB,
            F(setTerrainGrid)
        ]
    ];
};

// -- Adds topics in reverse order, to draw first one on the top
for "_i" from (count _topics - 1) to 0 step -1 do {
    player createDiaryRecord [SUBJECT_NAME, _topics # _i];
};
