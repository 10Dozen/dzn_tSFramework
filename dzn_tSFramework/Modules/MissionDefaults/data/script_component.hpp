#include "..\..\script_macro.hpp"


#define COMPONENT MissionDefaults

#define Q(X) #X
#define FNC_WRAP(X) fnc_##X
#define F(NAME) Q(FNC_WRAP(NAME))

#define INIT_COMPONENT \
    COMPILE_EXECUTE(COMPONENT_DATA_PATH(Component));\

#define Component_Setting_Init(SELF,NAME) (SELF get "Settings" get "Init" get Q(NAME))
#define COMPONENT_FNC_PATH(FILE) MAINPREFIX\SUBPREFIX\COMPONENT\data\fnc_##FILE##.sqf
#define PREP_COMPONENT_FUNCTION(NAME) \
    [F(NAME), compileScript [QUOTE(COMPONENT_FNC_PATH(NAME))]]



#define PHONETIC_ABC_WILDCARD "$"
#define NUMERIC_WILDCARD "#"

// [min/base, othersMax, totalMax(inclusive)]
#define NUMERIC_RANGES_3 [100, 10, 210]
#define NUMERIC_RANGES_2 [10, 9, 24]
#define NUMERIC_RANGES_1 [1, 9, 9]
