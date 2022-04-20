// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract MasterContract {
  /**
  Custom Data types
   */
   struct Property { 
   string propertyAddress;
   uint uniqueID;//TODO change to guid
}
  uint private _maxCoins=1000000000;
  mapping(address => uint) public balances;
  address private _owner;
  mapping(uint => address) public propertyOwners;
  mapping(uint => Property) public propertyDescriptions;
  MyRandomUtil _randomUtil;

  constructor(uint maxCoins) {
    _maxCoins=maxCoins;
    _owner=msg.sender;
    _randomUtil = new MyRandomUtil();
  }
  function issueCoins(address buyer, uint amount) external onlyOwner {
        addToBalance(buyer,amount);
    }
  modifier onlyOwner() {
        require(msg.sender == _owner, "Ownable: caller is not the owner");
        _;
    }
    function createProperty(string calldata propertyAddress) external onlyOwner() returns(uint propertyId)
    {
      // generate unique ID
       propertyId = _randomUtil.randMod(100000000000);
       Property memory prop =  Property({propertyAddress:propertyAddress,uniqueID:propertyId});
       propertyDescriptions[propertyId] = prop;
    }

    function updateBalance(address destAddress,uint newBalance) private {
      balances[destAddress] = newBalance;
   }

   function addToBalance(address destAddress,uint addedValue) private onlyOwner {
     uint myBalance = balances[msg.sender];
     uint newBalance = myBalance + addedValue;
     updateBalance(destAddress, newBalance);
   }

}

// Creating a contract
contract MyRandomUtil
{
 
// Initializing the state variable
uint randNonce = 0;
 
// Defining a function to generate
// a random number
function randMod(uint _modulus) external returns(uint)
{
   // increase nonce
   randNonce++; 
   return uint(keccak256(abi.encodePacked(block.timestamp,
                                          msg.sender,
                                          randNonce))) % _modulus;
 }
}
 