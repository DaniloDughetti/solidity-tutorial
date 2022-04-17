pragma solidity ^0.8.0;

/*
* If we instantiate a contract class for every new Item we have the cons that
* Ethereum creates a new address for each of them.
*/

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";

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

contract ItemManager is Ownable {

    enum SupplyChainState { 
        Created, Paid, Delivered
        }

    struct S_Item {
        string _identifier;
        uint _itemPrice;
        ItemManager.SupplyChainState _state;
        Item _item;
    }
    
    mapping(uint => S_Item) public items;
    uint itemIndex;
    event SupplyChainStep(uint _itemIndex, uint _step, address _itemAddress);

    function createItem(string memory _identifier, uint _itemPrice) public onlyOwner {
        Item _item = new Item(this, _itemPrice, itemIndex);
        items[itemIndex]._item = _item;
        items[itemIndex]._identifier = _identifier;
        items[itemIndex]._itemPrice = _itemPrice;
        items[itemIndex]._state = ItemManager.SupplyChainState.Created;
        //we need to cast enum to uint and cast is type(value_to_cast)
        emit SupplyChainStep(itemIndex, uint(items[itemIndex]._state), address(_item));
        itemIndex++;
    }

    function triggerPayment(uint _itemIndex) public payable{
        require(items[_itemIndex]._itemPrice <= msg.value, "Only full price accepted");
        require(items[_itemIndex]._state == ItemManager.SupplyChainState.Created, "Product not in supply chain");
        items[_itemIndex]._state = ItemManager.SupplyChainState.Paid;
        emit SupplyChainStep(_itemIndex, uint(items[_itemIndex]._state), address(items[_itemIndex]._item));
    }

    function triggerDelivery(uint _itemIndex) public onlyOwner {
        require(items[_itemIndex]._state == SupplyChainState.Paid, "Item not in supply chain");
        items[_itemIndex]._state = SupplyChainState.Delivered;
        emit SupplyChainStep(_itemIndex, uint(items[_itemIndex]._state), address(items[_itemIndex]._item));
    }
}