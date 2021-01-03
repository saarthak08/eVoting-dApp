const assert = require("assert");
const ganache = require("ganache-cli");
const Web3 = require("web3");
const {
	contractABI,
	contractBytecodeObject,
} = require("../utils/eVoting-utils");
const web3 = new Web3(ganache.provider());

let accounts;
let eVoting;

beforeEach(async () => {
	accounts = await new web3.eth.getAccounts();

	eVoting = await new web3.eth.Contract(contractABI)
		.deploy({
			data: contractBytecodeObject,
		})
		.send({ gas: 3000000, from: accounts[0] });
});

describe("eVoting Contract", () => {
	it("deploys a contract", () => {
		assert.ok(eVoting.options.address);
	});
});
