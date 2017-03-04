/*
 * Scenario Assets
 */
dzn_fnc_tSF_3DEN_AddZeus = {
	collect3DENHistory {
		if !(isNull dzn_tSF_3DEN_Zeus) exitWith {
			// "tSF Tools - Zeus Module already exists" call dzn_fnc_tSF_3DEN_ShowWarn;
		};
		
		dzn_tSF_3DEN_Zeus = create3DENEntity ["Logic","ModuleCurator_F",screenToWorld [0.3,0.3]];
		dzn_tSF_3DEN_Zeus set3DENAttribute ["Name", "tSF_Zeus"];		
		
		dzn_tSF_3DEN_Zeus set3DENAttribute [
			"Init"
			, "this setVariable ['addons',3,true];this setVariable ['owner','#adminLogged',true];"
		];
		
		call dzn_fnc_tSF_3DEN_createTSFLayer;
		dzn_tSF_3DEN_Zeus set3DENLayer dzn_tSF_3DEN_tSFLayer;
		
		"tSF Tools - Zeus Module was created" call dzn_fnc_tSF_3DEN_ShowNotif;	
	};
};

dzn_fnc_tSF_3DEN_AddBaseTrg = {
	collect3DENHistory {	
		if !(isNull dzn_tSF_3DEN_BaseTrg) exitWith {
			"tSF Tools - BaseTrg already exists" call dzn_fnc_tSF_3DEN_ShowWarn;
		};
		
		dzn_tSF_3DEN_BaseTrg = create3DENEntity ["Trigger","EmptyDetectorAreaR250", screenToWorld [0.5,0.5]];
		dzn_tSF_3DEN_BaseTrg set3DENAttribute ["Name", "baseTrg"];

		call dzn_fnc_tSF_3DEN_createTSFLayer;
		dzn_tSF_3DEN_BaseTrg set3DENLayer dzn_tSF_3DEN_tSFLayer;
		
		do3DENAction "ToggleMap";
		"tSF Tools - BaseTrg was created" call dzn_fnc_tSF_3DEN_ShowNotif;
	};
};

dzn_fnc_tSF_3DEN_AddCCP = {
	collect3DENHistory {	
		if !(isNull dzn_tSF_3DEN_CCP) exitWith { 
			"tSF Tools - CCP already exists" call dzn_fnc_tSF_3DEN_ShowWarn;
		};
		
		private _pos = screenToWorld [0.5,0.5];
		dzn_tSF_3DEN_CCP = create3DENEntity ["Logic","Logic", _pos];
		private _ccpZone = create3DENEntity [
			"Trigger"
			,"EmptyDetectorAreaR250"
			, [ (_pos select 0) + 50, _pos select 1, 0 ]
		];
		
		dzn_tSF_3DEN_CCP set3DENAttribute ["Name", "tSF_CCP"];
		
		call dzn_fnc_tSF_3DEN_createTSFLayer;
		dzn_tSF_3DEN_CCP set3DENLayer dzn_tSF_3DEN_tSFLayer;
		_ccpZone set3DENLayer dzn_tSF_3DEN_tSFLayer;
		
		add3DENConnection ["Sync", [dzn_tSF_3DEN_CCP],_ccpZone];
		do3DENAction "ToggleMap";
		"tSF Tools - CCP was created" call dzn_fnc_tSF_3DEN_ShowNotif;
	};
};

