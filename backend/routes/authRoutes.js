const express = require('express');
const { registerUser, loginUser, logoutUser ,profileUser } = require('../controller/authController');
const { protect } = require('../middelware/auth');

const router = express.Router();

router.post('/register', registerUser);
router.post('/login', loginUser);
router.post('/logout',protect, logoutUser);
router.post('/profile',protect, profileUser);

module.exports = router;
