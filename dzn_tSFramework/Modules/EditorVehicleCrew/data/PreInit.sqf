#include "script_component.hpp"

__HEADLESS_OR_SERVER__

LOG("Pre-Initialization started");

#define INIT_COMPONENT \
    COMPILE_EXECUTE(COMPONENT_DATA_PATH(Component))

INIT_COMPONENT;

GVAR(ComponentObject) call ["init"];
