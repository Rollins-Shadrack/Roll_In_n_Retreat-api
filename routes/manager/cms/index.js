const { Router } = require("express");
const router = Router();
const city = require("./city");
const serviceCategory = require("./service_category")

router.use("/city", city);

router.use("/service_category", serviceCategory)

module.exports = router;
