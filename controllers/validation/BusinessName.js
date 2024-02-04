const asyncHandler = require('express-async-handler');
const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient();
/**
 * @Description checking to see if 2 business names are registered in one city
 * @Methood POST
 * @Params
 * @Request
 * @Resposne  true/false
 */
const checkBusinessExists = asyncHandler(async (req, res, next) => {
    try {
        const { cityId, businessName } = req.body;
        if (!cityId || !businessName) return res.status(400).json({ success: false, message: "Field is required" });

        const businessExists = await prisma.partner.findFirst({
            where: {
                city_id: cityId,
                business_name:businessName
            }
        })
        if (businessExists && businessExists.id) return { message: "Business name is already in use in this city" };
        res.status(200).json({ available: "available" });
    } catch (error) {
      console.log();
      return res.status(500).json(error.message);
    }
})

module.exports = {
    checkBusinessExists
}