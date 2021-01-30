<template>
  <div>
    <Header />
    <Breadcrumbs title="wishlist" />
    <section class="wishlist-section section-b-space">
      <div class="container">
        <div class="row">
          <div class="col-sm-12">
            <table class="table cart-table table-responsive-sm" v-if="wishlist.length">
              <thead>
                <tr>
                  <th scope="col">Изображение</th>
                  <th scope="col">Наименование</th>
                  <th scope="col">Цена</th>
                  <th scope="col">Действие</th>
                </tr>
              </thead>
              <tbody v-for="(item,index) in wishlist" :key="index">
                <tr>
                  <td>
                    <nuxt-link :to="{ path: '/product/sidebar/'+item.id}">
                      <img :src='item.images[0]' alt="">
                    </nuxt-link>
                  </td>
                  <td>
                    <nuxt-link :to="{ path: '/product/sidebar/'+item.id}">{{item.name}}</nuxt-link>
                  </td>
                  <td>
                    <p>{{ (parseInt(discountedPrice(item))).toLocaleString('ru-RU')  }} <small style="color: #aaaaaa; text-transform: initial">сум/шт.</small></p>
                    <!-- <del>{{ (parseInt(item.price)).toLocaleString('ru-RU') }}</del> -->
                  </td>
                  <td>
                    <a href="javascript:void(0)" class="icon mr-3" @click="removeWishlistItem(item)">
                      <i class="ti-close"></i>
                    </a>
                    <!-- <a href="javascript:void(0)" class="cart" @click="addToCart(item)">
                      <i class="ti-shopping-cart" ></i>
                    </a> -->
                  </td>
                </tr>
              </tbody>
            </table>
          </div>
        </div>
        <div class="row wishlist-buttons" v-if="wishlist.length">
          <div class="col-12">
            <nuxt-link :to="{ path: '/'}" :class="'btn btn-solid'">Продолжить покупки</nuxt-link>
          </div>
        </div>
        <div class="col-sm-12 empty-cart-cls text-center" v-if="!wishlist.length">
              <img :src='"@/assets/images/empty-wishlist.png"' class="img-fluid" alt="empty cart" />
              <h3 class="mt-3">
                <strong>Ваш список изобранных пуст</strong>
              </h3>
              <div class="col-12">
                <nuxt-link :to="{ path: '/'}" class="btn btn-solid">Продолжить покупки</nuxt-link>
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
export default {
  components: {
    Header,
    Footer,
    Breadcrumbs
  },
  computed: {
    ...mapGetters({
      wishlist: 'products/wishlistItems',
      curr: 'products/changeCurrency'
    })
  },
  methods: {
    getImgUrl(path) {
      return require('@/assets/images/' + path)
    },
    removeWishlistItem: function (product) {
      this.$store.dispatch('products/removeWishlistItem', product)
    },
    // addToCart: function (product) {
    //   this.$store.dispatch('cart/addToCart', product)
    // },
    discountedPrice(product) {
        const price = product.price - (product.price * product.discount / 100)
        return price
    }
  }
}
</script>
