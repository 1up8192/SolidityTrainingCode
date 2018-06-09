pragma solidity ^0.4.0;
contract koth{
    uint public currentTopBid;
    address public currentWinner;
    address public owner;
    uint public lastBidTime;
    uint public gameStartTime;
    uint public ownerMoney;
    bool public hasEnded;
    uint public roundMoney;
    mapping(address => uint) prizes;
    
    modifier onlyOwner{
        require(msg.sender == owner);
        _;
    }
    
    function bid() public payable {
        if(hasEnded){
            lastBidTime = now;
            gameStartTime = now;
            hasEnded = false;
        }
        if( (lastBidTime + 2 minutes < now) || (gameStartTime + 1 days < now) ){
            restart();
        }
        if(currentTopBid < msg.value){
            currentWinner = msg.sender;
            currentTopBid = msg.value;
            lastBidTime = now;
        }
        roundMoney += msg.value;
    }
    
    function restart() private {
        ownerMoney += roundMoney / 100 * 5;
        prizes[currentWinner] += roundMoney / 100 * 90;
        hasEnded = true;
        currentWinner = 0x0;
        currentTopBid = 0;
        roundMoney = roundMoney / 100 * 5;
    }
    
    constructor() public {
        owner = msg.sender;
    }
    
    function winnerPayout() public {
        uint prize = prizes[msg.sender];
        prizes[msg.sender] = 0;
        msg.sender.transfer(prize);
    }
    
    function withdraw() public onlyOwner{
        owner.transfer(ownerMoney);
        ownerMoney = 0;
    }
    
    function deposit() public payable{
        
    }
    
}
