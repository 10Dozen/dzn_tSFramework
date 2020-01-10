var locale = 0; // 0 - EN, 1 - RU
var code = "";

var defaultTags = {
	"SPECOPS": { 		hint: "Спецоперация спецоператоров"},
	"INFANTRY": {		hint: "Легкая пехота (контр инсургенси, патрули, оборона)" },
	"COMB.ARMS": {		hint: "Общевойсковая операция" },
	"MOUT": {			hint: "Преимущественно городские бои" },
	"JTAC/CAS": { 		hint: "Есть CAS/нужен JTAC" },
	"ARMOR": { 			hint: "Есть тяжелая техника (БМП, танки)" },
	"RolePlay":  { 		hint: "Есть ролевой элемент" }
};

var defaultTopics = [
	["I. Situation:", "I. Обстановка:", ""]
	,["A. Enemy Forces:", "А. Враждебные силы:", ""]
	,["B. Friendly Forces:", "Б. Дружественные силы:", ""]
	,["II. Mission:", "II. Задание:", "1. \n2. \n3. \n"]
	,["III. Execution:", "III. Выполнение:", "По плану командира."]
	,["IV. Service Support:", "IV. Поддержка:", ""]
	,["V. Command & Signal:", "V. Сигналы:", "PL NET 50\n1'1 - SR CH 1\n1'2 - SR CH 2"]
	,["VI. Mission notes:", "VI. Замечания:", "Powered by Tactical Shift Framework"]
	,["VII. GSO notes:", "VII. Замечания для GSO:", "-"]
];

var textAreaSettings = {
	"cols": 50
	,"rows": 10
	,"width": "800px"
}

function generateTagsCheckboxes() {
	let tagsArray = Object.entries(defaultTags);
	
	for (let i = 0; i < tagsArray.length; ++i) {
		let tag = tagsArray[i];
		let tagName = tag[0];
		let tagProps = tag[1];
		
		$("#tags > ul").append(
			"<li>" +
			"<input type='checkbox' id='" + tagName + "'/>" + 
			"<label for='" + tagName + "'>" + tagName + " (" + tagProps.hint + ")" + "</label>" +
			"</li>"
		);
	}
};

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

function getCode() {
	let defineBlock = "//     tSF Briefing\n// Do not modify this part"
		+ "\n#define BRIEFING		_briefing = [];"
		+ "\n#define TOPIC(NAME) 	_briefing pushBack [\"Diary\", [ NAME,"
		+ "\n#define END			]];"
		+ "\n#define ADD_TOPICS	for \"_i\" from (count _briefing) to 0 step -1 do {player createDiaryRecord (_briefing select _i);};"
		+ "\n#define TAGS(X) tSF_MissionTags = X ;"
		+ "\n//\n//\n// Mission tags";
	
	let tags = [];
	let tagsInputs = $("#tags input");
	
	for (let i = 0; i < tagsInputs.length; ++i) {
		if ($(tagsInputs[i]).prop("checked")) {
			let tagName = $(tagsInputs[i]).prop("id");
			tags.push('"' + tagName + '"');
		}
	}
	let tagsBlock = "\nTAGS([" + tags + "])";
	let preBriefingBlock = 	"\n\n// Briefing goes here" + "\n\nBRIEFING\n";
	
	let topics = "";
	let topicCount = $( ".topicInput" ).length;
	
	for (let i = 0; i < topicCount; i++) {
		let text = ( $($( ".topicData" )[i]).val() ).replace(/(\r\n|\n|\r)/g,"<br />");
		
		if (i == topicCount - 1) {
			topics = topics
				+ "\nif ((serverCommandAvailable '#logout') || !(isMultiplayer) || isServer) then {"
				+ "\nTOPIC(\"" + escapeQuotes ( $($( ".topicInput" )[i]).val() ) + "\")"
				+ "\n\"" +  escapeQuotes(text) + "\""
				+ "\nEND"
				+ "\n};\n";
			
		} else {
		
			topics = topics
				+ "\nTOPIC(\"" + escapeQuotes ( $($( ".topicInput" )[i]).val() ) + "\")"
				+ "\n\"" +  escapeQuotes(text) + "\""
				+ "\nEND\n";
		}
	}
	
	let endBlock = "\nADD_TOPICS"
	
	let code = (defineBlock + tagsBlock + preBriefingBlock + topics + endBlock);
	return code;
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
	a.setAttribute('href', 'data:text/plain;charset=utf-8,' + encodeURIComponent(getCode()));
	a.setAttribute('download', "tSF_briefing.sqf" );
	a.click();
}

