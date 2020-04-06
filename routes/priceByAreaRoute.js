var db = require("../db");
const connection = require('../db.js');

// export routes so that they can be imported in the server.js
module.exports = {
    // GET endpoint 
  showAvgPrice: (request, response) => {
    connection.query('select listingArea, avg(listingPrice) as avgPrice from listing GROUP BY listingArea;', 
    function(error, results, fields) {
      response.render('./pages/priceByArea', { avgPrices: results });
    });
  }
};