pragma solidity ^0.4.0;
contract fallbackExample {
    function () public payable{
        revert();
    }
}
