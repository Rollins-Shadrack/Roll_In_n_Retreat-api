const asyncHandler = require('express-async-handler');
const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient();
const checkEmailExists = asyncHandler(async (req, res, next) => {
    try {
        const { email } = req.body;
        if (!email) return res.status(400).json({ success: false, message: "Field is required" });
        await prisma.$transaction(async (PrismaClient) => {
            const account = await PrismaClient.account.findUnique({ where: { email } });
            if (account && account.id) return res.status(400).json({ success: false, message: "Email in use please use a different email or login/reset your password", activated: true, id: account.id });
            const registration = await PrismaClient.hold.findUnique({ where: { email } });
            if (registration && registration.account_status === "confirmed")
                return res.status(400).json({ message: "Please login or resest your password", activated: true });
            if (registration && registration.account_status === "pending") return res
              .status(400)
              .json({
                message: "registration is pending activaition please click on the link sent to your email or reguest a new link ",
                activated: false,
              });
            if (!registration) return res.status(200).json({ available: "available" }) ;
        })
    } catch (error) {
      console.log();
      return res.status(500).json(error.message);
    }
})

module.exports = {
    checkEmailExists
}