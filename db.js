const mysql = require('mysql');

// Create connection
const connection = mysql.createConnection({
    host     : 'localhost',
    user     : 'root',
    password : 'Mtb16574',
    database : 'RateMyLandlord'
});

// Connect to the MySQL Database
connection.connect((err) => {
    if(err){
        throw err;
    }
    console.log('MySql Connected...');
});

module.exports = connection;