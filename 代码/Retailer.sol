pragma solidity^0.4.1;
import "gametest/Roles.sol";
contract Retailer{
    using Roles for Roles.Role;
    Roles.Role private _retailer;
    
    event retailerAdded(address amount);
    event retailerRemoved(address amount);
    
    constructor(address distributor)public{
        _addRetailer(distributor);
    }
    
    function _addRetailer(address amount)internal{
        _retailer.add(amount);
        emit retailerAdded(amount);
    }
    
    function _removeRetailer(address amount)internal{
        _retailer.remove(amount);
        emit retailerAdded(amount);
    }
    
    function isRetailer(address amount)public view returns(bool){
        return _retailer.has(amount);
    }
    modifier onlyRetailer(){
        require(isRetailer(msg.sender));
        _;
    }
    function addRetailer(address amount)public onlyRetailer{
        _addRetailer(amount);
    }
    
    function removeRetailer()public{
        _removeRetailer(msg.sender);
    }
}
