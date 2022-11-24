// SPDX-License-Identifier: MIT
pragma solidity >=0.5.0 <0.9.0;

import "./zombiefeeding.sol";

contract ZombieHelper is ZombieFeeding {

  uint levelUpFee = 0.001 ether;

  // requireの処理を使いまわしたい時に使う
  modifier aboveLevel(uint _level, uint _zombieId) {
    require(zombies[_zombieId].level >= _level);
    _;
  }

  function withdraw() external onlyOwner {
    // このcontractをdeployしたaccountを取得する
    address payable _owner = payable(owner());
    // このcontractのaccountに保存されている全残高を、deployしたaccountに送金する
    _owner.transfer(address(this).balance);
  }

  // ether は、将来価値が変わるかもしれないため、外部から変更できるようにする
  function setLevelUpFee(uint _fee) external onlyOwner {
    levelUpFee = _fee;
  }

  // payable は、modifierの一つでEthの支払いを可能にする.
  // msg.value は、frontendから送信されてきたEth.
  function levelUp(uint _zombieId) external payable {
    require(msg.value == levelUpFee);
    zombies[_zombieId].level++;
  }

  // level2以上であれば使える能力
  // calldata は、externalの時のみ使える. (memoryのように実行後破棄されるが、コピーを作らず値が変更されないことを保証できる？)
  function changeName(uint _zombieId, string calldata _newName) external aboveLevel(2, _zombieId) ownerOf(_zombieId) {
    zombies[_zombieId].name = _newName;
  }

  // level20以上であれば使える能力
  function changeDna(uint _zombieId, uint _newDna) external aboveLevel(20, _zombieId) ownerOf(_zombieId) {
    zombies[_zombieId].dna = _newDna;
  }

  // external view は、書き込みしないことを保証するためgas代がかからない
  // internal view だと、呼び出し元の関数などで書き込みが発生することがあるため、gas代がかかることもある
  function getZombiesByOwner(address _owner) external view returns(uint[] memory) {
    // storageへの参照を持ちつつ処理をするとgas代がかかるため、memoryに箱を作って処理していく
    // 例えば、storage に mapping(address => uint[]) のような変数をもって、account毎にzombieを管理するとする
    // zombieの受け渡しが発生した時に、zombieの追加・削除、配列の中身をずらす処理等が必要になり、gas代が大きくなる
    // それならば、少し手間だが所有しているzombieの取得はloopで走査して行うことにし、少しでもstorageの操作をへらす
    uint[] memory result = new uint[](ownerZombieCount[_owner]);

    uint counter = 0;
    for (uint i = 0; i < zombies.length; i++) {
      if(zombieToOwner[i] == _owner) {
        result[counter] = i;
        counter++;
      }
    }

    return result;
  }
}