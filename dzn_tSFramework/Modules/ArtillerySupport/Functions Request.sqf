
tSF_fnc_ArtillerySupport_ShowMenu = {
	// @BatteryCallsign call tSF_fnc_ArtillerySupport_ShowMenu
	private _battery = _this call tSF_fnc_ArtillerySupport_GetBattery;	
	
	if ([_battery, "State", "Waiting"] call tSF_fnc_ArtillerySupport_AssertStatus) then {
		_battery call tSF_fnc_ArtillerySupport_ShowRequestMenu;
	} else {
		if (_battery call tSF_fnc_ArtillerySupport_IsAvailable) then {
			_battery call tSF_fnc_ArtillerySupport_ShowCorrectionMenu;
		} else {
			hint "Artillery is not available";		
		};	
	};
};

tSF_fnc_ArtillerySupport_ShowRequestMenu = {
	// [ @Logic, @Callsign, @VehicleDisplayName, @Vehicles ]
	tSF_ArtillerySupport_LastRequested = _this;
	private _AvailableFMs = _this call tSF_fnc_ArtillerySupport_GetBatteryMissionsAvailable;
	
	
	[
		[0,"HEADER","Firemission Request"]
		,[1,"LABEL","<t align='right'>Battery:</t>"]
		,[1,"LABEL", (_this select 1)]
		,[2,"LABEL", format ["<t align='center'>%1<t>", _AvailableFMs select 2]]
		,[3,"HEADER",""]
		,[4,"INPUT"]
		,[4,"LABEL", "<t align='left'>8-Grid</t><t align='right'>TRP</t>"]
		,[4,"DROPDOWN",[" ","TRP001","TRP002","TRP003"],[]]
		,[5,"LABEL",""]
		,[6,"LISTBOX", _AvailableFMs select 0, _AvailableFMs select 1]
		,[6,"LABEL","<t align='left'>Type</t> <t align='center' color='#999999'>ROUND</t> <t align='right'>Number</t>"]
		,[6,"LISTBOX",["5","6","7","8","9","10","1","2","3","4"],[]]
		,[7,"LABEL",""]		
		,[8,"LABEL","<t align='right'>Spread diameter(m)</t>"]
		,[8,"SLIDER",[0,500,30]]		
		,[9,"LABEL",""]
		,[10,"BUTTON","CANCEL",{closeDialog 2;}]
		,[10,"LABEL",""]
		,[10,"BUTTON","REQUEST", {
			closeDialog 2;
			[tSF_ArtillerySupport_LastRequested, _this] spawn tSF_fnc_ArtillerySupport_RequestFiremission;
		}]
	] call dzn_fnc_ShowAdvDialog;
};

tSF_fnc_ArtillerySupport_ShowCorrectionMenu = {
	// [ @Logic, @Callsign, @VehicleDisplayName, @Vehicles ]
	tSF_ArtillerySupport_LastRequested = _this;
	private _firemission = [_this, "Firemission"] call tSF_fnc_ArtillerySupport_GetStatus; //  [_pos, _type, _typeName, _number, _spread]
	
	private _pos = _firemission select 0;
	private _type = _firemission select 1;
	private _typeName = _firemission select 2;
	private _number = _firemission select 3;
	private _spread = _firemission select 4;
	
	[
		[0,"HEADER","Adjust Firemission"]
		,[1,"LABEL","<t align='right'>Battery:</t>"]
		,[1,"LABEL", (_this select 1)]
		,[2,"LABEL","<t align='right'>Firemission:</t>"]
		,[2,"LABEL", format ["%1, %2 %3", _pos call dzn_fnc_getMapGrid, _number, _typeName]]
	
		,[3,"HEADER",""]
	
		,[4,"LABEL","<t align='center'>North</t>"]
		,[5,"LABEL","<t align='center'>West</t>"]
		,[5,"INPUT"]
		,[5,"LABEL","<t align='center'>East</t>"]
		,[6,"INPUT"]
		,[6,"BUTTON","<t align='center'>ADJUST</t>",{
			closeDialog 2;
			[tSF_ArtillerySupport_LastRequested, _this] call tSF_fnc_ArtillerySupport_AdjustFiremission;
		}]
		,[6,"INPUT"]
		,[7,"LABEL",""]
		,[7,"INPUT"]
		,[7,"LABEL",""]
		,[8,"LABEL","<t align='center'>South</t>"]
		,[9,"LABEL",""]
	
		,[10,"BUTTON","ABORT",{
			closeDialog 2;
			[tSF_ArtillerySupport_LastRequested] call tSF_fnc_ArtillerySupport_CancelFiremission;
		}]
		,[10,"LABEL",""]
	
		,[10,"BUTTON","FIRE FOR EFFECT",{
			closeDialog 2;
			[tSF_ArtillerySupport_LastRequested] call tSF_fnc_ArtillerySupport_FireForEffect;		
		}]
	] call dzn_fnc_ShowAdvDialog;
};





/*
b1 = getArtilleryAmmo [vehicle A1];
b2 = (getPos TGT1) inRangeOfArtillery [[vehicle A1], "8Rnd_82mm_Mo_shells"];

(A1) commandArtilleryFire [(getPos TGT1), "8Rnd_82mm_Mo_Smoke_white", 6]
*/



/*

_this in Button Code is an array of values formatted as:
		INPUT			- [@InputText (STRING)]
		DROPDOWN or LISTBOX	- [@SelectedItemID (SCALAR), @SelectedItemText (STRING), @ExpressionPerItem (ARRAY of CODE)]
		CHECKBOX		- [@IsChecked (BOOL)]
		SLIDER			- [@SelectedValue (SCALAR), [@MinimumValue (SCALAR), @MaximumValues (SCALAR)]]
	Values are listed in order they where added (e.g. from line 0 to 5) and can be reffered as _this select 0 for 1st input item, _this select 6 for 7th inpu
	*/
/*
	Artillery Battery State Machine:
	
	Initial: [Waiting]
	 |
	Artillery Called and TGT POS is valid: [Searching Fire]
	 |
	Artillery check distance -- Not In Range -- Cancel firemission: [Waiting]
	 |
	In Range - Make shot and wait for Correction: [Waiting Correction]
	 |			|
	 |			Aborted By Requester OR 5 min of Inactivity -- Cancel firemission: [Waiting]
	 |
	[Correction Passed] 
	 |		|
	 |		New Searching Fire requested: [Searching Fire] -- Reset Inactivity timeout: [Waiting Correction]
	 |
	Fire For Effect requested: [Fire For Effect] -- On firemission comleted: [Waiting]

*/
