#include "script_component.hpp"

/*
    Module that draws LR/SW radio message on screen.
    Starts loop that processes 2 queues of messages (for LR or SW) and allows to add messages into the queue.
    Once added - each message transits through several states (displayed, hidden, removed) and after some timeout - removes from queue.

    Available methods to invoke and their params:
    - Show
      Add message to queque and then draw it on screen.
      Params:
        _type - (string) 'LR' for long-range or 'SW' for short-range radio.
        _title - (string) callsign or name of the caller to display.
        _msg - (string) message to display.
        _ttl - (number) time to display message. Optional, default 7 seconds.

    - Hide
      Marks all messages as expired and hide it from the screen.
      Params: none

    - Clear
      Hides all displayed messages and empties message queues.
      Params:
       _immediate - (boolean) if true - drops queue and removes controls in the same frame, otherwise - only marks all messages in queue to be deleted by main loop.

    Params:
    _method - (string) name of the method to invoke. See above.
    _params - (any) params of the selected method.

    Return:
    Nothing

    Example:
    ["Show", ["LR", "Bird-1-1", "This is Bird-1-1, apporaching LZ. Over.", 7]] call tSF_Chatter_fnc_MessageRenderer
*/

#include "MessageRenderer.h"

params ["_method", ["_params", []]];

DEBUG_1("Params: %1", _this);

if (toUpper _method == "REINIT") then {
    LOG("Re-initializing");
    [self_GET(PFH)] call CBA_fnc_removePerFrameHandler;
    removeMissionEventHandler ["Ended", self_GET(MissionEndHandler)];
    SELF = nil;
};

// Invoke method
if (!isNil QSELF) exitWith {
     LOG("Instance exists. Invoking selected method");
    _params call (SELF get toUpper _method);
};

// Initialize object
DEBUG_1("No instance exists. Initializing %1 object", QSELF);
SELF = createHashMapFromArray [
    self_PREP(show)
    , self_PREP(hide)
    , self_PREP(clear)
    , self_PREP(createControls)
    , self_PREP(addToQueue)
    , self_PREP(removeFromQueue)
    , self_PREP(handleMainLoop)
    , self_PREP(transitToState)
    , self_PREP(animateAppear)
    , self_PREP(animateHide)
    , self_PREP(animateBlur)

    , [toUpper "ID", 0]
    , [toUpper "Queue", []]

    , [toUpper "PFH", [{ [] call self_FUNC(handleMainLoop) }, nil, PFH_DELAY] call CBA_fnc_addPerFrameHandler]
    , [toUpper "MissionEndHandler", addMissionEventHandler ["Ended", {
        LOG("(Renderer.OnMissionEnded) Clearing...");
        [] call self_FUNC(Clear);
        self_GET(PFH) call CBA_fnc_removePerFrameHandler;
    }]]
];

// Buffer of created controls in the session
uiNamespace setVariable [QGVAR(ControlsBuffer), []];

// Invoke selected method from initial params:
DEBUG_2("Invoking method '%1' with params %2", toUpper _method, _params);
_params call (SELF get toUpper _method);
