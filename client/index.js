
import {
    io
}
from "socket.io-client";

const socket = io("http://192.168.0.110:3000");

var socketId;

document.getElementById("modoption_roomid").addEventListener("change", sendLook);

function sendLook() {
	socket.emit("data", JSON.stringify({ "command": "look" }));
}

socket.on("connect", () => {
    sendToConsole('You connected with id: ' + socket.id);
    sendLook();
	updateFavicon();
    socketId = socket.id;
})

socket.on("data", message => {
    const test = JSON.parse(message);
    for (let i in test) {
        if (i == "roomdata")
			{ updateRoomData(test) }
		else if (i == "roomexits")
			{ updateRoomExits(test) }
		else if (i == "mapdata")
			{ updateMap(test); }
        else if (i == "whodata")
			{ updateWho(test); }
		else if (i == "roomobjects")
			{ updateRoomObjects(test); }
    }
})

socket.on("loggedIn", character => {
	socket.data.name = character.name;
	socket.data.roomid = character.roomid;
	socket.data.title = character.title;
	socket.data.tag = character.tag;
	socket.data.x = character.x;
	socket.data.y = character.y;
	socket.data.z = character.z;
	updatePlayerInfo();
	document.cookie = "username=; expires=Thu, 01 Jan 1970 00:00:00 UTC; path=/;";
	setCookie("username", character.name, 1);
})

socket.on("playerinfo", message => {
	socket.data = message;
	updatePlayerInfo();
})

socket.on("whochanged", () => {
    var messageBody = JSON.stringify({
        "command": "getwhodata"
    });
    socket.emit("data", messageBody);
})

socket.on("serverlog", message => {
    let output = JSON.parse(message);
    sendToConsole(output.console);
})

socket.on("locallog", message => {
    let output = JSON.parse(message);
    sendToLocal(output.console);
})

socket.on("globallog", message => {
    let output = JSON.parse(message);
    sendToGlobal(output.console);
})

socket.on("event", message => {
	let eventData = message;
	if (eventData.includes("Something")) {
		console.log(eventData);
	}
	else {
		switch(eventData) {
			case "startPlayerRegister":
				console.log('starting registration');
				startPlayerRegister();
				break;
			default: 
				break;
		}
	}
})

function updateFavicon() {
	var favicon = document.getElementById("favicon");
	var faviconSize = 16;
	var canvas = document.createElement("canvas");
	canvas.width = faviconSize;
	canvas.height = faviconSize;
	var context = canvas.getContext('2d');
	var img = document.createElement("img");
	img.src = favicon.href;
	img.onload = () => {
		context.drawImage(img, 0, 0, faviconSize, faviconSize);
		context.beginPath();
		context.arc( canvas.width - faviconSize / 2, faviconSize / 2, faviconSize / 2, 0, 2*Math.PI);
		context.fillStyle = '#00FF00';
		context.fill();
		favicon.href = canvas.toDataURL('image/png');
	};
}

function startPlayerRegister() {
	createRegisterForm();
}

function createRegisterForm() {
	var backMask = document.createElement("div");
	backMask.setAttribute("class", "backmask");
	backMask.setAttribute("id", "backmask");
	var formWindow = document.createElement("div");
	formWindow.setAttribute("class", "formwindow");
	formWindow.setAttribute("id", "formwindow");
	var formTitle = document.createElement("h4");
	formTitle.innerText = "New Player Registration";
	formWindow.appendChild(formTitle);
	var formValidation = document.createElement("h5");
	formValidation.setAttribute("id", "formValidation");
	formWindow.appendChild(formValidation);
	var formNameLabel = document.createElement("label");
	formNameLabel.setAttribute("for", "player_name_input");
	formNameLabel.innerText = "Player Name: ";
	formWindow.appendChild(formNameLabel);
	var formNameInput = document.createElement("input");
	formNameInput.setAttribute("type", "text");
	formNameInput.setAttribute("id", "player_name_input");
	formNameInput.setAttribute("name", "player_name_input");
	formWindow.appendChild(formNameInput);
	var submitButton = document.createElement("button");
	submitButton.innerText = "Register Player";
	submitButton.setAttribute("id", "register_submit");
	formWindow.appendChild(submitButton);
	backMask.appendChild(formWindow);
	document.body.appendChild(backMask);
	var nameinput = document.getElementById("player_name_input");
	nameinput.addEventListener("focusout", function() {
		validateInput("playername", nameinput);
	});
	document.getElementById("register_submit").addEventListener("click", function() {
		submitPlayerRegister(nameinput.value);
	});
}

