const express = require("express");
const router = express.Router();

router.post("/user", async (req, res, next) => {
    console.log('error')
  res.status(200).json({ message: "Hello world" });
});

module.exports = router;
