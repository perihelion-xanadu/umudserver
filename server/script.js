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

var mysql = require('mysql');
var con = mysql.createConnection({
    host: servercfg.server_backend_mysql_host,
    user: servercfg.server_backend_mysql_username,
    password: servercfg.server_backend_mysql_password,
    database: servercfg.server_backend_mysql_dbo
});

const clients = new Map();

var py = 1;

io.on("connection", socket => {
    console.log("connected");
    const color = Math.floor(Math.random() * 360);
    const name = "Unregistered Player " + py;
    const roomid = 1;
    const x = 0;
    const y = 0;
    const z = 0;
    socket.data.name = name;
    socket.data.roomid = roomid;
    socket.data.x = x;
    socket.data.y = y;
    socket.data.z = z;
	socket.emit("serverlog", JSON.stringify({
		"console": "server is connected",
		"player": socket.data
	}));
    const metadata = {
        name,
        roomid,
        x,
        y,
        z
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
    updateRoom();
})

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
    }
}

async function getWhoData(metadata, ws) {
    const sockets = await io.in("room_" + metadata.roomid).fetchSockets();
    var whoaround = new Array();
    var y = 0;
    for (let x = 0; x < sockets.length; x++) {
        whoaround[y] = sockets[x].data.name;
        if (sockets[x].id == ws.id)
            whoaround[y] += " (You)";
        y++;
    }
    var dataoutput = JSON.stringify({
        "whodata": whoaround
    });
    queueOutput(dataoutput, metadata, ws);
}

function getRoomData(pkid, metadata, ws) {
    con.query("SELECT * FROM regions_rooms WHERE PKID = " + pkid, (err, result) => {
        if (err) {
            return console.error(err.message);
        }
        const dataoutput = JSON.stringify({
            "roomdata": result[0]
        });
        queueOutput(dataoutput, metadata, ws);
    });
    con.query("SELECT RL.*, RM.*, RMO.x AS originx, RMO.y AS originy, RMO.z AS originz FROM regions_rooms_links AS RL INNER JOIN regions_rooms RM ON RM.pkid = RL.room2pkid INNER JOIN regions_rooms RMO ON RMO.pkid = RL.room1pkid WHERE room1pkid = " + pkid + " ORDER BY RM.y ASC", (err, result) => {
        if (err) {
            return console.error(err.message);
        }
        const dataoutput = JSON.stringify({
            "roomexits": result
        });
        queueOutput(dataoutput, metadata, ws);
    });
    con.query("SELECT DISTINCT RO.x AS originx, RO.y AS originy, RO.z AS originz, RL.x AS newx, RL.y AS newy, RL.z AS newz, RL.maptileicon, RL.maptileiconcolor, RL.maptilebgcolor, RO.pkid AS originpkid, RL.pkid AS newpkid, RO.maptileicon AS originicon, RO.maptileiconcolor AS origincolor, RO.maptilebgcolor AS originbgcolor FROM regions_rooms RL INNER JOIN regions_rooms RO ON RO.pkid = " + pkid + " WHERE RL.x BETWEEN (RO.x - 5) AND (RO.x + 5) AND RL.y BETWEEN (RO.y - 5) AND (RO.y + 5) AND RL.z = RO.z ORDER BY RL.x ASC, RL.y ASC, RL.z ASC", (err, result) => {
        if (err) {
            return console.error(err.message);
        }
        const dataoutput = JSON.stringify({
            "mapdata": result
        });
        queueOutput(dataoutput, metadata, ws);
    });
    getWhoData(metadata, ws);
}

function moveToRoom(x, y, z, metadata, ws) {
    con.query("SELECT * FROM regions_rooms_links RRL INNER JOIN regions_rooms RM ON RM.pkid = RRL.room2pkid WHERE room1pkid = " + metadata.roomid + " AND RM.x = " + x + " AND RM.y = " + y + " AND RM.z = " + z, (err, result) => {
        if (err) {
            return console.error(err.message);
        }
        if (result.length === 1) {
            const dataoutput = JSON.stringify({
                "moveresult": "success",
                "newpkid": result[0].room2pkid
            });
            getRoomData(result[0].room2pkid, metadata, ws);
            metadata.roomid = result[0].room2pkid;
            metadata.x = x;
            metadata.y = y;
            metadata.z = z;
            queueOutput(dataoutput, metadata, ws);
            ws.leave("room_" + result[0].room1pkid);
            ws.join("room_" + metadata.roomid);
            getWhoData(metadata, ws);
            ws.to("room_" + result[0].room1pkid).emit("whochanged");
            ws.to("room_" + result[0].room2pkid).emit("whochanged");
        } else {
            var output = JSON.stringify({
                "console": "You can't move that direction!"
            });
            servermsg(output, metadata, ws);
        }
    });

};

function cmdParse(command, metadata, ws) {
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
        default:
            serveroutput = "Command Not Found";
            break;
        };
    } else {
        switch (text.toLowerCase()) {
        case "getwhodata":
            getWhoData(metadata, ws);
            break;
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
