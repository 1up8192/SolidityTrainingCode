contract wait{
    function wait(){
        uint startingTime = now;
        while (now <= startingTime + 1 days){
            //do nothing
        }
        //do something
    }
}

contract saveSentAmount{
    mapping (address => uint) amounts;
    
    function send() public payable{
        amounts[msg.sender]=msg.value;
    }
}

contract guessRandomNumber{

    function guess(uint guess) returns (bool){
        if((block.hash * block.timestamp) % 10 == guess) return true;
        return false;
    }
}

contract guessSecretNumber{
    uint private secrtetNumber = 6;
    
    function guess(uint guess) public returns (bool){
        if(secrtetNumber == guess) return true;
        return false;
    }
}

contract openFile {
    
    function getFile(string location) public {
        srting result = file.open(location);
    }
}
