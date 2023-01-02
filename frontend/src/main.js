import { createApp } from 'vue'
import App from './App.vue'
import InitWeb3 from './plugins/Web3'

createApp(App).use(InitWeb3).mount('#app')
