pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/Address.sol";


contract WrappedPosi {
    using Address for address payable;

    string public name = "Wrapped Posi";
    string public symbol = "WPOSI";
    uint8 public decimals = 18;

    event Approval(address indexed owner, address indexed spender, uint256 amount);
    event Transfer(address indexed from, address indexed to, uint256 amount);
    event Deposit(address indexed to, uint256 amount);
    event Withdrawal(address indexed from, uint256 amount);

    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;

    receive() external payable {
        deposit();
    }

    function deposit() public payable {
        balanceOf[msg.sender] += msg.value;
        emit Deposit(msg.sender, msg.value);
    }

    function withdraw(uint256 amount) public {
        require(balanceOf[msg.sender] >= amount);
        balanceOf[msg.sender] -= amount;
        payable(msg.sender).sendValue(amount);
        emit Withdrawal(msg.sender, amount);
    }

    function totalSupply() public view returns (uint256) {
        return address(this).balance;
    }

    function approve(address spender, uint256 amount) public returns (bool) {
        allowance[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    function transfer(address to, uint256 amount) public returns (bool) {
        return transferFrom(msg.sender, to, amount);
    }

    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) public returns (bool) {
        require(balanceOf[from] >= amount);

        if (
            from != msg.sender && allowance[from][msg.sender] != type(uint256).max
        ) {
            require(allowance[from][msg.sender] >= amount);
            allowance[from][msg.sender] -= amount;
        }

        balanceOf[from] -= amount;
        balanceOf[to] += amount;

        emit Transfer(from, to, amount);

        return true;
    }
}

