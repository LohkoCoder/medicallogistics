pragma solidity >=0.4.25 <0.5.3;
import "./medicalEquipment";

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

contract Manufacturer is Owned {
    

    function sendPackage(medicalEquipment _medicalEquipment, bytes32 _batchId) onlyOwner public{
        _medicalEquipment.deliverByMan(_batchId);
    }
}