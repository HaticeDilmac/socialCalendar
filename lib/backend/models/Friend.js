const mongoose = require('mongoose');

const friendSchema = new mongoose.Schema({
                name: {
                                type: String,
                                required: true,
                },
                birthday: {
                                type: Date,
                },
                importantDates: [
                                {
                                                title: String,
                                                date: Date,
                                }
                ],
                interactionLog: [
                                {
                                                type: {
                                                                type: String,
                                                                required: true,
                                                },
                                                date: {
                                                                type: Date,
                                                                default: Date.now,
                                                }
                                }
                ],
                createdAt: {
                                type: Date,
                                default: Date.now,
                }
});


const Friend = mongoose.model('Friend', friendSchema);
module.exports = Friend;
