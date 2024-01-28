#include "script_component.hpp"

if (!isServer) exitWith {};
LOG("Pre-Initialization started");

INIT_SETTING;
INIT_FUNCTIONS;

INIT_SERVER;
