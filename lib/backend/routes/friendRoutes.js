const express = require('express');
const { addFriend, getFriends, updateFriend, deleteFriend } = require('../controllers/friendController');
const router = express.Router();

// Yeni arkadaş ekle
router.post('/friends', addFriend);

// Arkadaşları getir
router.get('/friends', getFriends);

// Arkadaş güncelle
router.put('/friends/:id', updateFriend);

// Arkadaş sil
router.delete('/friends/:id', deleteFriend);

module.exports = router; // router'ı dışa aktar
