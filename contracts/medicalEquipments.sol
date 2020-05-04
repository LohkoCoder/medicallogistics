pragma solidity >=0.4.25 <0.5.3;

contract medicalEquipment {
    
    address Owner;
    
    enum medicalEquipmentStatus {
        /// 出厂
        deliveredatM,
        /// 经销商收货
        picked4D,
        /// 经销商发货
        deliveredatD,
        /// 外贸商收货
        picked4T,
        /// 外贸商发货
        deliveredatT,
        /// 海关查货
        picked4C,
        /// 海关发货
        deliveredatC,
        /// 国外客户收货
        picked4F
    }
    
    event ShippmentUpdate(
        address indexed BatchID,
        address indexed Shipper,
        address indexed Receiver,
        uint Status
    );

    
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

    constructor(
        address Manufacturer, /// 生产商
        address Shipper1, 
        address Distributer, // 经销商
        address Shipper2,
        address TradingCom, // 外贸公司 
        address Shipper3,
        address Custom, // 海关 
        address ForeignCustomer  // 国外客户
        ) public {
        Owner = manufacturer;
        manufacturer = Manufacturer;
        shipper1 = Shipper1;
        distributer = Distributer;
        shipper2 = Shipper2;
        fTradingCom = TradingCom;
        shipper3 = Shipper3;
        custom = Custom;
        fCustomer = ForeignCustomer;
        status = medicalEquipmentStatus(0);
    }
    
    /// @notice
    /// @dev Pick Equipment Batch by Associate Transporter
    /// @param shpr Transporter Ethereum Network Address
    function pickPackagea1(
        address shpr
    ) public {
        require(
            shpr == shipper1,
            "Only Associate Shipper can call this function"
        );
        require(
            status == medicalEquipmentStatus(0),
            "Package must be at Manufacturer."
        );

        status = medicalEquipmentStatus(1);
        emit ShippmentUpdate(address(this),shipper1,distributer,1);
        
    }
    
    /// @notice
    /// @dev Received Equipment Batch by Associated Wholesaler or Distributer
    /// @param Rcvr
    function distributerReceivedPackage(
        address Rcvr
    ) public
    returns(uint rcvtype)
    {

        require(
            Rcvr == distributer,
            "Only distributer can call this function"
        );

        require(
            uint(status) = 1,
            "Product not picked up yet"
        );

        status = medicalEquipmentStatus(2);
        emit ShippmentUpdate(address(this),shipper1,distributer,2);
        return 1;

    }
    
    /// @notice
    /// @dev Pick Equipment Batch by Associate Transporter
    /// @param shpr Transporter Ethereum Network Address
    function pickPackagea2(
        address shpr
    ) public {
        require(
            shpr == shipper2,
            "Only Associate Shipper can call this function"
        );
        require(
            uint(status) = 2,
            "Package must be at Distributer."
        );

        status = medicalEquipmentStatus(3);
        emit ShippmentUpdate(address(this),shipper2,fTradingCom,3);
        
    }
    
        
    /// @notice
    /// @dev Received Equipment Batch by Associated Wholesaler or Distributer
    /// @param Rcvr
    function fTradingComReceivedPackage(
        address Rcvr
    ) public
    returns(uint rcvtype)
    {

        require(
            Rcvr == fTradingCom,
            "Only foreign trading company can call this function"
        );

        require(
            uint(status) = 3,
            "Product not picked up yet"
        );
        
        status = medicalEquipmentStatus(4);
        emit ShippmentUpdate(address(this),shipper2,fTradingCom,4);


    }
    
    /// @notice
    /// @dev Pick Equipment Batch by Associate Transporter
    /// @param shpr Transporter Ethereum Network Address
    function pickPackagea3(
        address shpr
    ) public {
        require(
            shpr == shipper3,
            "Only Associate Shipper can call this function"
        );
        require(
            uint(status) = 4,
            "Package must be at foreign trading company."
        );

        status = medicalEquipmentStatus(5);
        emit ShippmentUpdate(address(this),shipper3,custom,5);
        
    }


    /// @notice
    /// @dev Received Equipment Batch by custom
    /// @param Rcvr
    function customReceivedPackage(
        address Rcvr
    ) public
    returns(uint rcvtype)
    {

        require(
            Rcvr == custom,
            "Only custom can call this function"
        );

        require(
            uint(status) = 5,
            "Product not picked up yet"
        );
        
        status = medicalEquipmentStatus(6);
        emit ShippmentUpdate(address(this),shipper3,custom,6);

    }
    
    /// @notice
    /// @dev Deliver Equipment Batch by custom
    /// @param shpr Transporter Ethereum Network Address
    /// 注意：这一步不需要重新
    function customDeliverPackage(
        address Custom,
        bool authorized
    ) public {
        require(
            Custom == custom,
            "Only custom can call this function"
        );
        require(
            uint(status) = 6,
            "Package must be at custom."
        );

        status = medicalEquipmentStatus(7);
        
        if(authorized) {
            emit ShippmentUpdate(address(this),custom,fCustomer,7);
            quantity = 1;
            description = "products can be exported";
        } else { /// 产品不合格就退还给退还给物流公司
            emit ShippmentUpdate(address(this),custom,shipper3,7);
            quantity = 0;
            description = "products cannot be exported";
        }
        
    }
    
    /// @notice
    /// @dev Received Equipment Batch by Associated Wholesaler or Distributer
    /// @param Rcvr
    function fCustomerReceivedPackage(
        address Rcvr
    ) public
    returns(uint rcvtype)
    {

        require(
            Rcvr == fCustomer,
            "Only foreign customer can call this function"
        );

        require(
            uint(status) = 7,
            "Product not picked up yet"
        );

        status = medicalEquipmentStatus(8);
        emit ShippmentUpdate(address(this),custom,fCustomer,8);
    }
    
}
