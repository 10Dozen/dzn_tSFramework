#include "script_component.hpp"

/*
    Calculates given expression and prints result in hint and system chat.
    (_self)

    Params:
        0: _expression (STRING) - expression typed by player.

    Returns:
        nothing
*/
#define ON_ERROR_CHAT_MSG "[calc] Допустимы только цифры и математические знаки (+-*/.)"
#define CHAT_MSG_TEMPLATE "[calc] %1 = %2"
#define HINT_MSG_TEMPATE "Калькулятор:<br/><t align='right'>%1 =<t><br/><t align='right' size='3'>%2</t>"
#define EXPR_REGEX "^[\s\d\.e()\-+*\/%^]*$"

params ["_expression"];

private _result = "ERROR";
private _msg = ON_ERROR_CHAT_MSG;
if (_expression regexMatch EXPR_REGEX) then {
    _result = call compile _expression;
    _msg = format [CHAT_MSG_TEMPLATE, _expression, _result];
};

systemChat _msg;
hintSilent parseText format [
    HINT_MSG_TEMPATE,
    _expression,
    _result
];
