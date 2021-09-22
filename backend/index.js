const express = require('express')
const app = express()
 
const morgan = require('morgan');
const bodyParser = require('body-parser');
const cors = require('cors');
 
 
 
require('./db/mongoose')
 
 
 

 




 
const userRoutes = require('./routes/user');
 

require('dotenv').config({ path: './config/config.env' })

// middleware
app.use(morgan('dev'));
 
app.use(bodyParser.json());
app.use(cors());
 
 
 
 
app.use('/api/images',express.static('images'))
 
app.use('/api', userRoutes);
 
 
 


 
 

 
 
    
     


const port = process.env.PORT || 8000

 


app.listen(port, () => {
    console.log(`Server is running on port ${port}  `)
})
