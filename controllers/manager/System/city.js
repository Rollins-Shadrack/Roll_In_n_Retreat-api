const { PrismaClient } = require("@prisma/client");
const prisma = new PrismaClient();
const asyncHandler = require('express-async-handler')

/**
 * @Description Create a city
 * @Method POST
 * @Params []
 * @Request
 * @Response success
 */
const createCity = asyncHandler(async (req, res, next) => {
  try {
    const { name } = req.body;
    if (!name) return res.status(404).json({ success: false, message: "City name is required" });

    const createdCity = await prisma.city.create({
      data: {
        name: name,
      },
    });
    res.status(201).json({ success: true, message: "New City is Created", createdCity });
  } catch (error) {
    console.log(error.message);
    return res.status(500).json({ success: false, message: "Internal Server error" });
  }
})

/**
 * @Description get all cities
 * @Method GET
 * @Params []
 * @Request
 * @Response all cities
 */
const getAllCities = asyncHandler(async (req, res, next) => {
  try {
    const { search } = req.query;
    const cities = await prisma.city.findMany({
      where: {
        AND: [{ name: { equals: search, mode: "insensitive" } }, { deleted_at: { equals: null } }],
      },
    });
    res.status(200).json({ success: true, cities });
  } catch (error) {
    console.log(error);
    return res.status(500).json({ success: false, message: "Internal Server error" });
  }
})

/**
 * @Description get a city
 * @Method GET
 * @Params [cityId@string,]
 * @Request
 * @Response city
 */

const getACity = asyncHandler(async (req, res, next) => {
  try {
    const { id } = req.params;
    const city = await prisma.city.findUnique({
      where: { id },
    });
    if (!city || city.deleted_at !== null) return res.status(404).json({ success: false, message: "City not found" });
    res.status(200).json({ success: true, city });
  } catch (error) {
    console.log(error.message);
    return res.status(500).json({ success: false, message: "Internal Server error" });
  }
})

/**
 * @Description Update a city
 * @Method PUT
 * @Params [cityId@string,]
 * @Request
 * @Response city
 */

const updateACity = asyncHandler(async (req, res, next) => {
  try {
    const { id } = req.params;
    const { name } = req.body;
    if (!name) return res.status(404).json({ success: false, message: "City is required" });

    const updatedCity = await prisma.city.update({
      where: { id },
      data: {
        name: name,
      },
    });
    if (!updatedCity) return res.status(400).json({ success: false, message: "Unable to update" });
    res.status(200).json({ success: true, updatedCity });
  } catch (error) {
    console.log(error.message);
    return res.status(500).json({ success: false, message: "Internal server error" });
  }
})

/**
 * @Description Delete a city
 * @Method DELETE
 * @Params [cityId@string,]
 * @Request
 * @Response success
 */

const deleteACity = asyncHandler(async (req, res, next) => {
  try {
    const { id } = req.params;

    const deletedCity = await prisma.city.update({
      where: { id },
      data: { deleted_at: new Date() },
    });

    if (!deletedCity) return res.status(404).json({ success: false, message: "City not found" });

    res.status(200).json({ success: true, message: "City deleted successfully" });
  } catch (error) {
    console.log(error.message);
    return res.status(500).json({ success: false, message: "Internal server error" });
  }
})

module.exports = {
  createCity,
  getAllCities,
  getACity,
  updateACity,
  deleteACity
}
