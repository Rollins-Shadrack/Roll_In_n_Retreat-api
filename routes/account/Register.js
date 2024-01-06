const express = require('express')
const {registerUser} = require('../../controllers/account/Register')

const router = express.Router();

router.post('/user',registerUser)

module.exports = router