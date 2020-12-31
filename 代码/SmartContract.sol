pragma solidity ^0.5.13;
import "https://github.com/OpenZeppelin/openzeppelin-contracts/contracts/ownership/Ownable.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/contracts/math/SafeMath.sol";
import "./Allowance.sol";
contract SharedWallet is Allowance {
 event MoneySent(address indexed _beneficiary, uint _amount);
 event MoneyReceived(address indexed _from, uint _amount);
 function withdrawMoney(address payable _to, uint _amount) public ownerOrAllowed(_amount) {
require(_amount <= address(this).balance, "Contract doesn't own enough money");
if(!isOwner()) {
reduceAllowance(msg.sender, _amount);
}
emit MoneySent(_to, _amount);
_to.transfer(_amount);
 }
 function renounceOwnership() public onlyOwner {
revert("can't renounceOwnership here"); //not possible with this smart contract
 }
 function() external payable {
emit MoneyReceived(msg.sender, msg.value);
}
}
