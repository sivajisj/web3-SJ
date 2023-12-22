# web3-SJ
## dapp projects 


curl -L https://foundry.paradigm.xyz | bash
source /home/gitpod/.bashrc
foundryup 

	forge script script/DeploySimpleStorage.s.sol:DeploySimpleStorage --rpc-url $SEPOLIA_RPC_URL --private-key $PRIVATE_KEY --broadcast --verify --etherscan-api-key $ETHERSCAN_API_KEY -vvvv
 forge script/Interactions.s.sol:FundSubscription