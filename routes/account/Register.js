const express = require('express')
const { registerUser, registerPartner } = require("../../controllers/account/Register");

const router = express.Router();

router.post('/user', registerUser)

router.post('/partner', registerPartner)

module.exports = router