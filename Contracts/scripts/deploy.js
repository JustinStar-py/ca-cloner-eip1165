const hre = require("hardhat");

async function main() {

  const token = await hre.ethers.deployContract('MemeToken');
  await token.waitForDeployment();

  console.log(
    `sucessfully! contract deployed to ${token.target}`
  );
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});