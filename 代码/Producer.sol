pragma solidity^0.4.25;
import "gametest/Roles.sol";
contract Producer{
    using Roles for Roles.Role;
    Roles.Role private _producer;
    
    event producerAdded(address amount);
    event producerRemoved(address amount);
    
    constructor(address producer)public{
        _addProducer(producer);
    }
    
    function _addProducer(address amount)internal{
        _producer.add(amount);
        emit producerAdded(amount);
    }
    
    function _removeProducer(address amount)internal{
        _producer.remove(amount);
        emit producerAdded(amount);
    }
    
    function isProducer(address amount)public view returns(bool){
        return _producer.has(amount);
    }
    modifier onlyProducer(){
        require(isProducer(msg.sender));
        _;
    }
    function addProducer(address amount)public onlyProducer{
        _addProducer(amount);
    }
    
    function removeProducer()public{
        _removeProducer(msg.sender);
    }
}
