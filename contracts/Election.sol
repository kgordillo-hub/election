pragma solidity 0.5.8;

contract Election {
  
    struct Candidate{
    	uint id;
    	string name;
    	uint voteCount;
    }

    //Store accounts that have voted
    mapping(address => bool) public voters;
    //Store Candidates
    //Fetch Candidate
    mapping (uint => Candidate) public candidates;
    //Store candidates count
    uint public candidatesCount;

    // Constructor
    constructor () public {
       addCandidate("Pedrinchi el mazimo");
       addCandidate("El corrupto del barrio");
    }

    function addCandidate(string memory _name) private{
    	candidatesCount ++;
    	candidates[candidatesCount] = Candidate(candidatesCount, _name, 0);
    }

    function vote (uint _candidateId) public {
    	// require that they haven't voted before
    	require(!voters[msg.sender]);

    	// require a valid candidate
    	require(_candidateId > 0 && _candidateId <= candidatesCount);

    	// record that voter has voted
    	voters[msg.sender] = true;

    	//update candidate vote count
    	candidates[_candidateId].voteCount ++;

    	// trigger voted event
    	emit votedEvent(_candidateId);
    }

    event votedEvent(
    	uint indexed _candidateId
    );
}