(async function() {

    const ws = await connectToServer();    
	
	document.body.onload = setTimeout(function () {
		ws.send(JSON.stringify({ "command": "look" }));
	}, 1000);
	
	document.getElementById("sendbutton").onmousedown = function() {
		const sendInput = document.getElementById("input").value;
		const messageBody = { command: sendInput };
		ws.send(JSON.stringify(messageBody));
		document.getElementById("input").value = "";
	};
	const inputbox = document.getElementById("input");
	inputbox.addEventListener('keydown', function onEvent(e)  {
		if (e.keyCode === 13) {
			const sendInput = document.getElementById("input").value;
			const messageBody = { command: sendInput };
			ws.send(JSON.stringify(messageBody));
			document.getElementById("input").value = "";
		};
		
	});

    ws.onmessage = (webSocketMessage) => {
        var messageBody = JSON.parse(webSocketMessage.data);
		if (typeof messageBody.console != "undefined") {
			sendToConsole(messageBody);
		}
		else if (typeof messageBody.roomdata != "undefined") {
			updateRoomData(messageBody);
		}
		else if (typeof messageBody.roomexits != "undefined") {
			updateRoomExits(messageBody);
		}
		else if (typeof messageBody.mapdata != "undefined") {
			updateMap(messageBody);
		}
    };
        
    async function connectToServer() {    
        const ws = new SockJS('http://localhost:7071/ws');
        return new Promise((resolve, reject) => {
            const timer = setInterval(() => {
                if(ws.readyState === 1) {
                    clearInterval(timer);
                    resolve(ws);
                }
            }, 10);
        });   
    }

   async function sendToConsole(messageBody) {
		const newBody = messageBody.console;
		const log = document.getElementById("log");
		const para = document.createElement("p");
		const d = new Date();
		let diff = d.getTimezoneOffset();
		d.setHours(d.getHours() - (diff / 60));
		let ts = d.toISOString();
		const newLine = "<span class='date'>" + ts.substring(0, ts.indexOf("T")) + "</span> <span class='time'>" + ts.substr(ts.indexOf("T")+1) + "</span> <span class='message'>" + newBody + "</span>";
		para.innerHTML = newLine;
		log.appendChild(para);
   };
	async function updateRoomData(messageBody) {
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
	};
	
	function updateRoomExits(messageBody) {
		var currentexits = document.getElementById("currentroomexits");
		while (currentexits.hasChildNodes()) {
			currentexits.removeChild(currentexits.firstChild);
		}
		var roomexits = messageBody.roomexits;
		for (let i=0; i<roomexits.length; i++) {
			var exitpkid = roomexits[i].room2pkid;
			var exitname = roomexits[i].title;
			var exitx = roomexits[i].x;
			var exity = roomexits[i].y;
			var exitz = roomexits[i].z;
			var originx = roomexits[i].originx;
			var originy = roomexits[i].originy;
			var originz = roomexits[i].originz;
			var exitdirection = checkExitDirection(originx, originy, originz, exitx, exity, exitz);
			var newExit = document.createElement("tr");
			var newExitDir = document.createElement("td");
			newExitDir.setAttribute("class", "roomexitdir");
			newExitDir.innerHTML = exitdirection;
			newExit.appendChild(newExitDir);
			var newExitName = document.createElement("td");
			newExitName.setAttribute("class", "roomexitname");
			newExitName.innerHTML = exitname;
			newExit.appendChild(newExitName);
			var newExitPKID = document.createElement("td");
			newExitPKID.setAttribute("class", "roomexitpkid");
			newExitPKID.innerHTML = "(" + exitpkid + ")";
			newExit.appendChild(newExitPKID);
			currentexits.appendChild(newExit);
		}
		
	};
	
	function updateMap(messageBody) {
		var currentmapdata = document.getElementById("maptable");
		while (currentmapdata.hasChildNodes()) {
			currentmapdata.removeChild(currentmapdata.firstChild);
		}
		var newmapdata = messageBody.mapdata;
		for (let y=-5; y<6; y++) {
			var newRow = document.createElement("tr");
			for (let x=-5; x<6; x++) {
				var newTile = document.createElement("td");
				newTile.setAttribute("x", x);
				newTile.setAttribute("y", y);
				for (const i of newmapdata) {
					if (i.originx == x && i.originy == y) {
						newTile.setAttribute("x", i.originx);
						newTile.setAttribute("y", i.originy);
						newTile.setAttribute("pkid", i.originpkid);
						newTile.innerHTML = "&#9786;";
						newTile.style.color = "purple";
						newTile.style.backgroundColor = i.originbgcolor;
					}
					else if (i.newx == x && i.newy == y) {
						newTile.setAttribute("x", i.newx);
						newTile.setAttribute("y", i.newy);
						newTile.setAttribute("pkid", i.newpkid);
						newTile.innerHTML = i.maptileicon;
						newTile.style.color = i.maptileiconcolor;
						newTile.style.backgroundColor = i.maptilebgcolor;
					}
					else {
						
					}
				}
				newRow.appendChild(newTile);
			}
			currentmapdata.appendChild(newRow);
		}
	};
	
	function checkExitDirection(originx, originy, originz, exitx, exity, exitz) {
		if (originx == exitx && originy == exity) {
			if (exitz > originz) {
				return "&lsaquo;Down&rsaquo;";
			}
			else if (exitz < originz) {
				return "&lsaquo;Up&rsaquo;";
			}
			else {console.error("There was an error.");}
		}
		else if (originx == exitx && originz == exitz) {
			if (exity > originy) {
				return "&lsaquo;South&rsaquo;";
			}
			else if (exity < originy) {
				return "&lsaquo;North&rsaquo;";
			}
			else {console.error("There was an error.");}
		}
		else if (originy == exity && originz == exitz) {
			if (exitx > originx) {
				return "&lsaquo;East&rsaquo;";
			}
			else if (exitx < originx) {
				return "&lsaquo;West&rsaquo;";
			}
			else {console.error("There was an error.");}
		}
	};
})();


var logbox = document.getElementById("log");
var localchatbox = document.getElementById("localchat");
var globalchatbox = document.getElementById("globalchat");
var logbutton = document.getElementById("syslog_button");
var localbutton = document.getElementById("localchat_button");
var globalbutton = document.getElementById("globalchat_button");

logbutton.addEventListener("click", function() {
	logbox.style.display = "block";
	localchatbox.style.display = "none";
	globalchatbox.style.display = "none";
	logbutton.setAttribute("class", "selected");
	localbutton.removeAttribute("class");
	globalbutton.removeAttribute("class");
});

localbutton.addEventListener("click", function() {
	logbox.style.display = "none";
	localchatbox.style.display = "block";
	globalchatbox.style.display = "none";
	logbutton.removeAttribute("class");
	localbutton.setAttribute("class", "selected");
	globalbutton.removeAttribute("class");
});

globalbutton.addEventListener("click", function() {
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

charinfobutton.addEventListener("click", function() {
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

charinvbutton.addEventListener("click", function() {
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

charskillsbutton.addEventListener("click", function() {
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

charsocialbutton.addEventListener("click", function() {
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

charjournalbutton.addEventListener("click", function() {
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