pragma solidity >=0.4.25 <0.5.3;


contract Owned {

    address public owner;
    
    constructor() public {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    function setOwner(address _newOwner) onlyOwner public{
        owner = _newOwner;
    }
}

/**
 * @title SafeMath
 * @dev Math operations with safety checks that throw on error
 */
library SafeMath {
  function mul(uint256 a, uint256 b) internal pure returns (uint256) {
    uint256 c = a * b;
    assert(a == 0 || c / a == b);
    return c;
  }

  function div(uint256 a, uint256 b) internal pure returns (uint256) {
    // assert(b > 0); // Solidity automatically throws when dividing by 0
    uint256 c = a / b;
    // assert(a == b * c + a % b); // There is no case in which this doesn't hold
    return c;
  }

  function sub(uint256 a, uint256 b) internal pure returns (uint256) {
    assert(b <= a);
    return a - b;
  }

  function add(uint256 a, uint256 b) internal pure returns (uint256) {
    uint256 c = a + b;
    assert(c >= a);
    return c;
  }

  function toUINT112(uint256 a) internal pure returns(uint112) {
    assert(uint112(a) == a);
    return uint112(a);
  }

  function toUINT120(uint256 a) internal pure returns(uint120) {
    assert(uint120(a) == a);
    return uint120(a);
  }

  function toUINT128(uint256 a) internal pure returns(uint128) {
    assert(uint128(a) == a);
    return uint128(a);
  }
}


contract medicalEquipment is Owned{
    

    enum medicalEquipmentStatus {
        /// 出厂
        deliveredatM,
        
        /// 物流1收货
        pickedByS1,
        /// 物流1发货
        deliveredAtS1,
        
        /// 经销商收货
        pickedByD,
        /// 经销商发货
        deliveredAtD,

        /// 物流2收货
        pickedByS2,
        /// 物流2发货
        deliveredAtS2,

        /// 外贸商收货
        pickedByT,
        /// 外贸商发货
        deliveredAtT,
        
        /// 物流3收货
        pickedByS3,
        /// 物流3发货
        deliveredAtS3,
        
        /// 海关查货
        checkedByC,
        
        /// 国外客户收货
        pickedByF
    }
    
    event ShippmentUpdate(
        bytes32 indexed BatchID,
        address indexed From,
        address indexed To,
        uint Status
    );

    bytes32 BatchID;
    // 信息描述
    bytes32 description;
    /// @notice
    uint quantity;
    /// @notice
    address manufacturer;
    /// @notice
    address shipper1;
    /// @notice
    address distributer;
    /// @notice
    address shipper2;
    /// @notice
    address fTradingCom;
    /// @notice
    address shipper3;
    address custom;
    /// @notice
    address fCustomer;
    /// @notice
    medicalEquipmentStatus status;

    function registerMan(address _manufacturer) onlyOwner public{
        manufacturer = _manufacturer;
    }

    function registerShipper1(address _shipper1) onlyOwner public{
        shipper1 = _shipper1;
    }
    
    function registerDistributer(address _distributer) onlyOwner public{
        distributer = _distributer;
    }
    
    function registerShipper2(address _shipper2) onlyOwner public{
        shipper2 = _shipper2;
    }
    
    function registerFTradingCom(address _tradingCom) onlyOwner public{
        fTradingCom = _tradingCom;
    }
    
    function registerShipper3(address _shipper3) onlyOwner public{
        shipper3 = _shipper3;
    }
    
    function registerCustom(address _custom) onlyOwner public{
        custom = _custom;
    }
    
    function registerFCustomer(address _foreignCustomer) onlyOwner public{
        fCustomer = _foreignCustomer;
    }

    
    function deliveredByMan(bytes32 _batchID) public returns (bool){
        require(
            msg.sender == manufacturer,
            "Only Associate manufacturer can call this function");
        BatchID = _batchID;
        if (shipper1 == address(0x0)) {
            return false;
        }

        status = medicalEquipmentStatus(0);
        emit ShippmentUpdate(_batchID, manufacturer, shipper1, 0);
        return true;
    }

    function pickedByS1() public returns (bool){
        require(
            msg.sender == shipper1,
            "Only Associate Shipper can call this function"
        );
        require(
            status == medicalEquipmentStatus(0),
            "Package must be delivered by Manufacturer."
        );

        status = medicalEquipmentStatus(1);
        emit ShippmentUpdate(BatchID,manufacturer,distributer,1);
        return true;        
    }
    
    function deliveredByS1() public returns (bool) {
        require(
            msg.sender == shipper1,
            "Only Associate Shipper can call this function"
        );
        require(
            status == medicalEquipmentStatus(1),
            "Package must be picked by Associate Shipper"
        );
        if (distributer == address(0x0)) {
            return false;
        }
        status = medicalEquipmentStatus(2);
        emit ShippmentUpdate(BatchID,shipper1,distributer,2);
    }
    
    function pickedByDistributer() public returns (bool) {
        require(
            msg.sender == distributer,
            "Only Associate distributer can call this function"
        );
        require(
            status == medicalEquipmentStatus(2),
            "Package must be picked by distributer"
        );
        status = medicalEquipmentStatus(3);
        emit ShippmentUpdate(BatchID,shipper1,distributer,3);
    }
    
    function deliveredByDistributer() public returns (bool) {
        require(
            msg.sender == distributer,
            "Only Associate distributer can call this function"
        );
        require(
            status == medicalEquipmentStatus(3),
            "Package must be picked by distributer"
        );
        if (fTradingCom == address(0x0)) {
            return false;
        }
        status = medicalEquipmentStatus(4);
        emit ShippmentUpdate(BatchID,distributer,fTradingCom,4);
    }
    
    function pickedByS2() public returns (bool){
        require(
            msg.sender == shipper2,
            "Only Associate Shipper can call this function"
        );
        require(
            status == medicalEquipmentStatus(4),
            "Package must be delivered by Distributer."
        );
    
        status = medicalEquipmentStatus(5);
        emit ShippmentUpdate(BatchID,distributer,shipper2,5);
        return true;        
    }
    
    function deliveredByS2() public returns (bool) {
        require(
            msg.sender == shipper2,
            "Only Associate Shipper can call this function"
        );
        require(
            status == medicalEquipmentStatus(5),
            "Package must be picked by Associate Shipper"
        );
        if (fTradingCom == address(0x0)) {
            return false;
        }
        status = medicalEquipmentStatus(6);
        emit ShippmentUpdate(BatchID,shipper2,fTradingCom,6);
    }
    
    
    function pickedByFTradingCom() public returns (bool) {
        require(
            msg.sender == fTradingCom,
            "Only Associate foreign trading company can call this function"
        );
        require(
            status == medicalEquipmentStatus(6),
            "Package must be delivered by Associate shipper"
        );
        if (fTradingCom == address(0x0)) {
            return false;
        }
        status = medicalEquipmentStatus(7);
        emit ShippmentUpdate(BatchID,distributer,fTradingCom,7);
        return true;
    }
    
    function deliveredByFTradingCom() public returns (bool) {
        require(
            msg.sender == fTradingCom,
            "Only Associate foreign trading company can call this function"
        );
        require(
            status == medicalEquipmentStatus(7),
            "Package must be picked by foreign trading company"
        );
        if(custom == address(0x0)) {
            return false;
        }
        status = medicalEquipmentStatus(8);
        emit ShippmentUpdate(BatchID,fTradingCom,custom,8);
        return true;
    }
    
    function pickedByS3() public returns (bool){
        require(
            msg.sender == shipper3,
            "Only Associate Shipper can call this function"
        );
        require(
            status == medicalEquipmentStatus(8),
            "Package must be delivered by foreign trading company."
        );
    
        status = medicalEquipmentStatus(9);
        emit ShippmentUpdate(BatchID,fTradingCom,shipper3,9);
        return true;        
    }
    
    
    function deliveredByS3() public returns (bool) {
        require(
            msg.sender == shipper3,
            "Only Associate Shipper can call this function"
        );
        require(
            status == medicalEquipmentStatus(9),
            "Package must be picked by Associate Shipper"
        );
        if (custom == address(0x0)) {
            return false;
        }
        status = medicalEquipmentStatus(10);
        emit ShippmentUpdate(BatchID,shipper3,custom,10);
    }
    
    
    function checkedByCustom() public returns (bool) {
        require(
            msg.sender == custom,
            "Only custom can call this function"
        );
        require(
            status == medicalEquipmentStatus(10),
            "Package must be delivered by Associate shipper"
        );
        if(fCustomer == address(0x0)) {
            return false;
        }
        status = medicalEquipmentStatus(11);
        emit ShippmentUpdate(BatchID,custom,fCustomer,11);
        return true;
    }
    
    function pickedByFCustomer() public returns (bool){
        require(
            msg.sender == fCustomer,
            "Only foreign customer can call this function"
        );
        require(
            status == medicalEquipmentStatus(11),
            "Package must be checked by custom"
        );
        status = medicalEquipmentStatus(12);
        emit ShippmentUpdate(BatchID,custom,fCustomer,12);
        return true;
    }
}
