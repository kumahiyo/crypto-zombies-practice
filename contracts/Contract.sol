// SPDX-License-Identifier: MIT
pragma solidity >=0.5.0 <0.6.0;

contract ZombieFactory {
  uint dnaDigits = 16;
  uint dnaModulus = 10 ** dnaDigits;

  struct Zombie {
      string name;
      uint dna;
  }

  // 他のアプリからも読み取り可能にしたい
  // ※ 書き込みはデフォルトで不可
  Zombie[] public zombies;

  // グローバル変数と区別するために、(_) をつける
  // memory キーワードがあれば、コピーを作ってメモリに保存する
  // この値を関数内で変えても元の変数に影響を与えない
  // メモリのデータは実行後に破棄される
  function createZombie(string memory _name, uint _dna) public {

  }
}
