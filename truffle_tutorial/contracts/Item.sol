pragma solidity ^0.8.0;

import "./ItemManager.sol";

contract Item {
    uint public priceInWei;
    uint public index;
    uint public pricePaid;

    ItemManager parentContract;

    constructor(ItemManager _parentContract, uint _priceInWei, uint _index) {
        priceInWei = _priceInWei;
        index = _index;
        parentContract = _parentContract;
    }

    /*
    * receive fallback must be external and payable
    * In questo modo se un utente paga lo smart contract Item, viene chiamato il metodo triggerPayment
    * del contract ItemManager
    */
    receive() external payable {
        require(pricePaid == 0, "Item is paid already");
        require(priceInWei <= msg.value, "Only full payment allowed");
        pricePaid += msg.value;
        (bool success, ) = address(parentContract).call{value: msg.value}(abi.encodeWithSignature("triggerPayment(uint256)", index));
        require(success, "Transaction not succesful");
    }

    fallback() external {}
}