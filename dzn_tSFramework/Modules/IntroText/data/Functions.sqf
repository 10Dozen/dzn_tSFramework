#include "script_component.hpp"

FUNC(ShowIntroText) = {
	params ["_linesData","_showTimelabel","_textPosition","_displayTime"];

	private _lines = [];
	for "_i" from 1 to 3 do {
		(_linesData # (_i - 1)) params ["_lineText","_lineStyle"];

		// Skip if line is empty
		if (_lineText != "") then {
			if (_i == 1) then {
				if (_lineText == LINE1_DEFAULT) then {
					_lineText = format [
						_lineText
						, STR_DATE(MissionDate # 2) 
						, STR_DATE(MissionDate # 1)
						, MissionDate # 0
					];
				};

				if (_showTimelabel) then {
					_lineText = ([MissionDate # 3 + (MissionDate # 4)/60, "HH:MM"] call BIS_fnc_timeToString) + " " + _lineText;
				};

				_lines pushBack [_lineText, _lineStyle];
			} else {
				// Skip if lines are default text
				if (LINES_DEFAULT findIf {_lineText == _x} < 0) then {
					_lines pushBack [_lineText, _lineStyle];
				};
			};
		};
	};

	if (_lines isEqualTo []) exitWith { /* No lines - exit... */ };

	// Adds display timeout to last line
	(_lines select (count _lines - 1)) pushBack (_displayTime * 10);

	[
		_lines
		, _textPosition # 0, _textPosition # 1
	] spawn BIS_fnc_typeText;
};
