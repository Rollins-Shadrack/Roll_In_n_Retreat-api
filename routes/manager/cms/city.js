const { Router } = require("express");
const { createCity, getAllCities, getACity, updateACity, deleteACity } = require("../../../controllers/manager/System/city");
const router = Router();

router.post("/", createCity);

router.get("/", getAllCities);

router.get("/:id", getACity);

router.put("/:id", updateACity);

router.delete("/:id", deleteACity);

module.exports = router;
