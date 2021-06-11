const router = require("express").Router();
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');
const keys = require('../config/keys');
const { addAccount } = require("../blockchain/web3-functions");
const User = require("../model/User");
const validateSignupInput = require('../validators/signup');
const validateLoginInput = require('../validators/login');




router.post("/signup", async (req, res) => {
  const { errors, isValid } = validateSignupInput(req.body);

  if (!isValid) {
    return res.status(400).json(errors);
  }

  const {
    name,
    email,
    mobileNumber,
    password,
    aadharNumber
  } = req.body;

  // Verification to Aadhar Authentication API should take place.

  const dbUser = await User.findOne({
    $or: [
      {
        email
      },
      {
        aadharNumber
      },
      {
        mobileNumber
      }
    ]
  });

  if (dbUser) {
    return res.status(409).send("A user already exists with same email or aadhar number or mobile number");
  }

  //sending verification code to the user email
  //sendVerifyCode(email);

  let newUser = new User({
    name,
    email,
    mobileNumber,
    password,
    aadharNumber
  });

  bcrypt.genSalt(10, (err, salt) => {
    bcrypt.hash(newUser.password, salt, (err, hash) => {
      if (err) throw err;
      newUser.password = hash;
      addAccount(hash).then((val) => {
        newUser.accountAddress = val;
        newUser
          .save()
          .then((user) => res.send(user.toJSON()))
      });
    });
  });
});


//login route
router.post("/login", (req, res) => {
  const { errors, isValid } = validateLoginInput(req.body);

  if (!isValid) {
    return res.status(400).json(errors);
  }

  return User.findOne({ email: req.body.email }).then((user) => {
    //checking for user
    if (!user) {
      errors.email = "No user found!";
      return res.status(404).json(errors);
    }

    //check password
    bcrypt.compare(req.body.password, user.password).then((isMatch) => {
      if (isMatch) {
        //creating jwt payload
        const payload = {
          id: user.id,
          name: user.name,
          email: user.email,
        };

        //jwt signature
        jwt.sign(
          payload,
          keys.secretOrKey,
          { expiresIn: "1d" },
          (err, token) => {
            res.json(
              "Bearer " + token,
            );
          }
        );
      } else {
        errors.password = "Incorrect password!";
        return res.status(401).json(errors);
      }
    })
  })
});


module.exports = router;