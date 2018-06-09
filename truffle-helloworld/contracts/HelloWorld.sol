pragma solidity ^0.4.4;

contract HelloWorld{
    string public greeting = "HelloWorld";
    event greetingChanged (string oldGreeting, string newGreeting, address changerAddress);

    /*function getGreeting() returns(string){
      return greeting;
    }*/

    function setGreeting(string newGreeting) returns(string){
        greetingChanged(greeting, newGreeting, msg.sender);
        greeting = newGreeting;
        return newGreeting;
    }
}
