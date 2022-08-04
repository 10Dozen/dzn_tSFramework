#include "script_component.hpp"

// Public functions
PREP(SendMessageOverLRRadio);
PREP(SendMessageOverSWRadio);
PREP(sendMessageOverRadio);
PREP(Say);
PREP(Shout);
PREP(Whisper);

// Non-public functions
PREP(showMessageOverRadio);
PREP(showMessageLocally);

// Utils
PREP(MessageRenderer);
PREP(prepareTalkers);
PREP(createVirtualRadioTalker);
PREP(registerUnitAsRadioTalker);
PREP(getRadioTalkerByCallsign);
PREP(createDummy);
PREP(getInVehicleIsolationCoef);
PREP(addNoise);
