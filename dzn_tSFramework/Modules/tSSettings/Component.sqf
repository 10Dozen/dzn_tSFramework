#include "script_component.hpp"

/*
    tSSettings component adds client-side settings.
*/

/*
ToDO:
    - Menu for view distance (+quick options)
        - CBA keybind
*/

[
    PREP_COMPONENT_FUNCTION(initClient),
    PREP_COMPONENT_FUNCTION(addTopics),
    PREP_COMPONENT_FUNCTION(changeViewDistance),
    PREP_COMPONENT_FUNCTION(setViewDistance),
    PREP_COMPONENT_FUNCTION(saveViewDistance),
    PREP_COMPONENT_FUNCTION(restoreViewDistance),
    PREP_COMPONENT_FUNCTION(setShadowDistance),
    PREP_COMPONENT_FUNCTION(maximizeObjectViewDistance),
    PREP_COMPONENT_FUNCTION(setTerrainGrid),
    PREP_COMPONENT_FUNCTION(addKeybinds),
    PREP_COMPONENT_FUNCTION(changeViewDistancePreset),

    [Q(TerrainGridModes), createHashMapFromArray [
        [0, ["Низкая", 50]],
        [1, ["Обычная", 25]],
        [2, ["Высокая", 12.5]],
        [3, ["Очень высокая", 6.25]],
        [4, ["Максимальная", 3.125]]
    ]]
]
