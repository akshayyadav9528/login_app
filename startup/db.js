const mongoose = require('mongoose');
require('dotenv').config();


module.exports = async function connectdb(){
    try{
        await mongoose.connect(process.env.MONGO_URI);
       
        console.log('Connected to DB...');
    }catch (error){
        console.error('Could not connect to DB...', error);
        throw error;
    }
}