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
                                const friends = await Friend.find();
                                res.json(friends);
                }
                catch (errr) {
                                res.status(500).json({ message: 'Cannot get friends' });
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
// friends delete api
exports.deleteFriend = async (req, res) => {
                const { id } = req.params; // URL'den ID'yi al

                try {
                                const deletedFriend = await Friend.findByIdAndDelete(id); // ID ile arkadaş kaydını sil
                                if (!deletedFriend) {
                                                return res.status(404).json({ message: 'Friend not found' }); // Eğer arkadaş bulunamazsa
                                }
                                res.status(204).send(); // Başarılı silme işlemi için
                } catch (err) {
                                res.status(500).json({ message: 'Cannot delete friend', error: err.message }); // Hata durumunda
                }
}
