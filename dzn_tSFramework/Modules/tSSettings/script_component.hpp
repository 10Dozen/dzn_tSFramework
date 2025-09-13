#include "..\script_component.hpp"

#define thisMODULE tSSettings

#define SETTING_CATEGORY "Дальность видимости"

#define PROFILE_VD_VAR QGVAR(ViewDistance)
#define SUBJECT_NAME Q(tSF_NotesSettingsPage)

#define DEFAULT_VIEW_DISTANCE 3000
#define DEFAULT_OBJECT_VIEW_DISTANCE 2600

#define MAX_VIEW_DISTANCE 20000
#define MIN_VIEW_DISTANCE 500

#define MAX_OBJ_VIEW_DISTANCE 15000
#define MIN_OBJ_VIEW_DISTANCE 300

#define UPDATE_TIMEOUT 0.3


#define TOPIC_VIEW_DISTANCE_NAME "Дальность видимости"
#define TOPIC_TARRAIN_GRID_NAME "Детализация ландшафта"

#define GET_TOPIC_CONTENT(X) loadFile PATH(thisMODULE,X,txt)
#define TOPIC_VIEW_DISTANCE_CONTENT GET_TOPIC_CONTENT(topic_viewDistance)
#define TOPIC_TARRAIN_GRID_CONTENT GET_TOPIC_CONTENT(topic_terrainGrid)
