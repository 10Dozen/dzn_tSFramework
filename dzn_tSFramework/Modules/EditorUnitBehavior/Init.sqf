call compile preProcessFileLineNumbers "dzn_tSFramework\Modules\EditorUnitBehavior\Settings.sqf";

if (isServer) then {
	tSF_fnc_EUB_assignCaptiveBehavior = {
		_this spawn {
			private _u = _this;
			
			if (tSF_EUB_surrender_OnHit) then {
				private _u_Hit_EH = _u addEventHandler ["Hit", {
					private _u = _this select 0;					
					if (
						tSF_EUB_surrender_OnHit_PlayerCloseOnly 
						&& { [_u, tSF_EUB_surrender_PlayerDistance * 3, "bool"] call dzn_fnc_isPlayerNear }
					) then {
						[_u, true] call ACE_captives_fnc_setSurrendered;

						_u removeEventHandler ["hit", _u getVariable "hit_eh"];
						_u setVariable ["hit_eh", nil];
						_u setVariable ["surrender", true];
					};
				}];
				
				_u setVariable ["hit_eh", _u_Hit_EH];
			};			
			
			waitUntil {
				sleep 5;
				[_u, tSF_EUB_surrender_PlayerDistance, "bool"] call dzn_fnc_isPlayerNear
				||
				_u getVariable ["surrender", false]
			};
			[_u, true] call ACE_captives_fnc_setSurrendered;
		};
	};
	
	tSF_fnc_EUB_processEUBLogics = {
		{
			private _logic = _x;
			private _syncUnits = synchronizedObjects _x;
			
			if !(isNil {_logic getVariable "tSF_EUB"}) then {
				if (_logic getVariable "tSF_EUB" == "Surrender") then {
					{ _x call tSF_fnc_EUB_assignCaptiveBehavior } forEach _syncUnits;				
				};
			};
		} forEach (entities "Logic");	
	};


	waitUntil { time > tSF_EUB_initTimeout };
	call tSF_fnc_EUB_processEUBLogics;
};