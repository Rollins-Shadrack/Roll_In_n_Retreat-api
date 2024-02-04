const { Router } = require("express");
const { checkBusinessExists } = require("../../controllers/validation/BusinessName");
const { checkEmailExists } = require("../../controllers/validation/Email");

const router = Router();

router.post('/business_name', checkBusinessExists)

router.post('/email', checkEmailExists)

module.exports = router;
