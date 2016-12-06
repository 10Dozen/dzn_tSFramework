/*
call compile preProcessFileLineNumbers "dzn_tSFramework\Modules\tSAdminTools\Functions Diag.sqf"; 
call tSF_Diag_AddDiagTopic; 
call tSF_Diag_TSF_CollectData;
call tSF_Diag_TSF_CollectModulesData;

*/

#define		HEAD	""
#define		TITLE	""

tSF_Diag_AddDiagTopic = {
	tSF_Diag_Subject = "tSF_Diagpage";
	if !(player diarySubjectExists tSF_Diag_Subject) then {
		player createDiarySubject [tSF_Diag_Subject, "tSF DIAGNOSTICS"];
	};	
};

tSF_Diag_TSF_CollectTotalData = {	
	private _formatDate = {
		#define	STR_DATE(X)		if (count str(X) == 1) then { "0" + str(X) } else { str(X) }
		format[tSF_Intro_LineText1, STR_DATE(MissionDate select 2), STR_DATE(MissionDate select 1), MissionDate select 0	]
	};
	
	private _topicHead = format[
		"<font %1>Scenario name:</font><br/>        %2<br /><br /><font %1>Date:</font><br />        %3<br />"		
		, "size='14' color='#b7f931'"
		, missionName
		, call _formatDate
	];
	
	private _topicModules = format["<font %1>Modules:</font><br />", "size='14' color='#b7f931'"];
	{
		_topicModules = format [
			"%1<br /><font size='12'>[%2]</font>%3   <font color='%4'>%5</font>"
			, _topicModules
			, if (_x select 0) then { "<font color='#b7f931'>ON</font>"} else {"<font color='#f95631'>OFF</font>"}
			, if (_x select 0) then { " " } else { "" }
			, if (_x select 0) then { "#ffffff" } else { "#777777" }
			, _x select 1
		];
	} forEach [
		[tSF_module_MissionDefaults			,"Mission Defaults"]
		,[tSF_module_MissionConditions		,"Mission Conditions"]
		,[tSF_module_IntroText				,"Intro Text"]
		,[tSF_module_Briefing				,"Briefing"]
		,[tSF_module_JIPTeleport			,"JIP Teleport"]		
		,[tSF_module_tSNotes				,"tS Notes"]
		,[tSF_module_tSNotesSettings			,"tS Notes Settings"]		
		,[tSF_module_CCP					,"Casualties Collection Point"]
		,[tSF_module_Support				,"Support"]		
		,[tSF_module_Interactives			,"Interactives"]
		,[tSF_module_InteractivesACE			,"Interactives ACE"]		
		,[tSF_module_EditorVehicleCrew		,"Editor Vehicle Crew"]
		,[tSF_module_EditorUnitBehavior		,"Editor Unit Behavior"]
		,[tSF_module_EditorRadioSettings		,"Editor Radio Settings"]		
		,[tSF_module_tSAdminTools			,"tS Admin Tools"]
	];
	
	player createDiaryRecord ["tSF_Diagpage", ["tSF - Totals", format ["%1<br />%2", _topicHead, _topicModules]]];
};

tSF_Diag_TSF_CollectModulesData = {
	private _topic = "";
	{
		private _module = _x select 0;
		private _vars = _x select 1;
		
		_topic = format [
			"%1<br /><font size='16'>%2</font>"
			, _topic
			, _x select 0
		];
		
		{
			private _var = call compile (_x select 0);
			private _desc = _x select 1;
			private _vartype = _x select 2;
			
			_topic = format [
				"%1<br />  %2 -- %3"
				, _topic
				, _desc
				, switch (_vartype) do {
					case "bool": { if (_var) then { "Yes" } else { "No" } };
					case "string": { _var };
					case "time": { str(_var) + " seconds" };
				}
			];
		} forEach _vars;	
	} forEach [
		tSF_Briefing_Schema
		/*[
			"Briefing"
			,[
				["tSF_Briefing_ShowRoster", "Show Roster", "bool"]
				, ["tSF_Briefing_RosterTimeout", "Timeout before roster displayed", "time"]
				, ["tSF_Briefing_UpdateRosterOnJIP", "Update roster on JIP", "bool"]
			]
		]*/
		, [
			"CCP"
			,[
				["tSF_CCP_Composition", "Composition on site", "string"]
				, ["tSF_CCP_TimeToHeal", "Time to heal", "time"]
				, ["tSF_CCP_TimeToHold", "Time to stay at CCP", "time"]
			]
		]
	];
	
	player createDiaryRecord ["tSF_Diagpage", ["tSF - Modules", _topic]];
};




tSF_Diag_Dynai_CollectData = {
	/*
		Dynai:
			Config Zone vs Real zones
	*/
	
};

tSF_Diag_Gear_CollectData = {
	/*
		Gear:
			GAT vs Kits
			
			GAT vs Kits vs Roles
	*/
	
};

