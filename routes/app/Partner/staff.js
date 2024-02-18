const express = require("express");
const verifyJWT = require("../../../middleware/authMiddleware");
const { getAllStaffMembers } = require("../../../controllers/app/Partner/staff/crud");
const router = express.Router();
router.use(verifyJWT);

router.get('/', getAllStaffMembers)

module.exports = router;