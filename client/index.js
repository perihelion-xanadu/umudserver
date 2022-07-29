
import {
    io
}
from "socket.io-client";

const socket = io("http://192.168.0.110:3000");

var socketId;

socket.on("connect", () => {
    sendToConsole('You connected with id: ' + socket.id);
    socket.emit("data", JSON.stringify({
            "command": "look"
        }));
    socketId = socket.id;
})

socket.on("data", message => {
    const test = JSON.parse(message);
    for (let i in test) {
        if (i == "roomdata")
            updateRoomData(test)
		else if (i == "roomexits")
                updateRoomExits(test)
			else if (i == "mapdata")
                    updateMap(test);
                else if (i == "whodata")
                    updateWho(test);
    }
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
        newtag.innerHTML = "";
        newwho.appendChild(newtag);
        var newname = document.createElement("span");
        newname.setAttribute("class", "whoplayername");
        newname.innerHTML = message.whodata[i];
        newwho.appendChild(newname);
        var newtitle = document.createElement("span");
        newtitle.setAttribute("class", "whoplayertitle");
        newtitle.innerText = "<Unregistered Player>";
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
        let newExit = document.createElement("tr");
        let newExitDir = document.createElement("td");
        newExitDir.setAttribute("class", "roomexitdir");
        newExitDir.innerHTML = exitdirection;
        newExit.appendChild(newExitDir);
        let newExitName = document.createElement("td");
        newExitName.setAttribute("class", "roomexitname");
        newExitName.innerHTML = exitname;
        newExit.appendChild(newExitName);
        let newExitPKID = document.createElement("td");
        newExitPKID.setAttribute("class", "roomexitpkid");
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
    var currentmapdata = document.getElementById("maptable");
    while (currentmapdata.hasChildNodes()) {
        currentmapdata.removeChild(currentmapdata.firstChild);
    }
    var newmapdata = messageBody.mapdata;
    for (let y = -5; y < 6; y++) {
        var newRow = document.createElement("tr");
        for (let x = -5; x < 6; x++) {
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
                } else if (i.newx == x && i.newy == y) {
                    newTile.setAttribute("x", i.newx);
                    newTile.setAttribute("y", i.newy);
                    newTile.setAttribute("pkid", i.newpkid);
                    newTile.innerHTML = i.maptileicon;
                    newTile.style.color = i.maptileiconcolor;
                    newTile.style.backgroundColor = i.maptilebgcolor;
                } else {}
            }
            newRow.appendChild(newTile);
        }
        currentmapdata.appendChild(newRow);
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
