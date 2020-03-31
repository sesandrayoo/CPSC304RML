const express = require('express');
var db = require('./db');
const bodyParser = require('body-parser');
const {showAll, addUser} = require('./routes/sampleRoute');


const app = express(); 
app.set('views', `${__dirname}/views`)
app.set('view engine', 'ejs')
app.use(bodyParser.urlencoded({ extended: true }));

// Sets the correct directory for the project use (instead of your computer)
app.use(express.static(__dirname + '/views'));
app.use(express.static(__dirname + '/public'));

// The default
app.get('/', (req, res) => {
    console.log(req);
    const sampleResponse = {
        title: 'RateMyLandlord Home'
    }
    // Renders the index.ejs page
    res.render('./pages/index', sampleResponse);
    // you should see this console log in your terminal/command line when you go to localhost:3000/
    console.log('on homepage!');
    
})

//login page
app.get('/login', (req, res) => {
    const sampleResponse = {

        title: 'RateMyLandlord Login'
    }
    res.render('./pages/login', sampleResponse);
    console.log('on login page!');
})

//signup page
app.get('/signup', (req, res) => {
    const sampleResponse = {
        title: 'RateMyLandlord Signup'
    }
    res.render('./pages/signup', sampleResponse);
    console.log('on signup page!');
})

//search listing page
app.get('/searchlisting', (req, res) => {
    const sampleResponse = {
        title: 'RateMyLandlord searchlisting'
    }
    res.render('./pages/searchlisting', sampleResponse);
    console.log('on search listing page!');
})

//listings page
app.get('/listings', (req, res) => {
    const sampleResponse = {
        title: 'RateMyLandlord listings'
    }
    res.render('./pages/listings', sampleResponse);
    console.log('on listings page!');
})


// search Page
app.get('/search', (req, res) => {
    const randomvariables = {
        category: 'Landlord'
    }
    res.render('./pages/search', randomvariables);

})


// landlordProfile page 
app.get('/landlordProfile', (req, res) => {
    const sampleResponse = {
        title: 'RateMyLandlord Login'
    }
    res.render('./pages/landlordProfilePage', sampleResponse);
})


/// SAMPLE SECTION /////
/* import the endpoints */
app.get('/samplePage', showAll);
app.post('/samplePage', addUser);







/////// QUERIES /////////

// Select ALL Landlord profiles
app.get('/getAllProfiles', (req, res) => {
    let sql = 'SELECT * FROM LandlordProfiles';
    let query = db.query(sql, (err, results) => {
        if(err) throw err;
        console.log(results);
        console.log('see below!')
        res.send('Profiles fetched...');
    });
});

// Select single LandlordProfile
app.get('/getLandlordProfile/:id', (req, res) => {
    let sql = `SELECT * FROM LandlordProfiles WHERE id = ${req.params.id}`;
    let query = db.query(sql, (err, result) => {
        if(err) throw err;
        console.log(result);
        
        res.send('LandlordProfile fetched...');
    });
});

app.post('/searchlisting/submit', (req, res, next) => {
    res.redirect('.pages/listings');
});

// EXAMPLE Update post 
app.get('/updatepost/:id', (req, res) => {
    let newTitle = 'Updated Title';
    let sql = `UPDATE posts SET title = '${newTitle}' WHERE id = ${req.params.id}`;
    let query = db.query(sql, (err, result) => {
        if(err) throw err;
        console.log(result);
        res.send('Post updated...');
    });
});

// EXAMPLE Delete post
app.get('/deletepost/:id', (req, res) => {
    let newTitle = 'Updated Title';
    let sql = `DELETE FROM posts WHERE id = ${req.params.id}`;
    let query = db.query(sql, (err, result) => {
        if(err) throw err;
        console.log(result);
        res.send('Post deleted...');
    });
});

app.listen('3000', () => {
    console.log('Server started on port 3000');
});