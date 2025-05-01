// ***********************************
// Gear Kits
// ***********************************
// ******** GEAR CLASSES **********
//
//	Maptools		"ACE_MapTools"	["ACE_MapTools",1]
//	Binocular		"Binocular"	["Binocular",1]
//
// 	Map			"ItemMap"
//	Compass			"ItemCompass"
//	Watch			"ItemWatch"
//	Personal Radio		"ItemRadio"
//
// ******* KIT NAMES FORMAT ********
//  Kit names format:		kit_FACTION_ROLE
//	Platoon Leader / Командир Взвода	->	kit_ussf_pl
//	Squad Leader / Командир отделения	->	kit_ussf_sl
//	Section Leader				->	kit_ussf_sl
//	2IC					->	kit_ussf_2ic
//	Fireteam Leader				->	kit_ussf_ftl
//	Automatic Rifleman			->	kit_ussf_ar
//	Grenadier / Стрелок (ГП)		->	kit_ussf_gr
//	Rifleman / Стрелок			->	kit_ussf_r
//	Экипаж					->	kit_ussf_crew
//	Пулеметчик				->	kit_ussf_mg
//	Стрелок-Гранатометчик			->	kit_ussf_at
//	Стрелок, помощник гранатометчика	->	kit_ussf_aat
//	Старший стрелок				->	kit_ussf_ar / kit_ussf_ss
//	Снайпер					->	kit_ussf_mm
// ****************
//
// ******** USEFUL MACROSES *******
// Maros for Empty weapon
#define EMPTYKIT	[["","","","",""],["","","","",""],["","","","",""],["","","","",""],[],[["",0],["",0],["",0],["",0],["",0],["",0],["",0],["",0],["",0]],[["",0],["",0],["",0],["",0],["",0],["",0]],[]]
// Macros for Empty weapon
#define EMPTYWEAPON	"","",["","","",""]
// Macros for the list of items to be chosen randomly
#define RANDOM_ITEM	["H_HelmetB_grass","H_HelmetB"]
// Macros to give the item only if daytime is in given inerval (e.g. to give NVGoggles only at night)
#define NIGHT_ITEM(X)	if (daytime < 9 || daytime > 18) then { X } else { "" }

// ******** ASSIGNED and UNIFORM ITEMS MACRO ********
#define NVG_NIGHT_ITEM		if (daytime < 9 || daytime > 18) then { "NVGoggles_OPFOR" } else { "" }
#define BINOCULAR_ITEM		"Binocular"

#define ASSIGNED_ITEMS		"ItemMap","ItemCompass","ItemWatch","ItemRadio", NVG_NIGHT_ITEM
#define ASSIGNED_ITEMS_L	"ItemMap","ItemCompass","ItemWatch","ItemRadio", NVG_NIGHT_ITEM, BINOCULAR_ITEM

#define UNIFORM_ITEMS		["ACE_fieldDressing",5],["ACE_packingBandage",5],["ACE_elasticBandage",5],["ACE_tourniquet",2],["ACE_morphine",2],["ACE_epinephrine",2],["ACE_quikclot",5],["ACE_CableTie",2],["ACE_Flashlight_XL50",1],["ACE_EarPlugs",1]
#define UNIFORM_ITEMS_L		["ACE_fieldDressing",5],["ACE_packingBandage",5],["ACE_elasticBandage",5],["ACE_tourniquet",2],["ACE_morphine",2],["ACE_epinephrine",2],["ACE_quikclot",5],["ACE_CableTie",2],["ACE_Flashlight_XL50",1],["ACE_EarPlugs",1],["ACE_MapTools",1]
// ****************


