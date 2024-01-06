const asyncHandler = require('express-async-handler');
const { PrismaClient } = require('@prisma/client');
const { agentDetails } = require('../../Helpers/routeHelper');
const emailExist = require('../../Helpers/auth/CheckEmail');
const { createTempRegistration } = require('../../Helpers/auth/CreateTempRegistration');
const { sendEmail } = require('../../Library/sendEmail');
const signUpTemple = require('../../emailTemplates/signUp');
const prisma = new PrismaClient();


const registerUser = asyncHandler(async (req, res, next) => {
    try {
        await prisma.$transaction(async (PrismaClient) => {
            const { ipAddress, useragent } = agentDetails;

            const checkEmail = await emailExist(req.body.email, PrismaClient);
            if (checkEmail) return res.status(200).json(checkEmail.message);

            const createTempReg = await createTempRegistration(req.body, 'user', PrismaClient);
            if (!createTempReg) return res.status(400).json('could not create resource');

            await PrismaClient.sign_up.create({
                data: {
                    holding_id: createTempReg.id,
                    email: req.body.email,
                    sign_up_ip_address: ipAddress,
                    sign_up_agent: useragent
                }
            });
            const fullName = `${req.body.firstName} ${req.body.lastName}`;
            if(createTempReg) await sendEmail(req.body.email, 'Welcome to Roll In & Retreat!',signUpTemple(fullName, createTempReg.link,))

            res.status(201).json(createTempReg)
        })
    } catch (error) {
      console.error(error);
      res.status(500).json({ error: "Internal Server Error" });
    }
})

module.exports = {
    registerUser
}