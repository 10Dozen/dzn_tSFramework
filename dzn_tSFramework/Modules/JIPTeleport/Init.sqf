call compile preProcessFileLineNumbers "dzn_tSFramework\Modules\JIPTeleport\Settings.sqf";

dzn_tSF_JIPTeleport_isJIP = {
	didJIP
};

if (hasInterface && call dzn_tSF_JIPTeleport_isJIP) exitWith {	
	waitUntil { !(isNull (findDisplay 46)) && { isPlayer player && local player && time > (2 max tSF_JIPTeleport_InitTimeout) } }; 
	waitUntil tSF_JIPTeleport_InitCondition;
	
	player setVariable [
		"tSF_JIPTeleport_Action"
		, [
			player
			, "<t size='1.25' color='#EDB81A'>JIP Teleport</t>"
			, {
				player removeAction (player getVariable "tSF_JIPTeleport_Action");
				player setVariable ["tSF_JIPTeleport_Action", nil];
				
				private _u = objNull;
				private _grpUnits = units (group player);
				if (_grpUnits isEqualTo [] || count _grpUnits < 2 ) then {
					hint "Sorry, you are the only one, so wait for GSO to teleport you.";
				} else {
					_u = if (leader (group player) == player) then {
						( _grpUnits - [leader (group player)] ) select 0
					} else {
						leader (group player)
					};
					
					private _pos = _u modelToWorldVisual tSF_JIPTeleport_RelativePos;
					_pos set [2, 0];

					[_pos] spawn {
						player allowDamage false;
						
						sleep 1;					
						moveOut player;
						player setPosATL (_this select 0);
						
						sleep 1;
						player allowDamage true;				
					};
				};
			}
		] call dzn_fnc_addAction
	];
	
	private _initPos = getPosATL player;
	private _initTime = 0;
	
	if (tSF_JIPTeleport_ShowMessage) then {
		systemChat tSF_JIPTeleport_Message;	
	};	
	
	waitUntil {
		sleep 10; 
		_initTime = _initTime + 10;
		
		(player distance2d _initPos) > tSF_JIPTeleport_MaxDistance
		|| (_initTime > tSF_JIPTeleport_MaxTime)
	};
	
	if (!isNil { player getVariable "tSF_JIPTeleport_Action" }) then {
		player removeAction (player getVariable "tSF_JIPTeleport_Action");
		player setVariable ["tSF_JIPTeleport_Action", nil];
	};
};