dzn_fnc_tSF_3DEN_ConfigureScenario = {
	disableSerialization;
	
	private _form = [
		["Title", []]			
		, ["Summary", []]
		, ["Author (def: TS)",[]]
		, ["Picture (def: overview.jpg)",[]]			
		, ["Max Players", []]
	];
	private _scenarioData = ["", "", "Tactical Shift", "overview.jpg", ""];
	
	if !(isNull dzn_tSF_3DEN_ScnearioLogic) then {
		_scenarioData = [
			"Scenario" get3DENMissionAttribute "IntelBriefingName"
			, "Multiplayer" get3DENMissionAttribute "IntelOverviewText"
			, if ("Scenario" get3DENMissionAttribute "Author" == "") then { _scenarioData select 2 } else { "Scenario" get3DENMissionAttribute "Author" }
			, if ("Scenario" get3DENMissionAttribute "OverviewPicture"== "") then { _scenarioData select 3 } else { "Scenario" get3DENMissionAttribute "OverviewPicture" }
			, str("Multiplayer" get3DENMissionAttribute "MaxPlayers")
		];
		
		for "_i" from 0 to 4 do {
			(_form select _i) set [1, _scenarioData select _i];
		};
	};
	
	tsd = _scenarioData;
	private _result = [
		"Scenario Settings"
		, _form
	] call dzn_fnc_3DEN_ShowChooseDialog;
	if (count _result == 0) exitWith { dzn_tSF_3DEN_toolDisplayed = false };
	
	dzn_tSF_3DEN_Parameter = _result;
	
	collect3DENHistory {
		private _result = dzn_tSF_3DEN_Parameter;
		
		#define	RESOLVE_IF_NONE(X)	if (typename (_result select X) == "SCALAR") then { _scenarioData select X } else { _result select X }
		private _title = RESOLVE_IF_NONE(0);
		private _summary = RESOLVE_IF_NONE(1);
		private _author = RESOLVE_IF_NONE(2);
		private _picture = RESOLVE_IF_NONE(3);
		private _maxPlayers = RESOLVE_IF_NONE(4);
		
		tSF_3DEN_SummaryText = _summary;
		call dzn_fnc_tSF_3DEN_AddScenarioLogic;
		call dzn_fnc_tSF_3DEN_CoverMap;
		
		set3DENMissionAttributes [
			["Scenario","IntelBriefingName", _title]
			, ["Scenario","OverviewText", _summary]	
			, ["Scenario","OnLoadMission", _summary]			
			, ["Scenario","OverviewPicture", _picture]
			, ["Scenario","LoadScreen", _picture]
			, ["Scenario","OverviewPictureLocked", _picture]
			, ["Scenario","Author", _author]			
			, ["Scenario","Saving", false]
			, ["Scenario","EnableDebugConsole", 1]
			, ["Scenario","SaveBinarized", false]			
			
			, ["Multiplayer","MinPlayers", 1]
			, ["Multiplayer","MaxPlayers", parseNumber(_maxPlayers)]
			, ["Multiplayer","GameType","Coop"]
			, ["Multiplayer","IntelOverviewText", _summary]	
			, ["Multiplayer","DisabledAI", true]
			, ["Multiplayer","respawn",3]
			, ["Multiplayer","RespawnDialog", false]
			, ["Multiplayer","RespawnButton", 0]
			, ["Multiplayer","RespawnTemplates", ["ace_spectator","EndMission"]]
		];
	
		private _respawnMrk = create3DENEntity ["Marker","mil_start", screenToWorld [0.5,0.5]];
		_respawnMrk set3DENAttribute ["name", "respawn_west"];
		_respawnMrk set3DENAttribute ["text", "Rename me to 'respawn_west'"];
		do3DENAction "ToggleMap";
		
		"tSF Tools - Scenario was configured" call dzn_fnc_tSF_3DEN_ShowNotif;
	};
	
	call dzn_fnc_tSF_3DEN_AddZeus;
};

dzn_fnc_tSF_3DEN_AddScenarioLogic = {
	if !(isNull dzn_tSF_3DEN_ScnearioLogic) exitWith {
		dzn_tSF_3DEN_ScnearioLogic set3DENAttribute [
			"Init"
			, format ["tSF_SummaryText = '%1'", tSF_3DEN_SummaryText]
		];	
	};
	
	collect3DENHistory {
		dzn_tSF_3DEN_ScnearioLogic = create3DENEntity ["Logic","Logic",screenToWorld [0.3,0.5]];
		dzn_tSF_3DEN_ScnearioLogic set3DENAttribute ["Name", "tSF_Scenario_Logic"];
		dzn_tSF_3DEN_ScnearioLogic set3DENAttribute [
			"Init"
			, format ["tSF_SummaryText = '%1'", tSF_3DEN_SummaryText]
		];
		
		call dzn_fnc_tSF_3DEN_createMiscLayer;
		dzn_tSF_3DEN_ScnearioLogic set3DENLayer dzn_tSF_3DEN_MiscLayer;
	};
}; 

dzn_fnc_tSF_3DEN_CoverMap = {
	if !(isNull dzn_tSF_3DEN_CoverMap) exitWith {};
	
	collect3DENHistory {
		dzn_tSF_3DEN_CoverMap = create3DENEntity ["Logic","ModuleCoverMap_F",screenToWorld [0.7,0.5]];
		dzn_tSF_3DEN_CoverMap set3DENAttribute ["Name", "tSF_CoverMap"];
		dzn_tSF_3DEN_CoverMap set3DENAttribute ["size2", [2000,2000]];
		
		call dzn_fnc_tSF_3DEN_createMiscLayer;
		dzn_tSF_3DEN_CoverMap set3DENLayer dzn_tSF_3DEN_MiscLayer;
	};

};
