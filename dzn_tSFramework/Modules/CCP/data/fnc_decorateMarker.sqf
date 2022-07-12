#include "script_component.hpp"

/*
	Updates given marker and sets proper decoration to it

	Params:
	_marker - (marker) marker to decorate

	Return: none
*/

params ["_marker"];

_marker setMarkerTextLocal QUOTE(STR_SHORT_NAME);
_marker setMarkerTypeLocal MRK_ICON;
_marker setMarkerColorLocal MRK_COLOR;
_marker setMarkerAlpha 1;
