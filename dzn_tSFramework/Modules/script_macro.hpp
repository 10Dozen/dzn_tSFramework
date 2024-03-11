// Common macro
#define MISSION_STARTED time > 0
#define ON_MISSION_STARTED time > 0

// Dynai
#define DZN_DYNAI_RUNNING (!isNil "dzn_dynai_initialized")
#define DZN_DYNAI_RUNNING_SERVER_SIDE (!isNil "dzn_dynai_initialized" && {dzn_dynai_initialized })

// dzn_Gear
#define DZN_GEAR_RUNNING (!isNil "dzn_gear_serverInitDone")
#define DZN_GEAR_APPLIED(UNIT) (UNIT getVariable ["dzn_gear_done", false])



// tSF Error reporting
#define TSF_ERROR_FUNC tSF_tSFDiag_fnc_ReportFrameworkError
#define TSF_ERROR(REASON,MSG) [QUOTE(COMPONENT), REASON, MSG] call TSF_ERROR_FUNC;
#define TSF_ERROR_1(REASON,MSG,ARG1) [QUOTE(COMPONENT), REASON,FORMAT_1(MSG,ARG1)] call TSF_ERROR_FUNC;
#define TSF_ERROR_2(REASON,MSG,ARG1,ARG2) [QUOTE(COMPONENT), REASON, FORMAT_2(MSG,ARG1,ARG2)] call TSF_ERROR_FUNC;
#define TSF_ERROR_3(REASON,MSG,ARG1,ARG2,ARG3) [QUOTE(COMPONENT), REASON, FORMAT_3(MSG,ARG1,ARG2,ARG3)] call TSF_ERROR_FUNC;
#define TSF_ERROR_4(REASON,MSG,ARG1,ARG2,ARG3,ARG4) [QUOTE(COMPONENT), REASON, FORMAT_4(MSG,ARG1,ARG2,ARG3,ARG4)] call TSF_ERROR_FUNC;
#define TSF_ERROR_5(REASON,MSG,ARG1,ARG2,ARG3,ARG4,ARG5) [QUOTE(COMPONENT), REASON, FORMAT_5(MSG,ARG1,ARG2,ARG3,ARG4,ARG5)] call TSF_ERROR_FUNC;
#define TSF_ERROR_6(REASON,MSG,ARG1,ARG2,ARG3,ARG4,ARG5,ARG6) [QUOTE(COMPONENT), REASON, FORMAT_6(MSG,ARG1,ARG2,ARG3,ARG4,ARG5,ARG6)] call TSF_ERROR_FUNC;
#define TSF_ERROR_7(REASON,MSG,ARG1,ARG2,ARG3,ARG4,ARG5,ARG6,ARG7) [QUOTE(COMPONENT), REASON, FORMAT_7(MSG,ARG1,ARG2,ARG3,ARG4,ARG5,ARG6,ARG7)] call TSF_ERROR_FUNC;
#define TSF_ERROR_8(REASON,MSG,ARG1,ARG2,ARG3,ARG4,ARG5,ARG6,ARG7,ARG8) [QUOTE(COMPONENT), REASON, FORMAT_8(MSG,ARG1,ARG2,ARG3,ARG4,ARG5,ARG6,ARG7,ARG8)] call TSF_ERROR_FUNC;

#define TSF_ERROR_TYPE__NO_CONFIG "Config not found"
#define TSF_ERROR_TYPE__NO_MARKER "Marker not found"
#define TSF_ERROR_TYPE__MISCONFIGURED "Misconfigured"
#define TSF_ERROR_TYPE__MISSING_ENTITY "Missing Entity"


// Credits: CBA Team (https://github.com/CBATeam/CBA_A3/blob/master/addons/main/script_macros_common.hpp)
#define DEBUG true

#define MAINPREFIX dzn_tSFramework
#define SUBPREFIX Modules
#define PREFIX tSF
#ifndef COMPONENT
    #define COMPONENT common
#endif

#define DOUBLES(var1,var2) var1##_##var2
#define TRIPLES(var1,var2,var3) var1##_##var2##_##var3
#define QUOTE(var1) #var1

#define MODULE_COMPONENT DOUBLES(PREFIX,COMPONENT)

#define GVAR(var1) DOUBLES(MODULE_COMPONENT,var1)
#define EGVAR(var1,var2) TRIPLES(PREFIX,var1,var2)
#define QGVAR(var1) QUOTE(GVAR(var1))
#define QEGVAR(var1,var2) QUOTE(EGVAR(var1,var2))
#define QQGVAR(var1) QUOTE(QGVAR(var1))
#define QQEGVAR(var1,var2) QUOTE(QEGVAR(var1,var2))

