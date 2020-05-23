pragma solidity >=0.4.25 <0.5.3;
import "./medicalEquipment.sol";


contract distributer is Owned {
    

    function pickPackage(medicalEquipment _medicalEquipment) onlyOwner public{
        _medicalEquipment.pickedByDistributer();
    }
    
    function sendPackage(medicalEquipment _medicalEquipment) onlyOwner public{
        _medicalEquipment.deliveredByDistributer();
    }
}