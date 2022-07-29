// Server variables //
var servername = "Demo Server";


// comments go here
const serverstart = new Date();
console.log(servername + " started at " + serverstart);

var mysql = require('mysql');
var events = require('events');
var eventEmitter = new events.EventEmitter();
var api = require('./script');

var con = mysql.createConnection({
	host: "localhost",
	user: "mudserver",
	password: "mudserver",
	database: "umudserver"
});
	
con.connect(function(err) {
	if (err) throw err;
	var sql = "SELECT version() AS v;";
	con.query(sql, function (err, result, fields) {
		if (err) throw err;
		console.log("Database loaded.  Running MySQL version " + result[0].v);
		});
});