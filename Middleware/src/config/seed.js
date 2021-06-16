const bcrypt = require('bcrypt');
const { getElectionCommissioner } = require("../blockchain/contract-functions");
const User = require("../model/User");

const addElectionCommissionerUser = async () => {
    const electionComissioner = await getElectionCommissioner();
    User.findOne({ accountAddress: electionComissioner })
        .then((user) => {
            if (!user) {
                let newUser = new User({
                    name: "Election Commissioner",
                    email: "ec@evoting.com",
                    mobileNumber: "0",
                    password: "ec12345",
                    aadharNumber: "0"
                });
                bcrypt.genSalt(10, (err, salt) => {
                    bcrypt.hash(newUser.password, salt, (err, hash) => {
                        if (err) throw err;
                        newUser.password = hash;
                        newUser.accountAddress = electionComissioner;
                        newUser
                            .save().then(() => {
                                console.log('Election Commissioner Added')
                            })
                    });
                });
            }
        })
};


module.exports = addElectionCommissionerUser;