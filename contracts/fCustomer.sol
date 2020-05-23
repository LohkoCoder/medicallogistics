pragma solidity >=0.4.25 <0.5.3;
import "./medicalEquipment.sol";


contract fTradingCom is Owned {
    

    function pickPackage(medicalEquipment _medicalEquipment) onlyOwner public{
        _medicalEquipment.pickedByFCustomer();
    }

}