// TBH not sure why I need to reimport the database, but I do apparently...
var db = require("../db");

// export routes so that they can be imported in the server.js
module.exports = {
  // GET endpoint 
  showAll: (req, res) => {

    let sql = "SELECT * FROM testTable";
    db.query(sql, (err, results) => {
      if (err) throw err;

      let testVar = [];

      results.forEach(res => {
        testVar.push(res);
      });

      // To be used in the .ejs
      const sampleResponse = {
        example: testVar
      };

      res.render("./pages/samplePage", sampleResponse);
    });
  },
  // POST: Add a new user
  addUser: (req, res) => {
    let query =
      "INSERT INTO testTable (firstName, lastName) VALUES ('" +
      req.body.fname +
      "','" +
      req.body.lname +
      "');";
    // query database to get all the players
    // when wrting a query, it's probably a good idea to console log it out to make sure you formatted it correctly before running it (saying this from frustrated experience ;)!)
    //console.log(query);
    //execute query
    db.query(query, (err, result) => {
      if (err) {
        res.redirect("/");
      }
    });

    // I redirect to the same page with the GET endpoint
    res.redirect("/samplePage");
  }
};
