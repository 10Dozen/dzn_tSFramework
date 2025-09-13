/*
 *	Дата
 *
 *  Дата устанавливается с учетом выбранного времени в настройках миссии в лобби,
 *  а также с небольшой рандомизацией времени (+- час).
 *
 *  Вы можете указать конкретную дату без рандомизации:
 *  - массив вида [2021, 12, 31, 12, 45] (формат [YYYY,MM,DD,HH,mm])
 *  - команда `date` (вернет дату выставленную в редакторе)
 */
private _date = [
    date,
    "par_daytime" call BIS_fnc_getParamValue,
    ["day","night","morning","midday","evening","midnight","random"]
] call dzn_fnc_randomizeTime;

setDate _date;
MissionDate = date;
publicVariable "MissionDate";

/*
 *	Погода
 *  --
 *  Устанавливает погоду согласно настройке миссии в лобби.
 */
("par_weather" call BIS_fnc_getParamValue) spawn dzn_fnc_setWeather;


/*
 *	Серверный код миссии:
 */