kit_test1 = [
	["<EQUIPEMENT       >> ", "U_B_GEN_Soldier_F", "V_TacVest_gen_F", "", "H_MilCap_gen_F", ""],

	// Randomized weapon pattern
	["<PRIMARY WEAPON   >> ",[
		["arifle_MX_F",   "30Rnd_65x39_caseless_mag",["","",["optic_Aco", ""],""]],
		["arifle_MX_GL_F","30Rnd_65x39_caseless_mag",["","",["optic_Aco", ""],""]],
		["SMG_05_F",       "30Rnd_9x21_Mag_SMG_02",  ["","",["optic_Aco", ""],""]]
	]],

	["<LAUNCHER WEAPON  >> ","","",["","","",""]],
	["<HANDGUN WEAPON   >> ","hgun_P07_F","16Rnd_9x21_Mag",["","","",""]],
	["<ASSIGNED ITEMS   >> ","ItemMap","ItemCompass","ItemWatch","ItemRadio"],
	["<UNIFORM ITEMS    >> ",[["FirstAidKit",1],["PRIMARY MAG","x2-10"]]],
	["<VEST ITEMS       >> ",[["PRIMARY MAG",3],["HANDGUN MAG",2],["HandGrenade",1],["SmokeShell",1]]],
	["<BACKPACK ITEMS   >> ",[]],
	// Optional section
	["<IDENTITY         >> ",["TanoanHead_A3_02","TanoanHead_A3_02"],["vvv", "male01engfre"],"john Doe"],
	["<TAGS             >> ", "MyTag", ["MyNumber", 123]],
	["<SCRIPT           >> ",
		{ (_this # 0) setVariable ["XXX", 123]; },
		{ hint str(_this # 0 getVariable "XXX") }
	],
	["<UNIFORM TEXTURES >> ", ["camo1", ["/data/my_tex1.paa", "/data/my_tex2.paa"]]]
] call dzn_fnc_gear_make;

kit_test2 = [
	// Some lines were omitted
	["<EQUIPEMENT       >> ", "U_B_GEN_Soldier_F", "V_TacVest_gen_F", "", "H_MilCap_gen_F", ""],
	["<PRIMARY WEAPON   >> ",
		["arifle_MX_F", "arifle_MX_GL_F"] ,"30Rnd_65x39_caseless_mag",
		["","",["optic_Aco", ""],""]],
	["<HANDGUN WEAPON   >> ","hgun_P07_F","16Rnd_9x21_Mag",["","","",""]],
	["<ASSIGNED ITEMS   >> ","ItemMap","ItemCompass","ItemWatch","ItemRadio","Laserdesignator"],
	["<UNIFORM ITEMS    >> ",[["PRIMARY MAG","x2-10"]]],
	["<VEST ITEMS       >> ",[["PRIMARY MAG",3],["HANDGUN MAG",2],["HandGrenade",1],["SmokeShell",1]]],
	["<UNIFORM TEXTURES >> ",[0, "#(rgb,8,8,3)color(1,0,0,1)"]],
	["<TAGS             >> ", "leader", "PL_NET"]
] call dzn_fnc_gear_make;

kit_test3 = [
	// Some lines were omitted
	["<EQUIPEMENT       >> ", "U_B_GEN_Soldier_F", "V_TacVest_gen_F", "", "H_MilCap_gen_F", ""],
	["<PRIMARY WEAPON   >> ",
		"arifle_MX_F" , ["30Rnd_65x39_caseless_mag", "100Rnd_65x39_caseless_black_mag"],
		["","",["optic_Aco", ""],""]],
	["<HANDGUN WEAPON   >> ","hgun_P07_F","16Rnd_9x21_Mag",["","","",""]],
	["<ASSIGNED ITEMS   >> ","ItemMap","ItemCompass","ItemWatch"],
	["<UNIFORM ITEMS    >> ",[["FirstAidKit",1],["PRIMARY MAG","x2-10"]]],
	["<VEST ITEMS       >> ",[
		["PRIMARY MAG",3],
		["HANDGUN MAG",2],
		[["HandGrenade", "SmokeShell"],2]
	]],

	["<TAGS             >> ", "leader", "PL_NET"]
] call dzn_fnc_gear_make;

kit_test_random = ["kit_test1", "kit_test2", "kit_test3"];

cargo_kit_test2 = [
    [[["arifle_MX_ACO_pointer_F","hgun_P07_F"],3]],
    [],
    [[["FirstAidKit", "ACE_rope6"],4]],
    [],
    [[["arifle_MX_GL_F", "muzzle_snds_H", "", "optic_aco", ["30Rnd_65x39_caseless_mag", 15], ["3Rnd_HE_Grenade_shell", 2], ""], 2]]
] call dzn_fnc_gear_make;

cargo_kit_test3 = [
    ["< WEAPONS    >> ", [
		[["arifle_MX_ACO_pointer_F","hgun_P07_F"], 3],
		[
			// @String          @Sting          @str  @str       @Arr                              @Arr                          @Str
			["arifle_MX_GL_F", "muzzle_snds_H", "", "optic_aco", ["30Rnd_65x39_caseless_mag", 15], ["3Rnd_HE_Grenade_shell", 2], ""],
			2
		]
	]],
    ["< MAGAZINES  >> ", []],
    ["< ITEMS      >> ", [
        [["FirstAidKit", "ACE_rope6"],4]
    ]],
    ["< BACKPACKS  >> ", []]
] call dzn_fnc_gear_make;

cargo_kit_test4 = [
    ["<WEAPONS     >> ",[["arifle_MX_F",2],["arifle_MX_GL_F",2],["SMG_05_F",2],["hgun_P07_F",2]]],
    ["<MAGAZINES   >> ",[["30Rnd_65x39_caseless_mag",20],["30Rnd_9x21_Mag_SMG_02",20],["16Rnd_9x21_Mag",20],["HandGrenade",20],["SmokeShell",20],["100Rnd_65x39_caseless_black_mag",20]]],
    ["<ITEMS       >> ",[["FirstAidKit",10]]],
    ["<BACKPACKS   >> ",[]],
    ["<DESC        >> ", "Super cool kit for vehicles"],
    ["<TAGS        >> ", "isCoolVehicle"],
    ["<SCRIPT      >> ",
		{ (_this # 0) setVariable ["XXX", 123]; },
		{ hint str(_this # 0 getVariable "XXX") }
	],
	["<TEXTURES    >> ", ["camo1", ["/data/my_tex1.paa", "/data/my_tex2.paa"]]]
] call dzn_fnc_gear_make;
/*
kit_eee_pl = [
    ["<EQUIPEMENT       >> ","U_B_GEN_Soldier_F","V_TacVest_gen_F","","H_MilCap_gen_F",""],
    ["<PRIMARY WEAPON   >> ","SMG_05_F","30Rnd_9x21_Mag_SMG_02",["","","",""]],
    ["<LAUNCHER WEAPON  >> ","","",["","","",""]],
    ["<HANDGUN WEAPON   >> ","hgun_P07_F","",["","","",""]],
    ["<ASSIGNED ITEMS   >> ", ASSIGNED_ITEMS],
    ["<UNIFORM ITEMS    >> ",[UNIFORM_ITEMS]],
    ["<VEST ITEMS       >> ",[["PRIMARY MAG",3],["16Rnd_9x21_Mag",2],["HandGrenade",1],["SmokeShell",1]]],
    ["<BACKPACK ITEMS   >> ",[]]
] call dzn_fnc_gear_make;
*/
