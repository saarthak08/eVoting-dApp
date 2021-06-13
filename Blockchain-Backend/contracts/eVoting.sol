//SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.5.0 <0.8.0;
pragma experimental ABIEncoderV2;

contract eVoting {
    struct Candidate {
        address accountAddress;
        address[] voters;
        uint256 votersCount;
    }

    address public electionCommissioner;

    mapping(address => bool) public totalVotersList;
    mapping(address => bool) public votedList;

    Candidate[] candidatesList;
    mapping(address => bool) public candidatesMap;

    uint256 public feesForCandidates;
    uint256 public feesForVoters;
    uint256 public totalVotersCount;
    uint256 public totalVotesCount;
    uint256 public totalCandidatesCount;
    bool public isVotingStarted;

    modifier restrictVoting() {
        require(isVotingStarted, "Voting isn't started yet");
        require(msg.sender.balance != 0, "Insufficient Balance");
        require(totalVotersList[msg.sender], "Not a Voter");
        require(!votedList[msg.sender], "Already Voted");
        require(msg.value == 0.8 ether, "Insufficient Balance to Vote");
        _;
    }

    constructor() {
        electionCommissioner = msg.sender;
        feesForCandidates = 0.05 ether;
        feesForVoters = 0.8 ether;
        isVotingStarted = false;
    }

    function startVoting() public {
        require(msg.sender == electionCommissioner, "Unauthorized");
        isVotingStarted = true;
    }

    function stopVoting() public {
        require(msg.sender == electionCommissioner, "Unauthorized");
        isVotingStarted = false;
    }

    function registerAsCandidate() public payable {
        require(!isVotingStarted, "Voting already started! Can't register");
        require(msg.value == feesForCandidates, "Wrong Fees Provided!");
        require(!candidatesMap[msg.sender], "Already a Candidate");
        address[] memory voters;
        Candidate memory candidate =
            Candidate({
                accountAddress: msg.sender,
                voters: voters,
                votersCount: 0
            });
        totalCandidatesCount++;
        candidatesList.push(candidate);
        candidatesMap[msg.sender] = true;
    }

    function registerAsVoter() public {
        require(!isVotingStarted, "Voting already started! Can't register");
        require(!totalVotersList[msg.sender], "Already Registered Voter!");
        totalVotersCount++;
        totalVotersList[msg.sender] = true;
    }

    function getCandidates() public view returns (Candidate[] memory) {
        return candidatesList;
    }

    function vote(address candidate, uint256 index)
        public
        payable
        restrictVoting
    {
        require(candidatesMap[candidate], "Not a Valid Candidate Given");
        require(
            candidatesList[index].accountAddress == candidate,
            "Candidate's address & index don't match"
        );
        candidatesList[index].votersCount++;
        candidatesList[index].voters.push(msg.sender);
        totalVotesCount++;
        votedList[msg.sender] = true;
    }
}
