const { web3 } = require("./web3");
const { contractAddress, contractABI } = require("./eVoting-utils");

module.exports = new web3.eth.Contract(contractABI, contractAddress);
