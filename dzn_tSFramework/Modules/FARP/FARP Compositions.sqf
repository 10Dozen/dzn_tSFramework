
#define	EQUIP_BOX_CODE	missionNamespace setVariable ["tSF_FARP_EquipmentBox",_this, true]; clearItemCargoGlobal _this; sleep 2; _this enableSimulationGlobal true
tSF_FARP_Compositions = [

	[
		"NATO HEMMT RFA"
		,[
			["B_Truck_01_Repair_F",350.416,11.996,1.063,-0.003,false,{},true]
			,["B_Truck_01_fuel_F",100.487,6.197,184.683,-0.01,false,{},true]
			,["B_Truck_01_ammo_F",331.526,13.62,0,-0.01,false,{},true]
			
			,["Box_NATO_Equip_F",13.3591,8.006,94.157,0.024,false,{ EQUIP_BOX_CODE },true]	
			
			,["Land_CampingChair_V1_F",359.283,9.082,354.818,0.027,false,{},true]		
			,["Land_CampingTable_F",2.11435,7.865,0.001,0.024,false,{},true]
			,["Land_CampingTable_F",357.762,11.841,90.9,0.033,false,{},true]		
			,["Land_CanisterPlastic_F",349.918,7.13,1.505,0.024,false,{},true]
			,["Land_Pallet_MilBoxes_F",309.6,10.198,0,0,false,{},true]
			,["Land_WeldingTrolley_01_F",359.241,10.462,0.009,0.024,false,{},true]
			,["Land_RedWhitePole_F",303.68,10.458,359.958,0.024,false,{},true]
			,["Land_RedWhitePole_F",35.1402,7.616,359.914,0.024,false,{},true]
			,["Land_RedWhitePole_F",153.611,8.226,0.24,0.024,false,{},true]
			,["Land_RedWhitePole_F",331.439,6.949,359.865,0.024,false,{},true]
			,["RoadCone_F",141.182,5.356,359.999,0.024,false,{},true]
			,["RoadCone_F",97.5375,3.592,359.999,0.024,false,{},true]
			,["RoadCone_F",47.4087,5.395,359.999,0.024,false,{},true]
		]
	]

];

