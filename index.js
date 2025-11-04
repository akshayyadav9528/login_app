const express = require('express');
require('dotenv').config();


const app = express();
const PORT = process.env.PORT || 3000;

require('./startup/config')();
require('./startup/db')();
require('./startup/routes')(app);


app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});