// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {ERC20Upgradeable} from "lib/openzeppelin-contracts-upgradeable/contracts/token/ERC20/ERC20Upgradeable.sol";
import {Ownable2StepUpgradeable} from
    "lib/openzeppelin-contracts-upgradeable/contracts/access/Ownable2StepUpgradeable.sol";
import {ERC20DelegatesUpgradeable} from "./ERC20DelegatesUpgradeable.sol";
import {
    ERC20PermitUpgradeable,
    NoncesUpgradeable
} from "lib/openzeppelin-contracts-upgradeable/contracts/token/ERC20/extensions/ERC20PermitUpgradeable.sol";
import {UUPSUpgradeable} from "lib/openzeppelin-contracts-upgradeable/contracts/proxy/utils/UUPSUpgradeable.sol";

// TODO:
// - add natspecs
// - add events?
// - add error messages
contract MorphoToken is ERC20DelegatesUpgradeable, ERC20PermitUpgradeable, Ownable2StepUpgradeable, UUPSUpgradeable {
    /* CONSTANTS */

    /// @dev the name of the token.
    string internal constant NAME = "Morpho Token";

    /// @dev the symbol of the token.
    string internal constant SYMBOL = "MORPHO";

    /* ERRORS */

    /// @notice Reverts if the address is the zero address.
    error ZeroAddress();

    /* PUBLIC */

    function initialize(address dao, address wrapper) public initializer {
        require(dao != address(0), ZeroAddress());
        require(wrapper != address(0), ZeroAddress());

        ERC20Upgradeable.__ERC20_init(NAME, SYMBOL);
        Ownable2StepUpgradeable.__Ownable2Step_init();
        ERC20PermitUpgradeable.__ERC20Permit_init(NAME);

        _transferOwnership(dao); // Transfer ownership to the DAO.
        _mint(wrapper, 1_000_000_000e18); // Mint 1B to the wrapper contract.
    }

    function nonces(address owner) public view override(ERC20PermitUpgradeable, NoncesUpgradeable) returns (uint256) {
        return ERC20PermitUpgradeable.nonces(owner);
    }

    /* INTERNAL */

    function _update(address from, address to, uint256 value)
        internal
        override(ERC20Upgradeable, ERC20DelegatesUpgradeable)
    {
        ERC20DelegatesUpgradeable._update(from, to, value);
    }

    /// @inheritdoc UUPSUpgradeable
    function _authorizeUpgrade(address) internal override onlyOwner {}
}
