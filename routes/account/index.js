const express = require("express");
const registerRoutes = require("./Register");
const confirmationRoutes = require('./Confirmation')
const loginRoutes = require('./Login')
const refreshTokenRoutes = require('./RefreshToken')

const router = express.Router();

router.use("/register", registerRoutes);

router.use("/confirmation", confirmationRoutes);

router.use("/login", loginRoutes)

router.use('/refresh_token', refreshTokenRoutes)

module.exports = router;
