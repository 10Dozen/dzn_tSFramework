#include "script_component.hpp"

LOG("Pre-Initialization started");

if (isNil QUOTE(CCP_LOGIC)) exitWith {
	TSF_ERROR(TSF_ERROR_TYPE__MISSING_ENTITY, "CCP is not set in the Editor!");
};

INIT_SETTING;
INIT_FUNCTIONS;
INIT_FILE(data,Compositions);

INIT_SERVER;
INIT_CLIENT;
