const express = require("express");
const router = express.Router();
const Partner = require('./Partner');
const User = require('./User')

router.use('/partner', Partner)

router.use("/user", User);

module.exports = router;
