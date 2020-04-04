var db = require("../db");

// export routes so that they can be imported in the server.js
module.exports = {
    // GET endpoint 
  showAll: (req, res) => {

    let sql = "SELECT * FROM Listing";
    db.query(sql, (err, results) => {
      if (err) throw err;
      console.log(results);

      let testVar = [];

      results.forEach(res => {
        testVar.push(res);
      });

      // To be used in the .ejs
      const sampleResponse = {
        listings: testVar
      };

      res.render("./pages/listings", sampleResponse);
    });
  }
};
