const mongoose = require("mongoose");

const userSchema = mongoose.Schema({
    name: {
        type: String,
        required: true,
    },
    email: {
        type: String,
        required: true,
        unique: true
    },
    password: {
        type: String,
        required: true
    },
    mobileNumber: {
        type: Number,
        required: true,
        unique: true
    },
    aadharNumber: {
        type: Number,
        required: true,
        unique: true
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
        required: true,
        unique: true
    }

});

userSchema.methods.toJSON = function () {
    var obj = this.toObject();
    delete obj.password;
    delete obj.__v;
    obj.id = obj._id;
    delete obj._id;
    return obj;
}

module.exports = User = mongoose.model("User", userSchema);