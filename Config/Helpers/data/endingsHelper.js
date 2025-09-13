var locale = 0; // 0 - EN, 1 - RU
var EndingsMaxId = 0;
var Endings = [];

const endingTypes = [
	["WIN", "WIN", "Миссия выполнена", "Восхитительный успех!", "Задача выполнена."]
	, ["FAIL", "FAIL", "Миссия провалена", "Восхитительный провал", ""]
	, ["WIPED", "WIPED", "Миссия провалена", "Все погибли", "Такие дела..."]
	, ["MVP Dead", "MVP_DEAD", "Миссия выполнена", "MVP уничтожен", ""]
	, ["MVP Captured", "MVP_CAP", "Миссия выполнена", "MVP захвачен", "", ""]
	, ["TGT Dead", "TGT_DEAD", "Миссия выполнена", "Цель уничтожена", ""]
	, ["TGT Captured", "TGT_CAP", "Миссия выполнена", "Цель захвачена", ""]
	, ["Intel Captured", "INTEL_CAP", "Миссия выполнена", "Разведданые захвачены", ""]
];

var code = "";

const textAreaSettings = {
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

function replaceNewline(str) {
	return str.replace(/(?:\r\n|\r|\n)/g, '<br/>');
}

function getCode() {
	let debriefing;
	const debriefingBlockStart = "class CfgDebriefing\n{";
	const debriefingBlockEnd = "\n};";

	let debriefingClasses = "";
	for (var i = 0; i < Endings.length; i++) {
		var Ending = Endings[i];

		const text = '\n	class ' + Ending.name
			+ '\n	{'
			+ '\n		title = "' + escapeQuotes(Ending.title) + '";'
			+ '\n		subtitle = "' + escapeQuotes(Ending.subtitle) + '";'
			+ '\n		description = "' + replaceNewline(escapeQuotes(Ending.description)) + '";'
			+ '\n	};';

		debriefingClasses = debriefingClasses + text;
	};

	debriefing = debriefingBlockStart + debriefingClasses + debriefingBlockEnd;
	return debriefing;
};

function getCodeToDisplay() {
	document.getElementById("result-tab").style.top = "15%";
	document.querySelector("#result-tab-data > textarea").value = getCode();
}

function closeCodeDisplay() {
	document.getElementById("result-tab").style.top = "-3000px";
};

function getCodeToFile() {
	var a = document.createElement('a');
	a.setAttribute('href', 'data:text/plain;charset=utf-8,' + encodeURIComponent( getCode() ));
	a.setAttribute('download', "_MissionEndings.hpp" );
	a.click();
}


/*
 *	ENDING FUNCTIONS
*/
var a = [];

function getEndingByChildElement(el) {
	let id = null;
	do {
		el = el.parentElement;
		id = el.getAttribute('endingid');
	} while (id === null && el !== null);

	if (id === null) {
		console.error("Failed to find EndingID...")
		return
	}

	id = parseInt(id)
	return Endings.find((e)=>e.id==id);
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
	this.description = getEndingType()[4];
	this.form = null;
	this.$form = 
		"<ul class='ending-item' endingId='" + this.id + "'>"
		+ "<div class='ending-remove' title='Delete ending'>✖</div>"
		+ "<span><div class='ending-name' title='Ending class name (no spaces allowed)'>" + this.name + "</div></span>"
		+ "<li><div class='dl-1'>Title</div><div class='dl-2'>"
		+ "<input class='topicInput ending-title' placeholder='Mission Accomplished' value='" + this.title + "'></input></div></li>"
		+ "<li><div class='dl-1'>Subtitle</div><div class='dl-2'>"
		+ "<input class='topicInput  ending-subtitle' placeholder='All mission objectives completed' value='" + this.subtitle + "'></input></div></li>"
		+ "<li><div class='dl-1'>Description</div><div class='dl-3'>"
		+ "<textarea class='topicData ending-desc' cols='" + textAreaSettings.cols
			+ "' rows='" + textAreaSettings.rows + "'>" + this.description + "</textarea>"
		+ "</div></li><hr /></ul>";


	this.setEndingName = function (newName) {
		this.name = newName.replace(/[-[\]{}()*+?.,\\^$|#\s!@%=&]/g, "")
		const nameElement = this.form.getElementsByClassName("ending-name")[0]
		nameElement.style.display = "";
		nameElement.innerText = this.name;
	};
	this.draw = function () {
		const form = (new DOMParser().parseFromString(this.$form, "text/html")).body.firstChild;
		this.form = document.getElementById("endings-form").appendChild(form);
	}

	this.initEvents = function () {
		this.form.getElementsByClassName("ending-remove")[0].addEventListener(
			"click",
			function (event) {
				const self = getEndingByChildElement(this);
				self.remove();
			}
		);
		
		this.form.getElementsByClassName("ending-name")[0].addEventListener(
			"click",
			function (event) {
				const self = getEndingByChildElement(this);
				this.style.display = "none"

				const nameInput = this.parentElement.appendChild((new DOMParser().parseFromString(
					"<div class='ending-name-input' endingId='" + self.id + "'>"
			 		+ "<input value='" + self.name + "'/>"
			 		+  "<span class='ending-name-btn ending-name-accept'>✓</span>"
			 		+ "<span class='ending-name-btn ending-name-decline'>✗</span></div>"
				, "text/html")).body.firstChild);

				nameInput.getElementsByClassName('ending-name-accept')[0].addEventListener(
					"click",
					function (event) {
						const name = this.parentElement.getElementsByTagName("input")[0].value
						console.log(name)
						const self = getEndingByChildElement(this);
						this.parentElement.remove();

						self.setEndingName(escapeDuplicateNames(self.name, name));
					}
				);

				nameInput.getElementsByClassName('ending-name-decline')[0].addEventListener(
					"click",
					function (event) {
						const self = getEndingByChildElement(this);
						this.parentElement.remove()
						self.setEndingName(self.name)
					}
				);
			}
		);

		this.form.getElementsByClassName('ending-title')[0].addEventListener(
			"blur",
			function (event) {
				const self = getEndingByChildElement(this);
				self.title = this.value;
			}
		);
		this.form.getElementsByClassName('ending-subtitle')[0].addEventListener(
			"blur",
			function (event) {
				const self = getEndingByChildElement(this);
				self.subtitle = this.value;
			}
		);
		this.form.getElementsByClassName('ending-desc')[0].addEventListener(
			"blur",
			function (event) {
				const self = getEndingByChildElement(this);
				self.description = this.value;
			}
		);
	}

	this.remove = function () {
		Endings.splice( Endings.indexOf(this), 1 );
		this.form.remove();
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
	const name = document.getElementById("end-select").value;
	return endingTypes.find((e) => { return e[0] == name })
};

document.addEventListener("DOMContentLoaded", function(event) {
	const selector = document.getElementById("end-select");
    for (let i = 0; i < endingTypes.length; ++i) {
		let opt = document.createElement("option");
		opt.innerText = endingTypes[i][0];
		selector.append(opt);
	}
});