function validateInput(type, div) {
	socket.emit("validateInput", type, div.value, (response) => {
		switch(type) {
			case "playername":
				if (response == true) {
					document.getElementById("formValidation").innerText = "Player Name is Available!";
					document.getElementById("formValidation").setAttribute("class", "validate_true");
					document.getElementById("register_submit").disabled = false;
				}
				else {
					document.getElementById("formValidation").innerText = "That Name is Already Taken!";
					document.getElementById("formValidation").setAttribute("class", "validate_false");
					document.getElementById("register_submit").disabled = true;
				}
				break;
			case "charactername":
				if (response == true) {
					document.getElementById("formValidation").innerText = "Character Name is Available!";
					document.getElementById("formValidation").setAttribute("class", "validate_true");
					document.getElementById("register_submit").disabled = false;
				}
				else {
					document.getElementById("formValidation").innerText = "That Name is Already Taken!";
					document.getElementById("formValidation").setAttribute("class", "validate_false");
					document.getElementById("register_submit").disabled = true;
				}
				break;
		}
		
	});
}

function submitPlayerRegister(name) {
	socket.emit("createPlayer", name, (response) => {
		if (response == "success") {
			playerCreated();
		}
		else {
			console.log(response);
		}
	});
}

function playerCreated() {
	var formwindow = document.getElementById("formwindow");
	formwindow.remove();
	var formWindow = document.createElement("div");
	formWindow.setAttribute("class", "formwindow");
	formWindow.setAttribute("id", "formwindow");
	var formTitle = document.createElement("h4");
	formTitle.innerText = "Create Your First Character";
	formWindow.appendChild(formTitle);
}

async function sendAction(action) {
	socket.emit("data", JSON.stringify({ "command": action }));
}

function setCookie(cname, cvalue, exdays) {
	const d = new Date();
	d.setTime(d.getTime() + (exdays*24*60*60*1000));
	let expires = "expires=" + d.toUTCString();
	document.cookie = cname + "=" + cvalue + ";" + expires + ";path=/";
}

function getCookie(cname) {
	let name = cname + "=";
	let decodedCookie = decodeURIComponent(document.cookie);
	let ca = decodedCookie.split(';');
	for(let i = 0; i <ca.length; i++) {
	let c = ca[i];
	while (c.charAt(0) == ' ') {
	  c = c.substring(1);
	}
	if (c.indexOf(name) == 0) {
	  return c.substring(name.length, c.length);
	}
	}
	return "";
}

function checkCookie() {
  let username = getCookie("username");
  if (username != "") {

  } else {
    username = socket.data.name;
    if (username != "" && username != null) {
      setCookie("username", username, 1);
    }
  }
}

function updatePlayerInfo() {
	var statusPlayerName = document.getElementById("statusbar_name_playername");
	if (statusPlayerName.innerHTML != socket.data.name) {
		statusPlayerName.innerHTML = socket.data.name;
		checkCookie();
	}
}

function updateWho(message) {
    var whomods = document.getElementById("whomods");
    while (whomods.hasChildNodes()) {
        whomods.removeChild(whomods.firstChild);
    }
    var whoplayers = document.getElementById("whoplayers");
    while (whoplayers.hasChildNodes()) {
        whoplayers.removeChild(whoplayers.firstChild);
    }
    var whomobs = document.getElementById("whomobs");
    while (whomobs.hasChildNodes()) {
        whomobs.removeChild(whomobs.firstChild);
    }
    for (let i = 0; i < message.whodata.length; i++) {
        var newwho = document.createElement("li");
        newwho.setAttribute("class", "whoplayer");
        var newtag = document.createElement("span");
        newtag.setAttribute("class", "whoplayertag");
        newtag.innerText = message.whodata[i].tag;
        newwho.appendChild(newtag);
        var newname = document.createElement("span");
        newname.setAttribute("class", "whoplayername");
        newname.innerHTML = message.whodata[i].name;
        newwho.appendChild(newname);
        var newtitle = document.createElement("span");
        newtitle.setAttribute("class", "whoplayertitle");
        newtitle.innerText = message.whodata[i].title;
        newwho.appendChild(newtitle);
        whoplayers.appendChild(newwho);
    }
}

