// TBH not sure why I need to reimport the database, but I do apparently...
var db = require("../db");

// export routes so that they can be imported in the server.js
module.exports = {
  // POST endpoint
  createProfile: (req, res) => {

    let currentUserName='NotARealUser';
    
    if(req.session.loggedin){
      currentUserName=req.session.username;
    } 

    if (req.body.address != "") {

      let sql = `

      INSERT INTO Municipality
      (propertyPostal, propertyCity)
      VALUES('${req.body.postalcode}', '${req.body.city}');

      INSERT INTO PropertyLocation
      VALUES('${req.body.address}', '${req.body.postalcode}');
      
      
      INSERT INTO Property 
        (propertyStreetAddress, propertyDescription, propertyType)
            VALUES('${req.body.address}', '${req.body.description}','${req.body.type}');
            

        INSERT INTO LandlordProfile 
        (profileName, profileCity, userID) 
        VALUES('${req.body.name}', '${req.body.city}', (SELECT userID from User WHERE userName='${currentUserName}'));

        INSERT INTO Owns VALUES ((SELECT profileID FROM LandlordProfile
          WHERE profileName='${req.body.name}' LIMIT 1), (SELECT propertyID FROM Property
          WHERE propertyStreetAddress='${req.body.address}' LIMIT 1));
          `;

      db.query(sql, [1, 2, 3, 4], (err, result) => {
        if (err) {
          res.redirect("/");
        }
      });
    } else {
      // TODO: CHANGE THE USERID TO BE DYNAMIC
      let sql = `INSERT INTO LandlordProfile 
            (profileName, profileCity, userID) 
            VALUES('${req.body.name}', '${req.body.city}', 3);`;

      db.query(sql, (err, result) => {
        if (err) {
          res.redirect("/");
        }
      });
    }

    const searchResults = {
      values: "Landlord profile"
    };

    res.render("./pages/success", searchResults);
  }
};
