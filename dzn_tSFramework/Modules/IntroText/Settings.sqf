tSF_Intro_ShowCurrentTime   = true;

// 1st line -- Date in format DD/MM/YYYY. Use "%1/%2/%3" to use MissionDate.
tSF_Intro_LineText1	= "%1/%2/%3";
tSF_Intro_LineStyle1	= "<t align = 'right' shadow = '1' size = '0.7' font='PuristaBold'><br />%1</t>";

// 2nd line
tSF_Intro_LineText2	= "Район Н, Страна Н, Регион Н";
tSF_Intro_LineStyle2	= "<t align = 'right' shadow = '1' size = '0.7' font='PuristaBold'><br />%1</t>";

// 3rd line
tSF_Intro_LineText3	= "Операция 'Без имени'";
tSF_Intro_LineStyle3	= "<t align = 'right' shadow = '1' size = '0.9' font='PuristaBold'><br />%1</t>";

// Other settings
tSF_Intro_ShowTime	= 15;
tSF_Intro_TextPosition	= [0.2, 0.7];




/*
 * *********************************
 * Description of the module
 * *********************************
 */
tSF_Intro_Schema = [
	/* Module name */	"Intro Text"
	,[
		/* Module Settings */
		[
			/* Setting */		"tSF_Intro_ShowTime"
			/* Description */	, "Delay before Intro is shown"
			/* Type */			, "time"
		]
		, [
			/* Setting */		"tSF_Intro_ShowCurrentTime"
			/* Description */	, "Show Current time in intro text"
			/* Type */			, "bool"
		]
		, [
			/* Setting */		"tSF_Intro_LineText1"
			/* Description */	, "1st line"
			/* Type */			, "string"
		]
		, [
			/* Setting */		"tSF_Intro_LineText2"
			/* Description */	, "2nd line"
			/* Type */			, "string"
		]
		, [
			/* Setting */		"tSF_Intro_LineText3"
			/* Description */	, "3nd line"
			/* Type */			, "string"
		]
	]
];
