const fs = require('fs');
var rawservercfg = fs.readFileSync('server.cfg');
var servercfg = JSON.parse(rawservercfg); 

// Admin panel

const {
    instrument
} = require('@socket.io/admin-ui');

const io = require("socket.io")(servercfg.server_port, {
    cors: {
        origin: ["http://localhost:8080", "https://admin.socket.io", "http://192.168.0.110:8080", "http://megatron:8080"],
    },
})

const mysql = require('mysql');
const util = require('util');
const con = mysql.createConnection({
	host: servercfg.server_backend_mysql_host,
    user: servercfg.server_backend_mysql_username,
    password: servercfg.server_backend_mysql_password,
    database: servercfg.server_backend_mysql_dbo
});

const query = util.promisify(con.query).bind(con);

const clients = new Map();
var py = 1;

var actionList = new Array();
(async () => {
	try {
		const rows = await query("SELECT * FROM `umudserver`.`actions` ORDER BY categoryid ASC");
		if (rows.length == 0) {
			return false;
		}
		else {
			for (let i=0; i<rows.length; i++) {
				actionList.push(rows[i]);
			}
		}
	} finally {

	}
})();


io.on("connection", socket => {
    console.log("connected");
    const name = "Unregistered Player " + py;
    const roomid = 1;
    const x = 0;
    const y = 0;
    const z = 0;
	const title = "Unregistered User";
	const tag = "";
	const pkid = -1;
    socket.data.name = name;
    socket.data.roomid = roomid;
    socket.data.x = x;
    socket.data.y = y;
    socket.data.z = z;
	socket.data.title = title;
	socket.data.tag = tag;
	socket.data.pkid = pkid;
	
	socket.emit("serverlog", JSON.stringify({
		"console": "server is connected"
	}));
    const metadata = {
        name,
        roomid,
        x,
        y,
        z,
		title,
		tag,
		pkid
    };

    clients.set(socket, metadata);
	
    py += 1;
    socket.join("room_" + metadata.roomid);
    socket.join("global");
    socket.on("data", messageAsString => {
        const message = JSON.parse(messageAsString);
        const metadata = clients.get(socket);
        cmdParse(message.command, metadata, socket);
    });
    socket.on("disconnect", (reason) => {
        console.log("client disconnected due to " + reason);
        updateRoom();
    })

    socket.on("close", () => {
        console.log("client disconnected");
        clients.delete(socket);
        updateRoom();
    });
	
	socket.on("validateInput", async (type, name, callback) => {
		var result = "";
		switch(type) {
			case "playername":
				result = await validatePlayerName(name);
				break;
			case "charactername":
				result = await validateCharacterName(name);
				break;
			default:
				break;
		}
		callback(result);
	})
    updateRoom();
})

async function validateCharacterName(name) {
	try {
		const rows = await query("SELECT * FROM characters WHERE name = '" + name + "'");
		if (rows.length == 0) {
			return true;
		}
		else return false;
	} finally {
		
	}
}

async function validatePlayerName(name) {
	try {
		const rows = await query("SELECT * FROM players WHERE name = '" + name + "'");
		if (rows.length == 0) {
			return true;
		}
		else return false;
	} finally {
		
	}
}

async function loginCharacter(name, metadata, ws) {
	const player = new Object();
	try {
		const rows = await query("SELECT * FROM characters WHERE name = '" + name + "'");
		player.name = rows[0].name;
		player.tag = rows[0].tag;
		player.title = rows[0].title;
		player.pkid = rows[0].pkid;
		player.roomid = rows[0].currentroompkid;
	} finally {
		metadata.name = player.name;
		metadata.roomid = player.roomid;
		metadata.title = player.title;
		metadata.tag = player.tag;
		metadata.pkid = player.pkid;
		charData2(player, metadata, ws);
	}
}

async function charData2(player, metadata, ws) {
	try {
		const rows = await query("SELECT * FROM regions_rooms WHERE pkid = " + player.roomid);
		player.x = rows[0].x;
		player.y = rows[0].y;
		player.z = rows[0].z;
	} finally {
		metadata.x = player.x;
		metadata.y = player.y;
		metadata.z = player.z;
		ws.data = player;
		ws.emit("loggedIn", player);
		clients.set(ws, player);
		roomData(player.roomid, metadata, ws);
		ws.join("room_" + metadata.roomid);
	}
}

