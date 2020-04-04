// TBH not sure why I need to reimport the database, but I do apparently...
var db = require("../db");

// export routes so that they can be imported in the server.js
module.exports = {
  // GET endpoint
  searchResults: (req, res) => {
    if (Object.keys(req.query).length > 0) {
      let sql = `SELECT * FROM LandlordProfile WHERE profileName LIKE '%${req.query.landlord}%';`;
      let tempArr = [];
      db.query(sql, (err, results) => {
        if (err) throw err;
        results.forEach(res => {
          tempArr.push(res);
        });

        const searchResults = {
          category: tempArr
        };

        res.render("./pages/search", searchResults);
      });
    } else {
      const searchResults = {
        category: []
      };

      res.render("./pages/search", searchResults);
    }
  },
  searchResultsProperty: (req, res) => {
    if (Object.keys(req.query).length > 0) {
      let sql = `SELECT P.propertyStreetAddress, M.propertyCity, P.propertyType, P.Bedrooms, P.Bathrooms FROM Property P
      LEFT OUTER JOIN propertyLocation pl ON p.propertyStreetAddress=pl.propertyStreetAddress
      LEFT OUTER JOIN Municipality M ON pl.propertyPostal=M.propertyPostal
      WHERE P.propertyStreetAddress LIKE '%${req.query.property}%';`;

      let tempArr = [];
      db.query(sql, (err, results) => {
        if (err) throw err;
        results.forEach(res => {
          tempArr.push(res);
        });

        const searchResults = {
          category: tempArr
        };
        res.render("./pages/searchProperty", searchResults);
      });
    } else {
      const searchResults = {
        category: []
      };

      res.render("./pages/searchProperty", searchResults);
    }
  }
};
