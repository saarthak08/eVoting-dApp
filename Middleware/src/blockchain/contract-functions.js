const { web3 } = require("../../utils/web3");
const eVoting = require("../../utils/eVoting");

const getTotalVotes = async () => {
	return await eVoting.methods
		.totalVotesCount()
		.call();
};

