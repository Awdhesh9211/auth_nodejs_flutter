const User = require('../models/User');
const jwt = require('jsonwebtoken');
const dotenv = require('dotenv');

dotenv.config();

const registerUser = async (req, res) => {
    console.log("Received REQ");
  const { name, email, password } = req.body;

  // Validation (for simplicity, could be more robust)
  if (!name || !email || !password) {
    return res.status(400).json({ message: 'Please provide all fields.' });
  }

  try {
    // Check if user already exists
    const userExists = await User.findOne({ email });
    if (userExists) {
      return res.status(400).json({ message: 'User already exists.' });
    }

    // Create new user
    const user = new User({ name, email, password });
    await user.save();

    // Generate JWT token
    const token = jwt.sign({ userId: user._id }, process.env.JWT_SECRET, {
      expiresIn: '1h',
    });

    res.status(201).json({
      user: { name: user.name, email: user.email },
      token,
    });
  } catch (error) {
    res.status(500).json({ message: 'Error registering user.', error });
  }
};


const loginUser = async (req, res) => {
    const { email, password } = req.body;
  
    if (!email || !password) {
      return res.status(400).json({ message: 'Please provide both email and password.' });
    }
  
    try {
      const user = await User.findOne({ email });
      if (!user) {
        return res.status(400).json({ message: 'Invalid credentials.' });
      }
  
      // Compare passwords
      const isMatch = await user.comparePassword(password);
      if (!isMatch) {
        return res.status(400).json({ message: 'Invalid credentials.' });
      }
  
      // Generate JWT token
      const token = jwt.sign({ userId: user._id }, process.env.JWT_SECRET, {
        expiresIn: '1h',
      });
  
      res.status(200).json({
        user: { name: user.name, email: user.email },
        token,
      });
    } catch (error) {
      res.status(500).json({ message: 'Error logging in user.', error });
    }
  };

  const logoutUser = (req, res) => {
    // Invalidate the token by removing it from the client-side
    res.status(200).json({ message: 'Logout successful.' });
  };

  const profileUser=(req,res)=>{
    console.log("profilr");
    res.status(200).json({user:req.user})
  }
  
module.exports={
    registerUser,
    loginUser,
    logoutUser,
    profileUser
}
  