var openFile = function(event) {
	setTimeout( readFile(event), 200 );
}

function readFile(event) {
	var input = event.target;
	var reader = new FileReader();
	reader.onload = function(){
		text = reader.result;
		if (text.length > 0) {
			console.log( "Read!");
			importBriefing(text);
		} else {
			console.log( "Empty!" );
        }
	};
	reader.readAsText(input.files[0]);
};

function importBriefing(sqfText) {
	console.log("Importing Briefing");

	console.log("#     Parsing SQF");
	let parsedTopics = parseBriefing(sqfText);
	console.log("#     SQF parsed");

	console.log("#     Populating topics");
	for (let i = 0; i < parsedTopics.length; i++) {
		populateTopic(i*2, parsedTopics[i][0], parsedTopics[i][1]);
	}
	console.log("#     Topics populated");
	
	console.log("#     Parsing tags");
	let parsedTags = parseTags(sqfText);
	console.log("#     Tags parsed");
	
	console.log("#     Populating tags");
	populateTags(parsedTags);
	console.log("#     Tags populated");
	
	console.log("#     All done!");
}

function parseBriefing(rawBriefing) {
	var rawLines = rawBriefing.split("\n");

	var tempAllTopics = [];
	var tempTopic = [];
	var isSameTopic = false;
	for (var i = 0; i < rawLines.length; i++) {
		var rawLine = rawLines[i];

		if (!(rawLine.match(/END/g) === null)) {
			isSameTopic = false;

			var parsedTopic = [tempTopic[0]];
			var topicText = "";
			for (var j = 1; j < tempTopic.length; j++) {
				topicText = topicText + tempTopic[j];
			};

			topicText = topicText.substr(1);
			topicText = topicText.slice(0, -1);
			topicText = topicText.replace(/(<br \/>|<br\/)/g,"\n");

			parsedTopic.push(topicText);

			tempAllTopics.push(parsedTopic);
		};

		if (isSameTopic) {
        	tempTopic.push(rawLine);
        };

		if (
			!( rawLine.match(/TOPIC\("(.*)"\)/g) === null )
			 && rawLine.match(/TOPIC\(NAME\)/g) === null
		) {
			tempTopic = [];
			isSameTopic = true;

			tempTopic.push( (rawLine.match(/TOPIC\("(.*)"\)/))[1] );
		};
	};

	tempAllTopics.shift(0);
	/*
		Make splited lines all together
	*/
	return tempAllTopics
}

function parseTags(rawBriefing) {
	let rawLines = rawBriefing.split("\n");
	let tags = [];
	for (let i = 0; i < rawLines.length; i++) {
		let rawLine = rawLines[i];
		
		if (!(rawLine.match(/TAGS\(\[(.*)\]\)/g) === null)) {
			let tagsString = rawLine.match(/TAGS\(\[(.*)\]\)/)[1];
			tags = tagsString.replace(/"/g,"").split(",");
			
			break;
		};
	};
	
	return tags;
};

function populateTopic(id,title,text) {
	let topics = $('#briefing-form > ul > li');

	let topicTitle = $( topics[id] ).find('.topicInput')[0];
	let topicBody = $( topics[id + 1] ).find('.topicData')[0]

	topicTitle.value = title;
	topicBody.value = text;
}

function populateTags(tags) {
	let tagsInputs = $("#tags input");
	
	for (let j = 0; j < tags.length; ++j) {
		let tag = tags[j];
	
		for (let i = 0; i < tagsInputs.length; ++i) {
			if ($(tagsInputs[i]).prop("id") == tag ) {
				$(tagsInputs[i]).prop('checked',true);
				break;
			}
		}
	}
};

// --- Init
$( document ).ready(function() {
	changeLocale();
	generateDefaultTopics();
	generateTagsCheckboxes();
});
