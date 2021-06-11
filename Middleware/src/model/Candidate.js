const mongoose = require('mongoose');

const candidateSchema = mongoose.Schema({
    name: {
        type: String,
        required: true
    },
    partyName: {
        type: String,
        required: true
    },
    manifesto: {
        type: String,
        required: true
    },
    user: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'User',
        required: true,
        unique: true
    }
});

candidateSchema.methods.toJSON = function () {
    var obj = this.toObject();
    delete obj.__v;
    obj.id = obj._id;
    delete obj._id;
    delete obj.user.password;
    delete obj.user.__v;
    obj.id = obj.user._id;
    delete obj.user._id;
    return obj;
}

module.exports = User = mongoose.model("Candidate", candidateSchema);