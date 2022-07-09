var mysql = require('mysql');

exports.con = mysql.createConnection({
	host: "localhost",
	user: "mudserver",
	password: "mudserver"
});



