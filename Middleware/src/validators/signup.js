const validator = require('validator');
const isEmpty = require('./is-empty');

module.exports = function validateSignupInput(data) {
    let errors = {};

    data.name = isEmpty(data.name) ? "" : data.name;
    data.email = isEmpty(data.email) ? "" : data.email;
    data.password = isEmpty(data.password) ? "" : data.password;
    data.confirmPassword = isEmpty(data.confirmPassword) ? "" : data.confirmPassword;
    data.mobileNumber = isEmpty(data.mobileNumber) ? "" : data.mobileNumber;
    data.aadharNumber = isEmpty(data.aadharNumber) ? "" : data.aadharNumber;

    //name
    if (!validator.isLength(data.name, { min: 2, max: 30 })) {
        errors.name = "Name must be between 2 and 30 characters";
    }

    if (validator.isEmpty(data.name)) {
        errors.name = "Name is required";
    }

    //email
    if (!validator.isEmail(data.email)) {
        errors.email = "Email is invalid";
    }

    if (validator.isEmpty(data.email)) {
        errors.email = "Email is required";
    }

    //password
    if (!validator.isLength(data.password, { min: 6, max: 30 })) {
        errors.password = "Password must be between 6 and 30 characters";
    }

    if (validator.isEmpty(data.password)) {
        errors.password = "Password is required";
    }

    //confirm password
    if (!validator.equals(data.password, data.confirmPassword)) {
        errors.confirmPassword = "Password must match";
    }

    if (validator.isEmpty(data.confirmPassword)) {
        errors.confirmPassword = "Confirm Password is required";
    }

    if (validator.isEmpty(data.mobileNumber)) {
        errors.mobileNumber = "Mobile Number is requrired";
    }

    if (!validator.isMobilePhone(data.mobileNumber, 'en-IN')) {
        errors.mobileNumber = "Not a valid mobile number";
    }

    if (validator.isEmpty(data.aadharNumber)) {
        errors.aadharNumber = "Aadhar Number is required";
    }

    if (!validator.isNumeric(data.aadharNumber)) {
        errors.aadharNumber = "Not a valid Aadhar Number";
    }

    if (!validator.isLength(data.aadharNumber, { min: 12, max: 12 })) {
        errors.aadharNumber = "Not a valid Aadhar Number";
    }

    return {
        errors,
        isValid: isEmpty(errors),
    };
};