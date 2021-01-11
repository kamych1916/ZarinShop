<template>
  <div>
    <Header />
    <Breadcrumbs title="Корзина" />
    <section class="cart-section section-b-space" v-if="is_login">
      <div class="container">
        <div class="row">
          <div class="col-sm-12">
            <table class="table cart-table table-responsive-sm" v-if="cart.length">
              <thead>
                <tr>
                  <th scope="col">Изображение</th>
                  <th scope="col">Наименование</th>
                  <th scope="col">Размер</th>
                  <th scope="col">Цена</th>
                  <th scope="col">Количество</th>
                  <th scope="col">Убрать с корзины</th>
                  <!-- <th scope="col">Итого</th> -->
                </tr>
              </thead>
              <tbody v-for="(item,index) in cart" :key="index">
                <tr>
                  <td>
                    <nuxt-link :to="{ path: '/product/sidebar/'+item.id}">
                      <img :src="item.images[0]" alt />
                    </nuxt-link>
                  </td>
                  <td>
                    <nuxt-link :to="{ path: '/product/sidebar/'+item.id}">{{item.name}}</nuxt-link>
                    <div class="mobile-cart-content row">
                      <div class="col-xs-3">
                        <div class="qty-box">
                          <div class="input-group">
                            <span class="input-group-prepend">
                              <button
                                type="button"
                                class="btn quantity-left-minus"
                                data-type="minus"
                                data-field
                                @click="decrement()"
                              >
                                <i class="ti-angle-left"></i>
                              </button>
                            </span>
                            <input
                              type="text"
                              name="quantity"
                              class="form-control input-number"
                              v-model="counter"
                            />
                            <span class="input-group-prepend">
                              <button
                                type="button"
                                class="btn quantity-right-plus"
                                data-type="plus"
                                data-field
                                @click="increment()"
                              >
                                <i class="ti-angle-right"></i>
                              </button>
                            </span>
                          </div>
                        </div>
                      </div>
                      <div class="col-xs-3">
                        <p>{{ (parseInt(discountedPrice(item))).toLocaleString('ru-RU')  }} <small style="color: #aaaaaa; text-transform: initial">сум/шт.</small></p>
                      </div>
                      <div class="col-xs-3">
                        <h2 class="td-color">
                          <a href="#" class="icon">
                            <i class="ti-close"></i>
                          </a>
                        </h2>
                      </div>
                    </div>
                  </td>
                  <td>
                    <p>{{item.size}}</p>
                  </td>
                  <td>
                    <p>{{ (parseInt(discountedPrice(item))).toLocaleString('ru-RU')  }} <small style="color: #aaaaaa; text-transform: initial">сум/шт.</small></p>
                  </td>
                  <td>
                    <div class="qty-box">
                      <div class="input-group">
                        <span class="input-group-prepend">
                          <button
                            type="button"
                            class="btn quantity-left-minus"
                            data-type="minus"
                            data-field
                            @click="decrement(item)"
                          >
                            <i class="ti-angle-left"></i>
                          </button>
                        </span>
                        <input
                          type="text"
                          name="quantity"
                          class="form-control input-number"
                          :disabled="item.kol > item.stock"
                          v-model="item.kol"
                        />
                        <span class="input-group-prepend">
                          <button
                            type="button"
                            class="btn quantity-right-plus"
                            data-type="plus"
                            data-field
                            @click="increment(item)"
                          >
                            <i class="ti-angle-right"></i>
                          </button>
                        </span>
                      </div>
                    </div>
                  </td>
                  <td>
                    <a class="icon" @click="removeCartItem(item)">
                      <i class="ti-close"></i>
                    </a>
                  </td>
                  <!-- <td>
                    <p>{{ (parseInt(discountedPrice(item) * item.quantity)).toLocaleString('ru-RU')  }} <small style="color: #aaaaaa; text-transform: initial">сум.</small></p>
                  </td> -->
                </tr>
              </tbody>
            </table>
            <table class="table cart-table table-responsive-md" v-if="cart.length">
              <tfoot>
                <tr>
                  <td>Общая стоимость:</td>
                  <td>
                    <h2>{{ (cartTotal).toLocaleString('ru-RU') }}&nbsp;<small style="color: #aaaaaa; text-transform: initial">сум.</small></h2>
                  </td>
                </tr>
              </tfoot>
            </table>
            <div class="col-sm-12 empty-cart-cls text-center" v-if="!cart.length">
              <img :src='"@/assets/images/icon-empty-cart.png"' class="img-fluid" alt="empty cart" />
              <h3 class="mt-3">
                <strong>Ваша корзина пуста</strong>
              </h3>
              <h4 class="mb-3">Добавьте в корзину товар для вашего счастья :)</h4>
              <div class="col-12">
                <nuxt-link :to="{ path: '/'}" class="btn btn-solid">Вернутся к товарам</nuxt-link>
              </div>
            </div>
          </div>
        </div>
        <div class="row cart-buttons" v-if="cart.length">
          <div class="col-6">
            <nuxt-link :to="{ path: '/'}" :class="'btn btn-solid'">Вернутся к товарам</nuxt-link>
          </div>
          <div class="col-6">
            <nuxt-link :to="{ path: '/page/account/checkout'}" :class="'btn btn-solid'">Купить</nuxt-link>
          </div>
        </div>
      </div>
    </section>
    <Footer />
  </div>
</template>
<script>
import { mapGetters } from 'vuex'
import Header from '../../../components/header/header1'
import Footer from '../../../components/footer/footer1'
import Breadcrumbs from '../../../components/widgets/breadcrumbs'
import Api from "~/utils/api";
export default {
  data() {
    return {
      counter: 1,
      is_login: false
    }
  },
  components: {
    Header,
    Footer,
    Breadcrumbs
  },
  computed: {
    ...mapGetters({
      cart: 'cart/cartItems',
      cartTotal: 'cart/cartTotalAmount',
      curr: 'products/changeCurrency'
    })
  },
  mounted(){
    if(localStorage.getItem('cil')){
      this.is_login = true
      this.UpdateCart()
    } else{
      this.is_login = false
      this.$router.push('/')
    }
  },
  methods: {
    UpdateCart(){
      Api.getInstance().cart.UpdateCart().then((response) => {
        this.$store.dispatch('cart/changeCart', response.data.items);
      }).catch((error) => {
        console.log("addToCart -> ", error)
      });
    },
    getImgUrl(path) {
      return require('@/assets/images/' + path)
    },
    removeCartItem: function (product) {
      let storeProduct = {
        id: product.id,
        size: product.size
      }
      Api.getInstance().cart.DelFromCart(storeProduct).then((response) => {
        this.$store.dispatch('cart/removeCartItem', product)
      }).catch((error) => {
        console.log("addToCart -> ", error)
      });
    },
    increment(product, qty = 1) {
      this.$store.dispatch('cart/updateCartQuantity', {
        product: product,
        qty: qty
      })
    },
    decrement(product, qty = -1) {
      this.$store.dispatch('cart/updateCartQuantity', {
        product: product,
        qty: qty
      })
    },
    discountedPrice(product) {
        const price = product.price - (product.price * product.discount / 100)
        return price
    }
  }
}
</script>
<style>
.cart-section .cart-table thead th, .wishlist-section .cart-table thead th{
  font-weight: inherit;
}
</style>