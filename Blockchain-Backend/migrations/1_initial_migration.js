const Migrations = artifacts.require("Migrations");
const Web3 = require("web3");
const TruffleConfig = require("../truffle-config");

module.exports = async function (deployer, network, accounts) {
    const config = TruffleConfig.networks[network];
    const web3 = new Web3(
        new Web3.providers.WebsocketProvider(
            "ws://" + config.host + ":" + config.port
        )
    );

    if (network !== "development") {
        await web3.eth.personal.unlockAccount(config.from, "", 36000);
    }

    deployer.deploy(Migrations);
};
