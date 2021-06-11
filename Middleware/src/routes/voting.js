const router = require('express').Router();
const passport = require('passport');
const bcrypt = require('bcrypt');
const { getElectionCommissioner, vote, getTotalVotersCount, getTotalVotesCount, isVoter, getCandidates } = require('../blockchain/contract-functions');
const User = require('../model/User');
const candidate = require('../validators/candidate');
const validateVotingInputs = require('../validators/voting');


router.get('/election-commissioner', passport.authenticate('jwt', { session: false }), (req, res) => {
    getElectionCommissioner().then((electionCommissioner) => {
        return res.send({ electionCommissioner: electionCommissioner });
    })
});

router.get('/total-votes', passport.authenticate('jwt', { session: false }), (req, res) => {
    getTotalVotesCount().then((votes) => {
        return res.send({ totalVotes: votes });
    });
});

router.get('/voters-count', passport.authenticate('jwt', { session: false }), (req, res) => {
    getTotalVotersCount().then((voters) => {
        return res.send({ votersCount: voters });
    })
});

router.get('/voters', passport.authenticate('jwt', { session: false }), async (req, res) => {
    let users = [];
    await User.find({ isVoter: true }).then(async (dbUsers) => {
        for (user of dbUsers) {
            const val = await isVoter(user.accountAddress);
            if (val) {
                users.push(user);
            }
        }
    });
    return res.send({ voters: users });
});

router.post('/vote', passport.authenticate('jwt', { session: false }), async (req, res) => {
    const { errors, isValid } = validateVotingInputs(req.body);

    if (!isValid) {
        return res.status(400).send(errors);
    }

    const { password, candidateAddress } = req.body;

    const isMatch = await bcrypt.compare(password, req.user.password);

    if (!isMatch) {
        return res.status(401).send('Unauthorized');
    }

    let candidate;
    let index;

    await getCandidates().then((candidates) => {
        for (let i = 0; i < candidates.length; i++) {
            if (candidates[i].accountAddress === candidateAddress) {
                candidate = candidates[i];
                index = i;
                break;
            }
        }
    });

    if (!candidate) {
        return res.status(404).send('No candidate found with given address');
    }

    vote(req.user.accountAddress, candidateAddress, index, req.user.password).then((val) => {
        if (val) {
            return res.send('Successfully voted');
        } else {
            return res.status(500).send("An error occurred");
        }
    }).catch((err) => {
        return res.status(500).send(err.data.stack.substring(0, err.data.stack.indexOf("\n")));
    });
});

module.exports = router;