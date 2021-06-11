const router = require("express").Router();

router.use(require("./auth"));
router.use("/user", require("./user"));
router.use('/candidate', require("./candidate"));
router.use('/voting', require('./voting'));

module.exports = router;