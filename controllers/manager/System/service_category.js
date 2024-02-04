const asyncHandler = require('express-async-handler');
const { PrismaClient } = require("@prisma/client");
const prisma = new PrismaClient();

/**
 * @Description Create a new Service Category
 * @Method POST
 * @Params []
 * @Request
 * @Response success
 */

const createServiceCategory = asyncHandler(async (req, res, next) => {
    try {
      const { name } = req.body;
      if (!name) return res.status(404).json({ success: false, message: "Field is required" });

      const result = await prisma.service_category.create({
        data: { name },
      });
      res.status(201).json({ success: true, message: "Successfull", result });
    } catch (error) {
      console.log(error.message);
      return res.status(500).json({ success: false, message: "Internal Server error" });
    }
})

/**
 * @Description get all Service Category
 * @Method GET
 * @Params []
 * @Request
 * @Response  all Service Category
 */

const getAllServiceCategories = asyncHandler(async (req, res, next) => {
    try {
      const { search } = req.query;
      const result = await prisma.service_category.findMany({
        where: {
          AND: [{ name: { equals: search, mode: "insensitive" } }, { deleted_at: { equals: null } }],
        },
      });
      res.status(200).json({ success: true, result });
    } catch (error) {
      console.log(error);
      return res.status(500).json({ success: false, message: "Internal Server error" });
    }
})

/**
 * @Description get service category
 * @Method GET
 * @Params [serviceCategoryId@string,]
 * @Requestdb
 * @Response  service category
 */

const getAServiceCategory = asyncHandler(async (req, res, next) => {
    try {
      const { id } = req.params;
      const result = await prisma.service_category.findUnique({
        where: { id },
      });
      if (!result || result.deleted_at !== null) return res.status(404).json({ success: false, message: " item not found" });
      res.status(200).json({ success: true, result });
    } catch (error) {
      console.log(error.message);
      return res.status(500).json({ success: false, message: "Internal Server error" });
    }
})

/**
 * @Description Update a payment method
 * @Method PUT
 * @Params [paymentmethodId@string,]
 * @Request
 * @Response payment method
 */
const updateAServiceCategory = asyncHandler(async (req, res, next) => {
    try {
      const { id } = req.params;
      const { name } = req.body;
      if (!name) return res.status(404).json({ success: false, message: "field is required" });

      const result = await prisma.service_category.update({
        where: { id },
        data: { name },
      });
      if (!result) return res.status(400).json({ success: false, message: "Unable to update" });
      res.status(200).json({ success: true, result });
    } catch (error) {
      console.log(error.message);
      return res.status(500).json({ success: false, message: "Internal server error" });
    }
})

/**
 * @Description Delete a gender
 * @Method DELETE
 * @Params [gender@string,]
 * @Request
 * @Response success
 */

const deleteServiceCategory = asyncHandler(async (req, res, next) => {
    try {
      const { id } = req.params;

      const result = await prisma.service_category.update({
        where: { id },
        data: { deleted_at: new Date() },
      });

      if (!result) return res.status(404).json({ success: false, message: "item not found" });

      res.status(200).json({ success: true, message: "Deleted successfully" });
    } catch (error) {
      console.log(error.message);
      return res.status(500).json({ success: false, message: "Internal server error" });
    }
})

module.exports = {
    createServiceCategory,
    getAllServiceCategories,
    getAServiceCategory,
    updateAServiceCategory,
    deleteServiceCategory
}
