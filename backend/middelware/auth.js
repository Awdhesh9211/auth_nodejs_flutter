const jwt = require('jsonwebtoken');
const dotenv = require('dotenv');
const User = require('../models/User');

dotenv.config();

const protect = async (req, res, next) => {
  let token;

  // Check if token is provided in Authorization header
  if (req.headers.authorization && req.headers.authorization.startsWith('Bearer')) {
    try {
      // Get the token from the header
      token = req.headers.authorization.split(' ')[1];

      // Verify the token using JWT
      const decoded = jwt.verify(token, process.env.JWT_SECRET);

      // Find the user associated with the token's userId
      req.user = await User.findById(decoded.userId).select('-password');

      next(); // Continue to the next middleware or route handler
    } catch (error) {
      console.error(error);
      res.status(401).json({ message: 'Not authorized, token failed' });
    }
  }

  if (!token) {
    res.status(401).json({ message: 'No token, authorization denied' });
  }
};

module.exports = { protect };
