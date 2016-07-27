
if (hasInterface) then {
	call compile preProcessFileLineNumbers "dzn_tSFramework\Modules\IntroText\Settings.sqf";
	[] spawn {
		waitUntil { time > tSF_Intro_ShowTime };
		[
			[
				
				[
					tSF_Intro_LineText1
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
	sleep 10;

	private _GetFormattedTime = {
		private _hrs = floor (dayitme);
		private _min = floor((dayitme - _hrs) * 60);
		private _sec = floor(_min % 10);

		( format ["%1:%2:$3", _hrs, _min, _sec] )
	};

	for "_i" from 0 to 5 do {
		[ call _GetFormattedTime ] spawn BIS_fnc_infoText;
	};
};
