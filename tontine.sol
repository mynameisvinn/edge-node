pragma solidity >=0.5.0 <0.7.0;

contract Tontine {
    address public owner;  // ethpool team
    uint public pool; 
    uint public total_shares; 
    uint private share; 
    mapping(address => uint) public balances;
    address[] public addressIndices;

    constructor() public {
         owner = msg.sender;
    }
    
    function depositReward() payable public {
        require(msg.sender == owner, "Only ETHPool team can deposit rewards.");
        if (msg.sender == owner){
            pool += msg.value;
        }
    }
    
    function depositPool() payable public{ 
        require(msg.value >= 0, "Positive deposits, only.");
        addressIndices.push(msg.sender);
        balances[msg.sender] += msg.value;
        pool += msg.value;
    }
    

    function withdrawPool() payable public {
        require(balances[msg.sender] > 0, "Player is not a participant.");
        require(pool > 0, "Not enough money in the pool.");

        uint arrayLength = addressIndices.length;

        for (uint i=0; i<arrayLength; i++) {
            total_shares += balances[addressIndices[i]];
        }

        share = (balances[msg.sender] * pool * 1000000) / (total_shares  * 1000000);
        pool -= share;

        balances[msg.sender] = 0;
        total_shares = 0;

        msg.sender.transfer(share);
    }
}