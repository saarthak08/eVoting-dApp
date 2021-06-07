const mongoose = require("mongoose");

const userSchema = mongoose.Schema({
    name: {
        type: String,
        required: true
    },
    email: {
        type: String,
        required: true
    },
    password: {
        type: String,
        required: true
    },
    mobileNumber: {
        type: Number,
        required: true
    },
    aadharNumber: {
        type: Number,
        required: true
    },
    isVoter: {
        type: Boolean,
        default: false
    },
    isCandidate: {
        type: Boolean,
        default: false
    },
    accountAddress: {
        type: String,
        required: true
    }

});

module.exports = User = mongoose.model("User", userSchema);