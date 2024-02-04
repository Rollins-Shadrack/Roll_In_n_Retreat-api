const { Router } = require("express");
const router = Router();
const cms = require("./cms/index");

router.use("/cms", cms);

module.exports = router;
