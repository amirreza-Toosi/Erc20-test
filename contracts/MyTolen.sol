//SPDX-License-Identifier: MIT
pragma solidity 0.8.17;
import "./ERC20.sol";
contract MyToken is ERC20{
    constructor(string memory _name, string memory _symbol, uint256 _initialSupply) ERC20(_name, _symbol){
        address owner = _msgSender();
        _mint(owner, _initialSupply);
    }
}