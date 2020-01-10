/*
 *	You can change MissionDate to some specific date to override date set in mission editor:
 *		format:		[@Year, @Month, @Day, @Hours, @Minutes] (e.g. [2012, 12, 31, 12, 45])
 */
private _fnc_getRandomHrs = { private _hrs = (_this # 0) + round(random (_this # 1)); if (_hrs  >= 24) then { _hrs = _hrs - 24; }; _hrs };
MissionDate = [
	date select 0
	, date select 1
	, date select 2
	, switch ("par_daytime" call BIS_fnc_getParamValue) do {
		case 0: { [10, 6] call _fnc_getRandomHrs };
		case 1: { [21, 8] call _fnc_getRandomHrs };
		case 2: { round(random 24) };
	}
	, selectRandom [0,10,15,20,25,30,40,45,50]
];

/*
 * Date
 */
setDate MissionDate;
MissionDate = date;
publicVariable "MissionDate";

/*
 *	Weather
 */
if (!isNil "dzn_fnc_setWeather") then {
	("par_weather" call BIS_fnc_getParamValue) spawn dzn_fnc_setWeather;
};


/*
 *	Collect Some Player connection data
 */
PlayerConnectedData = [];
PlayerConnectedEH = addMissionEventHandler ["PlayerConnected", {
	diag_log "Client connected";
	diag_log _this;
	// [ DirectPlayID, getPlayerUID player, name player, @bool, clientOwner ]
	PlayerConnectedData pushBack _this;
	publicVariable "PlayerConnectedData";
}];

/*
 *	Mission custom server code goes here:
 */
