#include "script_component.hpp"

/*
    Remote Exec component object's method.
    If _callback hashMap object passed -- executes it's callback with target = remoteExecutedOwner.

    _target:
      0 -- all machines;
      2 -- server only;
      -2 -- all clients except server;

    (_self)

    Params:
        _componentName (STRING) - name of the component to exec.
        _methodName (STRING) - name of the method to execute.
        _args (ANY) - optional, list of arguments.
        _targets (NUMBER or ARRAY or OBJECT) - target for remote exec (see https://community.bistudio.com/wiki/remoteExec).
        _callback (HASHMAP OBJECT) - optional, optional remote exec callback hashmap object
        (declared by tSF_Core_RemoteExecFunctionCallback or tSF_Core_RemoteExecCallbackCOB).

    Returns:
       nothing

    tSF_Core_Component call ["fnc_remoteExecComponent",
        [
            "FARP",
            "fnc_doStuff",
            [1,2,3],
            2,
            createHashMapObject [tSF_Core_RemoteExecFunctionCallback, ["hint", ["Stuff is done!"]]]
        ]
    ];
*/

params ["_componentName", "_methodName", ["_args", []], ["_targets", 0], ["_callback", nil]];

DEBUG_1("(remoteExecComponent) Params: %1", _this);

private _payload = [_componentName, _methodName, _args];
if (!isNil "_callback") then { _payload pushBack _callback; };

_payload remoteExec [QFUNC(CallComponentByRemote), _targets];
