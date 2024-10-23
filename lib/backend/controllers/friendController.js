const Friend = require('../models/Friend');

//add new friend api function
exports.addFriend = async (req, res) => {
                try {
                                console.log(req.body); // Gelen isteği yazdır
                                const newFriend = new Friend(req.body);
                                const friend = await newFriend.save();
                                res.status(201).json(friend);
                } catch (err) {
                                res.status(500).json({ message: 'Cannot add friend', error: err.message });
                }
};


// exports.addFriend = async (req, res) => {
//                 try {
//                                 const newFriend = new Friend(req.body);
//                                 const friend = await newFriend.save();
//                                 res.status(201).json(friend);
//                 } catch (errr) {
//                                 res.status(500).json({ message: 'Cannot add friends' });
//                 }
// };

//friends list
exports.getFriends = async (req, res) => {
                try {
                                console.log("Getting friends..."); // Bu satırı ekle
                                const friends = await Friend.find();
                                res.json(friends);
                } catch (errr) {
                                console.error("Error fetching friends:", errr); // Hata mesajını konsola yaz
                                res.status(500).json({ message: 'Cannot get friends', error: errr.message });
                }
}


// friends update api
exports.updateFriend = async (req, res) => {
                const { id } = req.params; // URL'den ID'yi al
                const updateData = req.body; // Gönderilen veriyi al

                try {
                                const updatedFriend = await Friend.findByIdAndUpdate(id, updateData, {
                                                new: true, // Güncellenmiş belgeyi döndür
                                                runValidators: true // Validasyonları çalıştır
                                });

                                if (!updatedFriend) {
                                                return res.status(404).json({ message: 'Friend not found' });
                                }

                                res.json(updatedFriend);
                } catch (err) {
                                res.status(500).json({ message: 'Cannot update friend', error: err.message });
                }
}


// friends delete api
exports.deleteFriend = async (req, res) => {
                const { id } = req.params; // URL'den ID'yi al

                try {
                                const deletedFriend = await Friend.findByIdAndDelete(id); // with id friend delete
                                if (!deletedFriend) {
                                                ß
                                                return res.status(404).json({ message: 'Friend not found' }); // if friends not found
                                }
                                res.status(204).send(); // if delete successfully
                } catch (err) {
                                res.status(500).json({ message: 'Cannot delete friend', error: err.message }); //eror state
                }
}
