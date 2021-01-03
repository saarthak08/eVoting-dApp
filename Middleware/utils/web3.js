require("dotenv").config();

const Web3 = require("web3");

const web3 = new Web3(
	new Web3.providers.WebsocketProvider("ws://" + "127.0.0.1" + ":" + "8546")
);

let account;

const fetchDeployerAccount = async () => {
	if (account === undefined) {
		return await web3.eth.getAccounts().then((val) => {
			account = val;
			return val;
		});
	} else {
		return account;
	}
};

module.exports = { fetchDeployerAccount, web3 };
