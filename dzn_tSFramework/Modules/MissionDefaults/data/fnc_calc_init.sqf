#include "script_component.hpp"

/*
    Inits calculator chat command handlers
*/

if !(_self get Q(Settings) get Q(Calculator) getOrDefault [Q(enable), false]) exitWith {};

["calc", {  GVAR(ComponentObject) call [F(calc_handle), _this]; }, "all"] call CBA_fnc_registerChatCommand;
