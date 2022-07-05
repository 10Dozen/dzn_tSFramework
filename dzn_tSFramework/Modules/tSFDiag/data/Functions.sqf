#include "script_component.hpp"

FUNC(ReportFrameworkError) = {
	/*
		Reports error to the RPT file and logs internally for tSF Diagnostics usage.

		Params:
		_component - (string) name of the component where the error occured.
		_type - (string) error type.
		_msg - (string) error message.

		Return:
		none

		["EditorVehicleCrew", "Misconfigured", "Crew failed to mount!"] call tSF_tSFDiag_fnc_ReportFrameworkError;
	*/
	params ["_component", "_type", "_msg"];

	private _log_msg = format ['[%1] (%2) ERROR in [%3]: <%4> - %5', QUOTE(PREFIX), QUOTE(COMPONENT), _component,  _type, _msg];
	diag_log text _log_msg;

	private _timestamped_msg = format ["(%1) %2", CBA_missionTime, _log_msg];

	private _errors = GVAR(ReportedErrors) get _component;
	if (isNil "_errors") then {
		GVAR(ReportedErrors) set [_component, [_timestamped_msg]];
	} else {
		_errors pushBack _timestamped_msg;
	};
};
