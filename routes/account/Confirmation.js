const express = require('express');
const router = express.Router();
const { confirmUser } = require('../../controllers/account/Confirmation')

router.post('/user', confirmUser);

module.exports = router;