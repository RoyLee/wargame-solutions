pragma solidity 0.4.24;

import "../../node_modules/openzeppelin-solidity/contracts/math/SafeMath.sol";

contract PiggyBank is CtfFramework{

    using SafeMath for uint256;

    uint256 public piggyBalance;
    string public name;
    address public owner;
    
    constructor(address _ctfLauncher, address _player, string _name) public payable
        CtfFramework(_ctfLauncher, _player)
    {
        name=_name;
        owner=msg.sender;
        piggyBalance=piggyBalance.add(msg.value);
    }
    
    function() external payable ctf{
        piggyBalance=piggyBalance.add(msg.value);
    }

    
    modifier onlyOwner(){
        require(msg.sender == owner, "Unauthorized: Not Owner");
        _;
    }

    function withdraw(uint256 amount) internal{
        piggyBalance = piggyBalance.sub(amount);
        msg.sender.transfer(amount);
    }

    function collectFunds(uint256 amount) public onlyOwner ctf{
        require(amount<=piggyBalance, "Insufficient Funds in Contract");
        withdraw(amount);
    }
    
}


contract CharliesPiggyBank is PiggyBank{
    
    uint256 public withdrawlCount;
    
    constructor(address _ctfLauncher, address _player) public payable
        PiggyBank(_ctfLauncher, _player, "Charlie") 
    {
        withdrawlCount = 0;
    }
    
    function collectFunds(uint256 amount) public ctf{
        require(amount<=piggyBalance, "Insufficient Funds in Contract");
        withdrawlCount = withdrawlCount.add(1);
        withdraw(amount);
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