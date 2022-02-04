pragma solidity >=0.5.0 <0.7.0;

contract Tontine {
    address public owner;  // ethpool team
    uint public total_paid_in;  
    mapping(address => uint) public balances;
    address[] public addressIndices;

    constructor() public {
         owner = msg.sender;
    }
    
    // deposit by eth team
    function depositReward() payable public {
        require(msg.sender == owner, "Only ETHPool team can deposit rewards.");
        if (msg.sender == owner){
            // pool += msg.value;
            uint arrayLength = addressIndices.length;

            for (uint i=0; i<arrayLength; i++) {
                uint paid_in = balances[addressIndices[i]];
                balances[addressIndices[i]] += (msg.value * paid_in * 1000000) / (total_paid_in  * 1000000);
            }
            total_paid_in += msg.value;
        }
    }
    
    // deposit by player
    function depositPool() payable public{ 
        
        require(msg.value >= 0, "Positive deposits, only.");
        
        addressIndices.push(msg.sender);
        balances[msg.sender] += msg.value;
        total_paid_in += msg.value;
    }
    
    // withdraw by player
    function withdrawPool() payable public {
        require(balances[msg.sender] > 0, "Player is not a participant.");
        
        total_paid_in -= balances[msg.sender];
        msg.sender.transfer(balances[msg.sender]);
        balances[msg.sender] = 0;
    }
}