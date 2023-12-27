// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/proxy/Clones.sol";
import "@openzeppelin/contracts/proxy/utils/Initializable.sol";

contract CloneFactory {
    address[] public totalContracts;

    uint256 public feePoolPrice = 0.1 ether;
    address public companyAcc = 0x54a6963429c65097E51d429662dC730517e630d5;

    function createClone(address _owner, address _targetContract, 
        string memory tokenName, string memory tokenSymbol, uint8 tokenDecimals,
        address payable marketingWallet, address payable teamWallet, uint56[] memory tokenTaxable, uint56[] memory tokenConfiguration) external payable returns (address) {
        require(msg.value >= feePoolPrice, "Payment failed! the amount is less than expected.");
        require(payTo(companyAcc, msg.value));

        address clone = Clones.clone(_targetContract);
        InitialToken(clone).initialize(_owner,
            tokenName, tokenSymbol, tokenDecimals,
            marketingWallet, teamWallet, 
            tokenTaxable, tokenConfiguration);

        totalContracts.push(clone);
        return clone;
    }

    function payTo(address _to, uint256 _amount) internal returns (bool) {
        (bool success,) = payable(_to).call{value: _amount}("");
        require(success, "Payment failed");
        return true;
    }

    function returnTotalContracts() public view returns (address[] memory) {
        return totalContracts;
    }
}

contract InitialToken is Initializable {    
    string public _name;
    string public _symbol;
    uint8 public _decimals = 18;

    address payable public marketingWalletAddress = payable(0xeBb61C24FbeF54C8EC08bcE722Bce88cB5Efa89F); 
    address payable public teamWalletAddress = payable(0xeBb61C24FbeF54C8EC08bcE722Bce88cB5Efa89F);
    address public immutable deadAddress = 0x000000000000000000000000000000000000dEaD;
    
    mapping (address => uint256) _balances;
    mapping (address => mapping (address => uint256)) private _allowances;
    
    mapping (address => bool) public isExcludedFromFee;
    mapping (address => bool) public isWalletLimitExempt;
    mapping (address => bool) public isTxLimitExempt;
    mapping (address => bool) public isMarketPair;
 
    uint256 public _buyLiquidityFee = 0;
    uint256 public _buyMarketingFee = 2;
    uint256 public _buyTeamFee = 0;
    
    uint256 public _sellLiquidityFee = 0;
    uint256 public _sellMarketingFee = 2;
    uint256 public _sellTeamFee = 0;

    uint256 public _liquidityShare = 0; 
    uint256 public _marketingShare = 100;
    uint256 public _teamShare = 0; 

    uint256 public _totalTaxIfBuying = _buyLiquidityFee + _buyMarketingFee + _buyTeamFee;
    uint256 public _totalTaxIfSelling = _sellLiquidityFee + _sellMarketingFee + _sellTeamFee;
    uint256 public _totalDistributionShares = 0;

    uint256 private _totalSupply = 100000000 ether;
    uint256 public _maxTxAmount = 100000000 ether; 
    uint256 public _walletMax =   100000000 ether;
    uint256 private minimumTokensBeforeSwap = 1900 * 10**6; 

    function initialize (address _owner,
        string memory tokenName, string memory tokenSymbol, uint8 tokenDecimals,
        address payable marketingWallet, address payable teamWallet, uint56[] memory tokenTaxable, uint56[] memory tokenConfiguration
    ) external {
        _name = tokenName;
        _symbol = tokenSymbol;
        _decimals = tokenDecimals;

        marketingWallet = payable(marketingWallet);
        teamWallet = payable(teamWallet);

        _buyLiquidityFee = tokenTaxable[0];
        _buyMarketingFee = tokenTaxable[1];
        _buyTeamFee = tokenTaxable[2];

        _sellLiquidityFee = tokenTaxable[3];
        _sellMarketingFee = tokenTaxable[4];
        _sellTeamFee = tokenTaxable[5];

        _liquidityShare = tokenTaxable[6];
        _marketingShare = tokenTaxable[7];
        _teamShare = tokenTaxable[8];

        _totalSupply = tokenConfiguration[0] * 10**tokenDecimals;
        _maxTxAmount = tokenConfiguration[1] * 10**tokenDecimals;
        _walletMax = tokenConfiguration[2] * 10**tokenDecimals;
        minimumTokensBeforeSwap = tokenConfiguration[3] * 10**tokenDecimals;
    }
}