#define FUNC(var1) TRIPLES(MODULE_COMPONENT,fnc,var1)
#define FUNCMAIN(var1) TRIPLES(PREFIX,fnc,var1)
#define FUNC_INNER(var1,var2) TRIPLES(DOUBLES(PREFIX,var1),fnc,var2)
#define EFUNC(var1,var2) FUNC_INNER(var1,var2)
#define QFUNC(var1) QUOTE(FUNC(var1))
#define QFUNCMAIN(var1) QUOTE(FUNCMAIN(var1))
#define QFUNC_INNER(var1,var2) QUOTE(FUNC_INNER(var1,var2))
#define QEFUNC(var1,var2) QUOTE(EFUNC(var1,var2))
#define QQFUNC(var1) QUOTE(QFUNC(var1))
#define QQFUNCMAIN(var1) QUOTE(QFUNCMAIN(var1))
#define QQFUNC_INNER(var1,var2) QUOTE(QFUNC_INNER(var1,var2))
#define QQEFUNC(var1,var2) QUOTE(QEFUNC(var1,var2))



// -- Module and file execution
#define __SERVER_ONLY__ if (!isServer) exitWith {};
#define __CLIENT_ONLY__ if (!hasInterface) exitWith {};
#define __HEADLESS_OR_SERVER__ if ( \
        (isNil "HC" && !isServer) || \
        (!isNil "HC" && (hasInterface || isServer)) \
    ) exitWith {};


#define COMPONENT_PATH(FILE) MAINPREFIX\SUBPREFIX\COMPONENT\FILE
#define COMPONENT_FILE_PATH(DIR,FILE) MAINPREFIX\SUBPREFIX\COMPONENT\DIR\FILE
#define COMPONENT_DATA_PATH(FILE) COMPONENT_FILE_PATH(data,FILE)
#define COMPILE_EXECUTE(PATH) call compileScript ['PATH.sqf']

#define INIT_SETTING COMPILE_EXECUTE(COMPONENT_PATH(Settings))
#define INIT_FUNCTIONS COMPILE_EXECUTE(COMPONENT_DATA_PATH(Functions))
#define INIT_FILE(DIR,FILE) COMPILE_EXECUTE(COMPONENT_FILE_PATH(DIR,FILE))
#define INIT_COMMON COMPILE_EXECUTE(COMPONENT_DATA_PATH(Init))
#define INIT_SERVER if (isServer) then { COMPILE_EXECUTE(COMPONENT_DATA_PATH(InitServer)) }
#define INIT_CLIENT if (hasInterface) then { COMPILE_EXECUTE(COMPONENT_DATA_PATH(InitClient)) }

#define INIT_COMPONENT COMPILE_EXECUTE(COMPONENT_DATA_PATH(Component))


// --- Component Object
#define Q(X) #X
#define F_WRAP(NAME) fnc_##NAME
#define F(NAME) Q(F_WRAP(NAME))

#define COMPONENT_FNC_PATH(FILE) MAINPREFIX\SUBPREFIX\COMPONENT\data\fnc_##FILE##.sqf
#define PREP_COMPONENT_FUNCTION(NAME) \
    [F(NAME), compileScript [Q(COMPONENT_FNC_PATH(NAME))]]

#define COMPONENT_SETTINGS_PATH COMPONENT_PATH(Settings.yaml)
#define PREP_COMPONENT_SETTINGS \
    [Q(Settings), [Q(COMPONENT_SETTINGS_PATH)] call dzn_fnc_parseSFML]


// --- Component Objects - Setting getters
#define SETTING(SRC,NODE1) (SRC get Q(Settings) get Q(NODE1))
#define SETTING_2(SRC,NODE1,NODE2) (SRC get Q(Settings) get Q(NODE1) get Q(NODE2))
#define SETTING_3(SRC,NODE1,NODE2,NODE3) (SRC get Q(Settings) get Q(NODE1) get Q(NODE2) get Q(NODE3))

#define SETTING_OR_DEFAULT(SRC,NODE1,DEFAULT) (SRC get Q(Settings) getOrDefault [Q(NODE1), DEFAULT])
#define SETTING_OR_DEFAULT_2(SRC,NODE1,NODE2,DEFAULT) (SRC get Q(Settings) get Q(NODE1) getOrDefault [Q(NODE2), DEFAULT])
#define SETTING_OR_DEFAULT_3(SRC,NODE1,NODE2,NODE3,DEFAULT) (SRC get Q(Settings) get Q(NODE1) get Q(NODE2) getOrDefault [Q(NODE3), DEFAULT])



// --- Module init
#define RUN_MODULE(X) if (TRIPLES(PREFIX,module,X)) then { [] execVM 'MAINPREFIX\SUBPREFIX\X\data\PreInit.sqf'; }

// --- Useful macro
#define STARTS_WITH(STR,SUBSTR) (STR select [0, count SUBSTR] == SUBSTR)

