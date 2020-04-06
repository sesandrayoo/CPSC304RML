// TBH not sure why I need to reimport the database, but I do apparently...
var db = require("../db");

// export routes so that they can be imported in the server.js
module.exports = {
  // GET endpoint 
  showAdmin: (req, res) => {
    const response = {
      headers: [
        'reviewID',
        'created date',
        'admin',
        'action'
      ],
      unverifiedReviews: [
        {
          reviewID: '1234',
          createdDate: '2020-03-12',
          admin: 'Sandra'
        },
        {
          reviewID: '4323',
          createdDate: '2013-01-12',
          admin: 'Sandra'
        },
        {
          reviewID: '4443',
          createdDate: '2010-12-12',
          admin: 'Sandra'
        }
      ],
      verifiedReviews: [
        {
          reviewID: '4125',
          createdDate: '2020-03-12',
          reviewDate: '2020-03-20',
          admin: 'Sandra'
        },
        {
          reviewID: '1133',
          createdDate: '2018-05-12',
          reviewDate: '2018-05-20',
          admin: 'Sandra'
        },
        {
          reviewID: '2222',
          createdDate: '2011-2-28',
          reviewDate: '2011-03-01',
          admin: 'Sandra'
        }
      ]
    }
    res.render('./pages/adminPanel', response)
  },
  // POST: Add a new user
  updateReview: (req, res) => {
    const reviewId = req.body.reviewId || ''; // if doesnt exist, it's empty string
    console.log(reviewId)
    const response = {
      status: 200,
      data: {
        reviewId: reviewId
      }
    }
    res.json(response);
  }
}