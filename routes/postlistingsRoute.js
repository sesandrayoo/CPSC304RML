
var db = require("../db");

// export routes so that they can be imported in the server.js
module.exports = {
  // POST: Add a new listing
  addListing: (req, res) => {
    let query =
      "INSERT INTO Listing (uploaderID, listingTitle, listingArea, listingDescription, listingBedrooms, listingBathrooms, listingPrice) VALUES ('" +
      req.body.uploaderid +
      "','" +
      req.body.listingtitle +
      "','" +
      req.body.listingarea +
      "','" +
      req.body.listingdescription +
      "','" +
      req.body.bedrooms +
      "','" +
      req.body.bathrooms +
      "','" +
      req.body.listingprice +
      "');";
      
    db.query(query, (err, result) => {
      if (err) {
        res.redirect("/postListing");
      }
    });

    res.redirect("/");
  }
};
