pragma solidity >=0.4.20;

/*
    Cryptocurrency "FlensCoin".
*/

contract FlensCoin {
    string public message;

    address public creator;
    mapping(address => uint256) public balances;

    // Event that notifies when a transaction is completed
    event Delivered(address from, address to, uint256 amount);

    // Constructor
    constructor() public {
        creator = msg.sender;
        message = "Welcome to FlensCoin!";
    }

    // Function to give anybody FlensCoin-Token (only possible if you are the creator)
    function create(address receiver, uint256 amount) public {
        require(msg.sender == creator);
        balances[receiver] += amount;
    }

    // Function to transfer FlensCoin to another address
    function transferTo(address receiver, uint256 amount) public {
        require(balances[msg.sender] > amount);
        balances[msg.sender] -= amount;
        balances[receiver] += amount;
        emit Delivered(msg.sender, receiver, amount);
    }

    // See balance for selected account
    function getBalance() public view returns (uint256) {
        return balances[creator];
    }
}
