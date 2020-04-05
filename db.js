const mysql = require('mysql');

// Create connection
const connection = mysql.createConnection({
    host     : 'localhost',
    user     : 'root',
<<<<<<< HEAD
    password : 'Mtb16574',
    database : 'RateMyLandlord',
    multipleStatements: true
=======
    password : '',
    database : 'RateMyLandlord'
>>>>>>> d3a1c2c46ff55f6b4c14907fa4e4fabd149b5889
});

// Connect to the MySQL Database
connection.connect((err) => {
    if(err){
        throw err;
    }
    console.log('MySql Connected...');
});

// comment
module.exports = connection;