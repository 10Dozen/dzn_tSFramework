#include "..\..\script_macro.hpp"

#define COMPONENT AirborneSupport

#define MRK_ICON_AIR "\A3\ui_f\data\map\markers\nato\n_air.paa"
#define MRK_ICON_SIZE 32

#define CHATTER_TIMEOUT_SEC 5

#define CHATTER_PICKUP "PICKUP"
#define CHATTER_LAND_ON_LZ "LAND"
#define CHATTER_HOVER_OVER_LZ "HOVER"
#define CHATTER_RTB "RTB"
#define CHATTER_CALLIN "CALLIN"
#define CHATTER_ABORT "ABORT"
#define CHATTER_APPROACHING_LZ "APPROACHING_LZ"
#define CHATTER_LANDED "LANDED"
#define CHATTER_HOVERING "HOVERING"

#define GRID_AT(POS) POS call dzn_fnc_getMapGrid

#define RADIO_CHATTER_ON_PICKUP_REQUEST(CALLER,PROVIDER,GRID) format ["%1, this is %2, requesting pickup at grid %3. Over.", PROVIDER, CALLER, GRID]
#define RADIO_CHATTER_ON_PICKUP_RESPONSE(CALLER,PROVIDER,GRID) format ["%1, this is %2, providing pickup mission at grid %3. Moving to AO! Over'n'out.", CALLER, PROVIDER, GRID]

#define RADIO_CHATTER_ON_LAND_REQUEST(CALLER,PROVIDER) format ["%1, this is %2, requesting LANDING on LZ. I repeat, LAND on LZ. Over.", PROVIDER, CALLER]
#define RADIO_CHATTER_ON_LAND_RESPONSE(CALLER,PROVIDER) format ["10-4, %1. Will touch ground once there. %2, out.", CALLER, PROVIDER]

#define RADIO_CHATTER_ON_HOVER_REQUEST(CALLER,PROVIDER) format ["%1, this is %2, requesting HOVER over LZ. I repeat, stay in the air at LZ. Over.", PROVIDER, CALLER]
#define RADIO_CHATTER_ON_HOVER_RESPONSE(CALLER,PROVIDER) format ["Roger that, %1. We will hover over LZ, prepare ropes! %2, out.", CALLER, PROVIDER]

#define RADIO_CHATTER_ON_CALLIN_REQUEST(CALLER,PROVIDER,INGRESS) format ["%1, this is %2, requesting transport to AO, ingress from %3. Over.", PROVIDER, CALLER, INGRESS]
#define RADIO_CHATTER_ON_CALLIN_RESPONSE(CALLER,PROVIDER) format ["%1, this is %2. Reaching INGRESS point in 15 seconds, out.", CALLER, PROVIDER]

#define RADIO_CHATTER_ON_RTB_REQUEST(PROVIDER) format ["%1, return to base. Over.", PROVIDER]
#define RADIO_CHATTER_ON_RTB_RESPONSE(CALLER,PROVIDER) format ["%1, this is %2. Roger that, leaving AO and returning to the base. Out.", CALLER, PROVIDER]

#define RADIO_CHATTER_ON_ABORT_REQUEST(CALLER,PROVIDER) format ["Break-break-break! %1, this is %2, abort your mission immediately. Do you read? Over.", PROVIDER, CALLER]
#define RADIO_CHATTER_ON_ABORT_RESPONSE(CALLER,PROVIDER) format ["%1, this is %2, copy. Aborting mission. Waiting for a new orders! Over.", CALLER, PROVIDER]

#define RADIO_CHATTER_ON_APPROACHING_LZ(PROVIDER) format ["This is %1, approaching LZ. Over.", PROVIDER]

#define RADIO_CHATTER_ON_LANDED(PROVIDER) format ["This is %1, touched the ground. Over.", PROVIDER]
#define RADIO_CHATTER_ON_HOVERING(PROVIDER) format ["This is %1, hovering over LZ. Over.", PROVIDER]
