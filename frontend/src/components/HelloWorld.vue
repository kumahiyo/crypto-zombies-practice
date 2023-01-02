<template>
  <div>
    <div id="zombies">
      <div class="zombie">
        <input v-model="zombieName" type="text" name="zombieName" id="zombieName" class="inputField" placeholder="名前を入力してくれ" /><br>
        <a @click.prevent="createRandomZombie()" href="#">ゾンビを作ってやろう
        </a>
      </div>
    </div>

    <div id="txStatus">{{ txStatus }}</div>  

    <div class="zombie-list">
      <div v-for="(zombie, index) in zombies" :key="index" class="zombie-char">
        <div class="zombie-parts" :class="partsVisible(zombie)">
          <img :style="clothesColor(zombie)" v-show="!catMode" class="left-feet" src="@/assets/zombieparts/left-feet-1@2x.png">  
          <img :style="clothesColor(zombie)" v-show="!catMode" class="right-feet" src="@/assets/zombieparts/right-feet-1@2x.png">  

          <img :style="clothesColor(zombie)" v-show="!catMode" class="left-leg" src="@/assets/zombieparts/left-leg-1@2x.png">  
          <img :style="clothesColor(zombie)" v-show="!catMode" class="right-leg" src="@/assets/zombieparts/right-leg-1@2x.png">  

          <img :style="clothesColor(zombie)" v-show="!catMode" class="left-thigh" src="@/assets/zombieparts/left-thigh-1@2x.png">  
          <img :style="clothesColor(zombie)" v-show="!catMode" class="right-thigh" src="@/assets/zombieparts/right-thigh-1@2x.png">

          <img :style="headColor(zombie)" class="left-forearm" src="@/assets/zombieparts/left-forearm-1@2x.png">  
          <img :style="headColor(zombie)" class="right-forearm" src="@/assets/zombieparts/right-forearm-1@2x.png">

          <img :style="headColor(zombie)" class="right-upper-arm" src="@/assets/zombieparts/right-upper-arm-1@2x.png">  

          <img :style="clothesColor(zombie)" class="torso" src="@/assets/zombieparts/torso-1@2x.png">

          <img :style="clothesColor(zombie)" v-show="catMode" class="cat-legs" src="@/assets/zombieparts/catlegs.png">  

          <template v-for="n in 6" :key="n">
            <img v-if="currentShirtChoice(zombie) == n" :style="clothesColor(zombie)" :class="shirtClass(n)" :src="shirtSrc(n)">
          </template>      

          <img :style="headColor(zombie)" class="left-upper-arm" src="@/assets/zombieparts/left-upper-arm-1@2x.png">

          <img :style="headColor(zombie)" class="left-forearm" src="@/assets/zombieparts/left-forearm-1@2x.png">  
          <img :style="headColor(zombie)" class="right-forearm" src="@/assets/zombieparts/right-forearm-1@2x.png">

          <img :style="headColor(zombie)" class="left-hand" src="@/assets/zombieparts/hand1-1@2x.png">  
          <img :style="headColor(zombie)" class="right-hand" src="@/assets/zombieparts/hand-2-1@2x.png">

          <template v-for="n in 7" :key="n">
            <img v-if="currentHeadChoice(zombie) == n" :style="headColor(zombie)" :class="headClass(n)" :src="headSrc(n)">
          </template>
          <template v-for="n in 11" :key="n">
            <img v-if="currentEyeChoice(zombie) == n" :style="eyeColor(zombie)" :class="eyeClass(n)" :src="eyeSrc(n)">
          </template>

          <img class="mouth" src="@/assets/zombieparts/mouth-1@2x.png">

          <ul>
            <li v-if="isMyZombie(zombie.id)" class="tag">所持</li><span v-if="isMyZombie(zombie.id)"><input @change="selectedCheckbox(zombie.id)" type="radio" id="selectedZombie" name="selectedZombie">攻撃ゾンビ</span>
            <li>Name: {{ zombie.name }}</li>
            <li>DNA: {{ zombie.dna }}</li>
            <li>Level: {{ zombie.level }}</li>
            <li>Wins: {{ zombie.winCount }}</li>
            <li>Losses: {{ zombie.lossCount }}</li>
            <!--<li>Ready Time: {{ zombie.readyTime }}</li>-->
            <a v-if="!isMyZombie(zombie.id)" @click.prevent="attack(zombie.id)" href="#">攻撃!</a>
          </ul>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'HelloWorld',
  props: {
    msg: String
  },
  data() {
    return {
      web3: null,
      latestBlock: null,
      cryptoZombies: null,
      userAccount: null,
      zombies: [],
      myZombieList: [],
      selectedZombie: null,
      txStatus: '',
      catMode: false,
      zombieName: '',
    }
  },
  async created() {
    this.web3 = await this.$web3();
    await this.getLatestBlock()

    this.startApp()
  },
  methods: {
    async getLatestBlock() {
      const latestBlock = await this.web3.eth.getBlock('latest')
      this.latestBlock = latestBlock
      console.log(this.latestBlock);
    },
    async startApp() {
      const cryptoZombiesAddress = "0xb2b56eA9d98B99f48363Ed2517Cbc38962ff67B0";
      const cryptoZombiesABI = require('@/assets/build/contracts/CryptoZombies.json');

      // ABI は、Contaractのインターフェイスを定義したもの.
      // 利用するfunctionなどの情報が含まれている
      this.cryptoZombies = new this.web3.eth.Contract(cryptoZombiesABI.abi, cryptoZombiesAddress)

      // MetaMaskなどのアカウントが切り替わったことを検知するため定期的にチェック
      /*
      setInterval(function() {
        // accounts[0] が、現在アクティブなアカウント by MetaMask
        if (this.web3.eth.accounts[0] !== this.userAccount) {
          this.userAccount = this.web3.eth.accounts[0]
          // 所持しているZombieデータをアップデート
          this.getZombiesByOwner(this.userAccount).then(this.displayZombies)
        }
      }, 100)
      */

      // for debug
      this.userAccount = '0xb4C1a7e1fc4b6a3ffBD80b97D7fD4ecb1906d32d';
      this.getAllZombies().then(this.displayZombies)
      this.getZombiesByOwner(this.userAccount).then((myZombies) => {
        this.myZombieList = myZombies
      })

      /*
       * solidityのデフォルト関数.
       * 特定のeventの実行履歴を取得できる.
       * contractの中からは呼び出せないが、gas代も非常に安く利用価値が高い
       *
      this.cryptoZombies.getPastEvents("NewZombie", { fromBlock: 0, toBlock: "latest" })
      .then(function(events) {
        // `events` is an array of `event` objects that we can iterate, like we did above
        // This code will get us a list of every zombie that was ever created
      });
      */

      // backend側でindexed キーワードが宣言されているため、filterが使える.
      // eventは、関係ないユーザのeventも受信するため、accountでフィルターをかける.
      this.cryptoZombies.events.Transfer({ filter: { _to: this.userAccount } })
        .on("data", function(event) {
          let data = event.returnValues
          console.log(data)

          this.getZombiesByOwner(this.userAccount).then(this.displayZombies)
        }).on("error", console.error)
    },
    displayZombies(ids) {
      for (let id of ids) {
        this.getZombieDetails(id).then((zombie) => {
          this.zombies.push({
            id: id,
            name: zombie.name,
            dna: zombie.dna,
            level: zombie.level,
            winCount: zombie.winCount,
            lossCount: zombie.lossCount,
            readyTime: zombie.readyTime
          })
        })
      }
    },
    getZombiesByOwner(owner) {
      return this.cryptoZombies.methods.getZombiesByOwner(owner).call()
    },
    getAllZombies() {
      return this.cryptoZombies.methods.getAllZombies().call()
    },
    // contract側のメソッドをコールする
    // call() は、viewやpureに対してコールされるためgas代はかからない
    // send() は、ストレージなどへの書き込みを含むため、gas代がかかってくる
    getZombieDetails(id) {
      return this.cryptoZombies.methods.zombies(id).call()
    },
    createRandomZombie() {
      if (this.zombieName == '') {
        alert('名前を入力してください')
        return;
      }

      this.txStatus = '新しいゾンビをブロックチェーン上に生成しています. 少しお待ちください...'
      const self = this

      return this.cryptoZombies.methods.createRandomZombie(this.zombieName)
        .send({ from: this.userAccount, gas: '200000' })
        // transaction がブロックチェーンに組み込まれるとコールされる
        .on("receipt", function(receipt) {
          console.log(receipt)
          self.txStatus = 'ゾンビ ' + this.zombieName + ' の生成に成功しました!'

          self.getZombiesByOwner(self.userAccount).then(self.displayZombies);
        })
        .on("error", function(error) {
          self.txStatus = error
        })      
    },
    attack(targetId) {
      this.txStatus = 'ゾンビを攻撃しています。 少しお待ちください...'

      const self = this

      if (!this.selectedZombie) {
        alert("攻撃をするゾンビを選択してください")        
        return;
      }

      return this.cryptoZombies.methods.attack(this.selectedZombie, targetId)
        .send({ from: this.userAccount, gas: '200000' })
        .on("receipt", function(receipt) {
          console.log(receipt)
          self.txStatus = 'ゾンビの攻撃に成功しました! 新しいゾンビが生まれました。'

          self.getZombiesByOwner(self.userAccount).then(self.displayZombies)
        })
        .on("error", function(error) {
          self.txStatus = error
        });
    },
    isMyZombie(zombieId) {
      if (this.myZombieList.includes(zombieId) == true) {
        return true        
      }
      return false
    },
    selectedCheckbox(zombieId) {
      this.selectedZombie = zombieId
    },
    currentHeadChoice(zombie) {
      return parseInt(zombie.dna.substring(0, 2)) % 7 + 1
    },
    currentEyeChoice(zombie) {
      return parseInt(zombie.dna.substring(2, 4)) % 11 + 1
    },
    currentShirtChoice(zombie) {
      return parseInt(zombie.dna.substring(4, 6)) % 6 + 1
    },
    headSrc(i) {
      return require("@/assets/zombieparts/head-" + i + "@2x.png")
    },
    eyeSrc(i) {
      return require("@/assets/zombieparts/eyes-" + i + "@2x.png")
    },
    shirtSrc(i) {
      return require("@/assets/zombieparts/shirt-" + i + "@2x.png")
    },
    headClass(i) {
      return `head head-part-${i}`;
    },
    eyeClass(i) {
      return `eye eye-part-${i}`;
    },
    shirtClass(i) {
      return `shirt shirt-part-${i}`;
    },
    getColor (deg) {
      return `filter: hue-rotate(${deg}deg);`
    },
    currentSkinColorChoice(zombie) {
      return parseInt(zombie.dna.substring(6, 8)) / 100 * 360
    },
    currentEyeColorChoice(zombie) {
      return parseInt(zombie.dna.substring(8, 10)) / 100 * 360
    },
    currentClothesColorChoice(zombie) {
      return parseInt(zombie.dna.substring(10, 12)) / 100 * 360
    },
    headColor (zombie) {
      return this.getColor(this.currentSkinColorChoice(zombie));
    },
    eyeColor (zombie) {
      return this.getColor(this.currentEyeColorChoice(zombie));
    },
    clothesColor (zombie) {
      return this.getColor(this.currentClothesColorChoice(zombie));
    },
    partsVisible(zombie) {
      const headVisible = `head-visible-${this.currentHeadChoice(zombie)}`
      const eyeVisible = `eye-visible-${this.currentEyeChoice(zombie)}`
      const shirtVisible = `shirt-visible-${this.currentShirtChoice(zombie)}`

      return `${headVisible} ${eyeVisible} ${shirtVisible}`
    }
  }
}
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style lang="scss" scoped>
h3 {
  margin: 40px 0 0;
}
ul {
  list-style-type: none;
  padding: 0;
}
li {
  display: inline-block;
  margin: 0 10px;
}
a {
  color: #42b983;
}
.zombie-loading {
  background-size: cover;
  height: 287px;
  width: 192px;
  position: absolute;
  left: 16vh;
  animation: play 0.7s steps(24) infinite;  
}
@keyframes play {
   100% { background-position: -4608px; }
}
.zombie-parts-bin-component {
  background-size: cover;
}
.zombie-preview {
  height: 95vh;
  width: 55vh;
  background-size: cover;
}
.zombie-list {
  width: 100%;
  max-width: 1130px;
  display: flex;
  flex-wrap: wrap;
  margin: 0 auto;
}
.zombie-list > div {
  height: 60vh;
  flex-basis: 100%;

  @media screen and (min-width: 470px) {
    flex-basis: 50%;
  }
  @media screen and (min-width: 768px) {
    height: 70vh;
    flex-basis: 33.33%;
  }
}
.zombie-char {
  position: relative;
}
.share-page .zombie-parts {
  margin-left: 4vh;
}
.zombie-battle-component .zombie-parts {
  margin-left: -1vh;
}
.zombie-parts {
  position: relative;
  margin-top: 10vh;
  margin-left: -10vw;
  .head {
    width: 28vh;
    position: absolute;
    left: 13vh;
    top: -4vh;
  }
  .eye {
    width: 13vh;
    position: absolute;
    left: 23vh;
    top: 8vh;
  }
  .shirt {
    width: 13vh;
    position: absolute;
    left: 15.6vh;
    top: 13vh;
  }
}
.zombie-parts ul {
  position: absolute;
  top: 35vh;
  left: 15vh;
}
.zombie-parts ul li {
  display: block;
  text-align: left;
}
.mouth {
  width: 6vh;
  position: absolute;
  left: 26.6vh;
  top: 15vh;
}
.torso {
  width: 13vh;
  position: absolute;
  left: 15.6vh;
  top: 13vh;
}
.left-thigh {
  width: 6vh;
  position: absolute;
  left: 17.3vh;
  top: 22vh;
}
.right-thigh {
  width: 6vh;
  position: absolute;
  left: 20.4vh;
  top: 22vh;
}
.cat-legs {
  width: 10vh;
  position: absolute;
  left: 15.4vh;
  top: 18vh;
}
.left-hand {
  width: 4vh;
  position: absolute;
  left: 24.3vh;
  top: 19vh;
}
.right-hand{
  width: 4vh;
  position: absolute;
  left: 28.4vh;
  top: 19vh;
}
.left-forearm {
  width: 4vh;
  position: absolute;
  left: 22.3vh;
  top: 20vh;
}
.right-forearm {
  width: 4vh;  
  position: absolute;
  left: 26.4vh;
  top: 20vh;
}
.left-upper-arm {
  width: 6vh;
  position: absolute;
  left: 19.3vh;
  top: 16vh;
}
.right-upper-arm {
  width: 6vh;
  position: absolute;
  left: 23.4vh;
  top: 16vh;
}
.left-leg {
  width: 4vh;
  position: absolute;
  left: 18.3vh;
  top: 27vh;
}
.right-leg {
  width: 3.3vh;
  position: absolute;
  left: 22.3vh;
  top: 27.6vh;
}
.left-feet {
  width: 4vh;
  position: absolute;
  left: 18.3vh;
  top: 30vh;
}
.right-feet {
  width: 3.3vh;
  position: absolute;
  left: 22.3vh;
  top: 30.3vh;
}
.zombie-name {
  text-transform: uppercase;
  font-weight: bold;
  text-shadow: 5px 5px 5px rgba(0,0,0,0.2)
}
.zombie-details {
  position: absolute;
  bottom: 5%;
  left: 50%;
  width: 300px;
  margin-left: -150px;
  text-align: center;
  font-size: 24px;
  color: white;
  font-weight: bold;
}
.zombie-name {
  font-weight: bold;
}
.inputField {
  width: 80%;
  text-align: center;
  padding: 10px 15px; /*ボックスを大きくする*/
  font-size: 16px;
  border-radius: 3px; /*ボックス角の丸み*/
  border: 2px solid #ddd; /*枠線*/
  box-sizing: border-box;
  margin-bottom: 1rem;

  @media screen and (min-width: 768px) {
    width: 30%;  
  }
}
.tag {
  display: inline-block !important;
  background: #42b983;
  color: #ffffff;
  padding: 4px 8px;
  margin: 4px 0;
}
</style>
