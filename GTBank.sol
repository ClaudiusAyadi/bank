// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

interface ICBMonitor {
    function creditTx(
        address depositor,
        address recipient,
        uint256 amount
    ) external;
}

contract GTBank {
    /*----------------------------------------------------------*|
    |*  # VARIABLES & CONSTRUCTOR                               *|
    |*----------------------------------------------------------*/
    address depositor;
    ICBMonitor CBContract =
        ICBMonitor(0xe78A0F7E598Cc8b0Bb87894B0F60dD2a88d6a8Ab);

    /**
     * GTBank Constructor
     * @dev this smart contract is a simple bank contract that allows users to deposit, check balances, and withdraw their funds
     * @dev assigns depositor to msg.sender.
     */
    constructor() {
        depositor = msg.sender;
    }

    /*----------------------------------------------------------*|
    |*  # EVENTS & ERROR HANDLING                               *|
    |*----------------------------------------------------------*/

    event Deposit(address indexed depositor, uint256 value);
    event Withdraw(address indexed depositor, uint256 value);
    event Transfer(
        address indexed depositor,
        address indexed recipient,
        uint256 value
    );

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
        emit Deposit(msg.sender, msg.value);
    }

    /**
     * withdraw
     * @dev function that allows users to withdraw their deposited funds
     * @param amount amount of funds to be withdrawn
     * @dev user's balance must be greater or equals amount to be withdrawn (require)
     * @dev amount withdrawn would be substracted from the user's  balance
     * @dev emit the event.
     */
    function withdraw(uint256 amount) public payable onlyDepositor {
        require(balances[msg.sender] >= amount, "Insufficient balance!");
        balances[msg.sender] -= amount;
        (bool success, ) = (msg.sender).call{value: amount}(
            "Your withdrawal is successful!"
        );
        require(success, "Withdrawal failed!");
        emit Withdraw(msg.sender, amount);
    }

    /**
     * transfer
     * @dev function that allows users to transfer their deposited funds one to another
     * @param recipient address of the receiver
     * @param amount amount of funds to be sent out
     * @dev user balance must be greater or equals amount to be withdrawn (require)
     * @dev amount withdrawn would be substracted from the user balance
     * @dev emit the event.
     */
    function transfer(address recipient, uint256 amount)
        public
        onlyDepositor
        returns (bool success)
    {
        require(
            balances[msg.sender] >= amount,
            "Insufficent balance, transferred failed!"
        );
        require(
            msg.sender != recipient,
            "You cannot send funds to yourself. Choose another wallet address!"
        );
        balances[msg.sender] -= amount;
        balances[recipient] += amount;
        CBContract.creditTx(depositor, recipient, amount);
        emit Transfer(msg.sender, recipient, amount); //solhint-disable-line indent, no-unused-vars
        return true;
    }

    /**
     * checkBalance
     * @dev function that allows users to check their balances
     * @param account addresses of our users
     */
    function checkBalance(address account) public view returns (uint256) {
        return balances[account];
    }
}
