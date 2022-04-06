pragma solidity 0.8.3;

contract FunctionExampleContract {

    //visibilità proprietà va sempre come ultimo modificatore
    address payable public owner;

    uint public contractBalance;

    mapping(address => uint) public balanceReceived;

    constructor() {
        owner = payable(msg.sender);
    }

    function destroySmartContract() public {
        require(msg.sender == owner, "Unauthorized");
        selfdestruct(owner);
    }
    //Data location can only be specified for array, struct or mapping types
    function receiveMoney() public payable {
        uint _amount = msg.value;
        assert(balanceReceived[msg.sender] + _amount >= balanceReceived[msg.sender]);
        balanceReceived[msg.sender] += _amount;
        addToBalance(_amount);
    }

    function withdrawMoney(address payable _to, uint _amount) public {
        require(_amount < balanceReceived[msg.sender], "Not enough money");
        assert(balanceReceived[msg.sender] >= balanceReceived[msg.sender] - _amount);
        balanceReceived[msg.sender] -= _amount;
        sotractToBalance(_amount);
        _to.transfer(_amount);
    }

    function myBalance() public view returns(uint) {
        return balanceReceived[msg.sender];
    }

    function addToBalance(uint _amount) internal {
        assert(contractBalance <= contractBalance + _amount);
        contractBalance += _amount;
    }
    //Non è a somma zero il bilancio perchè quando si invia ad un address questo ovviamente è esterno allo smart contract
    //Il bilancio si somma se l'address in questione a sua volta chiama il receiveMoney
    function sotractToBalance(uint _amount) internal {
        assert(contractBalance - _amount >= 0);
        contractBalance -= _amount;
    }

    function convertWeiToEth(uint _amount) public pure returns(uint) {
        //La divisione tra interi viene troncata in Solidity
        return _amount / 1 ether;
    }

    receive() external payable {
        receiveMoney();
    }
}