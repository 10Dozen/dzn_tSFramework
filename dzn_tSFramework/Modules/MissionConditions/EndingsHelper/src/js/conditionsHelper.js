var locale = 0; // 0 - EN, 1 - RU
var EndingsMaxId = 0;
var Endings = [];

var endingTypes = [
	["WIN", "WIN", "Миссия выполнена", "Восхитительный успех!"]
	, ["FAIL", "FAIL", "Миссия провалена", "Восхитительный провал"]
	, ["WIPED", "WIPED", "Миссия провалена", "Все погибли"]
	, ["MVP Dead", "MVP_DEAD", "Миссия выполнена", "MVP уничтожен"]
	, ["MVP Captured", "MVP_CAP", "Миссия выполнена", "MVP захвачен"]
	, ["TGT Dead", "TGT_DEAD", "Миссия выполнена", "Цель уничтожена"]
	, ["TGT Captured", "TGT_CAP", "Миссия выполнена", "Цель захвачена"]
	, ["Intel Captured", "INTEL_CAP", "Миссия выполнена", "Разведданые захвачены"]
];

var code = "";

var textAreaSettings = {
	"cols": 50
	,"rows": 10
	,"width": "800px"
}

/*		
 *	COMMON FUNCTIONS
*/ 

function escapeQuotes(str) {
	return ( str.replace(new RegExp('"','g'),'""') );
};

function getCode() {	
	var debriefing;
	var debriefingBlockStart = "class CfgDebriefing\n{";
	var debriefingBlockEnd = "\n};";
	
	var debriefingClasses = "";
	for (var i = 0; i < Endings.length; i++) {
		var Ending = Endings[i];
		
		var text = '\n	class ' + Ending.name
			+ '\n	{'
			+ '\n		title = "' + escapeQuotes(Ending.title) + '";'
			+ '\n		subtitle = "' + escapeQuotes(Ending.subtitle) + '";'
			+ '\n		description = "' + escapeQuotes(Ending.description) + '";'
			+ '\n	};';

		debriefingClasses = debriefingClasses + text;		
	};

	debriefing = debriefingBlockStart + debriefingClasses + debriefingBlockEnd;
	return debriefing;
};

function getCodeToDisplay() {
	var code = getCode();
	code = code.replace(/<br \/>/g, "\n&lt;br /&gt;");
	code = code.replace(/</g, "&lt;");
	code = code.replace(/>/g, "&gt;");
	code = code.replace(/(\r\n|\n|\r)/g,"<br />");
	
	$( "#result-tab" ).css( "top", "15%" );
	$( "#result-tab-data" ).html( code );
}

function closeCodeDisplay() {
	$( "#result-tab" ).css( "top", "-3000px" );
};

function getCodeToFile() {
	var a = document.createElement('a');
	a.setAttribute('href', 'data:text/plain;charset=utf-8,' + encodeURIComponent( getCode() ));
	a.setAttribute('download', "Endings.hpp" );
	a.click();
}


/*		
 *	ENDING FUNCTIONS
*/ 
var a = [];

function getEndingById(id) {
	var ending = {};
	for (var i = 0; i < Endings.length; i++) {
		if (Endings[i].id == id) { 
			ending = Endings[i]; 
			break;
		}
	};	
	return ending;
}

function escapeDuplicateNames(originalName, newName) {
	var resultName = newName;

	for (var i = 0; i < Endings.length; i++) {
		if (Endings[i].name == newName) {
			resultName = originalName;
			break;
		};
	};

	if (newName == "") { resultName = originalName; };
	return resultName;
}

function checkDuplicateNames(name) {
	var result = true;
	for (var i = 0; i < Endings.length; i++) {
		if (Endings[i].name == name) {
			result = false;
			break;
		};
	};
	
	if (name == "") { result = false };
	return result;
};


