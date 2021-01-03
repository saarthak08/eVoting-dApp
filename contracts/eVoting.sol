pragma solidity >=0.5 <0.8;
pragma experimental ABIEncoderV2;

contract eVoting {
    
    struct Candidate {
        string name;
        string party;
        address accountAddress;
        address[] voters;
        uint votersCount;
    }
    
    address public electionCommissioner;
    
    mapping(address=>bool) public totalVotersList;
    mapping(address=>bool) public votedList;
    
    Candidate[] public candidatesList;
    mapping(address=>bool) candidatesMap;
    
    uint public feesForCandidates;
    uint public feesForVoters;
    uint public totalVotersCount;
    uint public totalVotesCount;
    uint public totalCandidatesCount;

     
    modifier restrictVoting() {
        require(msg.sender.balance!=0,"Insufficient Balance");
        require(totalVotersList[msg.sender],"Not a Voter");
        require(!votedList[msg.sender],"Already Voted");
        require(msg.value == 0.9 ether,"Insufficient Balance to Vote");
        _;
    }
    
    constructor() {
        electionCommissioner=msg.sender;
        feesForCandidates=0.05 ether;
        feesForVoters=0.9 ether;
    }
    
    
    function registerAsCandidate(string memory name, string memory party) public payable {
        require(msg.value==feesForCandidates,"Wrong Fees Provided!");
        require(!candidatesMap[msg.sender],"Already a Candidate");
        address[] memory voters;
        Candidate memory candidate=Candidate({
            name:name,
            party:party,
            accountAddress:msg.sender,
            voters:voters,
            votersCount:0
        });
        totalCandidatesCount++;
        candidatesList.push(candidate);
        candidatesMap[msg.sender]=true;
    }
    
    function registerAsVoter() public {
        require(!totalVotersList[msg.sender],"Already Registered Voter!");
        totalVotersCount++;
        totalVotersList[msg.sender]=true;
    }
    
    function getCandidates() public view returns(Candidate[] memory) {
        return candidatesList;
    }
    
   
    function vote(address candidate, uint index) public payable restrictVoting {
        require(candidatesMap[candidate],"Not a Valid Candidate Given");
        require(candidatesList[index].accountAddress==candidate,"Candidate's address & index don't match");
        candidatesList[index].votersCount++;
        candidatesList[index].voters.push(msg.sender);
        totalVotesCount++;
        votedList[msg.sender]=true;
    }
    
}