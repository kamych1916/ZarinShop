<template>
  <div>
    <div class="icon-nav">
      <ul>
        <li class="onhover-div mobile-search">
          <div>
            <!-- <img
              alt
              :src='"@/assets/images/icon/layout4/search.png"'
              @click="openSearch()"
              class="img-fluid"
            > -->
            <div class="desktop-serach p-1 bg-light rounded rounded-pill">
              <div class="input-group">
                <input type="search" v-model="searchString" placeholder="Я ищу.." aria-describedby="button-addon1" class="form-control border-0 rounded rounded-pill  bg-light">
                <div class="input-group-append">
                  <button id="button-addon1" @click="searchString ? $router.push(`/collection/0?search=${searchString}`) : ''" class="btn btn-link text-primary">
                    <img alt :src='"@/assets/images/icon/layout4/search.png"' class="img-fluid">
                  </button>
                </div>
              </div>
            </div>
            <i class="ti-search" @click="openSearch()"></i>
          </div>
          <div id="search-overlay" class="search-overlay" :class="{ opensearch:search }">
            <div>
              <span class="closebtn" @click="closeSearch()" title="Close Overlay">×</span>
              <div class="overlay-content">
                <div class="container">
                  <div class="row">
                    <div class="col-xl-12">
                      <div class="form-group mb-0">
                        <input
                          type="text"
                          class="form-control"
                          v-model="searchString"
                          placeholder="Я ищу.."
                        >
                      </div>
                      <button @click="searchString ? ($router.push(`/collection/0?search=${searchString}`), closeSearch()) : ''" class="btn btn-primary">
                        <img alt :src='"@/assets/images/icon/layout4/search.png"' class="img-fluid">
                      </button>
                      <!-- <ul class="search-results" v-if="searchItems.length">
                        <li v-for="(product,index) in searchItems" :key="index" class="product-box">
                          <div class="img-wrapper">
                            <img
                              :src='product.images[0]'
                              class="img-fluid bg-img"
                              :key="index"
                            />
                          </div>
                          <div class="product-detail">
                            <nuxt-link :to="{ path: '/product/sidebar/'+product.id}">
                              <h6>{{ product.title }}</h6>
                            </nuxt-link>
                            <h4>{{ product.price * curr.curr | currency(curr.symbol) }}</h4>
                          </div>
                        </li>
                      </ul> -->
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </li>
        <li class="onhover-div mobile-cart">
          <div @click="is_login || locale_check_is_login ?  '' : $router.push(`/page/account/login`)">
            <img alt :src='"@/assets/images/icon/layout4/cart.png"' class="img-fluid">
            <i class="ti-shopping-cart"></i>
            <span class="cart_qty_cls">{{cart.length}}</span>
          </div>
          <span v-if="is_login">
            <ul class="show-div shopping-cart" v-if="!cart.length">
              <li>Корзина пуста</li>
            </ul>
            <ul class="show-div shopping-cart" v-if="cart.length">
              <li>
                <div class="total">
                  <h5>
                    Итого :
                    <span>{{ parseInt(cartTotal).toLocaleString('ru-RU') }} сум.</span>
                  </h5>
                </div>
              </li>
              <li>
                <div class="buttons wrap_buy_cart">
                  <nuxt-link :to="{ path: '/page/account/cart'}" :class="'view-cart'">
                    корзина
                  </nuxt-link>
                  <nuxt-link :to="{ path: '/page/account/checkout'}" :class="'checkout'">
                    купить сейчас
                  </nuxt-link>
                </div>
              </li>
              <li v-for="(item,index) in cart" :key="index" class="mt-2">
                <div class="media">
                  <nuxt-link :to="{ path: '/product/sidebar/'+item.id}">
                    <img alt class="mr-3" :src='item.images[0]'>
                  </nuxt-link>
                  <div class="media-body">
                    <nuxt-link :to="{ path: '/product/sidebar/'+item.id}">
                      <h6>{{item.name}} - <b>{{item.size.toUpperCase()}}</b></h6> 
                    </nuxt-link>
                    <h4>
                      <span>{{item.kol}} x {{ parseInt(discountedPrice(item)).toLocaleString('ru-RU') }} <small>сум/шт.</small></span>
                    </h4>
                  </div>
                </div>
                <div class="close-circle">
                  <a @click='removeCartItem(item)'>
                    <i class="fa fa-times" aria-hidden="true"></i>
                  </a>
                </div>
              </li>
            </ul>
          </span>
        </li>
        <!-- <li class="onhover-div mobile-setting">
          <div>
            <img alt :src='"@/assets/images/icon/layout4/setting.png"' class="img-fluid">
            <i class="ti-settings"></i>
          </div>
          <div class="show-div setting">
            <ul class="list-inline">
              <li>
                <a href="javascript:void(0)" @click="updateLanguage('ru')"><img width="20" src="https://aux2.iconspalace.com/uploads/387440583.png" alt=""> Русский </a>
              </li>
              <li>
                <a href="javascript:void(0)" @click="updateLanguage('uz')"><img width="18" src="https://cdn.countryflags.com/thumbs/uzbekistan/flag-button-round-250.png" alt=""> Узбекский </a>
              </li>
 
            </ul>
          </div>
        </li> -->
        <!-- <li class="onhover-div mobile-setting">
          <div>
            <img alt :src='"@/assets/images/icon/layout4/setting.png"' class="img-fluid">
            <i class="ti-settings"></i>
          </div>
          <div class="show-div setting">
            <h6>currency</h6>
            <ul class="list-inline">
              <li>
                <a href="javascript:void(0)" @click="updateCurrency('eur', '€')">eur</a>
              </li>
              <li>
                <a href="javascript:void(0)" @click="updateCurrency('inr', '₹')">inr</a>
              </li>
              <li>
                <a href="javascript:void(0)" @click="updateCurrency('gbp', '£')">gbp</a>
              </li>
              <li>
                <a href="javascript:void(0)" @click="updateCurrency('usd', '$')">usd</a>
              </li>
            </ul>
          </div>
        </li> -->

      </ul>
    </div>
  </div>
