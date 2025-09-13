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
    
    private _presetsOptions = (_self get Q(Presets)) apply {
        format [
            "<br /><font color='#A0DB65'><execute expression='%1 call [""%2"", [%3, %4]]'>%3 м (%4 м)</execute></font>", 
            QCOB,
            F(setViewDistance),
            _x,
            _x * GVAR(Setting_VD_ODRatio)
        ]
    } joinString "";
    
    private _topicContent = [
        format [
            loadFile PATH(thisMODULE,topic_viewDistance,txt),
            QCOB, 
            F(changeViewDistance),
            F(maximizedObjectViewDistance),
            F(saveViewDistance)
        ],
        _presetsOptions,
        format [
            loadFile PATH(thisMODULE,topic_viewDistanceShadows,txt),
            QCOB,
            F(setShadowDistance)
        ]
    ];
    
    _topics pushBack [TOPIC_VIEW_DISTANCE_NAME, _topicContent joinString ""];
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
