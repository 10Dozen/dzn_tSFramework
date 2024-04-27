#include "script_component.hpp"

/*
    Function to be called by remoteExec that redirects call into a specified COB.

    Params:
    _cobName (string) - name of the component which COB should be called.
    _methodName (string) - full name of the COB method (like "fnc_someMethod")
    _args (array) - optional list of arguments to be passed with method. Defaults to [].
    _callback (hashmap) - optional callback information hashmap object
    (declared by tSF_Core_RemoteExecFunctionCallback or tSF_Core_RemoteExecFunctionCallback).


    Return: nothing

    Example:
    ["SomeComponent", "Method", [1,2,3]] remoteExec ["tSF_Core_fnc_CallComponentByRemote", 2];
*/

params ["_cobName", "_methodName", ["_args", []], ["_callback", nil]];

private _cob = ECOB(Core) call [F(getComponentObject), _cobName];
private _result = _cob call [_methodName, _args];

if (isNil "_callback") exitWith {};
_callback call ["executeCallback", [_result]];
