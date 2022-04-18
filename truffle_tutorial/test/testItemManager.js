const itemManager = artifacts.require("./ItemManager.sol");

contract("ItemManager", accounts => {
    it("... should be able to add an Item", async function() {
        //Da istanza del contratto
        const itemManagerInstance = await itemManager.deployed();
        const itemName = "test1";
        const itemPrice = 500;

        const result = await itemManagerInstance.createItem(itemName, itemPrice, {from: accounts[0]});
        console.log(result);

        assert.equal(result.logs[0].args._itemIndex, 0, "It's  not first item");
        
        const item = await itemManagerInstance.items(0);
        console.log(item);
        assert.equal(item._identifier, itemName, "The identifier was different");
    });
});