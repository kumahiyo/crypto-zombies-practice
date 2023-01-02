
// Import the web3.js library
import Web3 from 'web3'

// Initialize the web3 object
const InitWeb3 = {
  install(app) {
    const initWeb3 = async() => {
      let web3
      if (window.ethereum) {
        // Use the provided provider
        web3 = new Web3(window.ethereum)
        try {
          // Request account access
          await window.ethereum.enable()
        } catch (error) {
          // Handle error
        }
      } else if (window.web3) {
        // Use the provided provider
        web3 = new Web3(window.web3.currentProvider)
      } else {
        // Fallback to a local node
        web3 = new Web3(new Web3.providers.WebsocketProvider('ws://127.0.0.1:8545'))
      }
      return web3
    }
    app.config.globalProperties.$web3 = initWeb3;
  }
}

// Export the web3 object
export default InitWeb3
