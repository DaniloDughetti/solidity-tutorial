pragma solidity ^0.5.13;

contract SendMoney {

    struct UserInfo {
        address userAddress;
        uint256 userBalance;
        bool isValid;
    }

    mapping(address => UserInfo) public users;
    uint256 public balanceReceived;
    uint256 public lastBlockTimestamp;

    function receiveMoney() public payable {
        balanceReceived += msg.value;

        UserInfo memory _user = users[msg.sender];
        if(_user.isValid) {
            _user.userBalance += msg.value;
            users[msg.sender] = _user;
        } else {
            users[msg.sender] = UserInfo(msg.sender, msg.value, true);
        }

        lastBlockTimestamp = block.timestamp;
    }

    function getBalance() public view returns(uint) {
        return address(this).balance;
    }

    function getPersonalBalance() public view returns(uint) {
        return users[msg.sender].userBalance;
    }

    function sendMoney(address payable _to) public {
        uint256 balanceToMove = users[msg.sender].userBalance;
        _to.transfer(balanceToMove);
        balanceReceived -= balanceToMove;
        users[msg.sender].userBalance -= balanceToMove;
    }

    function withdrawMoney() public {
        this.sendMoney(msg.sender);
    }

    function withdrawMoneyTo(address payable _to) public {
        this.sendMoney(_to);
    }

    function withdrawWithTime(address payable _to) public {
        if(block.timestamp >= lastBlockTimestamp + 1 minutes) {
            _to.transfer(balanceReceived);
        }
    }

}