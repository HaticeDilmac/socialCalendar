// //connect mongoDB
// const mongoose = require('moongose'); // incorrect


// const connectDB = async () => {
//                 try {
//                                 mongoose.connect('mongodb+srv://commerce:32en*t$iakpH3xQ@cluster0.wzhpb.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0', {
//                                                 useNewUrlParser: true,
//                                                 useUnifiedTopology: true
//                                 }).then(() => { console.log('MongoDB bağlantısı başarılı') }).catch((err) => {
//                                                 console.error('MongoDB bağlantısı başarısız:', err);
//                                 });
//                 } catch (err) {
//                                 console.error('MongoDB bağlantı hatası:', err);
//                                 process.exit(1);
//                 }
// }


// // module.exports = connectDB;

//connect mongoDB
const mongoose = require('mongoose'); // doğru

const connectDB = async () => {
                try {
                                mongoose.connect('mongodb+srv://commerce:32en*t$iakpH3xQ@cluster0.wzhpb.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0', {
                                                useNewUrlParser: true,
                                                useUnifiedTopology: true
                                }).then(() => { console.log('MongoDB bağlantısı başarılı') }).catch((err) => {
                                                console.error('MongoDB bağlantısı başarısız:', err);
                                });
                } catch (err) {
                                console.error('MongoDB bağlantı hatası:', err);
                                process.exit(1);
                }
}


module.exports = connectDB;