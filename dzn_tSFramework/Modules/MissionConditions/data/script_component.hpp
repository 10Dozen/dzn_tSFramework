#include "..\..\script_macro.hpp"

#define COMPONENT MissionConditions

#define SE__ALL_DEAD__NAME "ALL_DEAD"
#define SE__ALL_DEAD__EXPR { {alive _x} count ([] call BIS_fnc_listPlayers) < 1 }
