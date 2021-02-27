<template>
  <div>
    <b-modal
      id="modal-cart"
      size="lg"
      centered
      title="Add-to-cart"
      :hide-footer="true"
      :hide-header="true"
      v-if="openCart"
    >
      <div class="row cart-modal">
        <div class="col-lg-12">
          <button class="close" type="button" @click="closeCart(openCart)">
            <span>×</span>
          </button>
          <div class="media">
            <img
              :src="productData.images[0]"
              class="img-fluid"
              :alt="productData.images[0]"
            />
            <div class="media-body align-self-center text-center">
              <h5>
                <i class="fa fa-check"></i>
                <span>{{productData.name}}</span>
                <span>успешно добавлен в коризну.</span>
              </h5>
              <div class="buttons d-flex justify-content-center">
                <nuxt-link
                  :to="{ path: '/page/account/cart'}"
                  class="btn-sm btn-solid mr-2"
                >Корзина</nuxt-link>
                <nuxt-link
                  :to="{ path: '/page/account/checkout'}"
                  class="btn-sm btn-solid mr-2"
                >Купить сейчас</nuxt-link>
                <nuxt-link
                  :to="{ path: '/'}"
                  class="btn-sm btn-solid"
                >Продожить покупки</nuxt-link>
              </div>
              <!-- <div class="upsell_payment">
                <img alt="" class="img-fluid w-auto mt-3" :src='"@/assets/images/payment_cart.png"'>
              </div> -->
            </div>
          </div>
          <!-- <div class="product-section">
                <div class="col-12 product-upsell text-center">
                  <h4>Customers who bought this item also.</h4>
                </div>
                <div class="row">
                  <div
                  v-for="(product,index) in cartRelatedProducts(productData.collection[0], productData.id).slice(0, 4)"
                  :key="index"
                  class="product-box col-sm-3 col-6">
                    <div class="img-wrapper">
                      <div class="front">
                        <nuxt-link :to="{ path: '/product/sidebar/'+product.id}">
                          <img
                            :src='product.images[0]'
                            class="img-fluid"
                            :alt="product.name"
                          />
                        </nuxt-link>
                      </div>
                      <div class="product-detail">
                        <nuxt-link :to="{ path: '/product/sidebar/'+product.id}">
                          <h6>{{ product.title }}</h6>
                        </nuxt-link>
                        <h4 v-if="product.sale">{{ discountedPrice(product) * curr.curr | currency(curr.symbol) }}
                          <del>{{ product.price * curr.curr | currency(curr.symbol) }}</del>
                        </h4>
                        <h4 v-else>{{ product.price * curr.curr | currency(curr.symbol) }}</h4>
                      </div>
                    </div>
                  </div>
                </div>
              </div> -->
        </div>
      </div>
    </b-modal>
  </div>
</template>
<script>
import { mapState, mapGetters } from 'vuex'
export default {
  props: ['openCart', 'productData', 'products', 'category'],
  computed: {
    ...mapState({
      currency: state => state.products.currency
    }),
    ...mapGetters({
      curr: 'products/changeCurrency'
    })
  },
  methods: {
    // Get Image Url
    getImgUrl(path) {
      return require('@/assets/images/' + path)
    },
    closeCart(val) {
      val = false
      this.$emit('closeCart', val)
    },
    // cartRelatedProducts(collection, id) {
    //   return this.products.filter((item) => {
    //     if (item.collection.find(i => i === collection)) {
    //       if (item.id !== id) {
    //         return item
    //       }
    //     }
    //   })
    // },
    discountedPrice(product) {
      return product.price - (product.price * product.discount / 100)
    }
  }
}
</script>
