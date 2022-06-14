// SPDX-License-Identifier: MIT

pragma solidity 0.8.14;

contract CentralBank {
    /*----------------------------------------------------------*|
    |*  # EVENTS & ERROR HANDLING                               *|
    |*----------------------------------------------------------*/

    event Deposited(address depositor, uint256 value);
    event Withdrawn(address depositor, uint256 value);
    event Transferred(address depositor, address recipient, uint256 value);
}
