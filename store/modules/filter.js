'use strict'
import products from '../../data/products';

const state = {
  productslist: products.data,
  products: products.data,
  // productslist: getDataProducts().then((response) => {return response.data}), 
  // products: getDataProducts().then((response) => {return response.data}),
  tagItems: [],
  filteredProduct: [],
  paginate: 11,
  pages: [],
  priceArray: []
}
// getters
const getters = {
  // filterbyCategory: (state) => {
  //   const category = [...new Set(state.products.map(product => product.type))]
  //   return category
  // },
  // filterbyBrand: (state) => {
  //   const brands = [...new Set(state.filteredProduct.map(product => product.brand))]
  //   return brands
  // },
  // filterbycolor: (state) => {
  //   const uniqueColors = []
  //   state.filteredProduct.filter((product) => {
  //     product.variants.filter((variant) => {
  //       if (variant.color) {
  //         const index = uniqueColors.indexOf(variant.color)
  //         if (index === -1) uniqueColors.push(variant.color)
  //       }
  //     })
  //   })
  //   return uniqueColors
  // },
  filterbysize: (state) => {
    const uniqueSize = []
    state.filteredProduct.filter((product) => {
      product.variants.filter((variant) => {
        if (variant.size) {
          const index = uniqueSize.indexOf(variant.size)
          if (index === -1) uniqueSize.push(variant.size)
        }
      })
    })
    return uniqueSize
  },
  filterProducts: (state) => {
    return state.filteredProduct.filter((product) => {
      if (!state.tagItems.length) return true
      const Tags = state.tagItems.some((prev) => { // Match Tags
        if (product.tags) {
          if (product.tags.includes(prev)) {
            return prev
          }
        }
      })
      return Tags
    })
  }
}
// mutations
const mutations = {
  update_products: (state, payload) => {
        
    state.products = payload
    state.filteredProduct = payload
    
  },
  getCategoryFilter: (state, payload) => {
    state.filteredProduct = []
    state.tagItems = []
    state.products.filter((product) => {
      if (payload === product.type) {
        state.filteredProduct.push(product)
        state.priceArray = state.filteredProduct
      }
      if (payload === 'all' || payload === undefined) {
        state.filteredProduct.push(product)
        state.priceArray = state.filteredProduct
      }
    })
  },
  priceFilter: (state, payload) => {
    state.filteredProduct = []
    state.priceArray.find((product) => {
      if (product.price >= payload[0] && product.price <= payload[1]) {
        state.filteredProduct.push(product)
      }
    })
  },
  setTags: (state, payload) => {
    state.tagItems = payload
  },
  sortProducts: (state, payload) => {
    console.log(payload)
    if (payload === 'а-я') {
      state.filteredProduct.sort(function (a, b) {
        if (a.name < b.name) {
          return -1
        } else if (a.name > b.name) {
          return 1
        }
        return 0
      })
    } else if (payload === 'я-а') {
      state.filteredProduct.sort(function (a, b) {
        if (a.name > b.name) {
          return -1
        } else if (a.name < b.name) {
          return 1
        }
        return 0
      })
    } else if (payload === 'low') {
      state.filteredProduct.sort(function (a, b) {
        if (a.price < b.price) {
          return -1
        } else if (a.price > b.price) {
          return 1
        }
        return 0
      })
    } else if (payload === 'high') {
      state.filteredProduct.sort(function (a, b) {
        if (a.price > b.price) {
          return -1
        } else if (a.price < b.price) {
          return 1
        }
        return 0
      })
    }
  }
}
// actions
const actions = {
  changeProducts({commit}, products){
    commit('update_products', products)
  },
  getpaginate: (context, payload) => {
    context.commit('getpaginate', payload)
  },
  getCategoryFilter: (context, payload) => {
    context.commit('getCategoryFilter', payload)
  },
  priceFilter: (context, payload) => {
    context.commit('priceFilter', payload)
  },
  setTags: (context, payload) => {
    context.commit('setTags', payload)
  },
  sortProducts: (context, payload) => {
    context.commit('sortProducts', payload)
  }
}
export default {
  namespaced: true,
  state,
  getters,
  actions,
  mutations
}