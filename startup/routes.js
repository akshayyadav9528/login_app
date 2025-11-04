const express = require('express');
const cors = require('cors');
const auth = require('../middleware/auth');
const users = require('../routes/users');


// const cors = require('cors');
// app.use(cors({
//   origin: 'http://localhost:5000',  // Flutter web
//   credentials: true
// }));


module.exports = function(app){
    app.use(express.json());
    app.use(cors());
    app.use('/api/auth', auth);
    app.use('/api/users', users);
}