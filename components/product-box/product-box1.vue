<template>
  <div>
    <div class="img-wrapper">
      <div class="lable-block">
        <span class="lable3" v-if="product.discount && product.discount != 0">{{product.discount}}%</span>
      </div>
      <div class="front">
        <nuxt-link :to="{ path: '/product/sidebar/'+product.id}">
          <img
            :src='product.images[0]'
            :id="product.id"
            class="img-fluid bg-img"
            :alt="product.name"
            :key="index"
          />
        </nuxt-link>
      </div>
      <ul class="product-thumb-list">
        <li
          class="grid_thumb_img"
          :class="{active: imageSrc === image}"
          v-for="(image,index) in product.images"
          :key="index"
          @click="productVariantChange(image)"
        >
          <a href="javascript:void(0);">
            <img :src="image" />
          </a>
        </li>
      </ul>
      <div class="cart-info cart-wrap">
          <!-- <button
            data-toggle="modal"
            data-target="#addtocart"
            title="Добавить в корзину"
            @click="addToCart(product)"
            v-b-modal.modal-cart
            variant="primary"
          >
            <i class="ti-shopping-cart"></i>
          </button> -->
        <a href="javascript:void(0)" title="Wishlist">
          <i class="ti-heart" aria-hidden="true" @click="addToWishlist(product)"></i>
        </a>
        <a href="javascript:void(0)" title="Quick View" @click="showQuickview(product)" v-b-modal.modal-lg variant="primary">
          <i class="ti-search" aria-hidden="true"></i>
        </a>
        <!-- <a href="javascript:void(0)" title="Comapre" @click="addToCompare(product)" v-b-modal.modal-compare variant="primary">
          <i class="ti-reload" aria-hidden="true"></i>
        </a> -->
      </div>
    </div>
    <div class="product-detail">
      <!-- <div class="rating">
        <i class="fa fa-star"></i>
        <i class="fa fa-star"></i>
        <i class="fa fa-star"></i>
        <i class="fa fa-star"></i>
        <i class="fa fa-star"></i>
      </div> -->
      <nuxt-link :to="{ path: '/product/sidebar/'+product.id}">
        <h6>{{ product.name }} </h6>
      </nuxt-link>
      <p>{{ product.description }}</p>
      <h4 v-if="product.discount && product.discount != 0">
        {{ (parseInt(discountedPrice(product))).toLocaleString('ru-RU')  }} <small style="color: #aaaaaa; text-transform: initial">сум/шт.</small> 
        <del>{{ (parseInt(product.price)).toLocaleString('ru-RU') }}</del>
      </h4>
      <h4 v-else>{{ (parseInt(product.price)).toLocaleString('ru-RU') }} <small style="color: #aaaaaa; text-transform: initial">сум/шт.</small></h4>
      <ul class="color-variant" v-if="product.color">
        <li v-for="(variant, variantIndex) in Color(product.link_color)" :key="variantIndex">
          <a
            v-bind:style="{ 'background-color' : variant, 'border': '1px solid #ccc'}"
          ></a>
        </li>
        <!-- <li >
          <a v-bind:style="{ 'background-color' : product.color, 'border' : '1px solid #ccc'}"></a>
        </li> -->
      </ul>
    </div>
  </div>
</template>

<script>
import { mapState, mapGetters } from 'vuex'
import { log } from 'util'
export default {
  props: ['product', 'index'],
  data() {
    return {
      imageSrc: '',
      quickviewProduct: {},
      compareProduct: {},
      cartProduct: {},
      showquickview: false,
      showCompareModal: false,
      cartval: false,
      variants: {
        productId: '',
        image: ''
      },
      dismissSecs: 5,
      dismissCountDown: 0
    }
  },
  computed: {
    ...mapState({
      productslist: state => state.products.productslist
    }),
    ...mapGetters({
      curr: 'products/changeCurrency'
    })
  },
  methods: {
    addToCart: function (product) {
      this.cartval = true
      this.cartProduct = product
      this.$emit('opencartmodel', this.cartval, this.cartProduct)
      this.$store.dispatch('cart/addToCart', product)
    },
    addToWishlist: function (product) {
      this.dismissCountDown = this.dismissSecs
      // this.$emit('showalert', this.dismissCountDown)
      this.$store.dispatch('products/addToWishlist', product)
    },
    showQuickview: function (productData) {
      this.showquickview = true
      this.quickviewProduct = productData
      this.$emit('openquickview', this.showquickview, this.quickviewProduct)
    },
    addToCompare: function (product) {
      this.showCompareModal = true
      this.compareProduct = product
      this.$emit('showCompareModal', this.showCompareModal, this.compareProduct)
      this.$store.dispatch('products/addToCompare', product)
    },
    Color(variants) {
      const uniqColor = []
      for (let i = 0; i < Object.keys(variants).length; i++) {
        if (uniqColor.indexOf(variants[i].color) === -1) {
          uniqColor.push(variants[i].color)
        }
      }
      return uniqColor
    },
    productColorchange(color, product) {
      product.link_color.map((item) => {
        if (item.color === color) {
          product.images.map((img) => {
            if (img.image_id === item.image_id) {
              this.imageSrc = img.src
            }
          })
        }
      })
    },
    productVariantChange(imgsrc) {
      this.imageSrc = imgsrc
    },
    countDownChanged(dismissCountDown) {
      this.dismissCountDown = dismissCountDown
      this.$emit('alertseconds', this.dismissCountDown)
    },
    discountedPrice(product) {
        const price = product.price - (product.price * product.discount / 100)
        return price
    }
  }
}
</script>

<style >
.product-box .img-wrapper .lable-block .lable3, .product-wrap .img-wrapper .lable-block .lable3{
  width: 40px;
}
</style>