const http = require('http');
const sockjs = require('sockjs');
var mysql = require('mysql');
var con = mysql.createConnection({
	host: "localhost",
	user: "mudserver",
	password: "mudserver",
	database: "umudserver"
});
const wss = sockjs.createServer();
const clients = new Map();

var py = 1;

wss.on('connection', (ws) => {
    console.log("connected");
	
    const id = uuidv4();
    const color = Math.floor(Math.random() * 360);
	const name = "Player" + py;
	const roomid = 1;
	const x = 0;
	const y = 0;
	const z = 0;
    const metadata = { id, color, name, roomid, x, y, z };

    clients.set(ws, metadata);
	py += 1;

    ws.on('data', (messageAsString) => {
      const message = JSON.parse(messageAsString);
      const metadata = clients.get(ws);

      //ws.write(outbound);
	  //broadcast(outbound);
	  cmdParse(message.command, metadata, ws);
	  
    });

    ws.on("close", () => {
      clients.delete(ws);
    });
});

function uuidv4() {
  return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function(c) {
    var r = Math.random() * 16 | 0, v = c == 'x' ? r : (r & 0x3 | 0x8);
    return v.toString(16);
  });
}

function broadcast(message) {
	 [...clients.keys()].forEach((client) => {
        client.write(message);
      });
};

function servermsg(message, metadata, ws) {
	
	ws.write(message);
};

function queueOutput(message, metadata, ws) {
	ws.write(message);
}

function getRoomData(pkid, metadata, ws) {
	con.query("SELECT * FROM regions_rooms WHERE PKID = " + pkid, (err, result) => {
		if (err) {
			return console.error(err.message);
		}
		const dataoutput = JSON.stringify({ "roomdata": result[0] });
		queueOutput(dataoutput, metadata, ws);
	});
	con.query("SELECT RL.*, RM.*, RMO.x AS originx, RMO.y AS originy, RMO.z AS originz FROM regions_rooms_links AS RL INNER JOIN regions_rooms RM ON RM.pkid = RL.room2pkid INNER JOIN regions_rooms RMO ON RMO.pkid = RL.room1pkid WHERE room1pkid = " + pkid + " ORDER BY RM.y ASC", (err, result) => {
		if (err) {
			return console.error(err.message);
		}
		const dataoutput = JSON.stringify({ "roomexits": result });
		queueOutput(dataoutput, metadata, ws);
	});
	con.query("SELECT DISTINCT RO.x AS originx, RO.y AS originy, RO.z AS originz, RL.x AS newx, RL.y AS newy, RL.z AS newz, RL.maptileicon, RL.maptileiconcolor, RL.maptilebgcolor, RO.pkid AS originpkid, RL.pkid AS newpkid, RO.maptileicon AS originicon, RO.maptileiconcolor AS origincolor, RO.maptilebgcolor AS originbgcolor FROM regions_rooms RL INNER JOIN regions_rooms RO ON RO.pkid = " + pkid + " WHERE RL.x BETWEEN (RO.x - 5) AND (RO.x + 5) AND RL.y BETWEEN (RO.y - 5) AND (RO.y + 5) AND RL.z = RO.z ORDER BY RL.x ASC, RL.y ASC, RL.z ASC", (err, result) => {
		if (err) {
			return console.error(err.message);
		}
		const dataoutput = JSON.stringify({ "mapdata": result });
		queueOutput(dataoutput, metadata, ws);
	});
}

function moveToRoom(x, y, z, metadata, ws) {
	con.query("SELECT * FROM regions_rooms_links RRL INNER JOIN regions_rooms RM ON RM.pkid = RRL.room2pkid WHERE room1pkid = " + metadata.roomid + " AND RM.x = " + x + " AND RM.y = " + y + " AND RM.z = " + z, (err, result) => {
		if (err) {
			return console.error(err.message);
		}
		if (result.length === 1) {
			const dataoutput = JSON.stringify({ "moveresult": "success", "newpkid": result[0].room2pkid });
			getRoomData(result[0].room2pkid, metadata, ws);
			metadata.roomid = result[0].room2pkid;
			metadata.x = x;
			metadata.y = y;
			metadata.z = z;
			queueOutput(dataoutput, metadata, ws);
		}
		else {
			var output = { "console": "You can't move that direction!" };
			servermsg(JSON.stringify(output), metadata, ws);
		}
	});
	
};

function cmdParse(command, metadata, ws) {
	const text = command;
	const cmdArray = text.split(" ");
	var serveroutput;
	if (cmdArray.length > 1) {
		switch(cmdArray[0]) {
		case "say":
			const outboundsay = JSON.stringify({ "console": "<" + metadata.name + ">:  " + command.substr(4)});
			broadcast(outboundsay);
			break;
		default:
			serveroutput = "Command Not Found";
		};
	}
	else {
		switch(text) {
			case "look":
				getRoomData(metadata.roomid, metadata, ws);
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
	if (typeof serveroutput === "undefined") {
		
	} else {
		const newoutput = JSON.stringify({ console: serveroutput });
		servermsg(newoutput, metadata, ws);
	}
	
};

const server = http.createServer();
wss.installHandlers(server, {prefix: '/ws'});
server.listen(7071, '0.0.0.0');

console.log("wss up");


