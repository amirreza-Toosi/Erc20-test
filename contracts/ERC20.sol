//SPDX-License-Identifier: MIT
pragma solidity 0.8.17;
import "@openzeppelin/contracts/utils/Context.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract ERC20 is IERC20, IERC20Metadata, Context {
mapping(address => uint256) private _balances;
mapping(address=>mapping(address=>uint256)) private _allowances;


    string private _name;
    string private _symbol;
    uint256 private _totalSupply;
    constructor(string memory name_, string memory symbol_){
        _name = name_;
        _symbol = symbol_;
    }

    function name() public view virtual override returns(string memory){
        return _name;
    }
    function symbol() public view virtual override returns(string memory){
        return _symbol;
    }
    function decimals() public view virtual override returns(uint8){
        return 18;
    }


    function balanceOf(address account) public view virtual override returns(uint256){
        return _balances[account];
    }
    function totalSupply() public view virtual returns(uint256){
        return _totalSupply;
    }


    function allowance(address owner, address spender)public view virtual override returns(uint256){
        return _allowances[owner][spender];
    }
    function approve(address spender, uint256 amount)public virtual override returns(bool) {
        address owner = _msgSender();
        _approve(owner, spender, amount);
        return true;
    }
    function _approve(address owner, address spender, uint256 amount)internal virtual{
        require(owner != address(0), "ERC20: approve owner the zero address");
        require(spender != address(0), "ERC20: approve spender the zero address");

        _allowances[owner][spender]=amount;
        emit Approval(owner,spender,amount);
    }
    function _spendAllowance(address owner, address spender, uint256 amount)internal virtual{
        uint256 currentAllowance = allowance(owner, spender);
        if(currentAllowance != type(uint256).max){
            require(currentAllowance >= amount, "ERC20: incufficient allowance ");
            unchecked{
                _approve(owner, spender, currentAllowance - amount);
            }
        }
    }
    function increaseAllowance(address spender, uint256,uint256 amount)public virtual returns(bool){
        address owner = _msgSender();
        uint256 currentAllowance = _allowances[owner][spender];
        _approve(owner, spender, currentAllowance + amount);
        return true;
    }
    function decreaseAllowance(address spender, uint256 amount)public virtual returns(bool){
        address owner = _msgSender();
        uint256 currentAllowance = _allowances[owner][spender];
        require (currentAllowance >= amount, "Erc20: decreased allowance bellow zero");
        unchecked{
            _approve(owner ,spender, currentAllowance  - amount);
        }
        return true;
    }

    function transfer(address to, uint256 amount)public virtual override returns(bool){
        address owner = _msgSender();
        _transfer(owner, to, amount);

        return true;
    }

    function transferFrom(address from, address to, uint256 amount)public virtual override returns(bool){
        address spender = _msgSender();
        _spendAllowance(from, spender, amount);
        _transfer(from, to, amount);
        return true;
    }
    

    function _transfer(address from, address to, uint256 amount)internal virtual{
        require(from != address(0), "ERC20: transfer from the zero address");
        require(to != address(0), "ERC20: transfer to the zero address");
        
        uint256 fromBalance = _balances[from];
        require(fromBalance >= amount, "Erc20: transfer amount exceeds balance");

        unchecked{
            _balances[from] -= amount;
            _balances[to] += amount;
        }
        emit Transfer(from, to, amount);

    }




    function _mint(address account, uint256 amount)internal virtual{
        require(account != address(0), "ERC20: mint to the zero address");
        _totalSupply += amount;
        unchecked{
            _balances[account] += amount;
        }
        emit Transfer(address(0), account, amount);
    }
    function _burn(address account, uint256 amount)internal virtual{
        require(account != address(0), "ERC20: burn to the zero address");
        uint256 currentBalance = _balances[account];
        require(currentBalance >= amount, "ERC20: burn amount exceeds balance");

        unchecked{
            _balances[account] = currentBalance - amount;
            _totalSupply -= amount;
        
        }
    emit Transfer(account, address(0), amount);
    }
}





