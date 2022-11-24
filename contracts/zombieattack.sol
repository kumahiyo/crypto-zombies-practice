// SPDX-License-Identifier: MIT
pragma solidity >=0.5.0 <0.9.0;

import "./zombiehelper.sol";

contract ZombieAttack is ZombieHelper {
  // nonce 1度しか使えない値
  uint randNonce = 0;
  // zombieが攻撃した時に勝利する確率
  uint attackVictoryProbability = 70;

  function randMod(uint _modulus) internal returns(uint) {
    randNonce++;
    // _modulus で、任意の桁数だけ返す
    return uint(keccak256(abi.encodePacked(block.timestamp, msg.sender, randNonce))) % _modulus;
  }

  function attack(uint _zombieId, uint _targetId) external ownerOf(_zombieId) {
    Zombie storage myZombie = zombies[_zombieId];
    Zombie storage enemyZombie = zombies[_targetId];
    uint rand = randMod(100);   // 2桁(10^2)

    // 70%の確率で勝利
    if (rand <= attackVictoryProbability) {
      // win
      myZombie.winCount++;
      myZombie.level++;
      enemyZombie.lossCount++;
      _feedAndMultiply(_zombieId, enemyZombie.dna, "zombie");
    } else {
      // loss
      myZombie.lossCount++;
      enemyZombie.winCount++;
      _triggerCooldown(myZombie);
    }
  }
}