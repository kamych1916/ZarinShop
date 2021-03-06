import Vue from 'vue'
import Vuex from 'vuex'
import products from './modules/products'
import cart from './modules/cart'
import filter from './modules/filter'
import layout from './modules/layout'
import auth from './modules/auth'
import lang from './modules/lang'

Vue.use(Vuex)
const createStore = () => {
  return new Vuex.Store({
    modules: {
      products,
      cart,
      filter,
      layout,
      auth,
      lang
    }
  })
}
export default createStore
