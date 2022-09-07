pragma solidity 0.4.24;

import "../../node_modules/openzeppelin-solidity/contracts/math/SafeMath.sol";

contract CtfFramework{
    
    event Transaction(address indexed player);

    mapping(address => bool) internal authorizedToPlay;
    
    constructor(address _ctfLauncher, address _player) public {
        authorizedToPlay[_ctfLauncher] = true;
        authorizedToPlay[_player] = true;
    }
    
    // This modifier is added to all external and public game functions
    // It ensures that only the correct player can interact with the game
    modifier ctf() { 
        require(authorizedToPlay[msg.sender], "Your wallet or contract is not authorized to play this challenge. You must first add this address via the ctf_challenge_add_authorized_sender(...) function.");
        emit Transaction(msg.sender);
        _;
    }
    
    // Add an authorized contract address to play this game
    function ctf_challenge_add_authorized_sender(address _addr) external ctf{
        authorizedToPlay[_addr] = true;
    }

}

contract Donation is CtfFramework{

    using SafeMath for uint256;

    uint256 public funds;

    constructor(address _ctfLauncher, address _player) public payable
        CtfFramework(_ctfLauncher, _player)
    {
        funds = funds.add(msg.value);
    }
    
    function() external payable ctf{
        funds = funds.add(msg.value);
    }

    function withdrawDonationsFromTheSuckersWhoFellForIt() external ctf{
        msg.sender.transfer(funds);
        funds = 0;
    }

}