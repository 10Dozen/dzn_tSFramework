#include "script_component.hpp"

LOG("Pre-Initialization started");

tSF_Core_RemoteExecCallbackFunction = [
    ["#type", "re_callback_function"],
    ["#create", {
        _this params ["_function", ["_args", []]];
        _self set ["function", _function];
        _self set ["_args", _args];
    }],
    ["executeCallback", {
        if (remoteExecutedOwner == 0) exitWith {};
        private _args = (_self get "args");
        if (!isNil "_this") then { _args = _args + [_this] };
        _args remoteExec [_self get "function", remoteExecutedOwner];
    }]
];

tSF_Core_RemoteExecCallbackCOB = [
    ["#type", "re_callback_cob"],
    ["#create", {
        _this params ["_cobName", "_method", ["_args", []]];
        _self set ["cob", _cobName];
        _self set ["method", _method];
        _self set ["_args", _args];
    }],
    ["executeCallback", {
        if (remoteExecutedOwner == 0) exitWith {};
        private _args = (_self get "args");
        if (!isNil "_this") then { _args = _args + [_this] };
        [
            _self get "cob",
            [_self get "method", _args]
        ] remoteExec [FUNC(CallComponentByRemote), remoteExecutedOwner];
    }]
];

// Initialize public functions
PREP_PUBLIC_FUNCTION(CallComponentByRemote);

INIT_COMPONENT;
