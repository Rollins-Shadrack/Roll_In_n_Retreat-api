const express = require('express');
const router = express.Router();
const { confirmUser, forgotPassword, resetPassword, confirmPartner } = require("../../controllers/account/Confirmation");

router.post('/user', confirmUser);

router.post("/partner", confirmPartner);

router.post('/forgot_password', forgotPassword);

router.post('/reset_password', resetPassword);

module.exports = router;