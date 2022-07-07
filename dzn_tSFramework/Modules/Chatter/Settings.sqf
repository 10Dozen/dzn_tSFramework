#include "data\script_component.hpp"

/* Dependency: No
 */

// Distance coef from where noise start to affect the messages. E.g. for LR range 10000 and coef 0.8 - noise starts from 8000m (0.8 * 10000) to 10000m
GVAR(DistanceRadioNoiseCoef) = 0.8;

// Maximum distance coef where message may be received as statics only. E.g. for LR range 10000 and coef 1.2 - statics will be received from 10000m to 12000m (1.2 * 10000)
GVAR(DistanceRadioStaticsCoef) = 1.2;

// Distance coef from where noise start to affect hearing of the direct speech. E.g. for normal talk (20m) it will be affected from 22.5m (0.75 * 20).
GVAR(DistanceVocalNoiseCoef) = 0.75;

/*
    Description of Radio talker:
    [@Side, @Callsign, @Unit, [@LRRange, @SWRange]]

    @Side - (side) the side of the talker (should be same side as players to appear on radio chat!)
    @Callsign - (string) callsign to be applied (group name)
    @Unit - (object) unit to represent the talker.
            Actual unit position will be used to determine range of the broadcast, if communication ranges defined. Will show local speech if nearby.
            Unit's death will prevent any chatter from it.
            May be a GameLogic (won't show local subtitle, can't be killed). Optional.
    [@LRRange, @SWRange] - (array of numbers) maximum range of the broadcast using LR/SW radio in 3d space (including altitude!).
                           Works only if @Unit is set. Optional, defaults [-1, -1] means unlimited range.
*/
CHATTER_TALKERS_TABLE
	/* Example talker:
	[west, "PAPA BEAR"], // 'virtual' talker, can send radio messages all over the map
	[west, "Spearhead-1", spearhead, [25000, 3000]] // 'real' talker - unit spearhead, with 25km for LR radio and 3km for SW radio coms
	*/

CHATTER_TALKERS_TABLE_ENDS
