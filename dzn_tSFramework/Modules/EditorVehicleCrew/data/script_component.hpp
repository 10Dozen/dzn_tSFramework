#include "..\..\script_macro.hpp"

#define COMPONENT EditorVehicleCrew

#define CREW_CONFIG_TABLE GVAR(CrewConfig) = createHashMapFromArray [
#define CREW_CONFIG_TABLE_END ];
#define OPFOR_CREW_CONFIG_DEFAULT GVAR(OPFOR_Side),GVAR(OPFOR_CrewSkill),GVAR(OPFOR_CrewKit),GVAR(OPFOR_HoldType)
