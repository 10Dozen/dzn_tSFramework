if ("par_daytime" call BIS_fnc_getParamValue == 0) then {
    setDate [2008,4,9,10 + round(random 4), 00]; 
} else {
    setDate [2008,4,9, 21 + round(random 8), 00];
};

// dzn Gear
  // set true to engage Edit mode
[false] execVM "dzn_gear\dzn_gear_init.sqf";
  // dzn DynAI
[] execVM "dzn_dynai\dzn_dynai_init.sqf";
  // TS Framework
[] execVM "dzn_tSFramework\dzn_tSFramework_Init.sqf";
  // dzn AAR
[] execVM "dzn_brv\dzn_brv_init.sqf";
