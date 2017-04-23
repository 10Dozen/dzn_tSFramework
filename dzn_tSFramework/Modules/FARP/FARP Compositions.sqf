
#define	EQUIP_BOX_CODE	missionNamespace setVariable ["tSF_FARP_EquipmentBox",_this, true]; clearItemCargoGlobal _this; sleep 2; _this enableSimulation true
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
	,[
		"FARP HEMTT NATO"
		, [
			["B_Truck_01_ammo_F",344.909,12.64,0,-0.01,false,{},true]
			,["B_Truck_01_fuel_F",97.2404,9.221,184.683,-0.01,false,{},true]
			,["B_Truck_01_Repair_F",5.11885,11.839,1.063,-0.005,false,{},true]
			
			,["ACE_Wheel",21.4821,7.061,0.948,0.028,false,{},true]
			,["ACE_Wheel",21.9095,7.017,1.805,0.339,false,{},true]
			,["ACE_Wheel",31.8056,7.941,0.175,0.028,false,{},true]
			,["ACE_Wheel",31.5062,7.806,0.512,0.339,false,{},true]
			
			,["Land_RedWhitePole_F",50.2153,9.68,359.946,0.024,false,{},true]
			,["Land_RedWhitePole_F",318.5,8.388,359.942,0.024,false,{},true]
			,["Land_RedWhitePole_F",230.834,7.086,0.254,0.024,false,{},true]
			,["Land_RedWhitePole_F",122.025,7.899,0.137,0.024,false,{},true]
			,["RoadCone_F",100.839,7.024,360,0.024,false,{},true]
			,["RoadCone_F",81.2633,7.165,360,0.024,false,{},true]
			,["RoadCone_F",62.7593,7.902,360,0.024,false,{},true]
			
			,["Land_Pallet_MilBoxes_F",323.392,8.055,0,0,false,{},true]
			,["Land_CanisterPlastic_F",30.3557,9.105,274.663,0.024,false,{},true]
			,["Land_WeldingTrolley_01_F",16.8076,10.926,0.002,0.024,false,{},true]
			,["Land_CampingTable_F",23.1396,8.51,359.996,0.024,false,{},true]
			,["Land_CampingChair_V1_F",18.0055,9.512,354.811,0.027,false,{},true]
			,["Land_CampingTable_F",12.4712,12.08,90.513,0.024,false,{},true]			
		]
	]

];