function sendToGlobal(messageBody) {
    const newBody = messageBody;
    var bodyClass = "message";
    if (newBody.startsWith("[You]:")) {
        bodyClass = "message fromyou";
    }
    const log = document.getElementById("globalchat");
    const para = document.createElement("p");
    const d = new Date();
    let diff = d.getTimezoneOffset();
    d.setHours(d.getHours() - (diff / 60));
    let ts = d.toISOString();
    const newLine = "<span class='date'>" + ts.substring(0, ts.indexOf("T")) + "</span> <span class='time'>" + ts.substr(ts.indexOf("T") + 1) + "</span> <span class='" + bodyClass + "'>" + newBody + "</span>";
    para.innerHTML = newLine;
    log.appendChild(para);
}

function sendToLocal(messageBody) {
    const newBody = messageBody;
    var bodyClass = "message";
    if (newBody.startsWith("[You]:")) {
        bodyClass = "message fromyou";
    }
    const log = document.getElementById("localchat");
    const para = document.createElement("p");
    const d = new Date();
    let diff = d.getTimezoneOffset();
    d.setHours(d.getHours() - (diff / 60));
    let ts = d.toISOString();
    const newLine = "<span class='date'>" + ts.substring(0, ts.indexOf("T")) + "</span> <span class='time'>" + ts.substr(ts.indexOf("T") + 1) + "</span> <span class='" + bodyClass + "'>" + newBody + "</span>";
    para.innerHTML = newLine;
    log.appendChild(para);
}

function moveRoom(dir) {
    var messageBody = JSON.stringify({
        "command": dir
    });
    socket.emit("data", messageBody);
}

function sendToConsole(messageBody) {
    const newBody = messageBody;
    var bodyClass = "message";
    if (newBody.startsWith("[You]:")) {
        bodyClass = "message fromyou";
    }
    const log = document.getElementById("log");
    const para = document.createElement("p");
    const d = new Date();
    let diff = d.getTimezoneOffset();
    d.setHours(d.getHours() - (diff / 60));
    let ts = d.toISOString();
    const newLine = "<span class='date'>" + ts.substring(0, ts.indexOf("T")) + "</span> <span class='time'>" + ts.substr(ts.indexOf("T") + 1) + "</span> <span class='" + bodyClass + "'>" + newBody + "</span>";
    para.innerHTML = newLine;
    log.appendChild(para);
}

function updateRoomData(messageBody) {
    var roomdata = messageBody.roomdata;
    var roomid = roomdata.pkid;
    var roomtitle = roomdata.title;
    var roomdesc = roomdata.description;
    var x = roomdata.x;
    var y = roomdata.y;
    var z = roomdata.z;
    var currentobjects = document.getElementById("roomobjecttable");
    while (currentobjects.hasChildNodes()) {
        currentobjects.removeChild(currentobjects.firstChild);
    }
    document.getElementById("currentroomtitle").innerHTML = roomtitle;
    document.getElementById("currentroomdesc").innerHTML = roomdesc;
    document.getElementById("currentroomid").innerHTML = "(" + roomid + ")";
	if (document.getElementById("modoption_roomid").checked == false) {
		document.getElementById("currentroomid").setAttribute("class", "option_disabled");
	}
	else {
		document.getElementById("currentroomid").setAttribute("class", "option_enabled");
	}
}

function updateRoomObjects(message) {
	if (message.roomobjects.length > 0) {
		var currentobjects = document.getElementById("roomobjecttable");
		var roomObjects = message.roomobjects;
		for (let i=0; i<roomObjects.length; i++) {
			var newObject = document.createElement("p");
			newObject.setAttribute("id", "roomObject_" + roomObjects[i].pkid);
			newObject.setAttribute("data-tooltip", roomObjects[i].longname);
			var newPKID = document.createElement("span");
			newPKID.setAttribute("class", "roomobjectpkid");
			newPKID.style.display = "none";
			newPKID.innerText = roomObjects[i].pkid;
			newObject.appendChild(newPKID);
			var newDesc = document.createElement("span");
			newDesc.setAttribute("class", "roomobjectdesc");
			newDesc.innerText = roomObjects[i].description;
			newObject.appendChild(newDesc);
			currentobjects.appendChild(newObject);
			document.getElementById("roomObject_" + roomObjects[i].pkid).addEventListener("mousedown", function() {
				sendAction(roomObjects[i].action);
			});			
		}
	}
}

