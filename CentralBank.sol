// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

contract CentralBank {
    /*----------------------------------------------------------*|
    |*  # STRUCT, ARRAY $ FUNCTIONS                             *|
    |*----------------------------------------------------------*/
    
    /**
     * @title TxDetails
     * @dev a struct holding all the required details of a transaction
     * @param depositor address of the fund owner
     * @param recipient address of the receiving user
     * @param amount value sent or deposited
     * @param TxID indexed ID of the transaction
     */
    struct TxDetails {
        address depositor;
        address recipient;
        uint256 amount;
        uint256 TxID;
    }

    /**
     * txLog
     * @dev array of TXDetails
     */
    TxDetails[] txLog;

    /**
     * creditTx
     * @dev function to log every transfer by bank users
     * @param depositor address of sender
     * @param recipient address of receiver
     * @param amount amount or value sent
     */
    function creditTx(
        address depositor,
        address recipient,
        uint256 amount
    ) external {
        txLog.push(TxDetails(depositor, recipient, amount, txLog.length));
    }
   
    /**
     * getTx
     * @dev function to view indexed transactions from banks
     * @param index numeric ID for tx in the array
     */
    function getTx(uint256 index)
        public
        view
        returns (
            address,
            address,
            uint256
        )
    {
        return (
            txLog[index].depositor,
            txLog[index].recipient,
            txLog[index].amount
        );
    }
}
