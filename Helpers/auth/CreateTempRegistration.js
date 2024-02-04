const { PrismaClient } = require('@prisma/client')
const asyncHandler = require('express-async-handler')
const { v4: uuid } = require("uuid");
const { encryptData } = require('../../Library/cryptoFunctions');
const { addWeeks } = require("date-fns");

const timestamp = Date.now();
const currentDate = new Date();
const createTempRegistration = asyncHandler(async (req, entity, PrismaClient) => {
    const api = process.env.BACKEND_API;
    const frontendUrl = process.env.FRONTEND_URL;

    const { cityId, ...resdata } = req;
    const registrationId = uuid();
    const encryptedToken = encryptData({ regId: registrationId, timestamp, email: req.email });
    const confirmationUrl = `${api}/account/confirmation?token=${encryptedToken}`;
    const confirmationLink =
      entity === "user" ? `${frontendUrl}/auth/confirmation?token=${encryptedToken}` : `${frontendUrl}/onboard/profile?token=${encryptedToken}`;

    const temp = await PrismaClient.hold.create({
        data: {
            email: req.email,
            token: encryptedToken,
            entity: entity,
            registration_date: currentDate,
            expiration_date: addWeeks(currentDate, 1),
            registration_id: registrationId,
            account_data: resdata,
            link: confirmationLink
        }
    })

    return temp;

})

module.exports = {
  createTempRegistration,
};