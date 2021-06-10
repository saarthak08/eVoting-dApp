const passport = require('passport');
const router = require('express').Router();
const { getCandidates } = require('../blockchain/contract-functions');
const Candidate = require('../model/Candidate');
const User = require('../model/User');

router.get("/all", passport.authenticate("jwt", { session: false }), (req, res) => {
    getCandidates().then(async (val) => {
        let votesMap = {};
        let candidatesResponse = [];
        for (let i = 0; i < val.length; i++) {
            votesMap[val[i].accountAddress] = {
                votes: val[i].votersCount,
            }
        }
        await Candidate.find({}).populate("user").then((candidates) => {
            candidates.forEach((candidate) => {
                let candidateJSON = candidate.toJSON();
                if (votesMap[candidateJSON.user.accountAddress]) {
                    candidateJSON = { ...candidateJSON, ...votesMap[candidateJSON.user.accountAddress] };
                    candidatesResponse.push(candidateJSON);
                }
            })
        });
        res.send({ candidates: candidatesResponse });
    })
});


router.get("/", passport.authenticate("jwt", { session: false }), (req, res) => {
    if (req.query.accountAddress) {
        return User.findOne({ accountAddress: req.query.accountAddress })
            .then(async (user) => {
                if (user && user.isCandidate) {
                    let bcCandidate;
                    await getCandidates().then((val) => {
                        for (let i = 0; i < val.length; i++) {
                            if (val[i].accountAddress === user.accountAddress) {
                                bcCandidate = {
                                    name: val[i].name,
                                    partyName: val[i].party,
                                    votes: val[i].votersCount,
                                    accountAddress: val[i].accountAddress
                                };
                                break;
                            }
                        }
                    });

                    if (!bcCandidate) {
                        return res.status(404).send("No candidate found!");
                    }

                    return Candidate.findOne({ user: user })
                        .then((candidate) => {
                            return res.send({ ...bcCandidate, ...candidate.toJSON() });
                        })
                } else {
                    return res.status(404).send("No candidate found!");
                }
            })
    } else {
        return res.status(400).send("Account address is required!");
    }
});




module.exports = router;