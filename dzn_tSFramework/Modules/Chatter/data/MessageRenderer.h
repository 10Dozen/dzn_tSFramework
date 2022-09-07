#define CLS_NAME MessageRenderer
#define SELF GVAR(CLS_NAME)
#define QSELF QUOTE(SELF)

#define PREP_METHOD(FUNCNAME) compileScript ['COMPONENT_DATA_PATH(DOUBLES(fnc,CLS_NAME).FUNCNAME).sqf']

#define self_PREP(FUNCNAME) [toUpper 'FUNCNAME', PREP_METHOD(FUNCNAME)]
#define self_GET(X) (SELF get toUpper 'X')
#define self_FUNC(FNC) self_GET(FNC)
#define self_SET(PAR,VALUE) (SELF set [toUpper 'PAR', VALUE])


// MessageRenderer
#define PFH_DELAY 0.2

#define STATE_NEW "NEW"
#define STATE_BLUR1 "BLUR1"
#define STATE_BLUR2 "BLUR2"
#define STATE_PULL "PULL"
#define STATE_SHOWN "SHOWN"
#define STATE_BLURRED "BLURRED"
#define STATE_EXPIRED "EXPIRED"
#define STATE_HIDDEN "HIDDEN"
#define STATE_SHOWING "SHOWING"
#define STATE_HIDDING "HIDDING"
#define STATE_BLURRING "BLURRING"

#define QE_ID 0
#define QE_TYPE 1
#define QE_CONTROLS 2
#define QE_STATE 3
#define QE_TTL 4

#define ANIM_DUR_APPEAR 0.3
#define ANIM_DUR_APPEAR_TEXT (ANIM_DUR_APPEAR * 0.75)
#define ANIM_DUR_HIDE 0.2
#define ANIM_DUR_BLUR 0.1
#define ANIM_DUR_BLUR_APPEAR (ANIM_DUR_BLUR * 0.5)

#define TTL_SHOW 7
#define TTL_BLUR 5
#define TTL_BUFFER 30

#define BG_COLOR 0,0,0
#define BG_COLOR_LR 0.2,0.2,0.5
#define BG_COLOR_SW 0.2,0.5,0.2
#define BG_ALPHA_ACTIVE 0.8
#define BG_ALPHA_BLUR1 0.5
#define BG_ALPHA_BLUR2 0.3

#define TYPE_W safezoneW * 0.01
#define TYPE_H safezoneH * 0.12

#define TITLE_X TYPE_W
#define TITLE_Y 0
#define TITLE_W safezoneW * 0.25
#define TITLE_H safezoneH * 0.075 * 0.35

#define MSG_X TYPE_W
#define MSG_Y TITLE_H
#define MSG_W TITLE_W
#define MSG_H (TYPE_H - TITLE_H)

#define BOX_INIT_X safezoneX
// #define BOX_INIT_LR_Y (safezoneY + safezoneH * 0.35)
#define BOX_INIT_Y (safezoneY + safezoneH * 0.6)
#define BOX_W (TYPE_W + TITLE_W)
#define BOX_BLUR_OFFSET_Y TYPE_H * 1.05
