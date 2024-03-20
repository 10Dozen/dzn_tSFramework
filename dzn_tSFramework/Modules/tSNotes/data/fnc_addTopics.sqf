#include "script_component.hpp"

/*
    Adds pre-defined topics according to settings.
    (_self)

    Params:
        none.
    Returns:
        nothing
*/

player createDiarySubject [SUBJECT_NAME, SETTING(_self,Title)];
private _topics = [];

// --- Static content topics
if (SETTING(_self,Reports)) then {
    _topics pushBack TOPIC_REPORTS;
};

if (SETTING(_self,ACEMedicine)) then {
    _topics pushBack TOPIC_ACEMEDICINE;
};

if (SETTING(_self,MedEvacRequest)) then {
    _topics pushBack TOPIC_MEDEVAC;
};

if (SETTING(_self,ArtilleryRequest)) then {
    _topics pushBack TOPIC_ARTILLERY;
};

if (SETTING(_self,CASRequest)) then {
    _topics pushBack TOPIC_CAS;
    _topics pushBack TOPIC_CAS6;
};

if (SETTING(_self,RangeFinding)) then {
    _topics pushBack TOPIC_RANGEFINDING;
};

// --- Framework related topics
_topics pushBack (_self call [F(composeFrameworkNotes)]);

// -- Adds topics in reverse order, to draw first one on the top
for "_i" from (count _topics - 1) to 0 step -1 do {
    player createDiaryRecord [SUBJECT_NAME, _topics # _i];
};
