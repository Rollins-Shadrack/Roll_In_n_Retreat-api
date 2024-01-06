const asyncHandler = require("express-async-handler");
const { decryptData } = require("../../Library/cryptoFunctions");
const { checkAccountStatus } = require("../../Helpers/routeHelper");
const { PrismaClient } = require("@prisma/client");
const prisma = new PrismaClient();
const bcrypt = require("bcryptjs");

const confirmUser = asyncHandler(async (req, res, next) => {
  try {
    const { token, password, confirmPassword } = req.body;
    if (!password || !confirmPassword) return res.status(400).json({ success: false, message: "password and confirm password are required" });
    if (password !== confirmPassword) return res.status(400).json({ success: false, message: "password and confirm password do not match" });

    const ipAddress = req.header("x-forwarded-for") || req.socket.remoteAddress;
    const { regId, email } = decryptData(token);
    const accountCheck = await checkAccountStatus(prisma, token);

    if (accountCheck.status) return res.status(accountCheck.status).json(accountCheck.message);

    const getAccountInfo = await prisma.hold.findFirst({ where: { registration_id: regId, email } });

    if (!getAccountInfo) return res.status(404).json("registeration not found please register again");

    const { accountInfo } = accountCheck;

    const userTransaction = await prisma.$transaction(async () => {
      const hashedPassword = await bcrypt.hash(password, 10);

      const userDetails = await prisma.account.create({
        data: {
          email: accountInfo.email,
          entity: accountInfo.entity,
          is_social_login: false,
          is_active: true,
          is_verified: false,
          is_email_verified: true,
          password: hashedPassword,
          user: {
            create: {
              first_name: accountInfo.account_data.firstName,
              last_name: accountInfo.account_data.lastName,
              mobile_number: accountInfo.account_data.mobileNumber,
              user_profile: {
                create: {},
              },
            },
          },
        },
      });
        return userDetails;
    });
      await prisma.sign_up.update({
          where: { holding_id: accountInfo.id },
          data: { confirmation_agent: req.useragent, confirmation_ip_address: ipAddress, process_completed: true }
      })

      await prisma.hold.update({ where: { id: accountInfo.id }, data: { account_status: 'confirmed' } });

      if (userTransaction) {
          res.status(200).json({message:'Account Confirmation was successufull'})
      }
  } catch (error) {
    console.log(error.message);
    res.status(500).json({ error: "Internal Server Error" });
  }
});

module.exports = {
  confirmUser,
};
