
if (hasInterface) then {
	call compile preProcessFileLineNumbers "dzn_tSFramework\Modules\IntroText\Settings.sqf";
	[] spawn {
		waitUntil { time > tSF_Intro_ShowTime };
		[
			[
				
				[
					format[tSF_Intro_LineText1, MissionDate select 2, MissionDate select 1, MissionDate select 0]
					, tSF_Intro_LineStyle1
				]
				,[
					tSF_Intro_LineText2
					, tSF_Intro_LineStyle2
				]
				,[
					tSF_Intro_LineText3
					, tSF_Intro_LineStyle3
				]
			]
			, tSF_Intro_TextPosition select 0
			, tSF_Intro_TextPosition select 1
		] spawn BIS_fnc_typeText;
	};


	if !(tSF_Intro_ShowCurrentTime) exitWith {};
	
	private _GetFormattedTime = {
		private _hrs = floor (daytime);
		private _min = str( floor ((daytime - _hrs) * 60));
		if (count (_min) == 1) then {
			_min = "0" + _min;
		};
		
		( format ["%1:%2", str(_hrs), _min] )
	};
	
	tSF_Intro_LineText1 = format ["%1 %2", call _GetFormattedTime, tSF_Intro_LineText1];
};
