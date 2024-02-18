const asyncHandler = require("express-async-handler");
const { decryptData } = require("../../Library/cryptoFunctions");
const { checkAccountStatus, resetStatus } = require("../../Helpers/routeHelper");
const { PrismaClient } = require("@prisma/client");
const prisma = new PrismaClient();
const bcrypt = require("bcryptjs");
const { sendEmail } = require("../../Library/sendEmail");
const confirmationLinkTemplate = require("../../emailTemplates/confirmationLinkTemplate");

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


const confirmPartner = asyncHandler(async (req, res, next) => {
  try {
    const { token, password, staffCount, partnerAddress } = req.body;

    const ipAddress = req.header("x-forwarded-for") || req.socket.remoteAddress;

    const { regId, email } = decryptData(token)
    
    const accountCheck = await checkAccountStatus(prisma, token);

    if (accountCheck.status) return res.status(accountCheck.status).json(accountCheck.message);

    const getAccountInfo = await prisma.hold.findFirst({
      where: {
        registration_id: regId,
        email
      }
    });
    if (!getAccountInfo) return res.status(404).json({ message: "registration was not found, please register again" })
    
    const { accountInfo } = accountCheck;

    const partnerTransaction = await prisma.$transaction(async () => {
      const hashedPassword = await bcrypt.hash(password, 10);

      const address = await prisma.address.create({
        data: {
          address_line1: partnerAddress.addressLine1,
          postal_code: partnerAddress.postalCode,
        },
      });

      const partnerDetails = await prisma.account.create({
        data: {
          email: accountInfo.email,
          entity: accountInfo.entity,
          is_social_login: false,
          is_active: true,
          is_verified: false,
          is_email_verified: true,
          password: hashedPassword,
          partner: {
            create: {
              business_name: accountInfo.account_data.businessName,
              first_name: accountInfo.account_data.firstName,
              last_name: accountInfo.account_data.lastName,
              mobile_number: accountInfo.account_data.mobileNumber,
              staff_count: staffCount,
              city_id: accountInfo.account_data.city,
              partner_address_id: address.id,
              staff: {
                create: {
                  first_name: accountInfo.account_data.firstName,
                  last_name: accountInfo.account_data.lastName,
                  email: accountInfo.email,
                  mobile_number: accountInfo.account_data.mobileNumber,
                  is_super_admin: true,
                  staff_address_id:address.id,
                  staff_profile: {
                    create:{}
                  }
                },
              },
            },
          },
        },
      });

      const partnerwithRelations = await prisma.account.findUnique({
        where: { id: partnerDetails.id },
        include: {
          partner: {
            include: {
              staff: {
                include: {
                  staff_profile:true
                }
              }
            }
          }
        }
      })

      return partnerwithRelations;
    })

    await prisma.sign_up.update({
      where: { holding_id: accountInfo.id },
      data: { confirmation_agent: req.useragent, confirmation_ip_address: ipAddress, process_completed: true },
    });

    await prisma.hold.update({ where: { id: accountInfo.id }, data: { account_status: "confirmed" } });

    console.log(partnerTransaction)

    if (partnerTransaction) {
      await prisma.staff.update({
        where: { id: partnerTransaction.partner.staff.id },
        data: { account_id: partnerTransaction.id },
      });
      console.log("Account Confirmation was successufull");
      res.status(200).json({ message: "Account Confirmation was successufull" });
    }
  } catch (error) {
    console.log(error);
    res.status(500).json({ message: "Internal server error" });
  }
})


const forgotPassword = asyncHandler(async (req, res, next) => {
  try {
    const { email } = req.body;
    if (!email) return res.status(400).json({ message: "Email is required" });

    const user = await prisma.account.findUnique({
      where:{email}
    })

    if (!user) return res.status(401).json({ message: "Account does not exist", success: false });
    const accountStatus = resetStatus(email, prisma)

    if (accountStatus && accountStatus.success === false) {
      return res.status(400).json({ error: accountStatus.message });
    }
    const frontendurl = process.env.FRONTEND_URL;
    const link = `${frontendurl}/auth/confirmation?email=${email}`;
    
    await sendEmail(email, 'Here is your reset password link!', confirmationLinkTemplate(link));

    res.status(200).json({message:"Reset Password link has been sent to your email"})
  } catch (error) {
    console.log(error)
    res.status(500).json({message:"Internal server error"})
  }
})

const resetPassword = asyncHandler(async (req, res) => {
  const { email, password, confirmPassword } = req.body;
  if (!password || !confirmPassword) return res.status(400).json({ success: false, message: "password and confirm password are required" });
  if (password !== confirmPassword) return res.status(400).json({ success: false, message: "password and confirm password do not match" });

  const account = await prisma.account.findUnique({ where: { email } });

  if (!account) return res.status(404).json({ success: false, message: "Account not found" });

  const hashedPassword = await bcrypt.hash(password, 10);

  const update = await prisma.account.update({
    where: { id: account.id },
    data: {
      password:hashedPassword
    }
  })

if(update) return res.status(200).json({success:true, message:"Password reset was successfully"})
})
module.exports = {
  confirmUser,
  confirmPartner,
  forgotPassword,
  resetPassword
};
