// SPDX-License-Identifier: MIT
pragma solidity >=0.5.0 <0.9.0;

// Ownable contractは、
import "./ownable.sol";

contract ZombieFactory is Ownable {

  event NewZombie(uint zombieId, string name, uint dna);

  // default to storage variables
  uint dnaDigits = 16;
  uint dnaModulus = 10 ** dnaDigits;

  struct Zombie {
      string name;
      uint dna;
  }

  // 他のアプリからも読み取り可能にしたい
  // ※ 書き込みはデフォルトで不可
  Zombie[] public zombies;

  // zombieから所有者のaccountを取得
  // 所有者から所有しているzombieの数を取得
  mapping (uint => address) public zombieToOwner;
  mapping (address => uint) ownerZombieCount;   // addressが存在しない場合は、0を返す (default to internal)

  // ゾンビを生成する
  // グローバル変数と区別するために、(_) をつける
  // 引数にmemory キーワードがあれば、関数呼び出し時にコピーを作って渡す
  // この値を関数内で変えても元の変数に影響を与えない
  // メモリのデータは実行後に破棄される
  // private は、継承先を含む他のcontractからのアクセスを禁止する
  // internal は、privateに継承先からのアクセスも許可したもの
  // external は、外部contractからのアクセスのみ許可する (内部contractからのアクセス不可)
  function _createZombie(string memory _name, uint _dna) internal {
      zombies.push(Zombie(_name, _dna));

      // local variable is memory by default. (not storage)
      uint id = zombies.length - 1;

      // 所有者とzombieの所有数を登録する
      zombieToOwner[id] = msg.sender;
      ownerZombieCount[msg.sender]++;

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
      require(ownerZombieCount[msg.sender] == 0);

      uint randDna = _generateRandomDna(_name);
      _createZombie(_name, randDna);
  }
}
