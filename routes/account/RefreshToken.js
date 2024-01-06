const express = require("express");
const { handleRefreshtoken } = require("../../controllers/account/RefreshToken");

const router = express.Router();

router.post("/", handleRefreshtoken);

module.exports = router;
