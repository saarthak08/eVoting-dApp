const validator = require('validator');
const isEmpty = require('./is-empty');

module.exports = function validateVoteInput(data) {
    let errors = {};

    data.candidateAddress = isEmpty(data.candidateAddress) ? "" : data.candidateAddress;
    data.password = isEmpty(data.password) ? "" : data.password;


    if (validator.isEmpty(data.candidateAddress)) {
        errors.candidateAddress = "Candidate Address is required";
    }

    if (validator.isEmpty(data.password)) {
        errors.password = "Password is required";
    }

    return {
        errors,
        isValid: isEmpty(errors),
    };
};