// -- Logging
#define LOG_SYS_FORMAT(LEVEL,MESSAGE) format ['[%1] (%2) %3: %4', 'PREFIX', 'COMPONENT', LEVEL, MESSAGE]
#define LOG_SYS(LEVEL,MESSAGE) diag_log text LOG_SYS_FORMAT(LEVEL,MESSAGE)
#define LOG(MESSAGE) LOG_SYS('LOG',MESSAGE)
#define LOG_1(MESSAGE,ARG1) LOG(FORMAT_1(MESSAGE,ARG1))
#define LOG_2(MESSAGE,ARG1,ARG2) LOG(FORMAT_2(MESSAGE,ARG1,ARG2))
#define LOG_3(MESSAGE,ARG1,ARG2,ARG3) LOG(FORMAT_3(MESSAGE,ARG1,ARG2,ARG3))
#define LOG_4(MESSAGE,ARG1,ARG2,ARG3,ARG4) LOG(FORMAT_4(MESSAGE,ARG1,ARG2,ARG3,ARG4))
#define LOG_5(MESSAGE,ARG1,ARG2,ARG3,ARG4,ARG5) LOG(FORMAT_5(MESSAGE,ARG1,ARG2,ARG3,ARG4,ARG5))
#define LOG_6(MESSAGE,ARG1,ARG2,ARG3,ARG4,ARG5,ARG6) LOG(FORMAT_6(MESSAGE,ARG1,ARG2,ARG3,ARG4,ARG5,ARG6))
#define LOG_7(MESSAGE,ARG1,ARG2,ARG3,ARG4,ARG5,ARG6,ARG7) LOG(FORMAT_7(MESSAGE,ARG1,ARG2,ARG3,ARG4,ARG5,ARG6,ARG7))
#define LOG_8(MESSAGE,ARG1,ARG2,ARG3,ARG4,ARG5,ARG6,ARG7,ARG8) LOG(FORMAT_8(MESSAGE,ARG1,ARG2,ARG3,ARG4,ARG5,ARG6,ARG7,ARG8))

#ifdef DEBUG
	#define DEBUG_MSG(MESSAGE) LOG_SYS("DEBUG",MESSAGE)
	#define DEBUG_1(MESSAGE,ARG1) DEBUG_MSG(FORMAT_1(MESSAGE,ARG1))
	#define DEBUG_2(MESSAGE,ARG1,ARG2) DEBUG_MSG(FORMAT_2(MESSAGE,ARG1,ARG2))
	#define DEBUG_3(MESSAGE,ARG1,ARG2,ARG3) DEBUG_MSG(FORMAT_3(MESSAGE,ARG1,ARG2,ARG3))
	#define DEBUG_4(MESSAGE,ARG1,ARG2,ARG3,ARG4) DEBUG_MSG(FORMAT_4(MESSAGE,ARG1,ARG2,ARG3,ARG4))
	#define DEBUG_5(MESSAGE,ARG1,ARG2,ARG3,ARG4,ARG5) DEBUG_MSG(FORMAT_5(MESSAGE,ARG1,ARG2,ARG3,ARG4,ARG5))
	#define DEBUG_6(MESSAGE,ARG1,ARG2,ARG3,ARG4,ARG5,ARG6) DEBUG_MSG(FORMAT_6(MESSAGE,ARG1,ARG2,ARG3,ARG4,ARG5,ARG6))
	#define DEBUG_7(MESSAGE,ARG1,ARG2,ARG3,ARG4,ARG5,ARG6,ARG7) DEBUG_MSG(FORMAT_7(MESSAGE,ARG1,ARG2,ARG3,ARG4,ARG5,ARG6,ARG7))
	#define DEBUG_8(MESSAGE,ARG1,ARG2,ARG3,ARG4,ARG5,ARG6,ARG7,ARG8) DEBUG_MSG(FORMAT_8(MESSAGE,ARG1,ARG2,ARG3,ARG4,ARG5,ARG6,ARG7,ARG8))
#endif

#define FORMAT_1(STR,ARG1) format[STR, ARG1]
#define FORMAT_2(STR,ARG1,ARG2) format[STR, ARG1, ARG2]
#define FORMAT_3(STR,ARG1,ARG2,ARG3) format[STR, ARG1, ARG2, ARG3]
#define FORMAT_4(STR,ARG1,ARG2,ARG3,ARG4) format[STR, ARG1, ARG2, ARG3, ARG4]
#define FORMAT_5(STR,ARG1,ARG2,ARG3,ARG4,ARG5) format[STR, ARG1, ARG2, ARG3, ARG4, ARG5]
#define FORMAT_6(STR,ARG1,ARG2,ARG3,ARG4,ARG5,ARG6) format[STR, ARG1, ARG2, ARG3, ARG4, ARG5, ARG6]
#define FORMAT_7(STR,ARG1,ARG2,ARG3,ARG4,ARG5,ARG6,ARG7) format[STR, ARG1, ARG2, ARG3, ARG4, ARG5, ARG6, ARG7]
#define FORMAT_8(STR,ARG1,ARG2,ARG3,ARG4,ARG5,ARG6,ARG7,ARG8) format[STR, ARG1, ARG2, ARG3, ARG4, ARG5, ARG6, ARG7, ARG8]
