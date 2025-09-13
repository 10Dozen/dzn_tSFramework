/*
 * SETTINGS
 */

// Paths
dzn_gear_kitsFiles = ["Config\Gear\Kits.sqf"];
dzn_gear_GATFile = "Config\Gear\GearAssignmentTable.yml";
dzn_gear_PluginsSettingsFile = "Config\Gear\PluginSettings.yml";

// Identity -- exports identity on getGear. If enabled - exports identity to kit and allows to copy-paste identity to unit via Zeus.
dzn_gear_handleIdentity = false;

// Plugins - comment line with unwanted plugin to disable
dzn_gear_Plugins = [
    /*
        Provides powefull GUI tools to create kits.
    */
    "Editor"

    /*
        Gear information displayed in Briefing topic.
        Includes full list of player's equipment.
    */
    , "Notes"

    /*
        dzn Gear Zeus Compatibility
        Allows to assign gear kits to units via Zeus.
        Select unit and press 'G' key to invoke menu
    */
    , "Zeus"
];
