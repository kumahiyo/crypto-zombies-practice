// SPDX-License-Identifier: MIT
pragma solidity >=0.5.0 <0.9.0;

contract ZombieFactory {

  event NewZombie(uint zombieId, string name, uint dna);

  uint dnaDigits = 16;
  uint dnaModulus = 10 ** dnaDigits;

  struct Zombie {
      string name;
      uint dna;
  }

  // 他のアプリからも読み取り可能にしたい
  // ※ 書き込みはデフォルトで不可
  Zombie[] public zombies;

  // ゾンビを生成する
  // グローバル変数と区別するために、(_) をつける
  // memory キーワードがあれば、コピーを作ってメモリに保存する
  // この値を関数内で変えても元の変数に影響を与えない
  // メモリのデータは実行後に破棄される
  // private は、他のcontractからのアクセスを禁止する
  function _createZombie(string memory _name, uint _dna) private {
      zombies.push(Zombie(_name, _dna));
      uint id = zombies.length - 1;
      emit NewZombie(id, _name, _dna);
  }

  // 文字列から16文字長のハッシュ値を生成
  // view は、contract内の他の変数にアクセスするが、修正は行わない
  // pure は、関数外部の変数にも一切アクセスしないし、修正も行わない
  function _generateRandomDna(string memory _str) private view returns (uint) {
      // keccak256: ハッシュ関数 insecure. 文字が1つ違うだけで全く違う文字列になる
      // ハッシュ化した文字列をuintでキャスト
      uint rand = uint(keccak256(abi.encodePacked(_str)));
      // dnaModulus の文字長に
      return rand % dnaModulus;
  }

  // 名前からハッシュ値を生成し、名前とそのハッシュ値からゾンビオブジェクトを配列に格納する
  function createRandomZombie(string memory _name) public {
      uint randDna = _generateRandomDna(_name);
      _createZombie(_name, randDna);
  }
}
