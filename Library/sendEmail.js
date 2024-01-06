const asyncHandler = require('express-async-handler');
const nodemailer = require('nodemailer');

const mailTransporter = nodemailer.createTransport({
  host: process.env.MAILTRANSPORTER_HOST,
  port: process.env.MAILTRANSPORTER_PORT,
  secure: true,
  auth: {
    user: process.env.MAILTRANSPORTER_EMAIL,
    pass: process.env.MAILTRANSPORTER_PASS,
  },
});

const sendEmail = asyncHandler(async (to, subject, template) => {
    const mailDetails = {
        from: process.env.MAILTRANSPORTER_EMAIL,
        to: to,
        subject: subject,
        html: template
    }
    try {
        await mailTransporter.sendMail(mailDetails);
    } catch (error) {
        console.log('email error', error.message)
    }
})

module.exports = {
    sendEmail
}