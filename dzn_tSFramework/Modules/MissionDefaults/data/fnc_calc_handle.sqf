#include "script_component.hpp"

/*
    Calculates given expression and print back in hint and system chat.
    (_self)
*/
#define EXPR_REGEX "^[\s\d\.e()\-+*\/%^]*$"

params ["_expression"];

private _result = "ERROR";
private _msg = "[calc] Допустимы только цифры и математические знаки (+-*/.)";
if (_expression regexMatch EXPR_REGEX) then {
    _result = call compile _expression;
    _msg = format ["[calc] %1 = %2", _expression, _result];
};

systemChat _msg;
hintSilent parseText format [
    "Калькулятор:<br/><t align='right'>%1 =<t><br/><t align='right' size='3'>%2</t>",
    _expression,
    _result
];
