if (!isNil "dzn_fnc_setWeather") then {
	  ("par_weather" call BIS_fnc_getParamValue) spawn dzn_fnc_setWeather;
};
