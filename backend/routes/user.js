const express = require('express')
const router = express.Router()
const {
  
    registerUser,
    getUserProfile,
   
 
    deleteUser,
    updateUserPhoto,
    updateUser,
   
   
  
} = require( '../controllers/user.js')
const { protect  } = require('../middleware/authMiddleware.js')
const multer = require('multer')
 
const storage = multer.diskStorage({
    
    destination:function(req,file,cb){
                  cb(null,'./images/');
    },
    filename:function(req,file,cb){
        cb(null, Date.now()+file.originalname);
    }
})
const upload = multer({
       storage:storage
  

})



 
router.get('/user/:id', getUserProfile);
 

router.put('/user-update/:id', updateUser);
router.post('/user-photo/:id', upload.single('image'),  updateUserPhoto );
 

 

router.delete('/users-delete/:user',  deleteUser);

router.post('/register', registerUser)

 
// router.post('/signin', authUser)

 
 



module.exports = router