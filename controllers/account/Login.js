const asyncHandler = require("express-async-handler");
const { PrismaClient } = require("@prisma/client");
const prisma = new PrismaClient();
const bcrypt = require("bcryptjs");
const jwt = require("jsonwebtoken");

const loginUser = asyncHandler(async (req, res, next) => {
  try {
    const { email, password } = req.body;
    console.log(req.body);
    if (!email || !password) return res.status(400).json({ message: "Email and password are required" });

    const foundUser = await prisma.account.findFirst({
      where: { email },
      include: {
        user: true,
      },
    });

    if (!foundUser) return res.status(404).json({ message: "User not found" }); //not found
    const match = await bcrypt.compare(password, foundUser.password);

    if (!match) return res.status(400).json({ message: "Incorrect email or Password" });

    const accessToken = jwt.sign(
      {
        userInfo: {
          email: foundUser.email,
        },
      },
      process.env.ACCESS_TOKEN_SECRET,
      { expiresIn: "1d" }
    );

    const refreshToken = jwt.sign(
      {
        email: foundUser.email,
      },
      process.env.REFRESH_TOKEN_SECRET,
      { expiresIn: "1d" }
    );

    await prisma.account.update({
      where: { email },
      data: {
        refresh_token: [refreshToken],
      },
    });

    res.cookie("authjwt", refreshToken, { httpOnly: true, secure: true, sameSite: "none", maxAge: 24 * 60 * 60 * 1000 });

    console.log('supossed to send these info')
    res.json({ data: { user: foundUser.id, accessToken, refreshToken } });
    console.log("sent")
  } catch (error) {
    console.log(error.message);
    res.status(500).json({ message: "Internal server error" });
  }
});


module.exports = {
  loginUser,
};
