const { PrismaClient } = require("@prisma/client");
const prisma = new PrismaClient();
const jwt = require("jsonwebtoken");
const asyncHandler = require("express-async-handler");

const handleRefreshtoken = asyncHandler(async (req, res, next) => {
  const { refreshToken } = req.body;
  const foundUser = await prisma.account.findFirst({
    where: {
      refresh_token: {
        has: refreshToken,
      },
    },
    include: {
      partner: true,
      staff:true
    }
  });

  if (!foundUser) return res.sendStatus(403);

  jwt.verify(refreshToken, process.env.REFRESH_TOKEN_SECRET, (err, decoded) => {
    if (err || foundUser.email !== decoded.userInfo.email) return res.sendStatus(403);
    const accessToken = jwt.sign(
      {
        role: decoded.role,
        userInfo: {
          email: foundUser.email,
        },
      },
      process.env.ACCESS_TOKEN_SECRET,
      { expiresIn: "1d" }
    );
    res.status(200).json({ user: foundUser, accessToken, role: decoded.role });
  });
});

module.exports = {
  handleRefreshtoken,
};
