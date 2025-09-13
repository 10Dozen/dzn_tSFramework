#include "script_component.hpp"

/*
    Adds pre-defined topics according to settings.
    (_self)

    Params:
        none.
    Returns:
        nothing
*/

private _settings = COMPONENT_SETTINGS;

player createDiarySubject [SUBJECT_NAME, _settings get Q(Title)];
private _topics = [];

// --- Static content topics
if (_settings get Q(Reports)) then {
    _topics pushBack TOPIC_REPORTS;
};

if (_settings get Q(ACEMedicine)) then {
    _topics pushBack TOPIC_ACEMEDICINE;
};

if (_settings get Q(MedEvacRequest)) then {
    _topics pushBack TOPIC_MEDEVAC;
};

if (_settings get Q(ArtilleryRequest)) then {
    _topics pushBack TOPIC_ARTILLERY;
};
if (_settings get Q(ArtilleryOptions)) then {
    _topics pushBack TOPIC_ARTILLERY_OPTIONS;
};

if (_settings get Q(CASRequest)) then {
    _topics pushBack TOPIC_CAS;
    _topics pushBack TOPIC_CAS6;
};

if (_settings get Q(RangeFinding)) then {
    _topics pushBack TOPIC_RANGEFINDING;
};

// --- Framework related topics
_topics pushBack (_self call [F(composeFrameworkNotes)]);

// -- Adds topics in reverse order, to draw first one on the top
for "_i" from (count _topics - 1) to 0 step -1 do {
    player createDiaryRecord [SUBJECT_NAME, _topics # _i];
};
