const router = require('express').Router();
const passport = require('passport');
const User = require('../model/User');
const { registerAsVoter, registerAsCandidate } = require('../blockchain/contract-functions');



router.get("/", passport.authenticate('jwt', { session: false }), (req, res) => {
    User.findOne({ email: req.user.email })
        .then((user) => {
            return res.send(user.toJSON());
        })

});

router.put("/registerAsVoter", passport.authenticate("jwt", { session: false }), (req, res) => {
    User.findOne(({ _id: req.user.id }))
        .then((user) => {
            if (user.isVoter) {
                return res.status(409).send('Already registered as voter');
            }
            user.isVoter = true;
            registerAsVoter(user.accountAddress, user.password)
                .then((val) => {
                    if (val) {
                        User.updateOne({ _id: req.user.id }, { $set: { isVoter: true } })
                            .then((val) => {
                                if (val.ok) {
                                    return res.send(user.toJSON());
                                }
                            });
                    }
                }).catch((err) => {
                    return res.status(500).send(err.data.stack.substr(0, err.data.stack.indexOf('\n')));
                });
        });
});

module.exports = router;