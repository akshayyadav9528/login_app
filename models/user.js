require('dotenv').config();
const mongoose = require('mongoose');
const joi = require('joi');
const jwt = require('jsonwebtoken');



const mongooseschema = mongoose.Schema({
    firstName:{
        type :String,
        required : true,
    },
    lastName:{
        type :String,
        required:true,
    },
    email:{
      type:String,
      required:true,
    },
    password:{
        type :String,
        required:true,
    },

    memos:[{
        timeStamp: {
            type: Date,
            default: Date.now
        },
        content:{
            type:String,
            required:true,
        }
    }]

});

mongooseschema.methods.generateAuthToken = function(){
    const token = jwt.sign({_id:this._id}, process.env.JWT_SECRET_KEY, {expiresIn: '5min'});
    return token;
};

const User = mongoose.model('User', mongooseschema);

function validateuser(user){
    const schema = joi.object({
        firstName: joi.string().min(3).max(30).required(),
        lastName: joi.string().min(3).max(20).required(),
        email: joi.string().email().required(),
        password: joi.string().min(8).max(16).required(),
        memos: joi.array().items(joi.object({
            timeStamp: joi.date().default(Date.now),
            content: joi.string().required()
        }))
    });
    return schema.validate(user);
}

module.exports = { User, validateuser };