function updateRoomExits(messageBody) {
    var currentexits = document.getElementById("currentroomexits");
    while (currentexits.hasChildNodes()) {
        currentexits.removeChild(currentexits.firstChild);
    }
    var roomexits = messageBody.roomexits;
    for (let i = 0; i < roomexits.length; i++) {
        let exitpkid = roomexits[i].room2pkid;
        let exitname = roomexits[i].title;
        let exitx = roomexits[i].x;
        let exity = roomexits[i].y;
        let exitz = roomexits[i].z;
        let originx = roomexits[i].originx;
        let originy = roomexits[i].originy;
        let originz = roomexits[i].originz;
        let exitdirection = checkExitDirection(originx, originy, originz, exitx, exity, exitz);
        let newExit = document.createElement("p");
        let newExitDir = document.createElement("span");
        newExitDir.setAttribute("class", "roomexitdir");
        newExitDir.innerHTML = exitdirection;
        newExit.appendChild(newExitDir);
        let newExitName = document.createElement("span");
        newExitName.setAttribute("class", "roomexitname");
        newExitName.innerHTML = exitname;
        newExit.appendChild(newExitName);
        let newExitPKID = document.createElement("span");
		if (document.getElementById("modoption_roomid").checked == false) {
			newExitPKID.setAttribute("class", "option_disabled");
		}
		else {
			newExitPKID.setAttribute("class", "roomexitpkid");
		}
        newExitPKID.innerHTML = "(" + exitpkid + ")";
        newExit.appendChild(newExitPKID);
        newExit.setAttribute("id", "exit_" + exitdirection);
        currentexits.appendChild(newExit);
        document.getElementById("exit_" + exitdirection).addEventListener("click", function () {
            moveRoom(exitdirection);
        });
    }

}

function updateMap(messageBody) {
    var currentmapdata = document.getElementById("mapgrid");
    while (currentmapdata.hasChildNodes()) {
        currentmapdata.removeChild(currentmapdata.firstChild);
    }
    var newmapdata = messageBody.mapdata;
    for (let y = -5; y < 6; y++) {
        for (let x = -5; x < 6; x++) {
            var newTile = document.createElement("span");
            newTile.setAttribute("x", x);
            newTile.setAttribute("y", y);
            for (const i of newmapdata) {
                if (i.originx == x && i.originy == y) {
                    newTile.setAttribute("x", i.originx);
                    newTile.setAttribute("y", i.originy);
                    newTile.setAttribute("pkid", i.originpkid);
                    newTile.innerHTML = "";
                    newTile.style.color = "white";
				//	newTile.style.backgroundImage = "linear-gradient(" + i.originbgcolor + ", " + i.originbgcolor + ")";
					newTile.style.backgroundColor = i.originbgcolor;
                } else if (i.newx == x && i.newy == y) {
                    newTile.setAttribute("x", i.newx);
                    newTile.setAttribute("y", i.newy);
                    newTile.setAttribute("pkid", i.newpkid);
                    newTile.innerHTML = i.maptileicon;
                    newTile.style.color = i.maptileiconcolor;
                    newTile.style.backgroundColor = i.maptilebgcolor;
				//	newTile.style.backgroundImage = "linear-gradient(" + i.maptilebgcolor + ", " + i.maptilebgcolor + ")";
					newTile.style.boxShadow = "0 0 7px 1px " + i.maptilebgcolor.replace(',1)', ',0.9)') + "";
                } else {
				}
            }
            currentmapdata.appendChild(newTile);
        }
    }
}

function checkExitDirection(originx, originy, originz, exitx, exity, exitz) {
    if (originx == exitx && originy == exity) {
        if (exitz > originz) {
            return "Down";
        } else if (exitz < originz) {
            return "Up";
        } else {
            console.error("There was an error.");
        }
    } else if (originx == exitx && originz == exitz) {
        if (exity > originy) {
            return "South";
        } else if (exity < originy) {
            return "North";
        } else {
            console.error("There was an error.");
        }
    } else if (originy == exity && originz == exitz) {
        if (exitx > originx) {
            return "East";
        } else if (exitx < originx) {
            return "West";
        } else {
            console.error("There was an error.");
        }
    }
}

var logbox = document.getElementById("log");
var localchatbox = document.getElementById("localchat");
var globalchatbox = document.getElementById("globalchat");
var logbutton = document.getElementById("syslog_button");
var localbutton = document.getElementById("localchat_button");
var globalbutton = document.getElementById("globalchat_button");

logbutton.addEventListener("click", function () {
    logbox.style.display = "block";
    localchatbox.style.display = "none";
    globalchatbox.style.display = "none";
    logbutton.setAttribute("class", "selected");
    localbutton.removeAttribute("class");
    globalbutton.removeAttribute("class");
});

localbutton.addEventListener("click", function () {
    logbox.style.display = "none";
    localchatbox.style.display = "block";
    globalchatbox.style.display = "none";
    logbutton.removeAttribute("class");
    localbutton.setAttribute("class", "selected");
    globalbutton.removeAttribute("class");
});

