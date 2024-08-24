// SPDX-License-Identifier: MIT
pragma solidity ^0.7.0;

import "./NewsManagerLib.sol";

contract NewsManager {
    address public admin;
    mapping(address => bool) public validators;
    mapping(address => uint256) public validatorRewards;
    uint256 public totalRewardAmount;
    uint256 public contractBalance;
    uint256 public validatorCount;

    address[] public validatorList;

    struct News {
        address newsAddress;
        string name;
        uint256 expirationDate;
        uint256 minValidations;
        uint256 validationCount;
        bool isValidated;
    }

    mapping(address => News) public newsList;
    mapping(address => mapping(address => bool)) public newsValidatedBy;
    

    event ValidatorAdded(address indexed validator);
    event ValidatorRemoved(address indexed validator);
    event RewardDistributed(address indexed validator, uint256 amount);
    event NewsAdded(address indexed newsAddress, string name, uint256 expirationDate, uint256 minValidations);
    event ValidationConfirmed(address indexed validator, address indexed newsAddress);
    event FundsDeposited(uint256 amount);

    modifier onlyAdmin() {
        require(msg.sender == admin, "Not authorized");
        _;
    }

    modifier onlyValidator() {
        require(validators[msg.sender], "Only validators can perform this action.");
        _;
    }

    constructor() {
        admin = msg.sender;
    }

    function addValidator(address _validator, uint256 _rewardAmount) external onlyAdmin {
        require(!validators[_validator], "Validator already exists.");
        validators[_validator] = true;
        validatorRewards[_validator] = _rewardAmount;
        totalRewardAmount += _rewardAmount;
        validatorCount += 1;
        validatorList.push(_validator);
        emit ValidatorAdded(_validator);
    }

    function removeValidator(address _validator) external onlyAdmin {
        require(validators[_validator], "Validator does not exist.");

        for (uint256 i = 0; i < validatorList.length; i++) {
            if (validatorList[i] == _validator) {
                validatorList[i] = validatorList[validatorList.length - 1];
                validatorList.pop();
                break;
            }
        }

        totalRewardAmount -= validatorRewards[_validator];
        validators[_validator] = false;
        delete validatorRewards[_validator];
        validatorCount -= 1;
        emit ValidatorRemoved(_validator);
    }

    function addNews(
        address _newsAddress,
        string memory _name,
        uint256 _expirationDate,
        uint256 _minValidations
    ) external onlyAdmin {
        newsList[_newsAddress] = News({
            newsAddress: _newsAddress,
            name: _name,
            expirationDate: _expirationDate,
            minValidations: _minValidations,
            validationCount: 0,
            isValidated: false
        });
        emit NewsAdded(_newsAddress, _name, _expirationDate, _minValidations);
    }

    function confirmValidation(address _newsAddress) external onlyValidator {
    News storage news = newsList[_newsAddress];
    require(news.expirationDate > block.timestamp, "Validation period has expired.");
    require(!news.isValidated, "News has already been validated.");
    require(!newsValidatedBy[_newsAddress][msg.sender], "Validator has already confirmed this news.");
    

    news.validationCount += 1;
    newsValidatedBy[_newsAddress][msg.sender] = true;

    // Distribuisce la ricompensa per ogni validatore subito dopo la conferma
    uint256 rewardAmount = validatorRewards[msg.sender];
    require(contractBalance >= rewardAmount, "Contract does not have enough balance for rewards.");
    
    payable(msg.sender).transfer(rewardAmount);
    contractBalance -= rewardAmount;
    emit RewardDistributed(msg.sender, rewardAmount);

    // Controlla se la notizia ha raggiunto il numero minimo di validazioni
    if (NewsManagerLib.isNewsValidatedByMinValidators(news)) {
        news.isValidated = true;
        emit ValidationConfirmed(msg.sender, _newsAddress);
    }
}


    function depositFunds() external payable onlyAdmin {
        contractBalance += msg.value;
        emit FundsDeposited(msg.value);
    }

    receive() external payable {
        contractBalance += msg.value;
        emit FundsDeposited(msg.value);
    }

    function getValidatorCount() external view returns (uint256) {
        return NewsManagerLib.getValidatorCount(validatorList);
    }

    function getValidatorList() external view returns (address[] memory) {
        return validatorList;
    }

    function getNewsDetails(address _newsAddress) external view returns (
        address, string memory, uint256, uint256, uint256, bool
    ) {
        News storage news = newsList[_newsAddress];
        return (news.newsAddress, news.name, news.expirationDate, news.minValidations, news.validationCount, news.isValidated);
    }
}
