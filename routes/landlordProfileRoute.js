var db = require("../db");

// export routes so that they can be imported in the server.js
module.exports = {
  // get endpoint
  getLLP: (req, res) => {

    const id = req.query.id;
    let orderBy = req.query.orderBy || 'reviewDate';
    let sortOrder = 'DESC';
    
    if(orderBy === 'lowestRating'){
        sortOrder = 'ASC';
        orderBy = 'rating'
    } 
    const parsedId = parseInt(id, 10); // use this id

    let sql = `SELECT * FROM LandlordProfile WHERE profileID=${parsedId};
    
    SELECT P.propertyStreetAddress FROM Property P
    LEFT OUTER JOIN Owns O ON O.propertyID=P.propertyID
    LEFT OUTER JOIN LandlordProfile L ON O.profileID=L.profileID
    WHERE L.profileID=${parsedId};

    SELECT avg(starRating) as averageRating,count(starRating) as numOfRatings FROM Review WHERE profileID=${parsedId};
    
    /******* get reviews ********/
    select R.reviewID, U.userName as userName, R.reviewText as description, R.starRating as rating, V.verificationStatus as isVerified, DATE_FORMAT(T.claimDateTime, "%M %d %Y") as reviewDate
    FROM Review R 
    LEFT JOIN Verification V ON R.reviewID=V.reviewID
	  LEFT JOIN User U ON R.userID=U.userID
    LEFT JOIN Verification_Log T ON V.verificationID=T.verificationID
    WHERE profileID=${parsedId}
    ORDER BY ${orderBy} ${sortOrder};

    /**** get latest verified *****/
    select R.reviewID, U.userName, R.reviewText, R.starRating, V.verificationStatus, DATE_FORMAT(T.claimDateTime, "%M %d %Y") as reviewDate
    FROM Review R 
    LEFT JOIN Verification V ON R.reviewID=V.reviewID
	  LEFT JOIN User U ON R.userID=U.userID
    LEFT JOIN Verification_Log T ON V.verificationID=T.verificationID
    WHERE profileID=${parsedId}
    AND V.verificationStatus=1
    ORDER BY T.claimDateTime;

    /***** NESTED AGGREGATION GROUP BY ******/
    select L.profileName as name, avg(R.starRating) AS rating FROM LandlordProfile L
    LEFT JOIN Review R ON L.profileID=R.profileID
    WHERE L.profileCity=(SELECT profileCity FROM LandlordProfile WHERE profileID=${parsedId})
    GROUP BY profileName;
    
    `;
    console.log('QUERY*****************', sql);
    db.query(sql, [0, 1, 2, 3, 4, 5],(err, results) => {
      if (err) throw err;

      // property address array
      let propertyArray = [];
      results[1].forEach(property => {
        propertyArray.push(property.propertyStreetAddress)
      });

      // review array
      let reviewArray = [];
      results[3].forEach(reviewInfo => {
        reviewArray.push(reviewInfo);
      });
      
      // other landlords array
      let otherLandlords = [];
      results[5].forEach(ll => {
        otherLandlords.push(ll);
      });

      console.log('reviewArray', reviewArray);
      
      const response = {
        name: results[0][0].profileName,
        rating: results[2][0].averageRating,
        ratingCount: results[2][0].numOfRatings,
        location: results[0][0].profileCity,
        managedProperties: propertyArray,
        latestReview: {
            date: results[4][0].reviewDate,
            entry: results[4][0].reviewText
        },
        otherLandlords: otherLandlords,
        reviews: {
            count: 6,
            entries:reviewArray
        }
    }
    res.render('./pages/landlordProfile', response);

    });

  },
  
};
