var db = require("../db");

// export routes so that they can be imported in the server.js
module.exports = {
  // POST: Add a new user
  addNewUser: (req, res) => {
    let query =
      "INSERT INTO User (userName, userAbout, userType, userPassword) VALUES ('" +
      req.body.signupUserName +
      "','" +
      req.body.about +
      "','" +
      req.body.type +
      "','" +
      req.body.psw +
      "');";

    db.query(query, (err, result) => {
        if (err) {
            res.redirect("/signup");
        }
    });

    res.redirect("/login");
  }
};