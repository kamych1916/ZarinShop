import Vue from 'vue'
import Vuex from 'vuex'
import blog from './modules/blog'
import menu from './modules/menu'
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
      blog,
      menu,
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
