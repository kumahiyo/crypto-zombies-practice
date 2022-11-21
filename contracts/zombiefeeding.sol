// SPDX-License-Identifier: MIT
pragma solidity >=0.5.0 <0.9.0;

import "./zombiefactory.sol";

// Interface は、自分で所有しない前提のcontract
// 業界で標準化した仕様をcontractに組み込んだりする場合に使う
contract KittyInterface {
  function getKitty(uint256 _id) external view returns (
      bool isGestating,
      bool isReady,
      uint256 cooldownIndex,
      uint256 nextActionAt,
      uint256 siringWithId,
      uint256 birthTime,
      uint256 matronId,
      uint256 sireId,
      uint256 generation,
      uint256 genes
  );
}

// ZombieFactory を継承
// これをdeployすればZombieFactoryもdeployされる
contract ZombieFeeding is ZombieFactory {
  // Use Interface
  KittyInterface kittyContract;

  // Interfaceのcontractを外部から変更できるようにすることで、
  // バグが見つかった時に、作り直したcontractに切り替えることができる
  // (ブロックチェーンでは一度deployしたcontractを変更できない)
  function setKittyContractAddress(address _address) external onlyOwner {
    kittyContract = KittyInterface(_address);
  }

  function feedAndMultiply(uint _zombieId, uint _targetDna, string memory _species) public {
      require(msg.sender == zombieToOwner[_zombieId]);

      // 関数内でstorageを使うと変数は参照となる
      // memoryを使うとコピーを変数に入れる
      Zombie storage myZombie = zombies[_zombieId];

      // 16桁であることを保証
      _targetDna = _targetDna % dnaModulus;
      // 新しいDNAは平均値を使う
      uint newDna = (myZombie.dna + _targetDna) / 2;
      // 文字列同士の比較はできないため、ハッシュ化して比較する
      // ハッシュ関数は再現性があるために可能
      if (keccak256(abi.encodePacked(_species)) == keccak256(abi.encodePacked("kitty"))) {
          // 下2桁をDNAの数値から引き、kittyを表す99を足す
          newDna = newDna - newDna % 100 + 99;
      }
      _createZombie("NoName", newDna);
  }

  function feedOnKitty(uint _zombieId, uint _kittyId) public {
      uint kittyDna;

      // returnされる値が複数ある場合の取得方法
      (,,,,,,,,,kittyDna) = kittyContract.getKitty(_kittyId);

      feedAndMultiply(_zombieId, kittyDna, "kitty");
  }
}
