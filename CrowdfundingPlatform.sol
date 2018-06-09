pragma solidity ^0.4.0;
contract crowdfundingSkeleton {
    //storage variables: e.g: balance, supporters, goal, , beneficiary
   
    //functions e.g: support, checkIfGoalMet, withdrawFunds, refund
   
    struct Crowdfunding {
     uint balance;
     mapping (address => uint) balances;
     address[] supporters;
     uint goal;
     address beneficiary;
     uint endDate;
     uint minimalAmount;
     bool closed;
    }
   
    mapping (uint => Crowdfunding) fundings;
    
    uint[] campaignsList; // hogy lehessen keresni
     
     function create(uint identifier, uint _goal, uint _minimalAmount, uint _days) public {
         require(fundings[identifier].endDate == 0); //ha már létezik az id, hiba
         Crowdfunding funding;
         funding.goal = 10 ether;
         funding.minimalAmount = 0.5 ether;
         funding.beneficiary = msg.sender;
         funding.endDate = block.timestamp + 1 days;
         fundings[identifier] = funding;
         campaignsList.push(identifier);
     }
     
     function support(uint identifier) public payable {
         Crowdfunding funding = fundings[identifier];
         require(msg.value >= funding.minimalAmount);
         require(!funding.closed);
         funding.balance += msg.value;
         funding.balances[msg.sender] += msg.value;
         if (funding.balances[msg.sender] == 0) {
            funding.supporters.push(msg.sender);
         }
         
         if (checkIfGoalMet(funding)) {
             funding.closed = true;
         }
     }
     
     function checkIfGoalMet(Crowdfunding  funding) private view returns (bool) {
         return funding.balance >= funding.goal;
     }
     
     function withdrawFunds(Crowdfunding storage funding) private {
         require(funding.closed);
         require(msg.sender == funding.beneficiary);
         funding.beneficiary.transfer(funding.balance);
     }
}
