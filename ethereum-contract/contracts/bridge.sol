// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IERC20 {
    function mint(address to, uint256 amount) external;
    function burn(address from, uint256 amount) external;
}

contract Bridge {
    address public owner;
    address public tokenAddress;  // The ERC-20 token used for minting/burning

    event TokensLocked(address indexed from, uint256 amount);
    event TokensUnlocked(address indexed to, uint256 amount);

    constructor(address _tokenAddress) {
        owner = msg.sender;          // Owner is the address deploying the contract
        tokenAddress = _tokenAddress; // Set the ERC-20 token contract address
    }

    // Function to mint new tokens (triggered by relayer)
    function mintTokens(address to, uint256 amount) external {
        require(msg.sender == owner, "Only the relayer can mint tokens");
        IERC20(tokenAddress).mint(to, amount);
        emit TokensUnlocked(to, amount);
    }

    // Function to burn tokens (when tokens are locked on Solana)
    function burnTokens(address from, uint256 amount) external {
        require(msg.sender == owner, "Only the relayer can burn tokens");
        IERC20(tokenAddress).burn(from, amount);
        emit TokensLocked(from, amount);
    }
}
