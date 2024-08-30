
#define SQ(X) 'X'

// HEX colors 
#define COLOR_HEX_WHITE SQ(#FFFFFF)
#define COLOR_HEX_GOLD SQ(#FFD000)
#define COLOR_HEX_BRICK_RED SQ(#eb4f34)
#define COLOR_HEX_GRAY SQ(#adadad)
#define COLOR_HEX_DARK_GRAY SQ(#777777)
#define COLOR_HEX_LIGHT_BLUE SQ(#84b0f0)
#define COLOR_HEX_LIGHT_GREEN SQ(#acdb8b)
#define COLOR_HEX_LIME SQ(#7bbf37)
#define COLOR_HEX_AQUA SQ(#12C4FF)

// RGBA colors 
#define COLOR_RGBA_BY_UI (["GUI", "BCG_RGB"] call BIS_fnc_displayColorGet)
#define COLOR_RGBA_WHITE [1, 1, 1, 1]
#define COLOR_RGBA_BLACK [0, 0, 0 ,1]
#define COLOR_RGBA_LIGHT_RED [0.92, 0.52, 0.52, 1]
#define COLOR_RGBA_LIGHT_GREEN [0.78, 0.92, 0, 1]
#define COLOR_RGBA_LIGHT_BLUE [0.6,0.6,0.9,1]
#define COLOR_RGBA_YELLOW [0.92, 0.81, 0, 1]
#define COLOR_RGBA_GRAY [0.7,0.7,0.7,1]
#define COLOR_RGBA_DIMMED_RED [0.4, 0.1, 0.1, 0.5]
#define COLOR_RGBA_DIMMED_GREEN [0.1, 0.4, 0.1, 0.5]


// Font sizes - UI
#define UI_SIZE_HINT_TITLE SQ(1.2)

#define UI_FONT_SIZE_XL SQ(1.5)
#define UI_FONT_SIZE_L SQ(1.25)
#define UI_FONT_SIZE_NORMAL SQ(1)
#define UI_FONT_SIZE_S SQ(0.85)
#define UI_FONT_SIZE_XS SQ(0.75)

// Font sizes - briefing pages
#define UI_NOTES_FONT_SIZE_XL SQ(20)
#define UI_NOTES_FONT_SIZE_L SQ(16)
#define UI_NOTES_FONT_SIZE_NORMAL SQ(14)
#define UI_NOTES_FONT_SIZE_S SQ(12)
#define UI_NOTES_FONT_SIZE_XS SQ(10)

// Fonts 
#define UI_FONT_MAIN SQ(PuristaMedium)