</template>
<script>
import Api from "~/utils/api"
import { mapState, mapGetters } from 'vuex'
export default {
  data() {
    return {
      currencyChange: {},
      search: false,
      searchString: '',
      is_login: null,
    }
  },
  computed: {
    locale_check_is_login(){
      return localStorage.getItem('cil')
    },
    ...mapState({
      searchItems: state => state.products.searchProduct
    }),
    ...mapGetters({
      cart: 'cart/cartItems',
      cartTotal: 'cart/cartTotalAmount',
      curr: 'products/changeCurrency'
    })
  },
  mounted(){
    this.check_is_login()
  },
  methods: {
    check_is_login(){
      Api.getInstance().auth.is_login().then((response) => {
        this.is_login = true;
        this.UpdateCart();
      }).catch(error => {});
    },
    UpdateCart(){
      Api.getInstance().cart.UpdateCart().then((response) => {
        if(response.data.length > 0){
          this.$store.dispatch('cart/changeCart', response.data.items);
        }
      }).catch((error) => {
        console.log("addToCart -> ", error)
      });
    },
    openSearch() {
      this.search = true
    },
    closeSearch() {
      this.search = false
    },
    searchProduct() {
      this.$store.dispatch('products/searchProduct', this.searchString)
    },
    removeCartItem: function (product) {
      let storeProduct = {
        id: product.id,
        size: product.size
      }
      Api.getInstance().cart.DelFromCart(storeProduct).then((response) => {
        this.$bvToast.toast('Товар успешно удалён из корзины.', {
          title: `Сообщение`,
          variant: "success",
          solid: true
        })
        this.$store.dispatch('cart/removeCartItem', product)
      }).catch((error) => {
        console.log("addToCart -> ", error)
      });
    },
    updateLanguage(lang) {
      Api.getInstance().lang.GetLanguage(lang).then((response) => {
        localStorage.setItem('lang_select', lang);
        this.$store.dispatch('lang/load_language', response.data);
        setTimeout(()=>{
          window.location.reload(true)
        }, 500)
      }).catch((error) => {
        console.log("GetLanguage -> ", error)
      });
    },
    discountedPrice(product) {
        const price = product.price - (product.price * product.discount / 100)
        return price
    }
  }
}
</script>

<style>
.wrap_buy_cart{
  border-bottom: 1px solid #f1f5f4;
  padding-bottom: 10px;
}
</style>