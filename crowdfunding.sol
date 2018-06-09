pragma solidity ^0.4.0;
contract crowdfundingSkeleton {
    //storage variables: e.g: balance, supporters, goal, , beneficiary
    mapping (address => uint) balances;
    address[] public supporters;
    uint goal = 10 ether;
    address benecifiary;
    uint end;
    uint minimalAmount = 0.5 ether;
    bool closed = false;
    
    //functions e.g: support, checkIfGoalMet, withdrawFunds, refund
    constructor() public{
        benecifiary = msg.sender;
        end = block.timestamp + 1 weeks;
    }
    
    function support() public payable{
        require(msg.value >= minimalAmount);
        require(!closed);
        if(balances[msg.sender] == 0){
            supporters.push(msg.sender);
        }
        balances[msg.sender] += msg.value;
        
        if (checkIfGoalMet()) {
            closed = true;
        }
        
    }
    
    function checkIfGoalMet() private view returns(bool){
        if (address(this).balance >= goal) return true;
        return false;
    }
    
    function withdraw() public {
        require(closed);
        require(msg.sender == benecifiary);
        benecifiary.transfer(address(this).balance);
    }
    
}
