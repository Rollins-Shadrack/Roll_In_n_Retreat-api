const template = `<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Welcome to Roll In & Retreat</title>
    <style>
      body {
        font-family: Arial, sans-serif;
        margin: 20px;
      }

      .container {
        max-width: 600px;
        margin: 0 auto;
        padding: 20px;
        border: 1px solid #ddd;
        background-color: #ffffff;
      }

      .logo {
        display: block;
        margin: 0 auto 20px auto;
        height: 250px;
      }

      .footer-text {
        color: #888;
        font-size: 12px;
      }

      .highlight {
        color: red;
      }
    </style>
  </head>
  <body>
    <div class="container">
      <img src="./logobg.png" alt="rollinretreat" class="logo" />

      <p>Hi {{name}},</p>

      <p>Thank you for registering on Roll In & Retreat! We appreciate your interest in our platform.</p>

      <p>
        To complete your account setup, please click on the link below. This will allow you to set up a new password and provide essential details
        about your business:
      </p>

      <a href="{{reset_link}}">Set up Account</a>

      <p>During the setup, you'll be able to:</p>
      <ul>
        <li>Provide the exact location of your business (Clients will only get your exact address once they book your service).</li>
        <li>Select the number of staff you have to manage your operations effectively.</li>
      </ul>

      <p>We look forward to having you on board and wish you success with your business on Roll In & Retreat!</p>
<p>Your new password must:</p>
      <ul>
        <li>Contain 8-36 characters</li>
        <li>Contain at least one mixed-case letter</li>
        <li>Contain at least one number</li>
        <li>Not be the same as your Screen Name</li>
      </ul>

      <p>
        This link will expire in 48 hours. After that, you'll need to submit a new request in order to complete your set up. If you don't want to
        create an account, simply disregard this email.
      </p>

      <p>
        If you need more help or believe this email was sent in error, feel free to
        <a href="{{contact_link}}" class="highlight">contact us</a>.<br /><span class="footer-text"
          >(Please don't reply to this message; it's automated.)</span
        >
      </p>

      <p>Thanks,</p>
      <p>Roll In & Retreat.com</p>
    </div>
  </body>
</html>

`;

const partnerOnboardTemple = function (name, resetLink, contactLink) {
  return template.replace("{{name}}", name).replace("{{reset_link}}", resetLink).replace("{{contact_link}}", contactLink);
};
module.exports = partnerOnboardTemple;
