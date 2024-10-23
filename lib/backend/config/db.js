//connect mongoDB
const mongoose = require('mongoose'); // doğru

const connectDB = async () => {
                try {

                                mongoose.connect('mongoDbConnectUrl', {
                                            useNewUrlParser: true,
                                                useUnifiedTopology: true,
                                                serverSelectionTimeoutMS: 5000
                                }).then(() => { console.log('MongoDB connection successful:') }).catch((err) => {
                                                console.error('MongoDB connection error:', err);
                                });
                } catch (err) {
                                console.error(':', err);
                                process.exit(1);
                }
}


module.exports = connectDB;