// SPDX-License-Identifier: MIT

pragma solidity 0.8.14;

import "./CentralBank.sol";

contract GTBank is CentralBank {
    /*----------------------------------------------------------*|
    |*  # VARIABLES & CONSTRUCTOR                               *|
    |*----------------------------------------------------------*/
    address depositor;

    /**
     * GTBank Constructor
     * @dev this smart contract is a simple bank contract that allows users to deposit, check balances, and withdraw their funds
     * @dev assigns depositor to msg.sender.
     */
    constructor() {
        depositor = msg.sender;
    }

    /*----------------------------------------------------------*|
    |*  # MODIFIER & MAPPING                                    *|
    |*----------------------------------------------------------*/
    /**
     * onlyDepositor
     * @dev ensures only the account owner can perform any function the modifier is declared on.
     */
    modifier onlyDepositor() {
        require(
            msg.sender == depositor,
            "Only account owner can perform this transaction"
        );
        _;
    }

    /**
     * GTBank Mapping
     * @dev mapping users' addresses to a uint to form the balances
     */
    mapping(address => uint256) private balances;

    /*----------------------------------------------------------*|
    |*  # FUNCTIONS                                             *|
    |*----------------------------------------------------------*/

    /**
     * deposit
     * @dev function that allows users to deposit their funds to our bank
     * @dev amount deposited would be added to the user balance
     * @dev emit the event.
     */
    function deposit() public payable onlyDepositor {
        balances[msg.sender] += msg.value;
        emit Deposited(msg.sender, msg.value);
    }

    /**
     * withdraw
     * @dev function that allows users to withdraw their deposited funds
     * @dev user balance must be greater or equals amount to be withdrawn (require)
     * @dev amount withdrawn would be substracted from the user balance
     * @dev emit the event.
     */
    function withdraw(uint256 amount) public payable onlyDepositor {
        require(balances[msg.sender] >= amount, "Insufficient balance");
        balances[msg.sender] -= amount;
        (bool success, ) = (msg.sender).call{value: amount}(
            "Your withdrawal is successful"
        );
        require(success, "Withdrawal failed");
        emit Withdrawn(msg.sender, amount);
    }

    function transfer(address recipient, uint256 amount)
        public
        payable
        onlyDepositor
    {
        require(balances[msg.sender] >= amount, "Insufficent balance");
        require(msg.sender != recipient, "You cannot send funds to yourself");
        balances[msg.sender] -= amount;
        payable(recipient).transfer(amount);
        balances[recipient] += amount;
        emit Transferred(msg.sender, recipient, amount);
    }

    /**
     * checkBalance
     * @dev function that allows users to check their balances
     */
    function checkBalance(address account) public view returns (uint256) {
        return balances[account];
    }
}
