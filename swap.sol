// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";


interface IERC20{

  function transfer(address recipient, uint amount) external  returns(bool);
  function approve(address spender, uint amount) external  returns(bool);
  function transferFrom(address sender, address recipient, uint amount) external returns(bool);
event Transfer(address indexed from, address indexed to, uint amount);
event Approval(address indexed owner, address indexed spender, uint amount);
}

// LINK TOKEN 
contract ERC20_BNB is IERC20{
  uint public totalsupply=30000;
  mapping(address=> uint) public balance;
  mapping(address=> mapping(address=>uint)) public Allowance;
  string public name="BNB";
  string public symbol='BNB';

function transfer(address recipient, uint amount) external override returns(bool){
  balance [msg.sender]-= amount;
  balance[recipient]+=amount;
  emit Transfer(msg.sender, recipient, amount);
  return true;
}
function approve(address spender, uint amount) external override  returns(bool){
  Allowance[msg.sender][spender]= amount;
  emit Approval(msg.sender, spender, amount);
  return true;
}

 function transferFrom(address sender, address recipient, uint amount) external override returns(bool){
 Allowance[sender][msg.sender] -= amount;
  balance [sender]-= amount;
  balance[recipient]+=amount;
  emit Transfer(msg.sender, recipient, amount);
  return true;
 }

}


// WEB3 TOKEN 
contract ERC20_Web3B is IERC20{
  uint public totalsupply=30000;
  mapping(address=> uint) public balance;
  mapping(address=> mapping(address=>uint)) public Allowance;
  string public name="web3Bridge";
  string public symbol='Web3B';

function transfer(address recipient, uint amount) external override returns(bool){
  balance [msg.sender]-= amount;
  balance[recipient]+=amount;
  emit Transfer(msg.sender, recipient, amount);
  return true;
}

function approve(address spender, uint amount) external override  returns(bool){
  Allowance[msg.sender][spender]= amount;
  emit Approval(msg.sender, spender, amount);
  return true;
}

 function transferFrom(address sender, address recipient, uint amount) external override returns(bool){
 Allowance[sender][msg.sender] -= amount;
  balance [sender]-= amount;
  balance[recipient]+=amount;
  emit Transfer(msg.sender, recipient, amount);
  return true;
 }

}

// THE MAIN SWAPPING
contract Token_swap{
    ERC20_BNB public TL;
    ERC20_Web3B public TW;
    address public ownerTL;
    address public ownerTW;
    uint public AmountTL;
    uint public AmountTW;

modifier SWAPPING(){
    require(msg.sender==ownerTL || msg.sender==ownerTW, "Not a participant");
    _;
}
    constructor(
    address _tl,
    address _tw,
    address _addrTL,
    address _addrTW,
    uint _amountTl,
    uint _amountTw
    ){

   TL = ERC20_BNB(_tl);
   TW = ERC20_Web3B(_tw);
   ownerTL=_addrTL;
   ownerTW=_addrTW;
   AmountTL=_amountTl;
   AmountTW=_amountTw;
    }

    function swap() public SWAPPING{
      require(TL.approve(ownerTL, AmountTL), 'Token Allowance invalid') ;
      require(TW.approve(ownerTW, AmountTW), 'Token Allowance invalid') ;
    TransferTokenFrom(TW, ownerTL, ownerTW, AmountTW);
    TransferTokenTo(TL, ownerTW, ownerTL, AmountTL);
    }

    function TransferTokenFrom(ERC20_Web3B tw,address sender, address recipient,uint amount) private {
bool senTW= tw.transferFrom(sender, recipient, amount);
require(senTW, "failed Transfer");
    }
    function TransferTokenTo(ERC20_BNB tl,address sender, address recipient,uint amount) private {
bool senTL= tl.transferFrom(sender, recipient, amount);
require(senTL, "failed Transfer");
    }
}
