const mongoose = require('mongoose')
 



const userSchema = new mongoose.Schema(
    {
        name: {
            type: String,
            trim: true,
            required: true,
            maxlength: 32
        },
        image:{
          type:String
        },
       uid:String,
        email: {
            type: String,
            
            required: true,
           
        },
       
    },
    { timestamps: true }
);


 

module.exports = mongoose.model('User', userSchema);