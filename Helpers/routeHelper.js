const asyncHandler = require('express-async-handler')
const { decryptData } = require('../Library/cryptoFunctions')
const agentDetails = function (req) {
    return {
        ipAddress: req.header('x-forwarded-for') || req.socket.remoteAddress,
        useragent: req.useragent,
        timestamp,
        currentDate
    }
}

const checkAccountStatus = asyncHandler(async (prismaClient, token) => {
    const { regId, timestamp, email } = decryptData(token);

    const getAccountInfo = await prismaClient.hold.findFirst({ where: { registration_id: regId, email } });

    if (!getAccountInfo) return { status: 404, message: email };

    const accountStatus = getAccountInfo.account_status;
    const now = Date.now();
    const isExpired = now > Date.parse(getAccountInfo?.expiration_date);
    const isLinkExpired = now - timestamp > process.env.LINK_EXPIRATION_IN_SECONDS;

    if (accountStatus === 'confirmed') {
        return { status: 404, message: 'account has already been activated please login or reset your password' };
    } else if (isExpired) {
        await prismaClient.hold.delete({ where: { registration_id: regId, email } });
        return { status: 404, message: 'registration has been deleted due to inactivity please re-register' };
    } else if (isLinkExpired) {
        return { status: 404, message: 'Link has expired please request a new link' };
    } else if (accountStatus === 'suspended') {
        return {status:404, message:'Registration suspended due to term and condition violation'}
    }

    return { status: null, message: null, accountInfo: getAccountInfo };
})

module.exports = {
  agentDetails,
  checkAccountStatus,
};