var db = require("../db");

// export routes so that they can be imported in the server.js
module.exports = {
  // get endpoint
  getLLP: (req, res) => {

    const { id } = req.query;
    const parsedId = parseInt(id, 10); // use this id

    let sql = `SELECT * FROM LandlordProfile WHERE profileID=${parsedId};
    
    SELECT P.propertyStreetAddress FROM Property P
    LEFT OUTER JOIN Owns O ON O.propertyID=P.propertyID
    LEFT OUTER JOIN LandlordProfile L ON O.profileID=L.profileID
    WHERE L.profileID=${parsedId};

    SELECT avg(starRating) as averageRating,count(starRating) as numOfRatings FROM Review WHERE profileID=${parsedId};
    
    select R.reviewID, U.userName, R.reviewText, R.starRating, V.verificationStatus, DATE_FORMAT(T.claimDateTime, "%M %d %Y") as reviewDate
    FROM Review R 
    LEFT JOIN Verification V ON R.reviewID=V.reviewID
	  LEFT JOIN User U ON R.userID=U.userID
    LEFT JOIN Verification_Log T ON V.verificationID=T.verificationID
    WHERE profileID=${parsedId}
    ORDER BY reviewDate DESC;

    /**** get latest verified *****/
    select R.reviewID, U.userName, R.reviewText, R.starRating, V.verificationStatus, DATE_FORMAT(T.claimDateTime, "%M %d %Y") as reviewDate
    FROM Review R 
    LEFT JOIN Verification V ON R.reviewID=V.reviewID
	  LEFT JOIN User U ON R.userID=U.userID
    LEFT JOIN Verification_Log T ON V.verificationID=T.verificationID
    WHERE profileID=${parsedId}
    AND V.verificationStatus=1
    ORDER BY T.claimDateTime;
    
    `;
    console.log('QUERY*****************', sql);
    db.query(sql, [0, 1, 2, 3, 4],(err, results) => {
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
        otherLandlords: [
            {
                name: 'Jimbob Brown',
                rating: 3.8
            },
            {
                name: 'Alice Wonderland',
                rating: 2.3
            },
            {
                name: 'Donald Trump',
                rating: 1.5
            },
            {
                name: 'Deidre Mengedoht',
                rating: 4.9
            }
        ],
        reviews: {
            count: 6,
            entries: [
                {
                    rating: 4.5,
                    isVerified: true,
                    property: '1234 West 6th Avenue',
                    date: 'March 23, 2020',
                    description: 'We did most of the heavy lifting for you to provide a default stylings that incorporate our custom components. Additionally, we refined animations and transitions to provide a smoother experience for developers.'
                },
                {
                    rating: 3.8,
                    isVerified: false,
                    property: '1234 West 6th Avenue',
                    date: 'March 10, 2020',
                    description: 'Some more sample text here wow.'
                },
                {
                    rating: 4.8,
                    isVerified: false,
                    property: '100 Kingsway Avenue',
                    date: 'June 10, 2018',
                    description: 'Great house wow much good nfjeknfdjknfjkrjnfjdkcjndjskdnjd'
                }
            ]
        }
    }
    res.render('./pages/landlordProfile', response);

    });

  }
};
