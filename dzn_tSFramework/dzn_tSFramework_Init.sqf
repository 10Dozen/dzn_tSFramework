#include "Modules\script_macro.hpp"

tSF_Version = TSF_VERSION_NUMBER;

private _settings = ["dzn_tSFramework\Settings.yaml"] call dzn_fnc_parseSFML;
if (_settings get "#ERRORS" isNotEqualTo []) exitWith {
    LOG(TSF_ERROR_TYPE__SETTINGS_PARSE_ERROR);
    [{ time > 5 }, {
        [
            "TaskFailed",
            ["", format ["%1<br/>%2", "tS Framework", TSF_ERROR_TYPE__SETTINGS_PARSE_ERROR]]
        ] call BIS_fnc_showNotification;
    }] call CBA_fnc_waitUntilAndExecute;
};

// New module init
RUN_MODULE(MissionDefaults);
RUN_MODULE(Authorization);
RUN_MODULE(IntroText);
RUN_MODULE(AirborneSupport);
RUN_MODULE(EditorVehicleCrew);
RUN_MODULE(POM);

// Legacy module init
{
    if !(_settings get _x) then { continue; };
    [] execVM format ['dzn_tSFramework\Modules\%1\Init.sqf', _x];
} forEach [
    "JIPTeleport"
    , "MissionConditions"
    , "Briefing"
    , "tSNotes"
    , "tSSettings"
    , "CCP"
    , "FARP"
    , "ArtillerySupport"
    , "Interactives"
    , "ACEActions"
    , "EditorUnitBehavior"
    , "EditorRadioSettings"
    , "tSAdminTools"
    , "Conversations"
]
