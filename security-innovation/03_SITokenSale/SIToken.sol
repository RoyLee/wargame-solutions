pragma solidity 0.4.24;

// https://github.com/OpenZeppelin/openzeppelin-solidity/blob/v1.8.0/contracts/token/ERC20/StandardToken.sol
import "../StandardToken.sol";

contract SIToken is StandardToken {

    using SafeMath for uint256;

    string public name = "SIToken";
    string public symbol = "SIT";
    uint public decimals = 18;
    uint public INITIAL_SUPPLY = 1000 * (10 ** decimals);

    constructor() public{
        totalSupply_ = INITIAL_SUPPLY;
        balances[this] = INITIAL_SUPPLY;
    }
}

contract SITokenSale is SIToken, CtfFramework {

    uint256 public feeAmount;
    uint256 public etherCollection;
    address public developer;

    constructor(address _ctfLauncher, address _player) public payable
        CtfFramework(_ctfLauncher, _player)
    {
        feeAmount = 10 szabo; 
        developer = msg.sender;
        purchaseTokens(msg.value);
    }

    function purchaseTokens(uint256 _value) internal{
        require(_value > 0, "Cannot Purchase Zero Tokens");
        require(_value < balances[this], "Not Enough Tokens Available");
        balances[msg.sender] += _value - feeAmount;
        balances[this] -= _value;
        balances[developer] += feeAmount; 
        etherCollection += msg.value;
    }

    function () payable external ctf{
        purchaseTokens(msg.value);
    }

    // Allow users to refund their tokens for half price ;-)
    function refundTokens(uint256 _value) external ctf{
        require(_value>0, "Cannot Refund Zero Tokens");
        transfer(this, _value);
        etherCollection -= _value/2;
        msg.sender.transfer(_value/2);
    }

    function withdrawEther() external ctf{
        require(msg.sender == developer, "Unauthorized: Not Developer");
        require(balances[this] == 0, "Only Allowed Once Sale is Complete");
        msg.sender.transfer(etherCollection);
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