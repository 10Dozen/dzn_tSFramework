#include "..\script_component.hpp"

#define thisMODULE tSNotes

#define SUBJECT_NAME Q(tSF_NotesPage)

#define GET_TOPIC_CONTENT(X) loadFile PATH(thisMODULE,X,txt)

#define TOPIC_REPORTS ["Отчеты",GET_TOPIC_CONTENT(topic_reports)]
#define TOPIC_ACEMEDICINE ["TCCC",GET_TOPIC_CONTENT(topic_medicine)]
#define TOPIC_MEDEVAC ["Запрос MEDEVAC",GET_TOPIC_CONTENT(topic_medevac)]
#define TOPIC_ARTILLERY ["Запрос Артиллерийского огня",GET_TOPIC_CONTENT(topic_artillery)]
#define TOPIC_ARTILLERY_OPTIONS ["Опции Артиллерийского огня",GET_TOPIC_CONTENT(topic_artillery_options)]
#define TOPIC_CAS ["Запрос CAS (9-Liner)",GET_TOPIC_CONTENT(topic_cas)]
#define TOPIC_CAS6 ["Запрос CAS (6-Liner)",GET_TOPIC_CONTENT(topic_cas6)]
#define TOPIC_RANGEFINDING ["Определение дистанции",GET_TOPIC_CONTENT(topic_rangefinding)]
