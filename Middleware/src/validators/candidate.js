const validator = require('validator');
const isEmpty = require('./is-empty');

module.exports = function validateRegisterAsCandidateInput(data) {
    let errors = {};

    data.name = isEmpty(data.name) ? "" : data.name;
    data.partyName = isEmpty(data.partyName) ? "" : data.partyName;
    data.manifesto = isEmpty(data.manifesto) ? "" : data.manifesto;


    if (validator.isEmpty(data.name)) {
        errors.name = "Name is required";
    }

    if (validator.isEmpty(data.partyName)) {
        errors.partyName = "Party Name is required";
    }

    if (validator.isEmpty(data.manifesto)) {
        errors.manifesto = "Manifesto is required";
    }

    return {
        errors,
        isValid: isEmpty(errors),
    };
};