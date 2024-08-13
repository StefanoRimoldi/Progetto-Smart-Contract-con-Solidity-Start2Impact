// SPDX-License-Identifier: MIT
pragma solidity ^0.7.0;

library NewsManagerLib {
    
    function isNewsValidatedByMinValidators(uint256 minValidations, uint256 validationCount) internal pure returns (bool) {
        return validationCount >= minValidations;
    }

    
    function isValidatorRegistered(mapping(address => bool) storage validators, address _validator) internal view returns (bool) {
        return validators[_validator];
    }

    
    function getValidatorCount(address[] storage validatorList) internal view returns (uint256) {
        return validatorList.length;
    }
}
