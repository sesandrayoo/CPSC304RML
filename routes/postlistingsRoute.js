
var db = require("../db");

// export routes so that they can be imported in the server.js
module.exports = {
  // POST: Add a new listing
  addListing: (req, res) => {
    let query =
      "INSERT INTO Listing (uploaderID, listingTitle, listingArea, listingDescription, listingPrice) VALUES ('" +
      req.body.uploaderid +
      "','" +
      req.body.listingtitle +
      "','" +
      req.body.listingarea +
      "','" +
      req.body.listingdescription +
      "','" +
      `$${req.body.listingprice}/month` +
      "');";
    db.query(query, (err, result) => {
      if (err) {
        res.redirect("/postListing");
      }
    });

    console.log(query);
    res.redirect("/");
  }
};
