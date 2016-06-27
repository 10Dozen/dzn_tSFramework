var OPTIONS_ITEMS = {
	"terrains": [
		"Altis"
		, "Stratis"
		, "Chernarus"
		, "Bystica"
		, "Takistan"
		, "Zargabad"
		, "Kunduz"
		, "Shapur"
		, "Proving Grounds"	
	]
	, "factions": [
		"NATO Army"
		,"NATO Peacekeeprs"		
		,"NATO Special Forces"		
		,"RuAF Army"
		,"RuAF Peacekeeprs"
		,"RuAF Special Forces"		
		,"Insurgents"
		,"Local Armed Forces"
		,"Local irregulars"
		,"Mercenaries"
		,"PMC/Contractors"	
	]
	, "objectives": [
		"Patrol"
		, "Assault keypoint"
		, "Defend keypoint"
		, "Search and Rescue"
		, "Ambush"

		, "Destroy Valuable Target"
		, "Hunt Valuable Target"
		, "Escort Valuable Target"
		
		, "Eliminate MVP"
		, "Hunt MVP"
		, "Rescue MVP"
		, "Escort MVP"
		
		, "Retrieve Intel"		
	]	
};


/*		
 *	ENDING FUNCTIONS
*/ 

var Idea = function () {
	this.terrain = "";
	this.allies = "";
	this.hostiles = "";
	this.objectives = ["","","",""];
	
	this.rollTerrain = function (render) {
		this.terrain = OPTIONS_ITEMS.terrains[Math.floor(Math.random() * OPTIONS_ITEMS.terrains.length)];
		if (render) { this.render(); };
	};
	this.rollAllies = function (render) {
		this.allies = OPTIONS_ITEMS.factions[Math.floor(Math.random() * OPTIONS_ITEMS.factions.length)];
		if (render) { this.render(); };
	};
	this.rollHostiles = function (render) {
		this.hostiles = OPTIONS_ITEMS.factions[Math.floor(Math.random() * OPTIONS_ITEMS.factions.length)];
		if (render) { this.render(); };
	};
	
	this.rollObjective = function (number, render) {	
		this.objectives[number] = OPTIONS_ITEMS.objectives[Math.floor(Math.random() * OPTIONS_ITEMS.objectives.length)];
		
		if (render) { this.render(); };
	};
	
	this.rollAllObjectives = function () {
		this.objectives = ["","","",""];
		
		var objCount = Math.ceil(Math.random()*4);		
		for (var i = 1; i < objCount+1; i++) {
			this.objectives[i-1] = OPTIONS_ITEMS.objectives[Math.floor(Math.random() * OPTIONS_ITEMS.objectives.length)];
		}
	};
	
	this.clearObjective = function (number, render) {
		this.objectives[number] = "";
		if (render) { this.render(); };
	};
	
	this.rollAll = function () {
		this.rollTerrain(false);
		this.rollAllies(false);
		this.rollHostiles(false);
		this.rollAllObjectives();
		
		this.render();
	};
	
	
	this.showSummary = function () {
		var text = "Terrain: " + this.terrain 
			+ "<br /><br />Allied forces: " + this.allies
			+ "<br />Hostile forces: " + this.hostiles
			+ "<br /><br />Objectives:";
		
		for (var i =0 ; i < this.objectives.length; i++) {
			if (this.objectives[i] != "") {			
				text = text + "<br />" + (i+1) + ". " + this.objectives[i];
			};
		};
		
		$('.summary').html(text);
	};
	
	this.render = function () {
		$(".select-terrain>option[name='" + this.terrain + "']").prop('selected', true);
		$(".select-allies>option[name='" + this.allies + "']").prop('selected', true);
		$(".select-hostiles>option[name='" + this.hostiles + "']").prop('selected', true);
		for (var i = 0; i < 4; i++) {
			$( $(".select-objectives")[i] ).val( this.objectives[i] );
			if ( this.objectives[i] == "" )  {
				$( $(".select-objectives")[i] ).css("background-color", "#eee");
			} else {
				$( $(".select-objectives")[i] ).css("background-color", "#fff");
			};
		};
		
		this.showSummary();
	};
	
	this.generateOptions = function (options) {
		var result = "";	
		for (var i = 0; i < options.length; i++) {
			result = result + "<option name='" + options[i] + "'>" + options[i] + "</options>";
		}
		
		return result;
	};
	
	
	
	this.init = function () {
		// Add options
		$('.select-terrain').append( this.generateOptions(OPTIONS_ITEMS.terrains) );
		$('.select-allies').append( this.generateOptions(OPTIONS_ITEMS.factions) );
		$('.select-hostiles').append( this.generateOptions(OPTIONS_ITEMS.factions) );		
		$('.select-objectives').append( this.generateOptions(OPTIONS_ITEMS.objectives) );		
		
		// Add buttons handlers
		$('.roll-terrain').on("click", function () {MIG.rollTerrain(true);});
		$('.roll-allies').on("click", function () {MIG.rollAllies(true);});
		$('.roll-hostiles').on("click", function () {MIG.rollHostiles(true);});
		$('.btn-roll-all').on("click", function () {MIG.rollAll();});
		
		$('.roll-obj').on("click", function () {		
			var id = $(this).parent().find(".inputs-number").html();
			MIG.rollObjective( id - 1, true );			
		});
		
		$('.clear-obj').on("click", function () {
			var id = $(this).parent().find(".inputs-number").html();
			MIG.clearObjective( id - 1, true );
		});
		
		// Add dropdown handlers
		$('.select-terrain').on("blur", function () { MIG.terrain = $('.select-terrain').val(); });
		$('.select-allies').on("blur", function () { MIG.allies = $('.select-allies').val(); });
		$('.select-hostiles').on("blur", function () { MIG.hostiles = $('.select-hostiles').val(); });
		$('.select-objectives').on("blur", function () {
			var id = ( $( this ).parent().parent().find(".inputs-number").html() ) - 1;
			MIG.objectives[id] = $(this).val();
			MIG.render();
		});	
		
		
		this.rollAll();
	};
	
	this.init();
}

$( document ).ready(function() {
	MIG = new Idea();
	
	$('.btn-roll-all').css( {
		width: "472px"
		, height: "48px"
		, fontSize: "11px"
		, cursor: "pointer"	
	} );
	
});
