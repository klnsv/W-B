pragma solidity >=0.7.0 <0.9.0;

contract voting{

    address voter;
    //bool isVoted;
    uint initialTime = block.timestamp;
    uint64[] voteArray;
    struct candidate
    {
        string name;
        uint64 votes;
    }
    
    mapping(address => bool) isVoted;
    constructor() {
        voter = msg.sender;
        //isVoted = false;
    }

    candidate[] internal  cand;

    event newVote (address sender, string candidate_name , uint64 votes);

    function postCandidate(string memory _name) public {

        uint8 counter=0;
        candidate memory newCandidate ;
        newCandidate.name = _name;
        newCandidate.votes =0;
        for (uint8 i = 0; i < cand.length; i++) {
        if (keccak256(abi.encodePacked(cand[i].name)) == keccak256(abi.encodePacked(_name))) {
            counter++;
        }
        }
        if(counter ==0){
            cand.push(newCandidate);
        }
        
        /*
        candidate memory newCandidate = candidate({
            name: _name,
            votes: 0
        });
        */

        //cand.push(newCandidate);
        
    }

    function getCandidates() public view returns(candidate[] memory) {
        return cand;
    }

    function deleteCandidate(string memory _name) public {
    for (uint8 i = 0; i < cand.length; i++) {
        if (keccak256(abi.encodePacked(cand[i].name)) == keccak256(abi.encodePacked(_name))) {
            cand[i] = cand[cand.length-1];
            cand.pop();
            break;
        }
    }
    }

    modifier checkingValidity {
        require(isVoted[voter] == false);
        _;
    }
    
    function postVotes(string memory _name) checkingValidity public {
        uint nowTime = block.timestamp;
        require(nowTime-initialTime <= 86400);
        for (uint8 i = 0; i < cand.length; i++) {
            if (keccak256(abi.encodePacked(cand[i].name)) == keccak256(abi.encodePacked(_name))) {
                cand[i].votes++;
                isVoted[voter]= true;
                emit newVote(voter, _name, cand[i].votes);
                break;
            }
        }
    }

    
    function declaringWinner() public view returns(candidate memory){
        
        for(uint8 i=0;i<cand.length;i++){
            uint8 counter =0;
            for(uint8 j=0;j<cand.length;j++){
                if(cand[i].votes>cand[j].votes){
                    counter++;
                }
             }
             if(counter == (cand.length-1)){
                return cand[i];
            }
        }

        return cand[0];
    }
    //Incase of a tiebreak it still announces winner, who is situated before the another candidate 

    /*
    function postVoting() public {
        
    }
    */


}
