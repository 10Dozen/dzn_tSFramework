/*
 *	[ @DisplayName, @Class, @Units ]
 */ 
#define LT "Lieutenant"
#define SGT "Sergeant"
#define CPL "Corporal"
#define PVT "Private"

dzn_tSF_3DEN_SquadTypes = [
	[
		"NATO 1-4-4", "US Squad",
		[
			["Squad Leader", SGT]
			,["RED - FTL", CPL]
			,["Automatic Rifleman", PVT]
			,["Grenadier", PVT]
			,["Rifleman", PVT]
			,["BLUE - FTL", CPL]
			,["Automatic Rifleman", PVT]
			,["Grenadier", PVT]
			,["Rifleman", PVT]
		]
	]
	, [
		"UK 4-4", "UK Section",
		[
			["Section Leader", SGT]
			,["Automatic Rifleman", PVT]
			,["Grenadier", PVT]
			,["Rifleman", PVT]
			,["BLUE - 2IC", CPL]
			,["Automatic Rifleman", PVT]
			,["Grenadier", PVT]
			,["Rifleman", PVT]
		]
	]
	, [
		"РФ МСО 1-2-3-3", "MSV Squad",
		[
			["Командир отделения", SGT]
			,["Наводчик-оператор", CPL]
			,["Механик-водитель", PVT]
			,["Пулеметчик", PVT]
			,["Стрелок-Гранатометчик", PVT]
			,["Стрелок, помощник гранатометчика", PVT]
			,["BLUE - Старший стрелок", CPL]
			,["Стрелок", PVT]
			,["Стрелок", PVT]
		]
	]
	, [
		"РФ ВВ 4-3", "ruvv squad",
		[
			["Командир отделения", SGT]
			,["Пулеметчик", PVT]
			,["Стрелок-Гранатометчик", PVT]
			,["Стрелок, помощник гранатометчика", PVT]
			,["BLUE - Старший стрелок", CPL]
			,["Стрелок (ГП)", PVT]
			,["Снайпер", PVT]
		]
	]
	, [
		"Platoon Squad", "nato platoon squad",
		[
			["Platoon Leader", LT]
			,["Platoon Sergeant", SGT]
			,["JTAC", CPL]
			,["FO", CPL]
		]
	]
	, [
		"Командный отряд", "msv platoon squad",
		[
			["Командир взвода", LT]
			,["Зам. командира взвода", SGT]
			,["ПАН", CPL]
			,["КАО", CPL]
		]
	]
	, [
		"NATO Weapon Squad", "us weapon squad",
		[
			["Squad Leader", SGT]
			,["Machinegunner", PVT]
			,["Asst. Machinegunner", PVT]
			,["Machinegunner", PVT]
			,["Asst. Machinegunner", PVT]
			,["Missile Specialist", PVT]
			,["Missile Specialist", PVT]
		]
	]
	, [
		"UK Weapon Section", "uk weapon section",
		[
			["Section Leader", SGT]
			,["Machinegunner", PVT]
			,["Asst. Machinegunner", PVT]
			,["Machinegunner", PVT]
			,["Asst. Machinegunner", PVT]
			,["Missile Specialist", PVT]
			,["Missile Specialist", PVT]
		]
	]
	, [
		"РФ Отделение усиления", "msv weapon squad",
		[
			["Командир отделения", SGT]
			,["Пулеметчик", PVT]
			,["Стрелок, помощнник пулеметчика", PVT]
			,["Пулеметчик", PVT]
			,["Стрелок, помощнник пулеметчика", PVT]
			,["ПТ-стрелок", PVT]
			,["Стрелок, помощник ПТ", PVT]
		]
	]
	, [
		"Crew Squad", "nato crew",
		[
			["Crew Commander", CPL]
			,["Crew Gunner", PVT]
			,["Crew Driver", PVT]
		]
	]
	, [
		"Экипаж", "ru crew",
		[
			["Командир экипажа", CPL]
			,["Наводчик-оператор", PVT]
			,["Механик-водитель", PVT]
		]
	]
	, [
		"Pilots", "nato pilots",
		[
			["Pilot", LT]
			,["Gunner", SGT]
		]	
	]
	, [
		"Пилоты", "ru pilots",
		[
			["Пилот", LT]
			,["Наводчик-оператор", SGT]
		]
	]
];

/*
 *	[ @DisplayName, @Class, @Squads ]
 */ 
dzn_tSF_3DEN_PlatoonTypes = [
	[
		"US Light Infantry"
		, "us infantry"
		, [	
			"%1'%2"
			, [1, "US Squad"]
			, [2, "US Squad"]
			, [3, "US Squad"]
			, [4, "US Weapon Squad"]
			, [6, "NATO Platoon Squad"]		
		]
	]
	,[
		"British Light Infantry"
		, "baf infantry"
		, [	
			"%1'%2"
			, [1, "UK Section"]
			, [2, "UK Section"]
			, [3, "UK Section"]
			, [4, "UK Weapon Section"]
			, [0, "NATO Platoon Squad"]		
		]
	]
	,[
		"РФ МСВ"
		, "ru infantry"
		, [	
			"%1'%2"
			, [1, "MSV Squad"]
			, [2, "MSV Squad"]
			, [3, "MSV Squad"]
			, [4, "MSV Weapon Squad"]
			, [0, "MSV Platoon Squad"]		
		]
	]
	,[
		"РФ ВВ"
		, "ru vv infantry"
		, [	
			"%1'%2"
			, [1, "ruvv squad"]
			, [2, "ruvv squad"]
			, [3, "ruvv squad"]
			, [4, "MSV Weapon Squad"]
			, [0, "MSV Platoon Squad"]		
		]
	]

];

/*
 *	Functions
 */
dzn_fnc_tSF_3DEN_getSquadAttributes = {
	/*
		0		- by id
		"us squad"	- by tag
		"List Names"	= return all list
	*/	
	private _result = [];
	if (typename _this == "STRING") then {
		// Callsign
		if (toLower(_this) == "list names") then {
			{
				_result pushBack (_x select 0);
			} forEach dzn_tSF_3DEN_SquadTypes;
			_result pushBack "";
		} else {
			// Callsign
			_result = ((dzn_tSF_3DEN_SquadTypes select { toLower(_x select 1) == toLower(_this) }) select 0) select 2;
		};
	} else {
		// ID
		_result = (dzn_tSF_3DEN_SquadTypes select _this) select 2;
	};
	
	_result
};

dzn_fnc_tSF_3DEN_getPlatoonAttributes = {
	/*
		0		- by id
		"us squad"	- by tag
		"List Names"	= return all list
	*/	
	private _result = [];
	if (typename _this == "STRING") then {
		// Callsign
		if (toLower(_this) == "list names") then {
			{
				_result pushBack (_x select 0);
			} forEach dzn_tSF_3DEN_PlatoonTypes;
			_result pushBack "";
		} else {
			// Callsign
			_result = ((dzn_tSF_3DEN_PlatoonTypes select { toLower(_x select 1) == toLower(_this) }) select 0) select 2;
		};
	} else {
		// ID
		_result = (dzn_tSF_3DEN_PlatoonTypes select _this) select 2;
	};
	
	_result
};


