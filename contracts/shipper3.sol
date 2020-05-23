pragma solidity >=0.4.25 <0.5.3;
import "./medicalEquipment.sol";


contract shipper3 is Owned {
    

    function pickPackage(medicalEquipment _medicalEquipment) onlyOwner public{
        _medicalEquipment.pickedByS3();
    }
    
    function sendPackage(medicalEquipment _medicalEquipment) onlyOwner public{
        _medicalEquipment.deliveredByS3();
    }
}