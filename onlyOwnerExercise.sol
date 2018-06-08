pragma solidity ^0.4.0;
contract onlyOwnerExercise {
    
    address owner;
    
    modifier onlyOwner{
        _;
    }
    
    constructor() public {
        
    }
}
