const { Router } = require("express");
const { createServiceCategory, getAllServiceCategories, getAServiceCategory, updateAServiceCategory, deleteServiceCategory } = require("../../../controllers/manager/System/service_category");

const router = Router();

router.post("/", createServiceCategory)

router.get("/", getAllServiceCategories);

router.get("/:id", getAServiceCategory);

router.put("/:id", updateAServiceCategory);

router.delete("/:id", deleteServiceCategory);

module.exports = router;
