var db = require("../db");

//module.exports = {
    // DELETE: Add a new user
//     deleteUser: (req, res) => {
//       let id = req.body.account-userid;
//       if (request.session.loggedin) {
//           console.log(request.session.username);
//           connection.query('DELETE FROM user WHERE userID = ?', [id], 
//           function(error, results, fields) {
//               if (error) throw error;
//               response.render('/');
//           });
//       } else {
//           response.redirect('/login');
//       }
//   }
// }