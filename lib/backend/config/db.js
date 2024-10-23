//connect mongoDB
const mongoose = require('mongoose'); // doğru

const connectDB = async () => {
                try {

                                mongoose.connect('mongodb+srv://biseylergelistiriyorum:tkdDLRUBZKVF8FO8@hatice.821gj.mongodb.net/?retryWrites=true&w=majority&appName=hatice', {
                                                // 'mongodb+srv://haticedilmac1011:32en*t$iakpH3xQ@cluster0.s5jipdt.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0', {
                                                // 'mongodb+srv://commerce:32en*t$iakpH3xQ@cluster0.wzhpb.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0', {
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