const Friend = require('../models/Friend');

//add new friend api function
exports.addFriend = async (req, res) => {
                try {
                                const newFriend = new Friend(req.body);
                                const friend = await newFriend.save();
                                res.status(201).json(friend);
                } catch (errr) {
                                res.status(500).json({ message: 'Cannot add friends' });
                }
};

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
                try {
                                const updateFriend = await Friend.findByIdAndUpdate();
                                res.json(updateFriend);
                }
                catch (errr) {
                                res.status(500).json({ message: 'Cannot update friends' });
                }
}

// friends delete api
exports.deleteFriend = async (req, res) => {
                try {
                                await Friend.findByIdAndDelete();
                                res.status(204).send();
                }
                catch (errr) {
                                res.status(500).json({ message: 'Cannot update friends' });
                }
}