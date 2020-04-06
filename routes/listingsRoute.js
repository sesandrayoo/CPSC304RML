var db = require("../db");
const connection = require('../db.js');

// // export routes so that they can be imported in the server.js
// module.exports = {
//   // GET endpoint 
//   showListings: (request, response) => {
//       connection.query('SELECT * FROM listing', 
//       function(error, results, fields) {
//           response.render('./pages/Listings', { listings: results });
//       });
//   }
// };
