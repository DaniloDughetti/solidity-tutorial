pragma solidity ^0.5.13;

contract StartStopUpdateContract {

    address owner;
    bool paused;

    function receiveMoney() public payable {

    }

    constructor() public {
        owner = msg.sender;
    }

    function setPaused(bool _paused) public {
        require(msg.sender == owner, "You are not the owner");
        paused = _paused;
    }

    function sendMoney(address payable _to) public {
        require(msg.sender == owner, "You are not the owner");
        require(!paused, "Smart contract is paused");
        _to.transfer(address(this).balance);
    }

    function getBalance() public view returns (uint) {
        return address(this).balance;
    }

}