async function updateCharacterRoom(metadata, ws) {
	try {
		const rows = await query("UPDATE characters SET currentroompkid = " + metadata.roomid + " WHERE name = '" + metadata.name + "'");
	} finally {
		console.log("Character " + metadata.name + " updated.");
	}
}

function servermsg(message, metadata, socket) {
    socket.emit("serverlog", message);
};

function queueOutput(message, metadata, socket) {
    socket.emit("data", message);
}

async function updateRoom() {
    const sockets = await io.fetchSockets();
    for (let x = 0; x < sockets.length; x++) {
        sockets[x].emit("whochanged");
		sockets[x].emit("playerinfo", sockets[x].data);
    }
}

async function getWhoData(metadata, ws) {
    const sockets = await io.in("room_" + metadata.roomid).fetchSockets();
    var whoaround = [];
    var y = 0;
    for (let x = 0; x < sockets.length; x++) {
		whoaround[y] = {};
        whoaround[y]['name'] = sockets[x].data.name;
		whoaround[y]['tag'] = sockets[x].data.tag;
		whoaround[y]['title'] = sockets[x].data.title;
        if (sockets[x].id == ws.id)
            whoaround[y]['name'] += " (You)";
        y++;
    }
    var dataoutput = JSON.stringify({
        "whodata": whoaround
    });
    queueOutput(dataoutput, metadata, ws);
}

async function roomData(pkid, metadata, ws) {
	try {
		const rows = await query("SELECT * FROM regions_rooms WHERE PKID = " + pkid);
        const dataoutput = JSON.stringify({
            "roomdata": rows[0]
        });
        queueOutput(dataoutput, metadata, ws);
	} finally {
		roomExits(pkid, metadata, ws);
		roomObjects(metadata, ws);
	}
}

async function roomObjects(metadata, ws) {
	try {
		const rows = await query("SELECT * FROM resources_worldobjects WHERE roomid = " + metadata.roomid);
		const dataoutput = JSON.stringify({
			"roomobjects": rows
		});
		queueOutput(dataoutput, metadata, ws);
	} finally {
		
	}
}

async function roomExits(pkid, metadata, ws) {
	try {
		const rows = await query("SELECT RL.*, RM.*, RMO.x AS originx, RMO.y AS originy, RMO.z AS originz FROM regions_rooms_links AS RL INNER JOIN regions_rooms RM ON RM.pkid = RL.room2pkid INNER JOIN regions_rooms RMO ON RMO.pkid = RL.room1pkid WHERE room1pkid = " + pkid + " ORDER BY RM.y ASC");
        const dataoutput = JSON.stringify({
            "roomexits": rows
        });
        queueOutput(dataoutput, metadata, ws);
	} finally {
		mapData(pkid, metadata, ws);
	}
}

async function mapData(pkid, metadata, ws) {
	try {
		const rows = await query("SELECT DISTINCT RO.x AS originx, RO.y AS originy, RO.z AS originz, RL.x AS newx, RL.y AS newy, RL.z AS newz, RL.maptileicon, RL.maptileiconcolor, RL.maptilebgcolor, RO.pkid AS originpkid, RL.pkid AS newpkid, RO.maptileicon AS originicon, RO.maptileiconcolor AS origincolor, RO.maptilebgcolor AS originbgcolor FROM regions_rooms RL INNER JOIN regions_rooms RO ON RO.pkid = " + pkid + " WHERE RL.x BETWEEN (RO.x - 5) AND (RO.x + 5) AND RL.y BETWEEN (RO.y - 5) AND (RO.y + 5) AND RL.z = RO.z ORDER BY RL.x ASC, RL.y ASC, RL.z ASC");
        const dataoutput = JSON.stringify({
            "mapdata": rows
        });
        queueOutput(dataoutput, metadata, ws);
	} finally {
		getWhoData(metadata, ws);
	}
}

