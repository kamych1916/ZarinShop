import products from '../../data/products'

const state = {
  products: [],
  cart: []
}
// getters
const getters = {
  cartItems: (state) => {
    return state.cart
  },
  cartTotalAmount: (state) => {
    function discountedPrice(product) {
      const price = product.price - (product.price * product.discount / 100)
      return price
    }
    return state.cart.reduce((total, product) => {
      return total + (discountedPrice(product) * product.kol)
    }, 0)
  }
}
// mutations
const mutations = {
  update_cart: (state, payload) => {
    state.cart = payload;
  },
  delete_cart: (state) => {
    state.cart = [];
  },
  addToCart: (state, payload) => {
    const product = payload
    // const cartItems = state.cart.find(item => item.id === payload.id)
    const qty = payload.kol ? payload.kol : 1

    let check_size_already = false
    if(state.cart.length > 0){
      for(let idsc of state.cart){
        if(idsc.id == payload.id ){
          if(idsc.size == payload.size){
            check_size_already = true
          }
        }
      }
      if(!check_size_already){
        state.cart.push({
          ...product,
          kol: qty
        })
      }
      for(let idc in state.cart){
        if(state.cart[idc].id == payload.id){
          if(state.cart[idc].size == payload.size){
            if(state.cart[idc].stock != state.cart[idc].kol){
              state.cart[idc].kol = qty
              // state.cart.push({
              //   ...product,
              //   kol: qty
              // })
            }
          }
          // if(payload.kol != idc.stock){
          //   state.cart.push({
          //     ...product,
          //     kol: qty
          //   })
          // }
        }
      }
    }else{
      state.cart.push({
        ...product,
        kol: qty
      })
    }
    // }
    product.stock--
  },
  updateCartQuantity: (state, payload) => {
    // Calculate Product stock Counts
    function calculateStockCounts(product, kol) {
      const qty = product.kol + kol
      const stock = product.stock
      if (stock < qty) {
        return false
      }
      return true
    }
    state.cart.find((items, index) => {
      if (items.size === payload.product.size && items.id === payload.product.id) {
        const qty = state.cart[index].kol + payload.qty
        const stock = calculateStockCounts(state.cart[index], payload.qty)
        if (qty !== 0 && stock) {
          state.cart[index].kol = qty
        } else {
          // state.cart.push({
          //   ...product,
          //   kol: qty
          // })
        }
        return true
      }
    })
  },
  removeCartItem: (state, payload) => {
    const index = state.cart.indexOf(payload)
    state.cart.splice(index, 1)
  }
}
// actions
const actions = {
  changeCart({commit}, products){
    commit('update_cart', products)
  },
  delete_cart({commit}){
    commit('delete_cart')
  },
  addToCart: (context, payload) => {
    context.commit('addToCart', payload)
  },
  updateCartQuantity: (context, payload) => {
    context.commit('updateCartQuantity', payload)
  },
  removeCartItem: (context, payload) => {
    context.commit('removeCartItem', payload)
  }
}
export default {
  namespaced: true,
  state,
  getters,
  actions,
  mutations
}
