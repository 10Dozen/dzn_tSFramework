
if (hasInterface) then {
	call compile preProcessFileLineNumbers "dzn_tSFramework\Modules\Intro\Settings.sqf";
	[] spawn {
		waitUntil { time > tsf_intro_showTime };
		[
			[
				
				[
					tsf_intro_lineText1
					, tsf_intro_lineStyle1
				]
				,[
					tsf_intro_lineText2
					, tsf_intro_lineStyle2
				]
				,[
					tsf_intro_lineText3
					, tsf_intro_lineStyle3
				]
			]
			, tsf_intro_textPosition select 0
			, tsf_intro_textPosition select 1
		] spawn BIS_fnc_typeText;
	};
};
