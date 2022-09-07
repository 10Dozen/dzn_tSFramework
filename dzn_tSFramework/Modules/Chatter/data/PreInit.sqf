#include "script_component.hpp"

LOG("Pre-Initialization started");

// Clearing controls that may be left from previous game...
{ ctrlDelete _x } forEach (uiNamespace getVariable QGVAR(ControlsBuffer));

INIT_SETTINGS_FILE;
INIT_FUNCTIONS;

__SERVER_ONLY__

GVAR(RadioTalkers) = createHashMap;
[] call FUNC(prepareTalkers);

LOG("Initialized");
