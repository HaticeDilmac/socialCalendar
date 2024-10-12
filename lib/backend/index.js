// const express = require('express');
// const connectDB = require('./config/db');
// const friendsRoutes = require('./routes/friendRoutes');


// const app = express();
// app.arguments(express.json());

// connectDB();

// //Routers
// app.use('/api', friendsRoutes);


// const port = 5000;
// app.listen(port, () => {//api start
//                 console.log(`Server is running on port ${port}`)
// });

const express = require('express');
const connectDB = require('./config/db');
const friendsRoutes = require('./routes/friendRoutes');

const app = express();
app.use(express.json());

connectDB();

// Routers
app.use('/api', friendsRoutes);

const port = 5000;
app.listen(port, () => {
    console.log(`Server is running on port ${port}`);
});
