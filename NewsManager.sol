// SPDX-License-Identifier: MIT
pragma solidity ^0.7.0;

import "./NewsManagerLib.sol"; // Importa la libreria NewsManagerLib

contract NewsManager {
    using NewsManagerLib for uint256;
    using NewsManagerLib for mapping(address => bool);
    using NewsManagerLib for address[];
    
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
        
        news.validationCount += 1;

        if (news.validationCount.isNewsValidatedByMinValidators(news.minValidations)) {
            news.isValidated = true;
            uint256 rewardAmount = validatorRewards[msg.sender];
            require(contractBalance >= rewardAmount, "Insufficient contract balance.");

            payable(msg.sender).transfer(rewardAmount);
            contractBalance -= rewardAmount;

            emit ValidationConfirmed(msg.sender, _newsAddress);
            emit RewardDistributed(msg.sender, rewardAmount);
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

    // verifica notizia se validata dal numero minimo di validator con libreria
    function checkIfNewsIsValidated(address _newsAddress) external view returns (bool) {
        News storage news = newsList[_newsAddress];
        return news.validationCount.isNewsValidatedByMinValidators(news.minValidations); 
    }

    // verifica se un indirizzo è un validator registrato con libreria
    function checkIfValidatorIsRegistered(address _validator) external view returns (bool) {
        return validators.isValidatorRegistered(_validator); 
    }

    // ottiene il numero di validatori registrati con libreria
    function getValidatorCountFromLib() external view returns (uint256) {
        return validatorList.getValidatorCount();
    }

    function getNewsDetails(address _newsAddress) external view returns (
        address newsAddress,
        string memory name,
        uint256 expirationDate,
        uint256 minValidations,
        uint256 validationCount,
        bool isValidated
    ) {
        News storage news = newsList[_newsAddress];
        return (news.newsAddress, news.name, news.expirationDate, news.minValidations, news.validationCount, news.isValidated);
    }

    function getValidatorList() external view returns (address[] memory) {
        return validatorList;
    }
}
