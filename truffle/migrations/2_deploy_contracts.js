var FlensCoin = artifacts.require("./FlensCoin.sol");
module.exports = function (deployer) {
  deployer.deploy(FlensCoin);
};
