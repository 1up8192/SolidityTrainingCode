pragma solidity ^0.4.0;
contract mappingExample{
    
    mapping (address => uint256) levels;
    
    function levelUp(address player) public {
        levels[player] += 1;
    }
}
