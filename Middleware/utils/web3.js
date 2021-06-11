require("dotenv").config();

const Web3 = require("web3");

let web3;

if (process.env.NODE_ENV === "development") {
	web3 = new Web3(
		new Web3.providers.HttpProvider("http://127.0.0.1:7545")
	);
} else {
	web3 = new Web3(
		new Web3.providers.WebsocketProvider("ws://" + "127.0.0.1" + ":" + "8546")
	);
}

let account;

const fetchDeployerAccount = async () => {
	if (account === undefined) {
		return await web3.eth.getAccounts().then((val) => {
			account = val[0];
			return val[0];
		});
	} else {
		return account;
	}
};

module.exports = { fetchDeployerAccount, web3 };
