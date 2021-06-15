const router = require('express').Router();
const passport = require('passport');
const User = require('../model/User');
const Candidate = require('../model/Candidate');
const { registerAsVoter, registerAsCandidate } = require('../blockchain/contract-functions');
const validateRegisterAsCandidateInput = require('../validators/candidate');
const candidate = require('../validators/candidate');



router.get("/", passport.authenticate('jwt', { session: false }), (req, res) => {
    if (req.query.accountAddress) {
        return User.findOne({ accountAddress: req.query.accountAddress })
            .then((user) => {
                if (user) {
                    return res.send(user.toJSON());
                } else {
                    return res.status(404).send('No user found with given address');
                }
            });
    } else {
        return User.findOne({ email: req.user.email })
            .then((user) => {
                return res.send(user.toJSON());
            });
    }

});

router.put("/register-as-voter", passport.authenticate("jwt", { session: false }), (req, res, next) => {
    return User.findOne(({ _id: req.user.id }))
        .then((user) => {
            if (user.isVoter) {
                return res.status(409).send('Already registered as a voter');
            }
            user.isVoter = true;
            return registerAsVoter(user.accountAddress, user.password)
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
                    if (err.data && err.data.stack) {
                        return res.status(500).send(err.data.stack.substr(0, err.data.stack.indexOf('\n')));
                    }
                    next();
                });
        });
});

router.put("/register-as-candidate", passport.authenticate("jwt", { session: false }), async (req, res, next) => {

    const { errors, isValid } = validateRegisterAsCandidateInput(req.body);

    if (!isValid) {
        return res.status(400).send(errors);
    }

    const user = await User.findOne(({ _id: req.user.id }));

    if (user.isCandidate) {
        return res.status(409).send('Already registered as a candidate');
    }

    const { name, partyName, manifesto } = req.body;

    user.isCandidate = true;

    let candidate = new Candidate({
        name,
        partyName,
        manifesto,
        user
    });

    return registerAsCandidate(user.accountAddress, user.password).then((val) => {
        if (val) {
            candidate.save().then((can) => {
                User.updateOne({ _id: req.user.id }, { $set: { isCandidate: true } })
                    .then((val) => {
                        if (val.ok) {
                            return res.send(can.toJSON());
                        }
                    });
            });
        }
    });
});

module.exports = router;