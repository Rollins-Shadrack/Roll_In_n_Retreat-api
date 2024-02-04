const express = require('express')
const { loginUser, loginPartner } = require("../../controllers/account/Login");

const router = express.Router();

router.post("/user", loginUser);

router.post("/partner", loginPartner);

module.exports = router