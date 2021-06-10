const router = require("express").Router();

router.use(require("./auth"));
router.use("/user", require("./user"));
router.use('/candidate', require("./candidate"));

module.exports = router;