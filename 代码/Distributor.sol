pragma solidity^0.4.1;
import "gametest/Roles.sol";
contract Distributor{
    using Roles for Roles.Role;
    Roles.Role private _distributor;
    
    event distributorAdded(address amount);
    event distributorRemoved(address amount);
    
    constructor(address distributor)public{
        _addDistributor(distributor);
    }
    
    function _addDistributor(address amount)internal{
        _distributor.add(amount);
        emit distributorAdded(amount);
    }
    
    function _removeDistributor(address amount)internal{
        _distributor.remove(amount);
        emit distributorAdded(amount);
    }
    
    function isDistributor(address amount)public view returns(bool){
        return _distributor.has(amount);
    }
    modifier onlyDistributor(){
        require(isDistributor(msg.sender));
        _;
    }
    function addDistributor(address amount)public onlyDistributor{
        _addDistributor(amount);
    }
    
    function removeDistributor() public{
        _removeDistributor(msg.sender);
    }
}
