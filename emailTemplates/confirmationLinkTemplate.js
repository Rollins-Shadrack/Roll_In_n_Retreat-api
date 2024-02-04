const template = `<!DOCTYPE html>
<html>
<head>
  <style>
    body {
      font-family: Arial, sans-serif;
      background-color: #f4f4f4;
      margin: 0;
      padding: 0;
    }
    .container {
      background-color: #ffffff;
      max-width: 600px;
      margin: 0 auto;
      padding: 20px;
      border: 1px solid #dddddd;
    }
    .header {
      text-align: center;
      font-size: 24px;
      color: #333333;
      margin-bottom: 20px;
    }
    .content {
      font-size: 16px;
      color: #333333;
      line-height: 1.5;
    }
    .footer {
      font-size: 14px;
      color: #999999;
      text-align: center;
      margin-top: 30px;
    }
  </style>
</head>
<body>
  <div class="container">
    <div class="header">
      {{headerText}}
    </div>
    <div class="content">
      Thank you for joining our community. We appreciate your support and look forward to providing you with valuable content.
      <br><br>
      <a href="{{confirmationLink}}" target="_blank">Click here to confirm your account</a>
    </div>
    <div class="footer">
      {{footerText}}
    </div>
  </div>
</body>
</html>
`;

const confirmationLinkTemplate = function (confirmationLink) {
  return template
    .replace("{{headerText}}", "Welcome to RollIn & Retreat !")
    .replace(
      "{{bodyText}}",
      "Thank you for joining our community. We appreciate your support and look forward to providing you with valuable services."
    )
    .replace("{{footerText}}", "© 2024 MyWebsite. All rights reserved.")
    .replace("{{confirmationLink}}", confirmationLink);
};

module.exports = confirmationLinkTemplate;
