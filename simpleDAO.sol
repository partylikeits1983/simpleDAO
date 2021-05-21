// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;
/// @title Simple DAO smart contract.
contract simpleDAO {
    
    // This simple proof of concept DAO smart contract sends ether to the digital vending machine
    // only if the majority of the DAO members vote "yes" to buy digital cookies.
    // If the majority of the DAO members decide not to send ether, the members who deposited ether 
    // are able to withdraw the ether they deposited.
    
   
    // address of vending machine
    address payable public VendingMachineAddress;
    
    uint public voteEndTime;
    
    // balance of ether in the smart contract
    uint public DAObalance;
    
    // allow withdrawals
    mapping(address=>uint) balances;
    
    // proposal decision of voters 
    uint decision;

    // default set as false 
    // makes sure votes are counted before ending vote
    bool ended;
    

    struct Voter {
        uint weight; // weight is accumulated by delegation
        bool voted;  // if true, that person already voted
        address delegate; // person delegated to
        uint vote;   // index of the voted proposal
    }

    struct Proposal {
        string name;   // short name (up to 32 bytes)
        uint voteCount; // number of accumulated votes
    }

    // address of the person who set up the vote 
    address public chairperson;

    mapping(address => Voter) public voters;
    Proposal[] public proposals;

    //error handlers

    /// The vote has already ended.
    error voteAlreadyEnded();
    /// The auction has not ended yet.
    error voteNotYetEnded();


    // Sample input string: ["buy_cupcakes", "no_cupcakes"]
    // First item in string is the one that will execute the purchase 
    // _VendingMachineAddress is the address where the ether will be sent
    constructor(
        address payable _VendingMachineAddress,
        uint _voteTime,
        string[] memory proposalNames
    ) {
        VendingMachineAddress = _VendingMachineAddress;
        chairperson = msg.sender;
        
        voteEndTime = block.timestamp + _voteTime;
        voters[chairperson].weight = 1;

        for (uint i = 0; i < proposalNames.length; i++) {

            proposals.push(Proposal({
                name: proposalNames[i],
                voteCount: 0
            }));
        }
    }
    
    // anyone can deposit ether to the DAO smart contract
    // members must deposit at least 1 eth into DAO 
    // this is to avoid complications during withdrawl if the DAO voted to buy cupcakes
    function DepositEth() public payable {
        if (block.timestamp > voteEndTime)
            revert voteAlreadyEnded();
            
        require(msg.value >= 1 ether, "You must deposit at least 1 ETH into DAO");
        
        DAObalance = address(this).balance;
        balances[msg.sender]+=msg.value;
    }
    
    
    
    // only the chairperson can decide who can vote
    function giveRightToVote(address voter) public {

        require(
            msg.sender == chairperson,
            "Only chairperson can give right to vote."
        );
        require(
            !voters[voter].voted,
            "The voter already voted."
        );
        require(voters[voter].weight == 0);
        voters[voter].weight = 1;
    }


    // proposals are in format 0,1,2,...
    function vote(uint proposal) public {
        Voter storage sender = voters[msg.sender];
        require(sender.weight != 0, "Has no right to vote");
        require(!sender.voted, "Already voted.");
        sender.voted = true;
        sender.vote = proposal;
        proposals[proposal].voteCount += sender.weight;
    }

    // winningProposal must be executed before EndVote
    function countVote() public
            returns (uint winningProposal_)
            
    {
        require(
            block.timestamp > voteEndTime,
            "Vote not yet ended.");
        
        uint winningVoteCount = 0;
        for (uint p = 0; p < proposals.length; p++) {
            if (proposals[p].voteCount > winningVoteCount) {
                winningVoteCount = proposals[p].voteCount;
                winningProposal_ = p;
                
                decision = winningProposal_;
                ended = true;
            }
        }
    }


   // Individuals can only withdraw what they deposited.
   // After EndVote function is run and if proposal "buy_cupcakes" won,
   // users will not be able to withdraw ether
    function withdraw(uint amount) public{
        if(balances[msg.sender]>=amount){
        balances[msg.sender]-=amount;
        payable(msg.sender).transfer(amount);
        DAObalance = address(this).balance;
        }
    }
   
   
    // ends the vote
    // if DAO decided not to buy cupcakes members can withdraw deposited ether
    function EndVote() public {
        require(
            block.timestamp > voteEndTime,
            "Vote not yet ended.");
          
        require(
            ended == true,
            "Must tally vote first");  
            
        require(
            decision == 0,
            "DAO decided to not buy cupcakes. Members may withdraw deposited ether.");
            
            
        if (DAObalance  < 1 ether) revert();
            (bool success, ) = address(VendingMachineAddress).call{value: 1 ether}(abi.encodeWithSignature("purchase(uint256)", 1));
            require(success);
            
        DAObalance = address(this).balance;
  
        }
    
}



