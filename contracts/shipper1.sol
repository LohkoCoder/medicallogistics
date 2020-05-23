pragma solidity >=0.4.25 <0.5.3;
import "./medicalEquipment.sol";


contract shipper1 is Owned {
    

    function pickPackage(medicalEquipment _medicalEquipment) onlyOwner public{
        _medicalEquipment.pickedByS1();
    }
    
    function sendPackage(medicalEquipment _medicalEquipment) onlyOwner public{
        _medicalEquipment.deliveredByS1();
    }
}