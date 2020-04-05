const express = require('express');
var db = require('./db');
const bodyParser = require('body-parser');
const {showAll, addUser} = require('./routes/sampleRoute');
const {addNewUser} = require('./routes/signupRoute');
const {addListing} = require('./routes/postlistingsRoute');
const {searchResults, searchResultsProperty} = require('./routes/searchRoute');
const { createProfile } = require("./routes/createNewLLPRoute");
const connection = require('./db.js');

const session = require('express-session');
const path = require('path');


const app = express(); 
app.set('views', `${__dirname}/views`)
app.set('view engine', 'ejs')
app.use(bodyParser.urlencoded({ extended: true }));


// Sets the correct directory for the project use (instead of your computer)
app.use(express.static(__dirname + "/views"));
app.use(express.static(__dirname + "/public"));

// use session for determining if user is logged in
app.use(session({
    secret: 'secret',
    resave: true,
    saveUninitialized: true
}));
app.use(bodyParser.json());

// The default
app.get("/", (req, res) => {
  const sampleResponse = {
    title: "RateMyLandlord Home"
  };
  // Renders the index.ejs page
  res.render("./pages/index", sampleResponse);
  // you should see this console log in your terminal/command line when you go to localhost:3000/
  console.log("on homepage!");
});

//login page
app.get('/login', (req, res) => {
    const sampleResponse = {title: 'RateMyLandlord Login'}
    res.render('./pages/login', sampleResponse);
})
app.post('/auth', (request, response) => {
    let username = request.body.username;
    let password = request.body.password;
    if (username && password) {
        connection.query('SELECT * FROM user WHERE userName = ? AND userPassword = ?', [username, password], 
        function(error, results, fields) {
        if (results.length > 0) {
          request.session.loggedin = true;
          request.session.username = username;
          request.session.userpassword = password;
          response.redirect('/');
        } else {
          response.send('Incorrect Username and/or Password!');
        }			
        response.end();
      });
    } else {
      response.send('Please enter Username and Password!');
      response.end();
    }
  })

//signup page
app.get('/signup', (req, res) => {
    const sampleResponse = { title: 'RateMyLandlord Signup' }
    res.render('./pages/signup', sampleResponse);
})

// Account page
app.get('/account', (request, response) => {
    if (request.session.loggedin) {
        connection.query('SELECT * FROM user WHERE userName = ?', [request.session.username], 
        function(error, results, fields) {
            response.render('./pages/account', { account: results[0] });
        });
    } else {
        response.redirect('/login');
    }
  })

  app.get('/accountDel', (request, response) => {
    let name = request.session.username;
    console.log(name);
    request.session.loggedin = false;
    connection.query('DELETE FROM user WHERE userName = ?', [name], 
    function(error, results, fields) {
        if (error) throw error;
        response.render('./pages/index');
        })
  })


app.post('/account', (request, response) => {
    let username = request.body.newUsername;
    let about = request.body.newAbout;
    let type = request.body.newType;
    console.log(username);
    console.log(about);
    console.log(type);
    console.log(request.session.username);
    console.log(request.session.userpassword);
    connection.query('UPDATE user SET userName = ?, userAbout = ?, userType = ? WHERE userName = ? AND userPassword = ?', [username, about, type, request.session.username, request.session.userpassword], 
    function(error, results, fields) {
        if (error) throw error;
        response.render('./pages/index');
    });
})

//search listing page
app.get('/searchlisting', (req, res) => {
    const sampleResponse = { title: 'RateMyLandlord searchlisting' }
    res.render('./pages/searchlisting', sampleResponse);
})

//listings page
app.get('/listings', (req, res) => {
    const sampleResponse = { title: 'RateMyLandlord listings' }
    res.render('./pages/listings', sampleResponse);
})


// postListing page
app.get('/postListing', (req, res) => {
    const sampleResponse = { title: 'Post Listing page' }
    res.render('./pages/postListing', sampleResponse);
})

app.post('/signup', addNewUser);
app.post('/postListing', addListing);


/////// SEARCH BY SECTION /////////
// PAGE: search by landlord 
app.get('/search', searchResults);
app.get('/searchProperty', searchResultsProperty);
///////////////////////////////////


////////// CREATE NEW LLP PAGE ///////
app.get('/createNewLLP', (req, res) => {
    res.render('./pages/createNewLLP');
})
app.post('/createNewLLP', createProfile);
//////////////////////////////////////


///// LANDLORD PROFILE PAGE ///////////
app.get('/landlordProfile', (req, res) => {
    const { id } = req.query;
    const parsedId = parseInt(id, 10); // use this id

    let sql = `SELECT * FROM LandlordProfile WHERE profileID=${parsedId};
    
    SELECT propertyStreetAddress FROM Property P
    LEFT OUTER JOIN Owns O ON O.propertyID=P.propertyID
    LEFT OUTER JOIN LandlordProfile L ON O.profileID=L.profileID
    WHERE L.profileID=${parsedId};

    
    `;
    console.log('QUERY*****************', sql);
    db.query(sql, [0, 1],(err, results) => {
      if (err) throw err;

      console.log('results1**********', results[0][0].profileName);

      const response = {
        name: results[0][0].profileName,
        rating: 4.7,
        ratingCount: 244,
        location: results[0][0].profileCity,
        managedProperties: [
            '1234 West 6th Avenue',
            '#410 - Megadoodoo Street',
            '100 Kingsway Avenue'
        ],
        latestReview: {
            date: 'March 16, 2020',
            entry: `I really liked this landlord. She was super reasonable and understanding. 
                I always paid my rent on time and never ran into any problems. Shewas walways able ro abdalslkfbsdakbf`
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

    // res.render('./pages/landlordProfilePage', sampleResponse);
})
////////////////////////////////////

//////////// SAMPLE SECTION ////////////
/* import the endpoints */
app.get('/samplePage', showAll);
app.post('/samplePage', addUser);
////////////////////////////////////////

/////// QUERIES /////////


app.post("/searchlisting/submit", (req, res, next) => {
  res.redirect(".pages/listings");
});

// EXAMPLE Update post
app.get("/updatepost/:id", (req, res) => {
  let newTitle = "Updated Title";
  let sql = `UPDATE posts SET title = '${newTitle}' WHERE id = ${req.params.id}`;
  let query = db.query(sql, (err, result) => {
    if (err) throw err;
    console.log(result);
    res.send("Post updated...");
  });
});

// EXAMPLE Delete post
app.get("/deletepost/:id", (req, res) => {
  let newTitle = "Updated Title";
  let sql = `DELETE FROM posts WHERE id = ${req.params.id}`;
  let query = db.query(sql, (err, result) => {
    if (err) throw err;
    console.log(result);
    res.send("Post deleted...");
  });
});

app.listen("3000", () => {
  console.log("Server started on port 3000");
});
