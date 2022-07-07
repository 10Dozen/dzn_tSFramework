#include "script_component.hpp"

LOG("Pre-Initialization started");

INIT_SETTING;
INIT_FUNCTIONS;

__SERVER_ONLY__

GVAR(RadioTalkers) = createHashMap;
[] call FUNC(prepareTalkers);

LOG("Initialized");
