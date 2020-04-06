// TBH not sure why I need to reimport the database, but I do apparently...
var db = require("../db");

// export routes so that they can be imported in the server.js
module.exports = {
  // GET endpoint 
  addReview: (req, res) => {
    const id = req.query.id;
    const name = req.query.name;
    const response = {
      ratingTotal: 5, // This is to show number of rating blocks on page
      landlordName: name
    }
    res.render('./pages/addReview', response)
  },
  // POST: Add a new user
  submitReview: (req, res) => {
    let currentUserName='NotARealUser';
    
    if(req.session.loggedin){
      currentUserName=req.session.username;
    } 
    

    let sql= `
    INSERT INTO Review 
		(userID, reviewText, starRating, profileID)  
    VALUES(
        (SELECT userID from User WHERE userName='${currentUserName}'), 
        '${req.body.reviewText}', 
        5, 
        (SELECT profileID from LandlordProfile WHERE profileName='${req.body.profileName}')
        );

    INSERT INTO Verification 
        (reviewID, adminID, verificationStatus, document) 
    VALUES(
        (SELECT reviewID FROM Review 
			WHERE reviewText='${req.body.reviewText}' 
            AND profileID=(SELECT profileID from LandlordProfile WHERE profileName='${req.body.profileName}')
		), 
        1, 
        0, 
        'contracts'
        );


    INSERT INTO Verification_Log 
        VALUES(
            (SELECT verificationID FROM Verification 
                WHERE reviewID=
					(SELECT reviewID FROM Review 
						WHERE userID=(SELECT userID from User WHERE userName='${currentUserName}') 
                        AND reviewText='${req.body.reviewText}' 
                        AND profileID=(SELECT profileID from LandlordProfile WHERE profileName='${req.body.profileName}')
					)
			), 
			CURDATE()
            );
    `;
      console.log(sql);

      db.query(sql, [1, 2, 3], (err, result) => {
        if (err) {
          res.redirect("/");
        }
      });

    // const searchResults = {
    //     values: "Review"
    //   };
  
    //   res.render("./pages/success", searchResults);
    res.json({success : "Updated Successfully", status : 200});
  }
};
