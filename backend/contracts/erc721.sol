// SPDX-License-Identifier: MIT
pragma solidity >=0.5.0 <0.9.0;

// ERC721 は、分割できずそれぞれの価値も違うものに適用できる
// なお、ERC20 は、通貨など分割可能で価値が同じものに適用できる
// ここで定義されている関数名などは変更不可(他のトークン、ERC721xなどでも共有利用されるため)
abstract contract ERC721 {
  // event は、そのeventを発生させていないユーザに対してもコールされる.
  // そのため、front-end側でfilterを使って関係のないコールを弾くことができる
  // そのfilterを使うための宣言が、indexed キーワード.
  event Transfer(address indexed _from, address indexed _to, uint256 indexed _tokenId);
  event Approval(address indexed _owner, address indexed _approved, uint256 indexed _tokenId);

  // virtual は、定義だけで関数の中身がないことを示す
  function balanceOf(address _owner) virtual external view returns (uint256);
  function ownerOf(uint256 _tokenId) virtual external view returns (address);
  function transferFrom(address _from, address _to, uint256 _tokenId) virtual external payable;
  function approve(address _approved, uint256 _tokenId) virtual external payable;
}
