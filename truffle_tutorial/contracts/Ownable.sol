pragma solidity ^0.8.0;

contract Ownable {

    address payable owner;

    modifier onlyOwner() {
        require(owner == msg.sender, "Operation denied: You are not the owner");
        _;
    }

    function isOnwer() public view returns(address) {
        return owner;
    }

}