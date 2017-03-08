/*
 *	[ @DisplayName, @Class, @Units ]
 */ 
dzn_tSF_3DEN_SquadTypes = [
	[
		"NATO 1-4-4", "US Squad",
		[
			["%1Squad Leader"		,"Sergeant"]
			,["RED - FTL"			,"Corporal"]
			,["Automatic Rifleman"	,"Private"]
			,["Grenadier"			,"Private"]
			,["Rifleman"			,"Private"]
			,["BLUE - FTL"		,"Corporal"]
			,["Automatic Rifleman"	,"Private"]
			,["Grenadier"			,"Private"]
			,["Rifleman"			,"Private"]
		]
	]
	, [
		"UK 4-4", "UK Section",
		[
			["%1Section Leader"		,"Sergeant"]				
			,["Automatic Rifleman"	,"Private"]
			,["Grenadier"			,"Private"]
			,["Rifleman"			,"Private"]
			,["BLUE - 2IC"		,"Corporal"]
			,["Automatic Rifleman"	,"Private"]
			,["Grenadier"			,"Private"]
			,["Rifleman"			,"Private"]
		]
	]
	, [
		"РФ МСО 1-2-3-3", "MSV Squad",
		[
			["%1Командир отделения"			,"Sergeant"]	
			,["Наводчик-оператор"			,"Corporal"]
			,["Механик-водитель"				,"Private"]
			,["Пулеметчик"				,"Private"]
			,["Стрелок-Гранатометчик"			,"Private"]
			,["Стрелок, помощник гранатометчика"	,"Private"]
			,["BLUE - Старший стрелок"			,"Corporal"]
			,["Стрелок"					,"Private"]
			,["Стрелок"					,"Private"]
		]
	]
	, [
		"РФ ВВ 4-3", "ruvv squad",
		[
			["%1Командир отделения"			,"Sergeant"]
			,["Пулеметчик"				,"Private"]
			,["Стрелок-Гранатометчик"			,"Private"]
			,["Стрелок, помощник гранатометчика"	,"Private"]
			,["BLUE - Старший стрелок"			,"Corporal"]
			,["Стрелок (ГП)"				,"Private"]
			,["Снайпер"					,"Private"]
		]
	]
	, [
		"Platoon Squad", "nato platoon squad",
		[
			["%1Platoon Leader"		,"Lieutenant"]
			,["Platoon Sergeant"		,"Sergeant"]
			,["JTAC"			,"Corporal"]
			,["FO"				,"Corporal"]	
		]
	]
	, [
		"Командный отряд", "msv platoon squad",
		[
			["%1Командир взвода"		,"Lieutenant"]
			,["Зам. командира взвода"	,"Sergeant"]
			,["ПАН"			,"Corporal"]
			,["КАО"			,"Corporal"]	
		]
	]
	, [
		"NATO Weapon Squad", "us weapon squad",
		[
			["%1Squad Leader"		,"Sergeant"]
			,["Machinegunner"		,"Private"]
			,["Asst. Machinegunner"	,"Private"]
			,["Machinegunner"		,"Private"]
			,["Asst. Machinegunner"	,"Private"]
			,["Missile Specialist"	,"Private"]
			,["Missile Specialist"	,"Private"]
		]
	]
	, [
		"UK Weapon Section", "uk weapon section",
		[
			["%1Section Leader"		,"Sergeant"]
			,["Machinegunner"		,"Private"]
			,["Asst. Machinegunner"	,"Private"]
			,["Machinegunner"		,"Private"]
			,["Asst. Machinegunner"	,"Private"]
			,["Missile Specialist"	,"Private"]
			,["Missile Specialist"	,"Private"]
		]
	]
	, [
		"РФ Отделение усиления", "msv weapon squad",
		[
			["%1Командир отделения"			,"Sergeant"]
			,["Пулеметчик"				,"Private"]
			,["Стрелок, помощнник пулеметчика"	,"Private"]
			,["Пулеметчик"				,"Private"]
			,["Стрелок, помощнник пулеметчика"	,"Private"]
			,["ПТ-стрелок"			,"Private"]
			,["Стрелок, помощник ПТ"		,"Private"]
		]
	]
	, [
		"Crew Squad", "nato crew",
		[
			["%1Crew Commander"		,"Corporal"]
			,["Crew Gunner"		,"Private"]
			,["Crew Driver"		,"Private"]
		]
	]
	, [
		"Экипаж", "ru crew",
		[
			["%1Командир экипажа"	,"Corporal"]
			,["Наводчик-оператор"	,"Private"]
			,["Механик-водитель"		,"Private"]
		]
	]
	, [
		"Pilots", "nato pilots",
		[
			["%1Pilot"	,"Lieutenant"]
			,["Gunner"	,"Sergeant"]
		]	
	]
	, [
		"Пилоты", "ru pilots",
		[
			["%1Пилот"			,"Lieutenant"]
			,["Наводчик-оператор"	,"Sergeant"]
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