globalbutton.addEventListener("click", function () {
    logbox.style.display = "none";
    localchatbox.style.display = "none";
    globalchatbox.style.display = "block";
    logbutton.removeAttribute("class");
    localbutton.removeAttribute("class");
    globalbutton.setAttribute("class", "selected");
});

var charinfobox = document.getElementById("char_info");
var charinvbox = document.getElementById("char_inventory");
var charskillsbox = document.getElementById("char_skills");
var charsocialbox = document.getElementById("char_social");
var charjournalbox = document.getElementById("char_journal");

var charinfobutton = document.getElementById("charinfo_button");
var charinvbutton = document.getElementById("inventory_button");
var charskillsbutton = document.getElementById("skills_button");
var charsocialbutton = document.getElementById("social_button");
var charjournalbutton = document.getElementById("journal_button");
charinfobox.style.display = "block";

charinfobutton.addEventListener("click", function () {
    charinfobox.style.display = "block";
    charinvbox.style.display = "none";
    charskillsbox.style.display = "none";
    charsocialbox.style.display = "none";
    charjournalbox.style.display = "none";
    charinfobutton.setAttribute("class", "selected");
    charinvbutton.removeAttribute("class");
    charskillsbutton.removeAttribute("class");
    charsocialbutton.removeAttribute("class");
    charjournalbutton.removeAttribute("class");
});

charinvbutton.addEventListener("click", function () {
    charinfobox.style.display = "none";
    charinvbox.style.display = "block";
    charskillsbox.style.display = "none";
    charsocialbox.style.display = "none";
    charjournalbox.style.display = "none";
    charinfobutton.removeAttribute("class");
    charinvbutton.setAttribute("class", "selected");
    charskillsbutton.removeAttribute("class");
    charsocialbutton.removeAttribute("class");
    charjournalbutton.removeAttribute("class");
});

charskillsbutton.addEventListener("click", function () {
    charinfobox.style.display = "none";
    charinvbox.style.display = "none";
    charskillsbox.style.display = "block";
    charsocialbox.style.display = "none";
    charjournalbox.style.display = "none";
    charinfobutton.removeAttribute("class");
    charinvbutton.removeAttribute("class");
    charskillsbutton.setAttribute("class", "selected");
    charsocialbutton.removeAttribute("class");
    charjournalbutton.removeAttribute("class");
});

charsocialbutton.addEventListener("click", function () {
    charinfobox.style.display = "none";
    charinvbox.style.display = "none";
    charskillsbox.style.display = "none";
    charsocialbox.style.display = "block";
    charjournalbox.style.display = "none";
    charinfobutton.removeAttribute("class");
    charinvbutton.removeAttribute("class");
    charskillsbutton.removeAttribute("class");
    charsocialbutton.setAttribute("class", "selected");
    charjournalbutton.removeAttribute("class");
});

charjournalbutton.addEventListener("click", function () {
    charinfobox.style.display = "none";
    charinvbox.style.display = "none";
    charskillsbox.style.display = "none";
    charsocialbox.style.display = "none";
    charjournalbox.style.display = "block";
    charinfobutton.removeAttribute("class");
    charinvbutton.removeAttribute("class");
    charskillsbutton.removeAttribute("class");
    charsocialbutton.removeAttribute("class");
    charjournalbutton.setAttribute("class", "selected");
});

document.getElementById("sendbutton").onmousedown = function () {
    if (localchatbox.style.display == "block") {
        var sendInput = "say " + document.getElementById("input").value;
    } else if (globalchatbox.style.display == "block") {
        var sendInput = "gsay " + document.getElementById("input").value;
    } else {
        var sendInput = document.getElementById("input").value;
    }
    const messageBody = JSON.stringify({
        "command": sendInput
    });
    socket.emit("data", messageBody);
    document.getElementById("input").value = "";
}
const inputbox = document.getElementById("input");
inputbox.addEventListener('keydown', function onEvent(e) {
    if (e.keyCode === 13) {
        if (localchatbox.style.display == "block") {
            var sendInput = "say " + document.getElementById("input").value;
        } else if (globalchatbox.style.display == "block") {
            var sendInput = "gsay " + document.getElementById("input").value;
        } else {
            var sendInput = document.getElementById("input").value;
        }
        const messageBody = JSON.stringify({
            "command": sendInput
        });
        socket.emit("data", messageBody);
        document.getElementById("input").value = "";
    }

})