// SPDX-License-Identifier: MIT
pragma solidity ^0.7.0;

import "./NewsManager.sol"; 

library NewsManagerLib {
    
    function isNewsValidatedByMinValidators(
        NewsManager.News memory news
    ) internal pure returns (bool) {
        return news.validationCount >= news.minValidations;
    }

    
    function isValidatorRegistered(
        mapping(address => bool) storage validators,
        address _validator
    ) internal view returns (bool) {
        return validators[_validator];
    }

    
    function getValidatorCount(address[] storage validatorList) internal view returns (uint256) {
        return validatorList.length;
    }

    // Controlla se un validatore ha già validato la notizia
    function hasValidatorValidated(mapping(address => bool) storage validators, address _validator) internal view returns (bool) {
        return validators[_validator];
    }
}
