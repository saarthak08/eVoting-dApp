const eVoting = artifacts.require("eVoting");

module.exports = function (deployer) {
	deployer.deploy(eVoting);
};
