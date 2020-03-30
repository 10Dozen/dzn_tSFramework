#include "script_component.hpp"

LOG("Server init started");

GVAR(CommonPermissions) = [false, false, false];
GVAR(RuleList) apply { 
	if (toLower (_x # 0) == "any") then {
		GVAR(CommonPermissions) = _x # 1;
	};

	[toLower (_x # 0), _x # 1]
};

GVAR(Initialized) = true;

publicVariable QGVAR(CommonPermissions);
publicVariable QGVAR(RuleList);
publicVariable QGVAR(Initialized);

LOG("Server initialized");