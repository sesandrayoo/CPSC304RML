const express = require('express');
var db = require('./db');

 
const app = express(); 
app.set('views', `${__dirname}/views`)
app.set('view engine', 'ejs')

// Sets the correct directory for the project use (instead of your computer)
app.use(express.static(__dirname + '/views'));

// The default
app.get('/', (req, res) => {
    const sampleResponse = {
        title: 'RateMyLandlord Home'
    }
    // Renders the index.ejs page
    res.render('./pages/index', sampleResponse);
    // you should see this console log in your terminal/command line when you go to localhost:3000/
    console.log('on homepage!');
})

// The login page
app.get('/login', (req, res) => {
    const sampleResponse = {
        title: 'RateMyLandlord Login'
    }
    // Renders the index.ejs page
    res.render('./pages/login', sampleResponse);
    // you should see this console log in your terminal/command line when you go to localhost:3000/
    console.log('on login page!');
})

// The signup page
app.get('/signup', (req, res) => {
    const sampleResponse = {
        title: 'RateMyLandlord Signup'
    }
    // Renders the index.ejs page
    res.render('./pages/signup', sampleResponse);
    // you should see this console log in your terminal/command line when you go to localhost:3000/
    console.log('on signup page!');
})

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