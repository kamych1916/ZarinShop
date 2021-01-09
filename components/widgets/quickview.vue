<template>
  <div>
    <b-modal
      id="modal-lg"
      size="lg"
      centered
      title="Быстрый просмотр"
      :hide-footer="true"
      @hidden="resetSwiper()"
      v-if="openModal"
    >
      <div class="row quickview-modal">
        <div class="col-lg-6 col-xs-12">
          <div class="quick-view-img">
            <div v-swiper:mySwiper="swiperOption">
              <div class="swiper-wrapper">
                <div
                  class="swiper-slide"
                  v-for="(image, index) in productData.images"
                  :key="index"
                >
                  <img
                    :src="image"
                    :id="index"
                    class="img-fluid bg-img"
                    :alt="image"
                  />
                </div>
              </div>
            </div>
          </div>
        </div>
        <div class="col-lg-6 rtl-text">
          <div class="product-right">
            <h2>{{ productData.name }}</h2>
            <h3 v-if="productData.hit_sales">
              {{
                parseInt(discountedPrice(productData)).toLocaleString("ru-RU")
              }}
              <small style="color: #aaaaaa; text-transform: initial"
                >сум/шт.</small
              >
              <del>{{
                parseInt(productData.price).toLocaleString("ru-RU")
              }}</del>
            </h3>
            <h3 v-else>
              {{ parseInt(productData.price).toLocaleString("ru-RU") }}
              <small style="color: #aaaaaa; text-transform: initial"
                >сум/шт.</small
              >
            </h3>
            <ul class="color-variant" v-if="productData.color">
              <h6 class="product-title">Цвета в наличии</h6>
              <li
                v-for="(variant, variantIndex) in productData.link_color"
                :key="variantIndex"
              >
                <a
                  v-bind:style="{
                    'background-color': variant.color,
                    border: '1px solid #ccc',
                  }"
                ></a>
              </li>
            </ul>
            <div
              class="product-description border-product"
              v-if="productData.size_kol[0].size"
            >
              <h6 class="product-title">Размеры</h6>
              <div class="size-box">
                <ul>
                  <li
                    v-for="(variant, variantIndex) in productData.size_kol"
                    :key="variantIndex"
                  >
                    <a href="javascript:void(0)">{{ variant.size }}</a>
                  </li>
                </ul>
              </div>
            </div>
            <div class="border-product">
              <h6 class="product-title">Описание товара</h6>
              <p>{{ productData.description.substring(0, 250) + "...." }}</p>
            </div>
            <div class="product-buttons">
              <!-- <a href="javascript:void(0)" @click="addToCart(productData)" class="btn btn-solid">в корзину</a> -->
              <nuxt-link
                :to="{ path: '/product/sidebar/' + productData.id }"
                class="btn btn-solid ml-0"
                >Подробнее</nuxt-link
              >
            </div>
          </div>
        </div>
      </div>
    </b-modal>
  </div>
</template>
<script>
import { mapGetters } from "vuex";
export default {
  watch: {
    productData(){
      this.swiperOption = {
        spaceBetween: 20,
        slidesPerView: 1,
        freeMode: true,
        loop: true
      }
    }
  },
  props: ["openModal", "productData"],
  data() {
    return {
      swiperOption: null,
    };
  },
  methods: {
    resetSwiper(){
      this.swiperOption = {
        spaceBetween: 22,
        slidesPerView: 1,
        freeMode: true,
        loop: true
      }
    },
    // Display Unique Color
    Color(variants) {
      const uniqColor = [];
      for (let i = 0; i < Object.keys(variants).length; i++) {
        if (uniqColor.indexOf(variants[i].color) === -1) {
          uniqColor.push(variants[i].color);
        }
      }
      return uniqColor;
    },
    // Display Unique Size
    Size(variants) {
      const uniqSize = [];
      for (let i = 0; i < Object.keys(variants).length; i++) {
        if (uniqSize.indexOf(variants[i].size) === -1) {
          uniqSize.push(variants[i].size);
        }
      }
      return uniqSize;
    },
    // add to cart
    // addToCart: function (product) {
    //   this.$store.dispatch('cart/addToCart', product)
    // },
    // Get Image Url
    getImgUrl(path) {
      return require("@/assets/images/" + path);
    },
    // Display Sale Price Discount
    discountedPrice(product) {
      return product.price - (product.price * product.discount) / 100;
    },
  },
};
</script>

<style>
.product-title {
  text-transform: none !important;
}
</style>
