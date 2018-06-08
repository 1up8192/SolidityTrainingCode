pragma solidity ^0.4.0;
contract requireExample{
    function percent(uint number, uint percentNumber) public returns (uint){
        require(percentNumber<=100);
        return number / 100 * percentNumber;
    }
}
