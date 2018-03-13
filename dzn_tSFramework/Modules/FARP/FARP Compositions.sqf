/*
	US/NATO:
		"NATO HEMMT RFA"
		"NATO HEMTT FA"
		"NATO HEMTT Woodland RFA"
		"NATO HEMMT Woodland FA"
		"NATO HEMTT Desert RFA"
		"NATO HEMMT Desert FA"
		"USA MTVR Desert RFA"
		"USA MTVR Desert FA"
		"USA MTVR Woodland RFA"
		"USA MTVR Woodland FA"
		"USA FMTV Woodland FA"
		"USA FMTV Desert FA"
		"USA FMTV Desert RFA"
		"USA HMMWV Desert FA"
		"USA HMMWV Woodland FA"

	Russian / Takistan / CSAT:
		"RU Trucks RFA"
		"RU Trucks FA"
		"ChDKZ URAL RFA"
		"ChDKZ URAL FA"
		"Taki URAL RFA"
		"Taki URAL FA"
		"Green URAL RFA"
		"Green URAL FA"
		"Taki Praga RFA"
		"Taki Praga FA"
		"Praga RFA"
		"Praga FA"
		"CSAT Typhoon FA"
		"CSAT Typhoon RFA"
		"CSAT Typhoon Green FA"
		"CSAT Typhoon Green RFA"
		"CSAT KAMAZ FA"
		"CSAT KAMAZ RFA"
		"AAF KAMAZ FA"
		"AAF KAMAZ RFA"

	Civil:
		"Civil RFA"
		"Civil FA"
		"Civil 2 FA"

	Helicopter:
		"Taki Mi-6"
		"RU Mi-6"
		"NATO CH-47"
		"USMC CH-53"

	Equipment vehicle:
		"Ru Tiger"
		"Land Rover Desert"
		"Land Rover Woodland"
		"Land Rover Taki"
		"Land Rover RACS"
		"Land Rover AAF"
		"Land Rover Civil"
		"Ru Vodnik"
		"Ru Tiger Camo"
		"SUV Black"
		"SUV Blue"
		"Civil Van"
		"GAZ-66"
*/

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
	, [
		"NATO HEMTT FA"
		, [
		
			["Land_CanisterPlastic_F",346.494,7.422,1.475,0,false,{},true]
			,["Land_RedWhitePole_F",303.15,10.97,0,0,false,{},true]
			,["Land_RedWhitePole_F",328.896,7.361,0,0,false,{},true]
			,["B_Truck_01_ammo_F",330.826,10.035,266.263,0,false,{},true]
			,["Land_Pallet_MilBoxes_F",309.687,10.442,0,0,false,{},true]
			,["B_Truck_01_fuel_F",99.4089,5.684,184.683,0,false,{},true]
			,["Land_CampingTable_F",13.1715,8.381,0,0,false,{},true]
			,["Land_CampingChair_V1_F",9.11839,9.501,354.814,0,false,{},true]
			,["Land_RedWhitePole_F",31.2124,7.517,0,0,false,{},true]
			,["RoadCone_F",144.158,4.906,0,0,false,{},true]
			,["RoadCone_F",95.0983,3.088,0,0,false,{},true]
			,["RoadCone_F",42.1798,5.193,0,0,false,{},true]
			,["Land_RedWhitePole_F",156.121,7.841,0,0,false,{},true]
			,["Box_NATO_Equip_F",23.211,8.803,94.157,0,false,{ EQUIP_BOX_CODE },true]
		]
	]
	, [
		"NATO HEMTT Woodland RFA"
		, [
			["Land_RedWhitePole_F",294.713,9.603,0,0,false,{},true]
			,["Land_Pallet_MilBoxes_F",300.879,9.184,0,0,false,{},true]
			,["Land_RedWhitePole_F",158.342,9.849,0,0,false,{},true]
			,["Land_CampingTable_F",2.5059,6.078,0,0,false,{},true]
			,["Land_CampingChair_V1_F",358.915,7.295,354.814,0,false,{},true]
			,["Land_CampingTable_F",356.979,10.055,91.588,0,false,{},true]
			,["Land_RedWhitePole_F",322.268,5.461,0,0,false,{},true]
			,["Land_RedWhitePole_F",44.4223,6.223,0,0,false,{},true]
			,["RoadCone_F",150.785,6.829,0,0,false,{},true]
			,["RoadCone_F",122.56,4.196,0,0,false,{},true]
			,["RoadCone_F",64.7211,4.366,0,0,false,{},true]
			,["Land_CanisterPlastic_F",346.332,5.385,1.475,0,false,{},true]
			,["Land_WeldingTrolley_01_F",358.924,8.676,0,0,false,{},true]
			,["Box_NATO_Equip_F",16.9154,6.274,94.157,0,false,{ EQUIP_BOX_CODE },true]
			,["rhsusf_M977A4_REPAIR_usarmy_wd",350.019,10.801,0,-0.006,false,{},true]
			,["rhsusf_M977A4_AMMO_usarmy_wd",328.94,12.511,0,-0.005,false,{},true]
			,["rhsusf_M978A4_usarmy_wd",115.476,6.718,183.443,-0.004,false,{},true]
		]
	]
	, [
		"NATO HEMMT Woodland FA"
		, [
			["Land_RedWhitePole_F",306.933,5.951,0,0,false,{},true]
			,["Land_RedWhitePole_F",287.884,10.653,0,0.247,false,{},true]
			,["Land_Pallet_MilBoxes_F",293.673,9.815,0,0,false,{},true]
			,["rhsusf_M977A4_AMMO_usarmy_wd",318.818,8.426,269.823,0,false,{},true]
			,["Land_CampingTable_F",9.97633,5.517,0,0,false,{},true]
			,["Land_CampingChair_V1_F",4.73998,6.677,354.814,0,false,{},true]
			,["Land_RedWhitePole_F",38.4701,4.728,0,0,false,{},true]
			,["RoadCone_F",164.03,6.973,0,0,false,{},true]
			,["RoadCone_F",144.742,3.676,0,0,false,{},true]
			,["RoadCone_F",66.1247,2.77,0,0,false,{},true]
			,["Land_RedWhitePole_F",167.357,10.142,0,0,false,{},true]
			,["Land_CanisterPlastic_F",343.626,5.087,1.475,0,false,{},true]
			,["Box_NATO_Equip_F",25.1266,5.924,94.157,0,false,{ EQUIP_BOX_CODE },true]
			,["rhsusf_M978A4_usarmy_wd",130.976,6.815,178.038,0,false,{},true]
		]
	]	
	, [
		"NATO HEMTT Desert RFA"
		, [
			["Land_RedWhitePole_F",295.276,9.823,0,0,false,{},true]
			,["Land_Pallet_MilBoxes_F",301.32,9.413,0,0,false,{},true]
			,["rhsusf_M977A4_AMMO_BKIT_usarmy_d",330.248,12.052,358.808,0,false,{},true]
			,["Land_CampingTable_F",0.97542,6.253,0,0,false,{},true]
			,["Land_CampingChair_V1_F",357.72,7.479,354.814,0,false,{},true]
			,["Land_CampingTable_F",356.142,10.244,91.588,0,false,{},true]
			,["Land_RedWhitePole_F",322.107,5.7,0,0,false,{},true]
			,["Land_RedWhitePole_F",42.224,6.245,0,0,false,{},true]
			,["RoadCone_F",151.231,6.595,0,0,false,{},true]
			,["RoadCone_F",121.611,3.966,0,0,false,{},true]
			,["RoadCone_F",61.6515,4.305,0,0,false,{},true]
			,["Land_RedWhitePole_F",158.829,9.623,0,0,false,{},true]
			,["Land_CanisterPlastic_F",345.182,5.598,1.475,0,false,{},true]
			,["Land_WeldingTrolley_01_F",357.915,8.86,0,0,false,{ EQUIP_BOX_CODE },true]
			,["Box_NATO_Equip_F",15.0833,6.403,94.157,0,false,{ EQUIP_BOX_CODE },true]
			,["rhsusf_M978A4_usarmy_d",122.748,6.95,179.959,-0.005,false,{},true]
			,["rhsusf_M977A4_REPAIR_BKIT_usarmy_d",348.419,11.206,0,0,false,{},true]
		]
	]
	, [
		"NATO HEMMT Desert FA"
		, [
			["Land_RedWhitePole_F",306.852,6.762,0,0,false,{},true]
			,["Land_RedWhitePole_F",289.167,11.426,0,0,false,{},true]
			,["Land_Pallet_MilBoxes_F",294.628,10.609,0,0,false,{},true]
			,["rhsusf_M977A4_AMMO_BKIT_usarmy_d",318.066,9.326,269.166,0,false,{},true]
			,["Land_CampingTable_F",2.9155,5.921,0,0,false,{},true]
			,["Land_CampingChair_V1_F",359.175,7.135,354.814,0,false,{},true]
			,["Land_RedWhitePole_F",28.6722,4.766,0,0,false,{},true]
			,["RoadCone_F",168.52,6.351,0,0,false,{},true]
			,["RoadCone_F",149.804,2.917,0,0,false,{},true]
			,["RoadCone_F",49.5555,2.468,0,0,false,{},true]
			,["Land_RedWhitePole_F",170.561,9.546,0,0,false,{},true]
			,["Land_CanisterPlastic_F",338.713,5.753,1.475,0,false,{},true]
			,["Box_NATO_Equip_F",17.6645,6.132,94.157,0,false,{ EQUIP_BOX_CODE },true]
			,["rhsusf_M978A4_usarmy_d",135.021,6.269,179.959,0,false,{},true]
		]
	]
	, [
		"USA MTVR Desert RFA"		
		, [
			["Land_RedWhitePole_F",300.555,10.151,0,0,false,{},true]
			,["Land_Pallet_MilBoxes_F",306.562,9.836,0,0,false,{},true]
			,["CUP_B_MTVR_Ammo_USA",326.184,12.15,0,0,false,{},true]
			,["CUP_B_MTVR_Refuel_USA",110.699,6.403,183.39,-0.001,false,{},true]
			,["Land_CampingTable_F",1.96232,7.222,0,0,false,{},true]
			,["Land_RedWhitePole_F",328.413,6.415,0,0,false,{},true]
			,["Land_RedWhitePole_F",37.8062,7.076,0,0,false,{},true]
			,["RoadCone_F",145.452,5.845,0,0,false,{},true]
			,["RoadCone_F",107.545,3.69,0,0,false,{},true]
			,["RoadCone_F",52.5434,4.95,0,0,false,{},true]
			,["Land_RedWhitePole_F",155.695,8.786,0,0,false,{},true]
			,["Land_CanisterPlastic_F",348.559,6.508,1.475,0,false,{},true]
			,["Box_NATO_Equip_F",14.1862,7.373,94.157,0,false,{ EQUIP_BOX_CODE },true]
			,["CUP_B_MTVR_Repair_USA",347.737,10.229,0,0,false,{},true]
			,["Land_CampingChair_V1_F",358.937,8.441,354.814,0,false,{},true]
			,["Land_CampingTable_F",357.194,11.201,91.588,0,false,{},true]
			,["Land_WeldingTrolley_01_F",358.942,9.822,0,0,false,{},true]
		]
	]
	, [
		"USA MTVR Desert FA"
		, [
			["Land_RedWhitePole_F",157.15,8.344,0,0,false,{},true]
			,["Land_CampingTable_F",359.021,7.537,0,0,false,{},true]
			,["Land_CanisterPlastic_F",346.021,6.901,1.475,0,false,{},true]
			,["Land_RedWhitePole_F",301,10.637,0,0,false,{},true]
			,["Land_RedWhitePole_F",33.8403,7.114,0,0,false,{},true]
			,["Land_RedWhitePole_F",327.133,6.885,0,0,false,{},true]
			,["Box_NATO_Equip_F",10.8491,7.602,94.157,0,false,{ EQUIP_BOX_CODE },true]
			,["Land_Pallet_MilBoxes_F",306.736,10.328,0,0,false,{},true]
			,["RoadCone_F",104.189,3.241,0,0,false,{},true]
			,["RoadCone_F",146.834,5.372,0,0,false,{},true]
			,["RoadCone_F",46.8726,4.868,0,0,false,{},true]
			,["Land_CampingChair_V1_F",356.519,8.774,354.814,0,false,{},true]
			,["CUP_B_MTVR_Ammo_USA",328.834,9.796,272.968,0,false,{},true]
			,["CUP_B_MTVR_Refuel_USA",107.079,6.672,183.39,0,false,{},true]
		]
	]
	, [
		"USA MTVR Woodland RFA"		
		, [
			["Land_RedWhitePole_F",300.555,10.151,0,0,false,{},true]
			,["Land_Pallet_MilBoxes_F",306.562,9.836,0,0,false,{},true]
			,["CUP_B_MTVR_Ammo_USMC",326.184,12.15,0,0,false,{},true]
			,["CUP_B_MTVR_Refuel_USMC",110.699,6.403,183.39,-0.001,false,{},true]
			,["Land_CampingTable_F",1.96232,7.222,0,0,false,{},true]
			,["Land_RedWhitePole_F",328.413,6.415,0,0,false,{},true]
			,["Land_RedWhitePole_F",37.8062,7.076,0,0,false,{},true]
			,["RoadCone_F",145.452,5.845,0,0,false,{},true]
			,["RoadCone_F",107.545,3.69,0,0,false,{},true]
			,["RoadCone_F",52.5434,4.95,0,0,false,{},true]
			,["Land_RedWhitePole_F",155.695,8.786,0,0,false,{},true]
			,["Land_CanisterPlastic_F",348.559,6.508,1.475,0,false,{},true]
			,["Box_NATO_Equip_F",14.1862,7.373,94.157,0,false,{ EQUIP_BOX_CODE },true]
			,["CUP_B_MTVR_Repair_USMC",347.737,10.229,0,0,false,{},true]
			,["Land_CampingChair_V1_F",358.937,8.441,354.814,0,false,{},true]
			,["Land_CampingTable_F",357.194,11.201,91.588,0,false,{},true]
			,["Land_WeldingTrolley_01_F",358.942,9.822,0,0,false,{},true]
		]
	]
	, [
		"USA MTVR Woodland FA"
		, [
			["Land_RedWhitePole_F",157.15,8.344,0,0,false,{},true]
			,["Land_CampingTable_F",359.021,7.537,0,0,false,{},true]
			,["Land_CanisterPlastic_F",346.021,6.901,1.475,0,false,{},true]
			,["Land_RedWhitePole_F",301,10.637,0,0,false,{},true]
			,["Land_RedWhitePole_F",33.8403,7.114,0,0,false,{},true]
			,["Land_RedWhitePole_F",327.133,6.885,0,0,false,{},true]
			,["Box_NATO_Equip_F",10.8491,7.602,94.157,0,false,{ EQUIP_BOX_CODE },true]
			,["Land_Pallet_MilBoxes_F",306.736,10.328,0,0,false,{},true]
			,["RoadCone_F",104.189,3.241,0,0,false,{},true]
			,["RoadCone_F",146.834,5.372,0,0,false,{},true]
			,["RoadCone_F",46.8726,4.868,0,0,false,{},true]
			,["Land_CampingChair_V1_F",356.519,8.774,354.814,0,false,{},true]
			,["CUP_B_MTVR_Ammo_USMC",328.834,9.796,272.968,0,false,{},true]
			,["CUP_B_MTVR_Refuel_USMC",107.079,6.672,183.39,0,false,{},true]
		]
	]
	, [
		"USA FMTV Woodland FA"
		, [
			["Land_CanisterPlastic_F",319.493,4.152,1.475,0,false,{},true]
			,["Land_RedWhitePole_F",295.204,5.268,0,0,false,{},true]
			,["Land_RedWhitePole_F",280.817,10.331,0,0,false,{},true]
			,["Land_Pallet_MilBoxes_F",285.824,9.673,0,0,false,{},true]
			,["rhsusf_M1078A1P2_wd_fmtv_usarmy",312.73,6.97,268.848,0.003,false,{},true]
			,["Land_CampingTable_F",343.834,4.161,0,0,false,{},true]
			,["Land_RedWhitePole_F",51.0585,3.769,0,0,false,{},true]
			,["RoadCone_F",166.637,8.26,0,0,false,{},true]
			,["RoadCone_F",154.016,4.821,0,0,false,{},true]
			,["RoadCone_F",94.7896,2.532,0,0,false,{},true]
			,["Land_RedWhitePole_F",168.864,11.445,0,0,false,{},true]
			,["Box_NATO_Equip_F",5.8326,3.947,94.157,0,false,{ EQUIP_BOX_CODE },true]
			,["rhsusf_M978A4_usarmy_wd",142.772,8.621,178.038,0,false,{},true]
			,["Land_CampingChair_V1_F",343.329,5.447,354.814,0,false,{},true]
		]
	]
	, [
		"USA FMTV Desert FA"
		, [
			["Land_CampingTable_F",352.624,8.315,0,0,false,{},true]
			,["Land_CanisterPlastic_F",340.618,7.852,1.475,0,false,{},true]
			,["Land_RedWhitePole_F",324.246,8.001,0,0,false,{},true]
			,["Land_RedWhitePole_F",301.609,11.808,0,0,false,{},true]
			,["Land_Pallet_MilBoxes_F",306.775,11.505,0,0,false,{},true]
			,["Land_CampingChair_V1_F",351.166,9.581,354.814,0,false,{},true]
			,["rhsusf_M1078A1P2_d_fmtv_usarmy",327.999,10.523,265.442,0,false,{},true]
			,["RoadCone_F",152.155,4.282,0,0,false,{},true]
			,["RoadCone_F",92.1828,2.205,0,0,false,{},true]
			,["RoadCone_F",32.9171,4.811,0,0,false,{},true]
			,["Land_RedWhitePole_F",161.749,7.349,0,0,false,{},true]
			,["rhsusf_M978A4_usarmy_d",118.574,6.432,179.959,0,false,{},true]
			,["Land_RedWhitePole_F",24.5452,7.277,0,0,false,{},true]
			,["Box_NATO_Equip_F",3.44468,8.192,94.157,0,false,{ EQUIP_BOX_CODE },true]
		]
	]
	, [
		"USA FMTV Desert RFA"
		, [
			["Land_CampingTable_F",354.811,11.231,91.588,0,false,{},true]
			,["Land_CampingTable_F",358.253,7.219,0,0,false,{},true]
			,["Land_CanisterPlastic_F",344.582,6.614,1.475,0,false,{},true]
			,["Land_RedWhitePole_F",34.7069,6.797,0,0,false,{},true]
			,["Land_RedWhitePole_F",299.251,10.555,0,0,false,{},true]
			,["Land_RedWhitePole_F",324.978,6.67,0,0,false,{},true]
			,["Land_RedWhitePole_F",158.54,8.607,0,0,false,{},true]
			,["Box_NATO_Equip_F",10.6182,7.27,94.157,0,false,{ EQUIP_BOX_CODE },true]
			,["Land_WeldingTrolley_01_F",356.219,9.839,0,0,false,{},true]
			,["Land_Pallet_MilBoxes_F",304.987,10.214,0,0,false,{},true]
			,["RoadCone_F",149.414,5.596,0,0,false,{},true]
			,["RoadCone_F",49.0185,4.586,0,0,false,{},true]
			,["RoadCone_F",110.08,3.248,0,0,false,{},true]
			,["Land_CampingChair_V1_F",355.77,8.46,354.814,0,false,{},true]
			,["rhsusf_M1078A1P2_d_fmtv_usarmy",323.256,11.264,345.856,0,false,{},true]
			,["rhsusf_M978A4_usarmy_d",116.87,6.187,179.959,0,false,{},true]
			,["rhsusf_M1083A1P2_B_M2_d_MHQ_fmtv_usarmy",346.473,12.016,358.918,0,false,{},true]
		]
	]	
	, [
		"USA HMMWV Desert FA"
		, [
			["Land_CampingTable_F",0.300878,5.556,0,0,false,{},true]
			,["Land_CanisterPlastic_F",344.146,4.827,1.475,0,false,{},true]
			,["Land_RedWhitePole_F",316.737,5.221,0,0,false,{},true]
			,["Land_RedWhitePole_F",291.326,9.619,0,0,false,{},true]
			,["Land_RedWhitePole_F",160.638,10.25,0,0,false,{},true]
			,["Land_RedWhitePole_F",46.3616,5.692,0,0,false,{},true]
			,["FlexibleTank_01_sand_F",124.187,6.092,0,0.994,false,{},true]
			,["FlexibleTank_01_sand_F",127.64,5.625,0,0.994,false,{},true]
			,["FlexibleTank_01_sand_F",128.439,6.521,0,0.994,false,{},true]
			,["FlexibleTank_01_sand_F",122.11,5.209,0,0.995,false,{},true]
			,["FlexibleTank_01_sand_F",119.022,5.773,0,0.995,false,{},true]
			,["FlexibleTank_01_sand_F",132.16,6.023,0,0.994,false,{},true]
			,["Box_NATO_Equip_F",16.1526,5.711,94.157,0,false,{ EQUIP_BOX_CODE },true]
			,["Land_Pallet_MilBoxes_F",297.336,9.139,0,0,false,{},true]
			,["RoadCone_F",130.059,4.312,0,0,false,{},true]
			,["RoadCone_F",154.448,7.179,0,0,false,{},true]
			,["RoadCone_F",70.0417,3.948,0,0,false,{},true]
			,["rhsusf_m998_d_2dr",114.559,5.362,0,0,false,{},true]
			,["AmmoCrates_NoInteractive_Medium",329.287,6.082,196.902,1.014,false,{},true]
			,["AmmoCrates_NoInteractive_Medium",314.054,8.011,1.849,1.014,false,{},true]
			,["Land_CampingChair_V1_F",356.835,6.787,354.814,0,false,{},true]
			,["rhsusf_m998_d_2dr_fulltop",318.233,9.227,0,0,false,{},true]
			,["rhsusf_m998_d_2dr_fulltop",339.378,6.952,11.261,0,false,{},true]
		]
	]
	, [
		"USA HMMWV Woodland FA"
		, [
			["RoadCone_F",152.155,7.172,0,0,false,{},true]
			,["Land_RedWhitePole_F",159.045,10.209,0,0.001,false,{},true]
			,["Land_CampingTable_F",2.83887,5.698,0,0,false,{},true]
			,["Land_CanisterPlastic_F",347.43,4.897,1.475,0,false,{},true]
			,["Land_RedWhitePole_F",292.653,9.435,0,0,false,{},true]
			,["Land_RedWhitePole_F",47.0948,5.97,0,0,false,{},true]
			,["Land_RedWhitePole_F",319.822,5.154,0,0,false,{},true]
			,["FlexibleTank_01_forest_F",119.441,5.357,0,0.995,false,{},true]
			,["FlexibleTank_01_forest_F",121.847,6.231,0,0.994,false,{},true]
			,["FlexibleTank_01_forest_F",126.164,6.64,0,0.994,false,{},true]
			,["FlexibleTank_01_forest_F",129.629,6.125,0,0.994,false,{},true]
			,["FlexibleTank_01_forest_F",125.027,5.748,0,0.994,false,{},true]
			,["FlexibleTank_01_forest_F",116.69,5.933,0,0.995,false,{},true]
			,["Box_NATO_Equip_F",18.1415,5.916,94.157,0,false,{ EQUIP_BOX_CODE },true]
			,["Land_Pallet_MilBoxes_F",298.847,8.98,0,0,false,{},true]
			,["RoadCone_F",126.604,4.426,0,0,false,{},true]
			,["RoadCone_F",69.4838,4.233,0,0,false,{},true]
			,["Land_CampingChair_V1_F",358.991,6.914,354.814,0,false,{},true]
			,["rhsusf_m998_w_2dr_fulltop",341.71,6.996,11.261,0,false,{},true]
			,["rhsusf_m998_w_2dr",112.189,5.54,0,0,false,{},true]
			,["rhsusf_m998_w_2dr_fulltop",319.978,9.164,0,0,false,{},true]
			,["AmmoCrates_NoInteractive_Medium",316.031,7.928,1.849,1.014,false,{},true]
			,["AmmoCrates_NoInteractive_Medium",331.993,6.076,196.902,1.014,false,{},true]
		]
	]	
	, [
		"RU Trucks RFA"
		, [
			["RoadCone_F",164.879,7.697,0,0,false,{},true]
			,["RoadCone_F",149.33,4.335,0,0,false,{},true]
			,["RoadCone_F",81.454,2.652,0,0,false,{},true]
			,["Land_RedWhitePole_F",167.736,10.872,0,0,false,{},true]
			,["RHS_Ural_Fuel_VV_01",135.044,6.693,186.828,0,false,{},true]
			,["Land_CampingTable_F",347.033,4.722,0,0,false,{},true]
			,["Land_CampingTable_F",347.786,8.77,91.588,0,false,{},true]
			,["Land_CanisterPlastic_F",325.374,4.572,1.475,0,false,{},true]
			,["Land_RedWhitePole_F",45.5346,4.247,0,0,false,{},true]
			,["Land_RedWhitePole_F",301.398,5.468,0,0,false,{},true]
			,["Land_RedWhitePole_F",284.209,10.366,0,0,false,{},true]
			,["CUP_O_Ural_Repair_RU",332.053,7.692,0,0,false,{},true]
			,["Box_NATO_Equip_F",6.29547,4.56,94.157,0,false,{ EQUIP_BOX_CODE },true]
			,["Land_WeldingTrolley_01_F",348.327,7.356,0,0,false,{},true]
			,["Land_Pallet_MilBoxes_F",289.404,9.762,0,0,false,{},true]
			,["Land_CampingChair_V1_F",345.891,6.004,354.814,0,false,{},true]
			,["rhs_gaz66_ammo_vv",304.885,9.132,341,0,false,{},true]
		]
	]
	, [
		"RU Trucks FA"
		, [
			["Land_CampingTable_F",351.554,5.957,0,0,false,{},true]
			,["Land_CanisterPlastic_F",334.47,5.599,1.475,0,false,{},true]
			,["Land_RedWhitePole_F",165.039,9.661,0,0,false,{},true]
			,["Land_RedWhitePole_F",291.243,10.583,0,0,false,{},true]
			,["Land_RedWhitePole_F",312.717,6.101,0,0,false,{},true]
			,["Land_RedWhitePole_F",37.0155,5.341,0,0,false,{},true]
			,["Box_NATO_Equip_F",6.7083,5.862,94.157,0,false,{ EQUIP_BOX_CODE },true]
			,["Land_Pallet_MilBoxes_F",296.676,10.097,0,0,false,{},true]
			,["RoadCone_F",160.35,6.52,0,0,false,{},true]
			,["RoadCone_F",135.503,3.419,0,0,false,{},true]
			,["RoadCone_F",59.0381,3.273,0,0,false,{},true]
			,["Land_CampingChair_V1_F",349.808,7.227,354.814,0,false,{},true]
			,["RHS_Ural_Fuel_VV_01",130.744,7.505,186.828,0,false,{},true]
			,["rhs_gaz66_ammo_vv",321.694,7.813,271.227,0,false,{},true]
		]
	]	
	, [
		"ChDKZ URAL RFA"
		, [
			["RoadCone_F",156.943,6.03,0,0,false,{},true]
			,["RoadCone_F",125.744,3.16,0,0,false,{},true]
			,["RoadCone_F",52.588,3.747,0,0,false,{},true]
			,["Land_RedWhitePole_F",163.055,9.138,0,0,false,{},true]
			,["CUP_B_Ural_Refuel_CDF",120.937,5.555,182.105,0,false,{},true]
			,["Land_CampingTable_F",353.788,6.523,0,0,false,{},true]
			,["Land_CampingTable_F",351.826,10.561,91.588,0,false,{},true]
			,["Land_CanisterPlastic_F",338.319,6.074,1.475,0,false,{},true]
			,["Land_RedWhitePole_F",34.8704,5.92,0,0,false,{},true]
			,["Land_RedWhitePole_F",317.644,6.402,0,0,false,{},true]
			,["Land_RedWhitePole_F",294.542,10.658,0,0,false,{},true]
			,["CUP_B_Ural_Repair_CDF",340.621,9.816,0,0,false,{},true]
			,["Box_NATO_Equip_F",7.58243,6.471,94.157,0,false,{ EQUIP_BOX_CODE },true]
			,["Land_WeldingTrolley_01_F",352.883,9.157,0,0,false,{},true]
			,["Land_Pallet_MilBoxes_F",300.067,10.23,0,0,false,{},true]
			,["Land_CampingChair_V1_F",351.805,7.785,354.814,0,false,{},true]
			,["CUP_B_Ural_Reammo_CDF",318.665,12.244,0,0,false,{},true]
		]
	]
	, [
		"ChDKZ URAL FA"
		, [
			["Land_CampingTable_F",356.664,6.662,0,0,false,{},true]
			,["Land_CanisterPlastic_F",341.662,6.121,1.475,0,false,{},true]
			,["Land_RedWhitePole_F",160.829,9.079,0,0,false,{},true]
			,["Land_RedWhitePole_F",296.096,10.441,0,0,false,{},true]
			,["Land_RedWhitePole_F",320.79,6.32,0,0,false,{},true]
			,["Land_RedWhitePole_F",36.3956,6.24,0,0,false,{},true]
			,["Box_NATO_Equip_F",10.0985,6.684,94.157,0,false,{ EQUIP_BOX_CODE },true]
			,["Land_Pallet_MilBoxes_F",301.796,10.043,0,0,false,{},true]
			,["RoadCone_F",153.532,6.013,0,0,false,{},true]
			,["RoadCone_F",120.232,3.337,0,0,false,{},true]
			,["RoadCone_F",53.446,4.101,0,0,false,{},true]
			,["Land_CampingChair_V1_F",354.257,7.911,354.814,0,false,{},true]
			,["CUP_B_Ural_Reammo_CDF",325.424,9.267,268.628,0,false,{},true]
			,["CUP_B_Ural_Refuel_CDF",117.887,5.751,182.105,0,false,{},true]
		]
	]
	, [
		"Taki URAL RFA"
		, [
			["RoadCone_F",156.943,6.03,0,0,false,{},true]
			,["RoadCone_F",125.744,3.16,0,0,false,{},true]
			,["RoadCone_F",52.588,3.747,0,0,false,{},true]
			,["Land_RedWhitePole_F",163.055,9.138,0,0,false,{},true]
			,["CUP_O_Ural_Refuel_TKA",120.937,5.555,182.105,0,false,{},true]
			,["Land_CampingTable_F",353.788,6.523,0,0,false,{},true]
			,["Land_CampingTable_F",351.826,10.561,91.588,0,false,{},true]
			,["Land_CanisterPlastic_F",338.319,6.074,1.475,0,false,{},true]
			,["Land_RedWhitePole_F",34.8704,5.92,0,0,false,{},true]
			,["Land_RedWhitePole_F",317.644,6.402,0,0,false,{},true]
			,["Land_RedWhitePole_F",294.542,10.658,0,0,false,{},true]
			,["CUP_O_Ural_Repair_TKA",340.621,9.816,0,0,false,{},true]
			,["Box_NATO_Equip_F",7.58243,6.471,94.157,0,false,{ EQUIP_BOX_CODE },true]
			,["Land_WeldingTrolley_01_F",352.883,9.157,0,0,false,{},true]
			,["Land_Pallet_MilBoxes_F",300.067,10.23,0,0,false,{},true]
			,["Land_CampingChair_V1_F",351.805,7.785,354.814,0,false,{},true]
			,["CUP_O_Ural_Reammo_TKA",318.665,12.244,0,0,false,{},true]
		]
	]
	, [
		"Taki URAL FA"
		, [
			["Land_CampingTable_F",356.664,6.662,0,0,false,{},true]
			,["Land_CanisterPlastic_F",341.662,6.121,1.475,0,false,{},true]
			,["Land_RedWhitePole_F",160.829,9.079,0,0,false,{},true]
			,["Land_RedWhitePole_F",296.096,10.441,0,0,false,{},true]
			,["Land_RedWhitePole_F",320.79,6.32,0,0,false,{},true]
			,["Land_RedWhitePole_F",36.3956,6.24,0,0,false,{},true]
			,["Box_NATO_Equip_F",10.0985,6.684,94.157,0,false,{ EQUIP_BOX_CODE },true]
			,["Land_Pallet_MilBoxes_F",301.796,10.043,0,0,false,{},true]
			,["RoadCone_F",153.532,6.013,0,0,false,{},true]
			,["RoadCone_F",120.232,3.337,0,0,false,{},true]
			,["RoadCone_F",53.446,4.101,0,0,false,{},true]
			,["Land_CampingChair_V1_F",354.257,7.911,354.814,0,false,{},true]
			,["CUP_O_Ural_Reammo_TKA",325.424,9.267,268.628,0,false,{},true]
			,["CUP_O_Ural_Refuel_TKA",117.887,5.751,182.105,0,false,{},true]
		]
	]
	, [
		"Green URAL RFA"
		, [
			["RoadCone_F",156.943,6.03,0,0,false,{},true]
			,["RoadCone_F",125.744,3.16,0,0,false,{},true]
			,["RoadCone_F",52.588,3.747,0,0,false,{},true]
			,["Land_RedWhitePole_F",163.055,9.138,0,0,false,{},true]
			,["RHS_Ural_Fuel_MSV_01",120.937,5.555,182.105,0,false,{ _this setDamage 0 },true]
			,["Land_CampingTable_F",353.788,6.523,0,0,false,{},true]
			,["Land_CampingTable_F",351.826,10.561,91.588,0,false,{},true]
			,["Land_CanisterPlastic_F",338.319,6.074,1.475,0,false,{},true]
			,["Land_RedWhitePole_F",34.8704,5.92,0,0,false,{},true]
			,["Land_RedWhitePole_F",317.644,6.402,0,0,false,{},true]
			,["Land_RedWhitePole_F",294.542,10.658,0,0,false,{},true]
			,["RHS_Ural_Repair_MSV_01",340.621,9.816,0,0,false,{ _this setDamage 0 },true]
			,["Box_NATO_Equip_F",7.58243,6.471,94.157,0,false,{ EQUIP_BOX_CODE },true]
			,["Land_WeldingTrolley_01_F",352.883,9.157,0,0,false,{},true]
			,["Land_Pallet_MilBoxes_F",300.067,10.23,0,0,false,{},true]
			,["Land_CampingChair_V1_F",351.805,7.785,354.814,0,false,{},true]
			,["RHS_Ural_Repair_MSV_01",318.665,12.244,0,0,false,{ _this setDamage 0 },true]
		]
	]
	, [
		"Green URAL FA"
		, [
			["Land_CampingTable_F",356.664,6.662,0,0,false,{},true]
			,["Land_CanisterPlastic_F",341.662,6.121,1.475,0,false,{},true]
			,["Land_RedWhitePole_F",160.829,9.079,0,0,false,{},true]
			,["Land_RedWhitePole_F",296.096,10.441,0,0,false,{},true]
			,["Land_RedWhitePole_F",320.79,6.32,0,0,false,{},true]
			,["Land_RedWhitePole_F",36.3956,6.24,0,0,false,{},true]
			,["Box_NATO_Equip_F",10.0985,6.684,94.157,0,false,{ EQUIP_BOX_CODE },true]
			,["Land_Pallet_MilBoxes_F",301.796,10.043,0,0,false,{},true]
			,["RoadCone_F",153.532,6.013,0,0,false,{},true]
			,["RoadCone_F",120.232,3.337,0,0,false,{},true]
			,["RoadCone_F",53.446,4.101,0,0,false,{},true]
			,["Land_CampingChair_V1_F",354.257,7.911,354.814,0,false,{},true]
			,["CUP_O_Ural_Reammo_RU",325.424,9.267,268.628,0,false,{},true]
			,["CUP_O_Ural_Refuel_RU",117.887,5.751,182.105,0,false,{},true]
		]
	]	
	, [
		"Taki Praga RFA"
		, [
			["Land_RedWhitePole_F",288.904,10.414,0,0,false,{},true]
			,["Land_Pallet_MilBoxes_F",294.321,9.889,0,0,false,{},true]
			,["CUP_O_V3S_Covered_TKM",314.365,9.804,352.951,0,false,{},true]
			,["Land_CampingTable_F",350.967,5.5,0,0,false,{},true]
			,["Land_RedWhitePole_F",309.443,5.79,0,0,false,{},true]
			,["Land_RedWhitePole_F",40.3054,4.988,0,0,false,{},true]
			,["RoadCone_F",161.537,6.959,0,0,false,{},true]
			,["RoadCone_F",140.293,3.768,0,0,false,{},true]
			,["RoadCone_F",66.5312,3.073,0,0,false,{},true]
			,["Land_RedWhitePole_F",165.65,10.109,0,0,false,{},true]
			,["Land_CanisterPlastic_F",332.388,5.182,1.475,0,false,{},true]
			,["Box_NATO_Equip_F",7.39778,5.407,94.157,0,false,{ EQUIP_BOX_CODE },true]
			,["CUP_O_V3S_Refuel_TKM",126.936,6.41,182.461,0,false,{},true]
			,["Land_CampingChair_V1_F",349.214,6.772,354.814,0,false,{},true]
			,["Land_CampingTable_F",349.991,9.546,91.588,0,false,{},true]
			,["Land_WeldingTrolley_01_F",350.862,8.137,0,0,false,{},true]
			,["CUP_O_V3S_Repair_TKM",337.398,8.429,0,0,false,{},true]
		]
	]
	, [
		"Taki Praga FA"
		, [
			["Land_RedWhitePole_F",165.012,8.882,0,0,false,{},true]
			,["Land_CampingTable_F",350.837,6.731,0,0,false,{},true]
			,["Land_CanisterPlastic_F",335.792,6.365,1.475,0,false,{},true]
			,["Land_RedWhitePole_F",294.513,11.058,0,0,false,{},true]
			,["Land_RedWhitePole_F",31.0275,5.856,0,0,false,{},true]
			,["Land_RedWhitePole_F",316.273,6.77,0,0,false,{},true]
			,["Box_NATO_Equip_F",4.24251,6.594,94.157,0,false,{ EQUIP_BOX_CODE },true]
			,["Land_Pallet_MilBoxes_F",299.83,10.628,0,0,false,{},true]
			,["RoadCone_F",127.463,2.77,0,0,false,{},true]
			,["RoadCone_F",159.674,5.745,0,0,false,{},true]
			,["RoadCone_F",46.9572,3.571,0,0,false,{},true]
			,["Land_CampingChair_V1_F",349.375,8.004,354.814,0,false,{},true]
			,["CUP_O_V3S_Refuel_TKM",121.224,6.082,182.461,0,false,{},true]
			,["CUP_O_V3S_Covered_TKM",321.259,9.136,270.81,0,false,{},true]
		]
	]	
	, [
		"Praga RFA"
		, [
			["Land_RedWhitePole_F",288.904,10.414,0,0,false,{},true]
			,["Land_Pallet_MilBoxes_F",294.321,9.889,0,0,false,{},true]
			,["CUP_I_V3S_Covered_TKG",314.365,9.804,352.951,0,false,{},true]
			,["Land_CampingTable_F",350.967,5.5,0,0,false,{},true]
			,["Land_RedWhitePole_F",309.443,5.79,0,0,false,{},true]
			,["Land_RedWhitePole_F",40.3054,4.988,0,0,false,{},true]
			,["RoadCone_F",161.537,6.959,0,0,false,{},true]
			,["RoadCone_F",140.293,3.768,0,0,false,{},true]
			,["RoadCone_F",66.5312,3.073,0,0,false,{},true]
			,["Land_RedWhitePole_F",165.65,10.109,0,0,false,{},true]
			,["Land_CanisterPlastic_F",332.388,5.182,1.475,0,false,{},true]
			,["Box_NATO_Equip_F",7.39778,5.407,94.157,0,false,{ EQUIP_BOX_CODE },true]
			,["CUP_I_V3S_Refuel_TKG",126.936,6.41,182.461,0,false,{},true]
			,["Land_CampingChair_V1_F",349.214,6.772,354.814,0,false,{},true]
			,["Land_CampingTable_F",349.991,9.546,91.588,0,false,{},true]
			,["Land_WeldingTrolley_01_F",350.862,8.137,0,0,false,{},true]
			,["CUP_I_V3S_Repair_TKG",337.398,8.429,0,0,false,{},true]
		]
	]
	, [
		"Praga FA"
		, [
			["Land_RedWhitePole_F",165.012,8.882,0,0,false,{},true]
			,["Land_CampingTable_F",350.837,6.731,0,0,false,{},true]
			,["Land_CanisterPlastic_F",335.792,6.365,1.475,0,false,{},true]
			,["Land_RedWhitePole_F",294.513,11.058,0,0,false,{},true]
			,["Land_RedWhitePole_F",31.0275,5.856,0,0,false,{},true]
			,["Land_RedWhitePole_F",316.273,6.77,0,0,false,{},true]
			,["Box_NATO_Equip_F",4.24251,6.594,94.157,0,false,{ EQUIP_BOX_CODE },true]
			,["Land_Pallet_MilBoxes_F",299.83,10.628,0,0,false,{},true]
			,["RoadCone_F",127.463,2.77,0,0,false,{},true]
			,["RoadCone_F",159.674,5.745,0,0,false,{},true]
			,["RoadCone_F",46.9572,3.571,0,0,false,{},true]
			,["Land_CampingChair_V1_F",349.375,8.004,354.814,0,false,{},true]
			,["CUP_I_V3S_Refuel_TKG",121.224,6.082,182.461,0,false,{},true]
			,["CUP_I_V3S_Covered_TKG",321.259,9.136,270.81,0,false,{},true]
		]
	]	
		
	, [
		"CSAT Typhoon FA"
		, [
			["Land_runway_edgelight",206.14,9.941,14.804,0,false,{},true]
			,["Land_CampingTable_F",350.128,6.327,0,0,false,{},true]
			,["Land_CanisterPlastic_F",334.066,5.998,1.475,0,false,{},true]
			,["Land_RedWhitePole_F",165.747,9.278,0,0,false,{},true]
			,["Land_RedWhitePole_F",292.515,10.905,0,0,false,{},true]
			,["Land_RedWhitePole_F",313.674,6.487,0,0,false,{},true]
			,["Land_RedWhitePole_F",33.1264,5.5,0,0,false,{},true]
			,["O_Truck_03_ammo_F",315.543,10.2,273.52,0,false,{},true]
			,["Box_NATO_Equip_F",4.4066,6.182,94.157,0,false,{ EQUIP_BOX_CODE },true]
			,["Land_Pallet_MilBoxes_F",297.833,10.44,0,0,false,{},true]
			,["RoadCone_F",52.0513,3.294,0,0,false,{},true]
			,["RoadCone_F",133.81,3.029,0,0,false,{},true]
			,["RoadCone_F",161.124,6.129,0,0,false,{},true]
			,["Land_CampingChair_V1_F",348.707,7.602,354.814,0,false,{},true]
			,["O_Truck_03_fuel_F",144.011,9.194,182.858,0,false,{},true]
		]
	]
	, [
		"CSAT Typhoon RFA"
		, [
			["Land_RedWhitePole_F",163.272,10.356,0,0,false,{},true]
			,["Land_runway_edgelight",257.064,8.508,14.804,0,false,{},true]
			,["Land_CampingTable_F",352.728,9.352,91.588,0,false,{},true]
			,["Land_CampingTable_F",355.817,5.322,0,0,false,{},true]
			,["Land_CanisterPlastic_F",336.676,4.865,1.475,0,false,{},true]
			,["Land_RedWhitePole_F",289.115,9.925,0,0,false,{},true]
			,["Land_RedWhitePole_F",45.1705,5.22,0,0,false,{},true]
			,["Land_RedWhitePole_F",311.653,5.348,0,0,false,{},true]
			,["O_Truck_03_ammo_F",323.496,12.044,0,0,false,{},true]
			,["Box_NATO_Equip_F",12.6075,5.367,94.157,0,false,{ EQUIP_BOX_CODE },true]
			,["Land_Pallet_MilBoxes_F",294.825,9.405,0,0,false,{},true]
			,["RoadCone_F",71.5383,3.472,0,0,false,{},true]
			,["RoadCone_F",136.361,4.177,0,0,false,{},true]
			,["RoadCone_F",158.277,7.239,0,0,false,{},true]
			,["Land_CampingChair_V1_F",353.082,6.577,354.814,0,false,{},true]
			,["O_Truck_03_repair_F",342.492,9.944,0,0,false,{},true]
			,["O_Truck_03_fuel_F",133.842,7.661,182.858,0,false,{},true]
		]
	]
	, [
		"CSAT Typhoon Green FA"
		, [
			["Land_runway_edgelight",206.14,9.941,14.804,0,false,{},true]
			,["Land_CampingTable_F",350.128,6.327,0,0,false,{},true]
			,["Land_CanisterPlastic_F",334.066,5.998,1.475,0,false,{},true]
			,["Land_RedWhitePole_F",165.747,9.278,0,0,false,{},true]
			,["Land_RedWhitePole_F",292.515,10.905,0,0,false,{},true]
			,["Land_RedWhitePole_F",313.674,6.487,0,0,false,{},true]
			,["Land_RedWhitePole_F",33.1264,5.5,0,0,false,{},true]
			,["O_T_Truck_03_ammo_ghex_F",315.543,10.2,273.52,0,false,{},true]
			,["Box_NATO_Equip_F",4.4066,6.182,94.157,0,false,{ EQUIP_BOX_CODE },true]
			,["Land_Pallet_MilBoxes_F",297.833,10.44,0,0,false,{},true]
			,["RoadCone_F",52.0513,3.294,0,0,false,{},true]
			,["RoadCone_F",133.81,3.029,0,0,false,{},true]
			,["RoadCone_F",161.124,6.129,0,0,false,{},true]
			,["Land_CampingChair_V1_F",348.707,7.602,354.814,0,false,{},true]
			,["O_T_Truck_03_fuel_ghex_F",144.011,9.194,182.858,0,false,{},true]
		]
	]
	, [
		"CSAT Typhoon Green RFA"
		, [
			["Land_RedWhitePole_F",163.272,10.356,0,0,false,{},true]
			,["Land_runway_edgelight",257.064,8.508,14.804,0,false,{},true]
			,["Land_CampingTable_F",352.728,9.352,91.588,0,false,{},true]
			,["Land_CampingTable_F",355.817,5.322,0,0,false,{},true]
			,["Land_CanisterPlastic_F",336.676,4.865,1.475,0,false,{},true]
			,["Land_RedWhitePole_F",289.115,9.925,0,0,false,{},true]
			,["Land_RedWhitePole_F",45.1705,5.22,0,0,false,{},true]
			,["Land_RedWhitePole_F",311.653,5.348,0,0,false,{},true]
			,["O_T_Truck_03_ammo_ghex_F",323.496,12.044,0,0,false,{},true]
			,["Box_NATO_Equip_F",12.6075,5.367,94.157,0,false,{ EQUIP_BOX_CODE },true]
			,["Land_Pallet_MilBoxes_F",294.825,9.405,0,0,false,{},true]
			,["RoadCone_F",71.5383,3.472,0,0,false,{},true]
			,["RoadCone_F",136.361,4.177,0,0,false,{},true]
			,["RoadCone_F",158.277,7.239,0,0,false,{},true]
			,["Land_CampingChair_V1_F",353.082,6.577,354.814,0,false,{},true]
			,["O_T_Truck_03_repair_ghex_F",342.492,9.944,0,0,false,{},true]
			,["O_T_Truck_03_fuel_ghex_F",133.842,7.661,182.858,0,false,{},true]
		]
	]	
	, [
		"CSAT KAMAZ FA"
		, [
			["Land_runway_edgelight",290.215,16.078,14.804,0,false,{},true]
			,["Land_CampingTable_F",347.751,4.97,0,0,false,{},true]
			,["Land_CanisterPlastic_F",327.16,4.781,1.475,0,false,{},true]
			,["Land_RedWhitePole_F",167.416,10.624,0,0,false,{},true]
			,["Land_RedWhitePole_F",285.572,10.426,0,0,false,{},true]
			,["Land_RedWhitePole_F",43.2356,4.432,0,0,false,{},true]
			,["Land_RedWhitePole_F",303.648,5.6,0,0,false,{},true]
			,["O_Truck_02_fuel_F",131.824,6.965,183.896,0,false,{},true]
			,["Box_NATO_Equip_F",6.02696,4.813,94.157,0,false,{ EQUIP_BOX_CODE },true]
			,["Land_Pallet_MilBoxes_F",290.811,9.844,0,0,false,{},true]
			,["RoadCone_F",147.461,4.121,0,0,false,{},true]
			,["RoadCone_F",164.329,7.453,0,0,false,{},true]
			,["RoadCone_F",76.1374,2.706,0,0,false,{},true]
			,["Land_CampingChair_V1_F",346.508,6.25,354.814,0,false,{},true]
			,["O_Truck_02_Ammo_F",313.173,8.288,268.566,0,false,{},true]
		]
	]
	, [
		"CSAT KAMAZ RFA"
		, [
			["Land_RedWhitePole_F",288.29,10.144,0,0,false,{},true]
			,["Land_Pallet_MilBoxes_F",293.829,9.61,0,0,false,{},true]
			,["O_Truck_02_Ammo_F",316.921,10.441,352.852,0,false,{},true]
			,["Land_CampingTable_F",353.01,5.28,0,0,false,{},true]
			,["Land_CampingChair_V1_F",350.801,6.547,354.814,0,false,{},true]
			,["Land_CampingTable_F",351.125,9.322,91.588,0,false,{},true]
			,["Land_RedWhitePole_F",309.373,5.498,0,0,false,{},true]
			,["Land_RedWhitePole_F",43.6532,4.995,0,0,false,{},true]
			,["RoadCone_F",160.351,7.211,0,0,false,{},true]
			,["RoadCone_F",139.61,4.056,0,0,false,{},true]
			,["RoadCone_F",71.2247,3.21,0,0,false,{},true]
			,["Land_RedWhitePole_F",164.727,10.35,0,0,false,{},true]
			,["Land_CanisterPlastic_F",333.643,4.912,1.475,0,false,{},true]
			,["Box_NATO_Equip_F",10.0565,5.252,94.157,0,false,{ EQUIP_BOX_CODE },true]
			,["O_Truck_02_fuel_F",128.584,7.229,183.896,0,false,{},true]
			,["O_Truck_02_box_F",337.915,8.216,0,0,false,{},true]
		]
	]
	, [
		"AAF KAMAZ FA"
		, [
			["Land_runway_edgelight",290.215,16.078,14.804,0,false,{},true]
			,["Land_CampingTable_F",347.751,4.97,0,0,false,{},true]
			,["Land_CanisterPlastic_F",327.16,4.781,1.475,0,false,{},true]
			,["Land_RedWhitePole_F",167.416,10.624,0,0,false,{},true]
			,["Land_RedWhitePole_F",285.572,10.426,0,0,false,{},true]
			,["Land_RedWhitePole_F",43.2356,4.432,0,0,false,{},true]
			,["Land_RedWhitePole_F",303.648,5.6,0,0,false,{},true]
			,["I_Truck_02_fuel_F",131.824,6.965,183.896,0,false,{},true]
			,["Box_NATO_Equip_F",6.02696,4.813,94.157,0,false,{ EQUIP_BOX_CODE },true]
			,["Land_Pallet_MilBoxes_F",290.811,9.844,0,0,false,{},true]
			,["RoadCone_F",147.461,4.121,0,0,false,{},true]
			,["RoadCone_F",164.329,7.453,0,0,false,{},true]
			,["RoadCone_F",76.1374,2.706,0,0,false,{},true]
			,["Land_CampingChair_V1_F",346.508,6.25,354.814,0,false,{},true]
			,["I_Truck_02_ammo_F",313.173,8.288,268.566,0,false,{},true]
		]
	]
	, [
		"AAF KAMAZ RFA"
		, [
			["Land_RedWhitePole_F",288.29,10.144,0,0,false,{},true]
			,["Land_Pallet_MilBoxes_F",293.829,9.61,0,0,false,{},true]
			,["I_Truck_02_ammo_F",316.921,10.441,352.852,0,false,{},true]
			,["Land_CampingTable_F",353.01,5.28,0,0,false,{},true]
			,["Land_CampingChair_V1_F",350.801,6.547,354.814,0,false,{},true]
			,["Land_CampingTable_F",351.125,9.322,91.588,0,false,{},true]
			,["Land_RedWhitePole_F",309.373,5.498,0,0,false,{},true]
			,["Land_RedWhitePole_F",43.6532,4.995,0,0,false,{},true]
			,["RoadCone_F",160.351,7.211,0,0,false,{},true]
			,["RoadCone_F",139.61,4.056,0,0,false,{},true]
			,["RoadCone_F",71.2247,3.21,0,0,false,{},true]
			,["Land_RedWhitePole_F",164.727,10.35,0,0,false,{},true]
			,["Land_CanisterPlastic_F",333.643,4.912,1.475,0,false,{},true]
			,["Box_NATO_Equip_F",10.0565,5.252,94.157,0,false,{ EQUIP_BOX_CODE },true]
			,["I_Truck_02_fuel_F",128.584,7.229,183.896,0,false,{},true]
			,["I_Truck_02_box_F",337.915,8.216,0,0,false,{},true]
		]
	]	
	, [
		"Civil RFA"
		, [
			["Land_CampingTable_F",354.824,11.23,91.588,0,false,{},true]
			,["Land_CampingTable_F",358.274,7.219,0,0,false,{},true]
			,["Land_CanisterPlastic_F",344.604,6.613,1.475,0,false,{},true]
			,["Land_RedWhitePole_F",34.7255,6.799,0,0,false,{},true]
			,["Land_RedWhitePole_F",299.259,10.553,0,0,false,{},true]
			,["Land_RedWhitePole_F",324.997,6.668,0,0,false,{},true]
			,["Land_RedWhitePole_F",158.523,8.608,0,0,false,{},true]
			,["Box_NATO_Equip_F",10.639,7.27,94.157,0,false,{ EQUIP_BOX_CODE },true]
			,["Land_WeldingTrolley_01_F",356.235,9.839,0,0,false,{},true]
			,["Land_Pallet_MilBoxes_F",304.996,10.212,0,0,false,{},true]
			,["RoadCone_F",149.39,5.597,0,0,false,{},true]
			,["RoadCone_F",49.0405,4.588,0,0,false,{},true]
			,["RoadCone_F",110.064,3.251,0,0,false,{},true]
			,["Land_CampingChair_V1_F",355.788,8.459,354.814,0,false,{},true]
			,["C_Truck_02_fuel_F",91.7219,5.444,183.578,-0.036,false,{},true]
			,["C_Truck_02_box_F",342.095,9.72,0,0,false,{},true]
			,["C_Van_01_box_F",322.053,11.594,347.791,-0.081,false,{},true]
		]
	]
	, [
		"Civil FA"
		, [
			["Land_CampingTable_F",353.472,7.298,0,0,false,{},true]
			,["Land_CanisterPlastic_F",339.727,6.834,1.475,0,false,{},true]
			,["Land_RedWhitePole_F",321.089,7.064,0,0,false,{},true]
			,["Land_RedWhitePole_F",297.873,11.107,0,0,false,{},true]
			,["Land_Pallet_MilBoxes_F",303.275,10.738,0,0,false,{},true]
			,["Land_CampingChair_V1_F",351.715,8.561,354.814,0,false,{},true]
			,["C_Van_01_box_F",320.587,10.238,268.156,0,false,{},true]
			,["RoadCone_F",154.923,5.28,0,0,false,{},true]
			,["RoadCone_F",113.867,2.669,0,0,false,{},true]
			,["RoadCone_F",43.1509,4.17,0,0,false,{},true]
			,["Land_RedWhitePole_F",162.338,8.37,0,0,false,{},true]
			,["C_Truck_02_fuel_F",102.018,5.656,183.58,0,false,{},true]
			,["Land_RedWhitePole_F",30.108,6.5,0,0,false,{},true]
			,["Box_NATO_Equip_F",5.8047,7.218,94.157,0,false,{ EQUIP_BOX_CODE },true]
		]
	]
	, [
		"Civil 2 FA"
		, [
			["Land_CampingTable_F",352.668,6.152,0,0,false,{},true]
			,["Land_CanisterPlastic_F",336.178,5.752,1.475,0,false,{},true]
			,["Land_RedWhitePole_F",314.711,6.181,0,0,false,{},true]
			,["Land_RedWhitePole_F",292.479,10.578,0,0,false,{},true]
			,["Land_Pallet_MilBoxes_F",297.967,10.114,0,0,false,{},true]
			,["Land_CampingChair_V1_F",350.777,7.419,354.814,0,false,{},true]
			,["C_Van_01_box_F",316.325,9.348,268.156,0,false,{},true]
			,["RoadCone_F",131.877,3.338,0,0,false,{},true]
			,["RoadCone_F",56.8211,3.461,0,0,false,{},true]
			,["Land_RedWhitePole_F",155.465,5.187,0,0,false,{},true]
			,["C_Van_01_fuel_F",102.596,4.485,182.727,0,false,{},true]
			,["Land_RedWhitePole_F",36.4515,5.563,0,0,false,{},true]
			,["Box_NATO_Equip_F",7.31673,6.082,94.157,0,false,{ EQUIP_BOX_CODE },true]
		]
	]	
	, [
		"Taki Mi-6"
		, [
			["Land_RedWhitePole_F",284.803,18.389,359.91,0.024,false,{},true]
			,["Land_RedWhitePole_F",301.305,10.487,359.986,0.024,false,{},true]
			,["Land_runway_edgelight",97.3866,15.055,14.804,0,false,{},true]
			,["Land_RedWhitePole_F",150.594,8.634,0.023,0.024,false,{},true]
			,["Land_RedWhitePole_F",164.543,17.707,0.433,0.024,false,{},true]
			,["CUP_O_MI6T_TKA",33.2506,12.633,359.866,0.001,false,{},true]
			,["Land_RedWhitePole_F",36.2738,5.463,359.954,0.024,false,{},true]
			,["Land_CampingChair_V1_F",17.7797,7.932,354.812,0.027,false,{},true]
			,["Land_CampingTable_F",24.0541,6.933,360,0.024,false,{},true]
			,["Box_NATO_Equip_F",11.1028,6.41,94.17,0.024,false,{ EQUIP_BOX_CODE },true]
		]
	]
	, [
		"RU Mi-6"
		, [
			["Land_RedWhitePole_F",284.803,18.389,359.91,0.024,false,{},true]
			,["Land_RedWhitePole_F",301.305,10.487,359.986,0.024,false,{},true]
			,["Land_runway_edgelight",97.3866,15.055,14.804,0,false,{},true]
			,["Land_RedWhitePole_F",150.594,8.634,0.023,0.024,false,{},true]
			,["Land_RedWhitePole_F",164.543,17.707,0.433,0.024,false,{},true]
			,["CUP_O_MI6T_RU",33.2506,12.633,359.866,0.001,false,{},true]
			,["Land_RedWhitePole_F",36.2738,5.463,359.954,0.024,false,{},true]
			,["Land_CampingChair_V1_F",17.7797,7.932,354.812,0.027,false,{},true]
			,["Land_CampingTable_F",24.0541,6.933,360,0.024,false,{},true]
			,["Box_NATO_Equip_F",11.1028,6.41,94.17,0.024,false,{ EQUIP_BOX_CODE },true]
		]
	]	
	, [
		"NATO CH-47"
		, [
			["Land_RedWhitePole_F",284.308,18.812,359.833,0.024,false,{},true]
			,["Land_RedWhitePole_F",32.4963,5.165,359.984,0.024,false,{},true]
			,["Land_RedWhitePole_F",153.462,8.464,0.017,0.024,false,{},true]
			,["Land_RedWhitePole_F",166.034,17.635,0.391,0.024,false,{},true]
			,["Land_RedWhitePole_F",299.874,10.841,0.066,0.024,false,{},true]
			,["RHS_CH_47F",44.1448,8.276,0,0,false,{},true]
			,["Land_CampingTable_F",20.6725,6.72,0,0.024,false,{},true]
			,["Land_CampingChair_V1_F",14.6873,7.764,354.821,0.027,false,{},true]
			,["Box_NATO_Equip_F",7.12557,6.295,94.174,0.024,false,{ EQUIP_BOX_CODE },true]
		]
	]
	, [
		"USMC CH-53"
		, [
			["Land_RedWhitePole_F",285.753,18.187,359.91,0.024,false,{},true]
			,["Land_RedWhitePole_F",303.222,10.383,359.986,0.024,false,{},true]
			,["Land_runway_edgelight",96.3656,15.299,14.804,0,false,{},true]
			,["Land_RedWhitePole_F",148.207,8.568,0.023,0.024,false,{},true]
			,["Land_RedWhitePole_F",163.47,17.553,0.433,0.024,false,{},true]
			,["Land_RedWhitePole_F",37.0622,5.819,359.954,0.024,false,{},true]
			,["Land_CampingChair_V1_F",19.091,8.246,354.812,0.027,false,{},true]
			,["Land_CampingTable_F",25.2648,7.265,360,0.024,false,{},true]
			,["Box_NATO_Equip_F",13.0156,6.701,94.17,0.024,false,{ EQUIP_BOX_CODE },true]
			,["rhsusf_CH53E_USMC",50.712,10.142,355.815,0,false,{},true]
		]
	]
	
	
	
	, [
		"Ru Tiger"
		, [
			["rhs_tigr_vv",5.44609,3.857,359.969,0.012,false,{},true]
			,["Box_NATO_Equip_F",280.354,1.141,1.02,0.024,false,{ EQUIP_BOX_CODE },true]
			,["Land_CampingTable_F",167.693,0.648,359.997,0.024,false,{},true]
		]
	]
	, [
		"Land Rover Desert"
		, [
			["CUP_B_LR_Transport_GB_D",5.44609,3.857,359.969,0.012,false,{},true]
			,["Box_NATO_Equip_F",280.354,1.141,1.02,0.024,false,{ EQUIP_BOX_CODE },true]
			,["Land_CampingTable_F",167.693,0.648,359.997,0.024,false,{},true]
		]
	]
	, [
		"Land Rover Woodland"
		, [
			["CUP_B_LR_Transport_GB_W",5.44609,3.857,359.969,0.012,false,{},true]
			,["Box_NATO_Equip_F",280.354,1.141,1.02,0.024,false,{ EQUIP_BOX_CODE },true]
			,["Land_CampingTable_F",167.693,0.648,359.997,0.024,false,{},true]
		]
	]
	, [
		"Land Rover Taki"
		, [
			["CUP_O_LR_Transport_TKA",5.44609,3.857,359.969,0.012,false,{},true]
			,["Box_NATO_Equip_F",280.354,1.141,1.02,0.024,false,{ EQUIP_BOX_CODE },true]
			,["Land_CampingTable_F",167.693,0.648,359.997,0.024,false,{},true]
		]
	]
	, [
		"Land Rover RACS"
		, [
			["CUP_I_LR_Transport_RACS",5.44609,3.857,359.969,0.012,false,{},true]
			,["Box_NATO_Equip_F",280.354,1.141,1.02,0.024,false,{ EQUIP_BOX_CODE },true]
			,["Land_CampingTable_F",167.693,0.648,359.997,0.024,false,{},true]
		]
	]
	, [
		"Land Rover AAF"
		, [
			["CUP_I_LR_Transport_AAF",5.44609,3.857,359.969,0.012,false,{},true]
			,["Box_NATO_Equip_F",280.354,1.141,1.02,0.024,false,{ EQUIP_BOX_CODE },true]
			,["Land_CampingTable_F",167.693,0.648,359.997,0.024,false,{},true]
		]
	]
	, [
		"Land Rover Civil"
		, [
			["CUP_C_LR_Transport_CTK",5.44609,3.857,359.969,0.012,false,{},true]
			,["Box_NATO_Equip_F",280.354,1.141,1.02,0.024,false,{ EQUIP_BOX_CODE },true]
			,["Land_CampingTable_F",167.693,0.648,359.997,0.024,false,{},true]
		]
	]
	, [
		"Ru Vodnik"
		, [
			["CUP_O_GAZ_Vodnik_PK_RU",5.44609,3.857,359.969,0.012,false,{},true]
			,["Box_NATO_Equip_F",280.354,1.141,1.02,0.024,false,{ EQUIP_BOX_CODE },true]
			,["Land_CampingTable_F",167.693,0.648,359.997,0.024,false,{},true]
		]
	]
	, [
		"Ru Tiger Camo"
		, [
			["rhs_tigr_3camo_msv",5.44609,3.857,359.969,0.012,false,{},true]
			,["Box_NATO_Equip_F",280.354,1.141,1.02,0.024,false,{ EQUIP_BOX_CODE },true]
			,["Land_CampingTable_F",167.693,0.648,359.997,0.024,false,{},true]
		]
	]
	, [
		"SUV Black"
		, [
			["CUP_I_SUV_ION",5.44609,3.857,359.969,0.012,false,{},true]
			,["Box_NATO_Equip_F",280.354,1.141,1.02,0.024,false,{ EQUIP_BOX_CODE },true]
			,["Land_CampingTable_F",167.693,0.648,359.997,0.024,false,{},true]
		]
	]
	, [
		"SUV Blue"
		, [
			["CUP_C_SUV_CIV",5.44609,3.857,359.969,0.012,false,{},true]
			,["Box_NATO_Equip_F",280.354,1.141,1.02,0.024,false,{ EQUIP_BOX_CODE },true]
			,["Land_CampingTable_F",167.693,0.648,359.997,0.024,false,{},true]
		]
	]
	, [
		"Civil Van"
		, [
			["C_Van_01_box_F",5.44609,3.857,359.969,0.012,false,{},true]
			,["Box_NATO_Equip_F",280.354,1.141,1.02,0.024,false,{ EQUIP_BOX_CODE },true]
			,["Land_CampingTable_F",167.693,0.648,359.997,0.024,false,{},true]
		]
	]
	, [
		"GAZ-66"
		, [
			["rhs_gaz66_msv",5.44609,3.857,359.969,0.012,false,{},true]
			,["Box_NATO_Equip_F",280.354,1.141,1.02,0.024,false,{ EQUIP_BOX_CODE },true]
			,["Land_CampingTable_F",167.693,0.648,359.997,0.024,false,{},true]
		]
	]	
];

