#include "..\..\script_macro.hpp"

#define COMPONENT CCP

#define CCP_LOGIC tSF_CCP
#define CCP_LOGIC_COMPOSITION_PROPERTY QUOTE(tSF_CCP_Composition)


#define MRK_LABEL "CCP"
#define MRK_ICON_PREVIEW "mil_box"
#define MRK_ICON "mil_flag"
#define MRK_COLOR "ColorKhaki"


#define SHOW_MESSAGE(MSG) [[side player, "HQ"], MSG] remoteExec ["commandChat"]

#define STR_SHORT_NAME CCP
#define STR_FULL_NAME Casualty Collection Point
#define STR_SUCCESSFULLY_SET QUOTE(STR_FULL_NAME will be deployed at selected location)
#define STR_NOT_ALLOWED QUOTE(This area is not secured to deploy STR_SHORT_NAME there. Choose different location.)
#define STR_ALREADY_SET QUOTE(STR_SHORT_NAME was already set (remove previous one to change location).)

#define CCP_PLAYER_SEARCH_RADIUS 15
#define STRETCHER_CLS "Land_Stretcher_01_olive_F"
#define HEALING_ANIMS [\
    "Acts_LyingWounded_loop" \
    ,"Acts_LyingWounded_loop1" \
    ,"Acts_LyingWounded_loop2" \
    ,"Acts_LyingWounded_loop3" \
]
