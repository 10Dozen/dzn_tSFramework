#include "script_component.hpp"

LOG("Pre-Initialization started");

// Initialize public functions
PREP_PUBLIC_FUNCTION(Say);
PREP_PUBLIC_FUNCTION(Shout);
PREP_PUBLIC_FUNCTION(Whisper);
PREP_PUBLIC_FUNCTION(SendMessageOverLRRadio);
PREP_PUBLIC_FUNCTION(SendMessageOverSWRadio);

// Initialize component
INIT_COMPONENT;