async function moveToRoom(x, y, z, metadata, ws) {
	try {
		const rows = await query("SELECT * FROM regions_rooms_links RRL INNER JOIN regions_rooms RM ON RM.pkid = RRL.room2pkid WHERE room1pkid = " + metadata.roomid + " AND RM.x = " + x + " AND RM.y = " + y + " AND RM.z = " + z);
        if (rows.length === 1) {
            const dataoutput = JSON.stringify({
                "moveresult": "success",
                "newpkid": rows[0].room2pkid
            });
            roomData(rows[0].room2pkid, metadata, ws);
            metadata.roomid = rows[0].room2pkid;
            metadata.x = x;
            metadata.y = y;
            metadata.z = z;
            queueOutput(dataoutput, metadata, ws);
            ws.leave("room_" + rows[0].room1pkid);
            ws.join("room_" + metadata.roomid);
            getWhoData(metadata, ws);
            ws.to("room_" + rows[0].room1pkid).emit("whochanged");
            ws.to("room_" + rows[0].room2pkid).emit("whochanged");
			clients.set(ws, metadata);
			if (metadata.name.includes("Unregistered")) {
				
			} else { updateCharacterRoom(metadata, ws); }
        } else {
            var output = JSON.stringify({
                "console": "You can't move that direction!"
            });
            servermsg(output, metadata, ws);
        }
    } finally {
		
	}
}

function startPlayerRegister(metadata, ws) {
	if (metadata.pkid === -1) {
		ws.emit("event", "startPlayerRegister");
	}
	else {
		ws.emit("event", "Something went wrong!");
	}
}

async function cmdParse(command, metadata, ws) {
    const text = command;
    const cmdArray = text.split(" ");
    var serveroutput;
    if (cmdArray.length > 1) {
        switch (cmdArray[0]) {
        case "say":
            const outboundsay = JSON.stringify({
                "console": "[" + metadata.name + "]:  " + text.substr(4)
            });
            ws.to("room_" + metadata.roomid).emit("locallog", outboundsay);
            const sayback = JSON.stringify({
                "console": "[You]: " + text.substr(4)
            });
            ws.emit("locallog", sayback);
            break;
        case "gsay":
            const outboundgsay = JSON.stringify({
                "console": "[" + metadata.name + "]:  " + text.substr(5)
            });
            ws.to("global").emit("globallog", outboundgsay);
            const gsayback = JSON.stringify({
                "console": "[You]: " + text.substr(4)
            });
            ws.emit("globallog", gsayback);
            break;
		case "login":
			if (cmdArray[1] != "" && cmdArray[1] != undefined) {
				var name = cmdArray[1];
				loginCharacter(name, metadata, ws);
			}
			break;
        default:
            serveroutput = "Command Not Found";
            break;
        };
    } else {
        switch (text.toLowerCase()) {
        case "getwhodata":
            getWhoData(metadata, ws);
            break;
		case "registerstart":
			startPlayerRegister(metadata, ws);
			break;
        case "look":
		case "l":
            roomData(metadata.roomid, metadata, ws);
            break;
        case "n":
        case "north":
            var newx = metadata.x;
            var newy = metadata.y - 1;
            var newz = metadata.z;
            moveToRoom(newx, newy, newz, metadata, ws);
            break;
        case "e":
        case "east":
            var newx = metadata.x + 1;
            var newy = metadata.y;
            var newz = metadata.z;
            moveToRoom(newx, newy, newz, metadata, ws);
            break;
        case "s":
        case "south":
            var newx = metadata.x;
            var newy = metadata.y + 1;
            var newz = metadata.z;
            moveToRoom(newx, newy, newz, metadata, ws);
            break;
        case "w":
        case "west":
            var newx = metadata.x - 1;
            var newy = metadata.y;
            var newz = metadata.z;
            moveToRoom(newx, newy, newz, metadata, ws);
            break;
        case "u":
        case "up":
            var newx = metadata.x;
            var newy = metadata.y;
            var newz = metadata.z - 1;
            moveToRoom(newx, newy, newz, metadata, ws);
            break;
        case "d":
        case "down":
            var newx = metadata.x;
            var newy = metadata.y;
            var newz = metadata.z + 1;
            moveToRoom(newx, newy, newz, metadata, ws);
            break;
        default:
            serveroutput = "Command Not Found";
        };
    }
    if (typeof serveroutput === "undefined") {}
    else {
        const newoutput = JSON.stringify({
            "console": serveroutput
        });
        servermsg(newoutput, metadata, ws);
    }

};

console.log("wss up");

instrument(io, {
    auth: false
});
