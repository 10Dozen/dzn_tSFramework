var locale = 0; // 0 - EN, 1 - RU
var code = "";

var defaultTopics = [
	["I. Situation:", "I. Обстановка:", ""]
	,["A. Enemy Forces:", "А. Враждебные силы:", ""]
	,["B. Friendly Forces:", "Б. Дружественные силы:", ""]
	,["II. Mission:", "II. Задание:", "1. \n2. \n3. \n"]
	,["III. Execution:", "III. Выполнение:", "По плану командира."]
	,["IV. Service Support:", "IV. Поддержка:", ""]
	,["V. Command & Signal:", "V. Сигналы:", "PL NET 50\n1'1 - SR 1\n1'2 - SR 2"]
	,["VI. Mission notes:", "VI. Замечания:", "Powered by Tactical Shift Framework"]
];

var textAreaSettings = {
	"cols": 50
	,"rows": 10
	,"width": "800px"
}


function generateDefaultTopics() {
	for (var i = 0; i < defaultTopics.length; i++ ) {
		$( "#briefing-form > ul" ).append(
			"<li><div class='dl-1'>Topic</div>"
			+ "<div class='dl-2'>"
			+ "<input class='topicInput' topicId='" + i + "' value='" + defaultTopics[i][locale] + "' placeholder='" + defaultTopics[i][locale] + "'></input>"
			+ "</div></li>"
			+ "<li><div class='dl-3'>"
			+ "<textarea class='topicData' cols='" + textAreaSettings.cols
			+ "' rows='" + textAreaSettings.rows + "'>"
			+ defaultTopics[i][2] + "</textarea>"
			+ "</div></li><hr />"	
		);
	};
	
	$( ".dl-3 > textarea" ).css( "width", textAreaSettings.width );
}

function changeTopicLocale() {
	$( ".topicInput" ).each( function() {
		var id = $( this ).attr("topicId");
		$( this ).attr({
			"value": defaultTopics[id][locale],
			"placeholder": defaultTopics[id][locale]
		});		
	} );
	
};

function changeLocale() {
	var l = $( "#locale" ).attr( "locale" );
	var label = "";
	if (l == 0) { label = "RU"; l = 1; } else { label = "EN"; l = 0; };
	locale = l;
	$( "#locale" ).attr( "locale", l);
	$( "#locale" ).html( label );
	
	changeTopicLocale();
}

function escapeQuotes(str) {
	return ( str.replace(new RegExp('"','g'),'""') );
};

$( document ).ready(function() {
	generateDefaultTopics();
});

function getCode() {
	var defineBlock = "//     tSF Briefing\n// Do not modify this part"
		+ "\n#define BRIEFING		_briefing = [];"
		+ "\n#define TOPIC(NAME) 	_briefing pushBack [\"Diary\", [ NAME,"
		+ "\n#define END			]];"
		+ "\n#define ADD_TOPICS	for \"_i\" from (count _briefing) to 0 step -1 do {player createDiaryRecord (_briefing select _i);};"
		+ "\n//\n//\n// Briefing goes here"
		+ "\n\nBRIEFING\n";
		
	var topics = "";
	var topicCount = $( ".topicInput" ).length;
	
	for (var i = 0; i < topicCount; i++) {
		var text = ( $($( ".topicData" )[i]).val() ).replace(/(\r\n|\n|\r)/g,"<br />");
		
		topics = topics
			+ "\nTOPIC(\"" + escapeQuotes ( $($( ".topicInput" )[i]).val() ) + "\")"
			+ "\n\"" +  escapeQuotes(text) + "\""
			+ "\nEND\n";
	}
	
	var endBlock = "\nADD_TOPICS"
	
	code = (defineBlock + topics + endBlock)
	return (defineBlock + topics + endBlock);
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
	a.setAttribute('download', "tSF_briefing.sqf" );
	a.click();
}
