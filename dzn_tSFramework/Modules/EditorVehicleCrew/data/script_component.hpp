#include "..\..\script_macro.hpp"

#define COMPONENT EditorVehicleCrew

#define EVC_GAMELOGIC_FLAG QUOTE(tSF_EVC)

#define CREW_CONFIG_TABLE GVAR(CrewConfig) = createHashMapFromArray [
#define CREW_CONFIG_TABLE_END ];
#define OPFOR_CREW_CONFIG_DEFAULT GVAR(OPFOR_Side),GVAR(OPFOR_CrewSkill),GVAR(OPFOR_CrewKit),GVAR(OPFOR_HoldType)


#define Q(X) #X
#define F(X) fnc_##X
#define cob_FUNC(NAME) Q(F(NAME))
