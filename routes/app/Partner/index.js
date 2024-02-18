const express = require("express");
const Staff = require('./staff')
const router = express.Router();

router.use("/staff",Staff)

module.exports = router;