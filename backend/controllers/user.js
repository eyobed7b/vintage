const asyncHandler  = require( 'express-async-handler')
const { generateToken }= require ('../utils/generateToken.js')
const User = require ('../models/user.js')
 
 
 
 
exports.registerUser = asyncHandler(async (req, res) => {
    

     

   

   
    const userInfo = new User(req.body)
   
    console.log(userInfo)

    await userInfo.save((err,data)=>{
        if(err){
             console.log(err.message)
             throw new Error('Invalid user data')
            // return res.status(401);
        }
        res.json(data)
    })

     
})
 
exports.getUserProfile = asyncHandler(async (req, res) => {
    const user = await User.findOne({uid:req.params.id})

    if (user) {
        res.json(user)
    } else {
        res.status(404)
        throw new Error('User not found')
    }
})

 

 
 


exports.updateUserPhoto = asyncHandler(async (req, res) => {
   
 
    try {
     
        let imagePath = req.file.path.replace(/\\/g, "/");
        const user = await User.findByIdAndUpdate({_id: req.params.id}, {image:imagePath}, {
            new: true,
            runValidators: true
        })
         

        if (!user) {
            return res.status(401).send()
        }
       

        await user.save()

        
       res.send(user)

    } catch (e) {
        console.log(e.message)
        res.status(400).send(e)
    }
})

exports.deleteUser = asyncHandler(async (req, res) => {
    const { user } = req.params

    const result = await User.findById(user)

    if (result) {
        await result.remove()
        res.json({ message: 'User removed' })
    } else {
        res.status(404)
        throw new Error('User not found')
    }
})

 
 


 
exports.updateUser = asyncHandler(async (req, res) => {
 
    const user = await User.findByIdAndUpdate({_id: req.params.id}, req.body, {
        new: true,
        runValidators: true 
    },)

    if (user) {
        
        res.json( user)
    } else {
        res.status(404)
        throw new Error('User not found')
    }
})
 
 


 


 