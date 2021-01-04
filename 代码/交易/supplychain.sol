pragma solidity 0.7.0;

contract supplyChain{
    uint32 public product_id = 0;
    uint32 public participant_id = 0;
    uint32 public owner_id = 0;

    struct product{
        string modelNum;
        string partNum;
        string serialNum;
        address productOwner;
        uint32 cost;
        uint32 mfgTimeStamp;
    }

    mapping(uint32 => product) public products;
    
    struct participant{
        string userName;
        string passwd;
        string participanType;
        address participantAddress;
    }

    mapping (uint32 => participant) public participants;

    struct ownership{
        uint32 productId;
        uint32 ownerId;
        uint32 trxtTimeStamp;
        address productOwner;
    }

    mapping(uint32 => ownership) public ownerships;
    mapping(uint32 => uint32[]) public productTrack;

    event TransForOwnership(uint32 productId);

    function addParticipant(string memory _name,string memory _pass,address _pAdd, string memory _pType) public returns(uint32){
        uint32 userId = participant_id++;
        participants[userId].userName = _name;
        participants[userId].passwd = _pass;
        participants[userId].participantAddress = _pAdd;
        participants[userId].participanType = _pType;

        return userId;
    }

    function getParticipant(uint32 _participant_id) public view returns(string memory,address,string memory){
        return(participants[_participant_id].userName,participants[_participant_id].participantAddress,participants[_participant_id].participanType);
    }
    
    function addProduct(uint32 _ownerId,string memory _modelNum,string memory _partNum,string memory _serialNum,uint32 _productCost) public returns(uint32){
        if(keccak256(abi.encodePacked(participants[_ownerId].participanType)) == keccak256("manufacturer")){
            uint32 productId = product_id++;
            products[productId].modelNum = _modelNum;
            products[productId].partNum = _partNum;
            products[productId].serialNum = _serialNum;
            products[productId].cost = _productCost;
            products[productId].productOwner = participants[_ownerId].participantAddress;
            products[productId].mfgTimeStamp = uint32(block.timestamp);
            
            return productId;
        }
    }
    
    modifier onlyOwner(uint32 _productId){
        require(msg.sender == products[_productId].productOwner,"");
        _;
    }
    
    function getProduct(uint32 _productId) public view returns(string memory,string memory,string memory,uint32,address,uint32){
        return (products[_productId].modelNum,
        products[_productId].partNum,
        products[_productId].serialNum,
        products[_productId].cost,
        products[_productId].productOwner,
        products[_productId].mfgTimeStamp
        );
    }
    
    function newOwner(uint32 _user1Id,uint32 _user2Id, uint32 _proId) onlyOwner(_proId) public returns(bool){
        participant memory p1 = participants[_user1Id];
        participant memory p2 = participants[_user2Id];
        uint32 ownership_id = owner_id++;
        
        if(keccak256(abi.encodePacked(p1.participanType))== keccak256("manufacturer")
        && keccak256(abi.encodePacked(p2.participanType)) == keccak256("supplier")){
            ownerships[ownership_id].productId = _proId;
            ownerships[ownership_id].productOwner = p2.participantAddress;
            ownerships[ownership_id].ownerId = _user2Id;
            ownerships[ownership_id].trxtTimeStamp = uint32(block.timestamp);
            products[_proId].productOwner = p2.participantAddress;
            productTrack[_proId].push(ownership_id);
            emit TransForOwnership(_proId);
            
            return(true);
        }
        else if(keccak256(abi.encodePacked(p1.participanType))==keccak256("supplier") 
        && keccak256(abi.encodePacked(p2.participanType)) == keccak256("supplier")){
            ownerships[ownership_id].productId = _proId;
            ownerships[ownership_id].productOwner = p2.participantAddress;
            ownerships[ownership_id].ownerId = _user2Id;
            ownerships[ownership_id].trxtTimeStamp = uint32(block.timestamp);
            products[_proId].productOwner = p2.participantAddress;
            productTrack[_proId].push(ownership_id);
            emit TransForOwnership(_proId);
            
            return(true);
        }
        else if(keccak256(abi.encodePacked(p1.participanType))==keccak256("supplier") 
        && keccak256(abi.encodePacked(p2.participanType)) == keccak256("consumer")){
            ownerships[ownership_id].productId = _proId;
            ownerships[ownership_id].productOwner = p2.participantAddress;
            ownerships[ownership_id].ownerId = _user2Id;
            ownerships[ownership_id].trxtTimeStamp = uint32(block.timestamp);
            products[_proId].productOwner = p2.participantAddress;
            productTrack[_proId].push(ownership_id);
            emit TransForOwnership(_proId);
            
            return(true);
        }
    }
    function getProvenance(uint32 _proId) external view returns(uint32[] memory){
        return productTrack[_proId];
    }
    function getOwnership(uint32 _regId) public view returns (uint32,uint32,address,uint32){
        ownership memory r = ownerships[_regId];
        return(r.productId,r.ownerId,r.productOwner,r.trxtTimeStamp);
    }
    
    function authenticateParticipant(uint32 _uid,string memory _uname,string memory _pass,string memory _utype) public view returns(bool){
        if(keccak256(abi.encodePacked(participants[_uid].participanType)) == keccak256(abi.encodePacked(_utype))){
            if(keccak256(abi.encodePacked(participants[_uid].userName))==keccak256(abi.encodePacked(_uname))){
                if(keccak256(abi.encodePacked(participants[_uid].passwd))==keccak256(abi.encodePacked(_pass))){
                    return(true);
                }
            }
        }
        
        return(false);
    }

    
}
