const router = require("express").Router();

router.use(require("./auth"));
router.use("/user", require("./user"));

module.exports = router;