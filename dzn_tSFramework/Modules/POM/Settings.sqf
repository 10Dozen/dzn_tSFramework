/*
 *	Platoon Operational Markers (POM)
 *
 *	Local opartional markers (squads) for Platoon Leaders for additional mission control. 
 */

tSF_POM_AuthorizedUsers		= [
						"1'6 Platoon Leader"						
						,"1'6 Командир взвода"
						
						,"Platoon Sergeant"
						,"Зам. командира взвода"						
];

tSF_POM_GenerateMarkersFromGroups	= true;
tSF_POM_OperationalMarkers = [
	["Infantry", "", east]
	, ["Infantry", "FT", east]
	, ["Infantry", "SQ", east]
	
	, ["Infantry", "JTAC", resistance, true]
	, ["Vehicle", "APC", east]
	, ["Vehicle", "Tank", east]
];

tSF_POM_TopicName = "tSF Operational Markers";


/*
 *	Preferences
 */
tSF_POM_InfantryMarker 	= "b_inf";
tSF_POM_VehicleMarker 	= "b_armor";

tSF_POM_InfantryLabels	= ["", "FT", "SQ", "Static"];
tSF_POM_VehicleLabels 	= ["", "Car", "APC", "IFV", "Tank"];
