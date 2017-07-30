
if (hasInterface) then {
	call compile preProcessFileLineNumbers "dzn_tSFramework\Modules\IntroText\Settings.sqf";
	[] spawn {
		waitUntil { time > tSF_Intro_ShowTime };
		#define	STR_DATE(X)		if (count str(X) == 1) then { "0" + str(X) } else { str(X) }
		private _formatDate = {
			format[
				tSF_Intro_LineText1
				, STR_DATE(MissionDate select 2)
				, STR_DATE(MissionDate select 1)
				, MissionDate select 0
			]
		};
		
		if (tSF_Intro_LineText2 == "Район Н, Страна Н, Регион Н") then {
			tSF_Intro_LineText2 = "";
		};
		if (tSF_Intro_LineText3 == "Операция 'Без имени'") then {
			tSF_Intro_LineText3 = "";
		};
		
		[
			[
				
				[call _formatDate, tSF_Intro_LineStyle1]
				,[tSF_Intro_LineText2, tSF_Intro_LineStyle2]
				,[tSF_Intro_LineText3, tSF_Intro_LineStyle3]
				,["                     ", tSF_Intro_LineStyle3]
			]
			, tSF_Intro_TextPosition select 0
			, tSF_Intro_TextPosition select 1
		] spawn BIS_fnc_typeText;
	};

	if !(tSF_Intro_ShowCurrentTime) exitWith {};
	tSF_Intro_LineText1 = format [
		"%1 %2"
		, call {
			private _hrs = MissionDate select 3;
			private _min = str(MissionDate select 4);
			if (count (_min) == 1) then {
				_min = "0" + _min;
			};

			( format ["%1:%2", str(_hrs), _min] )
		}
		, tSF_Intro_LineText1
	];
};
