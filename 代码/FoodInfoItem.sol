pragma solidity^0.4.25;
contract FoodInfoItem{
    uint256[] _timestamp;  //时间戳
    string[] _traceName;   //交易名称
    address[] _traceAddress; //交易地址
    uint8[] _traceQuality;   //交易质量
    string _name;           //商品名称
    string _currentName;    //当前交易名称
    address _currentAddress; //当前交易地址
    uint8 _currentQuality;   //当前交易质量 0 优质 1 合格 2 不合格
    uint8 _status;          //当前交易状态 0上传 1 销售 2租赁
    address owner;
    
    constructor(string name,string traceName,address traceAddress,uint8 quality)public{
        _timestamp.push(now);
        _traceName.push(traceName);
        _traceAddress.push(traceAddress);
        _traceQuality.push(quality);
        _name = name;
        _currentName = traceName;
        _currentAddress = traceAddress;
        _currentQuality = quality;
        _status = 0;
        owner = msg.sender;
    }
    function addFoodByDistributor(string traceName,address traceAddress,uint8 quality)public returns(bool){
        require(_status == 0,"this is not already exit");
        _timestamp.push(now);
        _traceName.push(traceName);
        _traceAddress.push(traceAddress);
        _traceQuality.push(quality);
        _currentName = traceName;
        _currentAddress = traceAddress;
        _currentQuality = quality;
        _status = 1;
        return true;
    }
    
    function addFoodByRetailer(string traceName,address traceAddress,uint8 quality)public returns(bool){
        require(_status == 1,"this is not already exit");
        _timestamp.push(now);
        _traceName.push(traceName);
        _traceAddress.push(traceAddress);
        _traceQuality.push(quality);
        _currentName = traceName;
        _currentAddress = traceAddress;
        _currentQuality = quality;
        _status = 2;
        return true;
    }
    
    function getFoodInfo()public view returns(uint256,string,string,uint8,address,uint8){
        return(_timestamp[0],_name,_currentName,_currentQuality,_traceAddress[0],_status);
    }
    
    function getFoodInfoByNew()public view returns(uint256,string,string,address,uint8){
        return(_timestamp[0],_name,_traceName[0],_traceAddress[0],_traceQuality[0]);
    }
    
    function getDFoodInfoByDistributor()public view returns(uint256,string,string,string,address,uint8){
        return(_timestamp[0],_name,_traceName[0],_traceName[1],_traceAddress[1],_traceQuality[1]);
    }
    
    function getFoodInfoByRetailer()public view returns(uint256,string,string,string,string,address,uint8){
        return(_timestamp[0],_name,_traceName[0],_traceName[1],_traceName[2],_traceAddress[2],_traceQuality[2]);
    }
        
    function getFoodInfoByRoles()public view returns(uint256[],address[],uint8[]){
        return(_timestamp,_traceAddress,_traceQuality);
    }
    
    function getFoodInfoByAll()public view returns(string,uint256,string,uint8,uint256,string,uint8,uint256,string,uint8){
        return(_name,_timestamp[0],_traceName[0],_traceQuality[0],_timestamp[1],_traceName[1],_traceQuality[1],_timestamp[2],_traceName[2],_traceQuality[2]);
    }
}
