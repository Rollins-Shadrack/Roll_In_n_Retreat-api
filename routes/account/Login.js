const express = require('express')
const {loginUser} = require('../../controllers/account/Login')

const router = express.Router();

router.post("/user", loginUser);

module.exports = router