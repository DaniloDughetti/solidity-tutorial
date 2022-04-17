pragma solidity ^0.8.0;

contract SimpleSmartContract {

    uint public myUint = 10;
    
    function setMyUint(uint _myUint) public {
        myUint = _myUint;
    }
}