var Ending = function () {
	this.id = EndingsMaxId;
	this.name = escapeDuplicateNames(getEndingType()[1] + EndingsMaxId, getEndingType()[1]);
	/* getEndingType()[1] + EndingsMaxId;*/
	this.title = getEndingType()[2];
	this.subtitle = getEndingType()[3];
	this.description = "";
	this.$form = $(
		"<ul class='ending-item' endingId='" + this.id + "'>"
		+ "<div class='ending-remove' title='Delete ending'>✖</div>"
		+ "<span><div class='ending-name' title='Ending class name (no spaces allowed)'>" + this.name + "</div></span>"
		+ "<li><div class='dl-1'>Title</div><div class='dl-2'>"
		+ "<input class='topicInput ending-title' placeholder='Mission Accomplished' value='" + this.title + "'></input></div></li>"
		+ "<li><div class='dl-1'>Subtitle</div><div class='dl-2'>"
		+ "<input class='topicInput  ending-subtitle' placeholder='All mission objectives completed' value='" + this.subtitle + "'></input></div></li>"
		+ "<li><div class='dl-1'>Description</div><div class='dl-3'>"
		+ "<textarea class='topicData ending-desc' cols='" + textAreaSettings.cols 
			+ "' rows='" + textAreaSettings.rows + "'></textarea>"
		+ "</div></li><hr /></ul>"	
	);
	
	
	this.setEndingName = function (newName) {
		this.name = newName.replace(/[-[\]{}()*+?.,\\^$|#\s!@%=&]/g, "")	
		$( this.$form ).find('.ending-name').html( this.name );
		$( this.$form ).find('.ending-name').css("display", "inline-block");
	};
	this.draw = function () {
		$( "#endings-form" ).append( this.$form );
	}
	
	this.initEvents = function () {
		$(this.$form).find('.ending-remove').on('click', function () {			
			var self = getEndingById( $ ($(this).parents()[0]).attr("endingId")  );
			self.remove();
		});
		
		$(this.$form).find('.ending-name').on('click', function () {			
			var id = $( $(this).parents()[1] ).attr("endingId");
			var name = $( this ).html();
			$( this ).css( "display", "none" );
			
			var $inputName = $(this).parent().append(
				"<div class='ending-name-input' endingId='" + id + "'>"
				+ "<input value='" + name + "'/>"
				+  "<span class='ending-name-btn ending-name-accept'>✓</span>"
				+ "<span class='ending-name-btn ending-name-decline'>✗</span></div>"
			);			
			
			$( $inputName ).find('.ending-name-btn').on('click', function () {
				$( $( this ).parent() ).find( '.ending-name-accept' ).off();
				$( $( this ).parent() ).find( '.ending-name-decline' ).off();
				$( $( this ).parent() ).remove();
			})
			$( $inputName ).find('.ending-name-accept').on('click', function () {
				var newName = $( this ).parent().find('input').val();				
				var ending = getEndingById( $(this).parent().attr("endingId")  );

				ending.setEndingName(escapeDuplicateNames(ending.name, newName));
				/*
				if ( !checkDuplicateNames(newName) ) { newName = ending.name; }
				ending.setEndingName(newName);
				*/

			});
			$( $inputName ).find('.ending-name-decline').on('click', function () {
				var ending = getEndingById( $(this).parent().attr("endingId")  );
				ending.setEndingName(ending.name);
			});			
		});
		
		$(this.$form).find('.ending-title').on('blur', function () {			
			var self = getEndingById( $ ($(this).parents()[2]).attr("endingId")  );
			self.title = $( this ).val();
		});
		$(this.$form).find('.ending-subtitle').on('blur', function () {			
			var self = getEndingById( $ ($(this).parents()[2]).attr("endingId")  );
			self.subtitle = $( this ).val();
		});
		$(this.$form).find('.ending-desc').on('blur', function () {			
			var self = getEndingById( $ ($(this).parents()[2]).attr("endingId")  );
			self.description = $( this ).val();
		});
	}
	
	this.remove = function () {
		Endings.splice( Endings.indexOf(this), 1 );			
		
		$( this.$form ).find('.ending-remove').off();
		$( this.$form ).find('.ending-name').off();
		$( this.$form ).find('.ending-name-btn').off();
		$( this.$form ).find('.ending-title').off();
		$( this.$form ).find('.ending-subtitle').off();
		$( this.$form ).find('.ending-desc').off();
		
		$( this.$form ).remove();
		
		console.log("Ending Removed");
	}
	
	this.init = function () {
		this.draw();
		this.initEvents();	
		
		EndingsMaxId++;
		Endings.push(this);
	}
	
	this.init();	
}

function addEnding() {
	var ending = new Ending();
	console.log('Ending added');
}

function getEndingType() {
	var name = $("#end-select").val();
	var ending;
	for (var i = 0; i < endingTypes.length; i++ ) {
		if (name == endingTypes[i][0]) { ending = endingTypes[i]; };
	};

	return ending;
};

$( document ).ready(function() {
	// populate select
	for (var i = 0; i < endingTypes.length; i++ ) {
		$("#end-select").append(
			"<option>" + endingTypes[i][0] + "</option>"
		)
	};
});
