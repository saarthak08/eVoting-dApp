const {web3,fetchDeployerAccount} = require('../../utils/web3');

const addAccount = async (password) => {
    const account = await web3.eth.personal.newAccount(password);
    const deployerAccount = await fetchDeployerAccount();
    console.log(deployerAccount);
	return await web3.eth.sendTransaction(
			{
				from: deployerAccount,
				to: account,
				gas: "3000000",
				value: "1000000000000000000",
				data: "",
			},
			process.env.ACCOUNT_PASSWORD
		);
}

