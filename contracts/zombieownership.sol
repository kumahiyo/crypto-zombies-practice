// SPDX-License-Identifier: MIT
pragma solidity >=0.5.0 <0.9.0;

import "./zombieattack.sol";
import "./erc721.sol";

contract ZombieOwnership is ZombieAttack, ERC721 {
  // zombie を送る時に、送り先が承認されているかを確認するために使用
  mapping (uint => address) zombieApprovals;

  // override は、virtualな関数を呼び出していることを示す
  function balanceOf(address _owner) override external view returns (uint256) {
    return ownerZombieCount[_owner];
  }

  function ownerOf(uint256 _tokenId) override external view returns (address) {
    return zombieToOwner[_tokenId];
  }

  function _transfer(address _from, address _to, uint256 _tokenId) private {
      ownerZombieCount[_to]++;
      ownerZombieCount[_from]--;
      zombieToOwner[_tokenId] = _to;

      emit Transfer(_from, _to, _tokenId);
  }

  function transferFrom(address _from, address _to, uint256 _tokenId) override external payable {
    // zombie の所有者 or 送り先として認証されている人だけが transferできる.
    require(zombieToOwner[_tokenId] == msg.sender || zombieApprovals[_tokenId] == msg.sender);

    _transfer(_from, _to, _tokenId);
  }

  // 承認できるのはzombieを持っている所有者だけ
  function approve(address _approved, uint256 _tokenId) override external payable onlyOwnerOf(_tokenId) {
    // 承認済みのaccountとして登録
    zombieApprovals[_tokenId] = _approved;
    
    emit Approval(msg.sender, _approved, _tokenId);
  }
}
