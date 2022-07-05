#include "script_component.hpp"

LOG("Pre-Initialization started");

INIT_FUNCTIONS;

GVAR(ReportedErrors) = createHashMap;
