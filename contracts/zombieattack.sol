// SPDX-License-Identifier: MIT
pragma solidity >=0.5.0 <0.9.0;

import "./zombiehelper.sol";

contract ZombieAttack is ZombieHelper {
  // nonce 1度しか使えない値
  uint randNonce = 0;
  // zombieが攻撃した時に勝利する確率
  uint attackVictoryProbability = 70;

  function randMod(uint _modulus) internal returns(uint) {
    randNonce = randNonce.add(1);
    // _modulus で、任意の桁数だけ返す
    return uint(keccak256(abi.encodePacked(block.timestamp, msg.sender, randNonce))) % _modulus;
  }

  function attack(uint _zombieId, uint _targetId) external onlyOwnerOf(_zombieId) {
    Zombie storage myZombie = zombies[_zombieId];
    Zombie storage enemyZombie = zombies[_targetId];
    uint rand = randMod(100);   // 2桁(10^2)

    // 70%の確率で勝利
    if (rand <= attackVictoryProbability) {
      // win
      myZombie.winCount = myZombie.winCount.add(1);
      myZombie.level = myZombie.level.add(1);
      enemyZombie.lossCount = enemyZombie.lossCount.add(1);
      _feedAndMultiply(_zombieId, enemyZombie.dna, "zombie");
    } else {
      // loss
      myZombie.lossCount = myZombie.lossCount.add(1);
      enemyZombie.winCount = enemyZombie.winCount.add(1);
      _triggerCooldown(myZombie);
    }
  }
}
