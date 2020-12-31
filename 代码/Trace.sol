pragma solidity^0.4.25;
//pragma experimental ABIEncoderV2; //返回结构体类型
import "gametest/Roles.sol";
import "gametest/Producer.sol";
import "gametest/Distributor.sol";
import "gametest/Retailer.sol";
import "gametest/FoodInfoItem.sol";

contract Trace is Producer,Distributor,Retailer{
    mapping(uint256=>address) foods;   //溯源码映射合约地址
    uint256[] foodList; 
    address owner; //合约的部署者，管理员
    
    //初始化三个角色，发行商，购买者，二次购买者
    constructor(address producer,address distributor,address retailer)public Producer(producer) Distributor(distributor) Retailer(retailer){
        owner = msg.sender;
    }

    function newFood(uint256 traceNumber,string name,string traceName,uint8 quality)public onlyProducer returns(address){
        require(foods[traceNumber]==address(0));
        FoodInfoItem food = new FoodInfoItem(name,traceName,msg.sender,quality);
        foods[traceNumber] = food;
        foodList.push(traceNumber);
        return food;
    }
 
    function addFoodByDistributor(uint256 traceNumber,string traceName,uint8 quality)public onlyDistributor returns(bool){
        require(foods[traceNumber]!=address(0));
        return FoodInfoItem(foods[traceNumber]).addFoodByDistributor(traceName,msg.sender,quality);
    }
  
    function addFoodByRetailer(uint256 traceNumber,string traceName,uint8 quality)public onlyRetailer returns(bool){
        require(foods[traceNumber]!=address(0));
        return FoodInfoItem(foods[traceNumber]).addFoodByRetailer(traceName,msg.sender,quality);
    }
   
    function getFoodInfo(uint256 traceNumber)public view returns(uint256,string,string,uint8,address,uint8){
        return FoodInfoItem(foods[traceNumber]).getFoodInfo();
    }
    //溯源
    function getFoodInfoByNew(uint256 traceNumber)public view returns(uint256,string,string,address,uint8){
        return FoodInfoItem(foods[traceNumber]).getFoodInfoByNew();
    }
    //溯源
    function getDFoodInfoByDistributor(uint256 traceNumber)public view returns(uint256,string,string,string,address,uint8){
        return FoodInfoItem(foods[traceNumber]).getDFoodInfoByDistributor();
    }
    //溯源
    function getFoodInfoByRetailer(uint256 traceNumber)public view returns(uint256,string,string,string,string,address,uint8){
        return FoodInfoItem(foods[traceNumber]).getFoodInfoByRetailer();
    }
    //三个阶段溯源
    function getFoodInfoByRoles(uint256 traceNumber)public view returns(uint256[],address[],uint8[]){
        return FoodInfoItem(foods[traceNumber]).getFoodInfoByRoles();
    }
    //整体溯源
    function getFoodInfoByAll(uint256 traceNumber)public view returns(string,uint256,string,uint8,uint256,string,uint8,uint256,string,uint8){
        return FoodInfoItem(foods[traceNumber]).getFoodInfoByAll();
    }
    //获取所有物品
    function getFoodList()public view returns(uint256[]){
        require(msg.sender == owner,'you are not owner');
        return foodList;
    }
}
