pragma solidity 0.4.24;

import "../CtfFramework.sol";

contract Lockbox1 is CtfFramework{

    uint256 private pin;

    constructor(address _ctfLauncher, address _player) public payable
        CtfFramework(_ctfLauncher, _player)
    {
        pin = now%10000;
    }
    
    function unlock(uint256 _pin) external ctf{
        require(pin == _pin, "Incorrect PIN");
        msg.sender.transfer(address(this).balance);
    }

}

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