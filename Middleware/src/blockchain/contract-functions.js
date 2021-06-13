const { web3 } = require("../../utils/web3");
const eVoting = require("../../utils/eVoting");
const { unlockAccount } = require("./web3-functions");

const getTotalVotesCount = async () => {
	return await eVoting.methods.totalVotesCount().call();
};

const getTotalVotersCount = async () => {
	return await eVoting.methods.totalVotersCount().call();
};

const getTotalCandidatesCount = async () => {
	return await eVoting.methods.totalCandidatesCount().call();
};

const getFeesForCandidates = async () => {
	return await eVoting.methods.feesForCandidates().call();
};

const getFeesForVoters = async () => {
	return await eVoting.methods.feesForVoters().call();
};

const getCandidates = async () => {
	return await eVoting.methods.getCandidates().call();
};

const isVoter = async (address) => {
	return await eVoting.methods.totalVotersList(address).call();
};

const isCandidate = async (address) => {
	return await eVoting.methods.candidatesMap(address).call();
};

const hasVoted = async (address) => {
	return await eVoting.methods.votedList(address).call();
};

const getElectionCommissioner = async () => {
	return await eVoting.methods.electionCommissioner().call();
};

const isVotingStarted = async () => {
	return await eVoting.methods.isVotingStarted().call();
}

const registerAsVoter = async (address, password) => {
	await unlockAccount(address, password);
	return await eVoting.methods
		.registerAsVoter()
		.send({ from: address, gas: "3000000" });
};

const startVoting = async (address, password) => {
	await unlockAccount(address, password);
	return await eVoting.methods
		.startVoting()
		.send({ from: address, gas: "3000000" });
}

const stopVoting = async (address, password) => {
	await unlockAccount(address, password);
	return await eVoting.methods
		.stopVoting()
		.send({ from: address, gas: "3000000" });
}

const registerAsCandidate = async (address, password) => {
	await unlockAccount(address, password);
	return await eVoting.methods.registerAsCandidate().send({
		from: address,
		value: "50000000000000000",
		gas: "3000000",
	});
};

const vote = async (voterAddress, candidatesAddress, index, password) => {
	await unlockAccount(voterAddress, password);
	return await eVoting.methods.vote(candidatesAddress, index).send({
		from: voterAddress,
		value: "800000000000000000",
		gas: "3000000",
	});
};

module.exports = {
	getTotalVotersCount,
	getCandidates,
	getElectionCommissioner,
	getFeesForCandidates,
	getFeesForVoters,
	getTotalCandidatesCount,
	getTotalVotesCount,
	isCandidate,
	isVoter,
	registerAsCandidate,
	registerAsVoter,
	vote,
	hasVoted,
	startVoting,
	stopVoting,
	isVotingStarted
};
