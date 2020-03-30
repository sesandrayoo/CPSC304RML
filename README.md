# RateMyLandlord
UBC CPSC 304 Final Project WT2 2019/20

Using:
 - NodeJS
 - MySQL
 - Express

# Setup

1. Install NodeJS
    - Version 12.16.1 or similar
2. Install MySQL
    - Version 8.0.19 or similar
    - Also get MySQL Workbench (provides nice GUI)
    - During set up, when it prompts you for a password DONT provide a password if possible (otherwise you might run into future errors, just press enter without putting in any password)
        - If you do run into errors, let me know because I also went through this. Otherwise, I just pasted in the error and followed what Google said
3. Install [Postman](https://www.postman.com/)
    - This will be really helpful in writing our queries, as it will return the content of the calls made from our app to the database
4. Clone this repo into the directory you want to work in
    - `git clone <linkGivenByGithub>`
5. Run `npm install` in the project directory using your terminal/cmd line window
    - This will download the node packages that we need 
    - Run `npm install nodemon`
6. Open MySQLWorkbench
    - Connect to the local instance (should be named something like `user:root, localhost:3306`)
    - Run `CREATE DATABASE RateMyLandlord` in the query window 
    - Refresh the panel to make sure the database was created (in schemas tab)
7. Open the project in VSCode
    - open `server.js`
    - Make sure this is true for you:
    ``` 
    const db = mysql.createConnection({
    host     : 'localhost',
    user     : 'root',
    password : '',
    database : 'RateMyLandlord'
    }); 
    ```
8. In command line/terminal window:
    - Run `npm run start`
        - this will start the application
    - If it works, then you should see the application when you go to `localhost:3000` in your browser of choice
    
9. SASS
    - run `npm install -g node-sass`
    - run `npm install -g concurrently --save-dev`


# Architecture

Our front end components are in the "views" folder, as `.ejs` files.

# Practices
- It's good practice to run `npm install` after `git fetch` and `git pull` so that you have the same node packages as everyone else.
- Work off of feature branches, not master

## Random
- Upon saving `.ejs` files, the browser does not refresh the page manually so you'll have to hit refresh to view your changes... I'm not sure how to set up auto refresh at the moment
