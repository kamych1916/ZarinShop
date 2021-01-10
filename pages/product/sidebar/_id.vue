<template>
  <div>
    <Header />
    <Breadcrumbs :title="getDetail.name" />
    <section class="section-b-space">
      <div class="collection-wrapper">
        <div class="container">
          <div class="row">

            <div class="col-lg-9 col-sm-12 col-xs-12 productdetail">
              <div class="container-fluid">
                <div class="row">
                  <div class="col-lg-6">
                    <div v-swiper:mySwiper="swiperOption" ref="mySwiper">
                      <div class="swiper-wrapper">
                        <div
                          class="swiper-slide"
                          v-for="(product,index) in getDetail.images"
                          :key="index"
                        >
                          <img
                            :src="product"
                            :id="index"
                            class="img-fluid bg-img"
                            :alt="product"
                          />
                        </div>
                      </div>
                    </div>
                    <div class="row">
                      <div class="col-12 slider-nav-images">
                        <div v-swiper:mySwiper1="swiperOption1">
                          <div class="swiper-wrapper">
                            <div
                              class="swiper-slide"
                              v-for="(product,index) in getDetail.images"
                              :key="index"
                            >
                              <img
                                :src="product"
                                :id="index"
                                class="img-fluid bg-img"
                                alt="product.alt"
                                @click="slideTo(index)"
                              />
                            </div>
                          </div>
                        </div>
                      </div>
                    </div>
                  </div>
                  <div class="col-lg-6 rtl-text">
                    <div class="product-right">
                      <h2>{{ getDetail.name }}</h2>
                      <h4 v-if="getDetail.discount && getDetail.discount != 0">
                        <del>{{ (parseInt(getDetail.price)).toLocaleString('ru-RU') }}</del>
                        <span>скидка {{ getDetail.discount }}%</span>
                      </h4>
                      <h3 v-if="getDetail.discount && getDetail.discount != 0">{{ (parseInt(discountedPrice(getDetail))).toLocaleString('ru-RU')  }} <small style="color: #aaaaaa; text-transform: initial">сум/шт.</small></h3>
                      <h3 v-else>{{ (parseInt(getDetail.price)).toLocaleString('ru-RU') }} <small style="color: #aaaaaa; text-transform: initial">сум/шт.</small></h3>
                      <ul class="color-variant" v-if="getDetail.link_color">
                        <li
                          v-bind:class="{ active: activeColor == variant}"
                          v-for="(variant,variantIndex) in Color(getDetail.link_color)"
                          :key="variantIndex"
                        >
                          <nuxt-link :to="{ path: `/product/sidebar/${variant.id}`}"
                            :class="[variant]"
                            v-bind:style="{ 'background-color' : variant.color}"
                          ></nuxt-link>
                        </li>
                      </ul>
                      <!-- <div class="pro_inventory" v-if="getDetail.stock < 8">
                        <p class="active"> Hurry! We have only {{ getDetail.stock }} product in stock. </p>
                        <div class="inventory-scroll">
                          <span style="width: 95%;"></span>
                        </div>
                      </div> -->
                      <div class="product-description border-product">
                        <h6 class="product-title size-text">
                          Выберите размер
                          <span>
                            <a href="javascript:void(0)" v-b-modal.modal-1>таблица размеров</a>
                          </span>
                        </h6>
                        <div class="size-box">
                          <ul>
                            <li
                              class="product-title"
                              v-bind:class="{ active: selectedSize == size}"
                              v-for="(size,index) in size"
                              :key="index"
                            >
                              <a
                                href="javascript:void(0)"
                                @click="changeSizeVariant(size)"
                              >{{size}}</a>
                            </li>
                          </ul>
                        </div>
                        <h5 class="avalibility" v-if="counter <= productStock">
                          <span>В наличии {{productStock}} шт.</span>
                        </h5>
                        <!-- <h5 class="avalibility" v-if="counter > productStock">
                          <span>Out of Stock</span>
                        </h5> -->
                        <h6 class="product-title">Выберите количество</h6>
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
                              readonly
                              :disabled="counter > productStock"
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
                      <div class="product-buttons">
                        <!-- <nuxt-link :to="{ path: '/page/account/cart'}"> -->
                          <button
                            class="btn btn-solid "
                            title="Add to cart"
                            @click="addToCart(getDetail, counter)"
                            :disabled="counter > getDetail.stock"
                          >В корзину</button>
                        <!-- </nuxt-link> -->
                        <button
                            class="btn btn-solid"
                            title="buy now"
                            @click="buyNow(getDetail, counter)"
                            :disabled="counter > getDetail.stock"
                          >Купить сейчас</button>
                      </div>
                      <div class="border-product">
                        <h6 class="product-title">Описание товара</h6>
                        <p v-if="getDetail.description">{{getDetail.description.substring(0,200)+"...."}}</p>
                      </div>
                      <div class="border-product">
                        <div class="product-icon">
                            <button class="wishlist-btn" @click="addToWishlist(getDetail)">
                              <i class="fa fa-heart"></i>
                              <span class="title-font">Добавить в избранное</span>
                            </button>
                        </div>
                      </div>
                      <!-- <div class="border-product">
                        <h6 class="product-title">Time Reminder</h6>
                        <Timer date="December 20, 2020" />
                      </div> -->
                    </div>
                  </div>
                </div>
              </div>
              <section class="tab-product m-0">
                <div class="row">
                  <div class="col-sm-12 col-lg-12">
                    <b-tabs card>
                      <b-tab title="Описание товара" active>
                        <b-card-text>{{getDetail.description}}</b-card-text>
                      </b-tab>
                      <b-tab title="Детали товара">
                        <b-card-text>
                          <div class="single-product-tables">
                            <table>
                              <tbody>
                                <tr>
                                  <td>Febric</td>
                                  <td>Chiffon</td>
                                </tr>
                                <tr>
                                  <td>Color</td>
                                  <td>Red</td>
                                </tr>
                                <tr>
                                  <td>Material</td>
                                  <td>Crepe printed</td>
                                </tr>
                              </tbody>
                            </table>
                            <table>
                              <tbody>
                                <tr>
                                  <td>Length</td>
                                  <td>50 Inches</td>
                                </tr>
                                <tr>
                                  <td>Size</td>
                                  <td>S, M, L .XXL</td>
                                </tr>
                              </tbody>
                            </table>
                          </div>
                        </b-card-text>
                      </b-tab>
                      <!-- <b-tab title="Video">
                        <b-card-text>
                          <div class="mt-3 text-center">
                            <iframe
                              width="560"
                              height="315"
                              src="https://www.youtube.com/embed/BUWzX78Ye_8"
                              allow="autoplay; encrypted-media"
                              allowfullscreen
                            ></iframe>
                          </div>
                        </b-card-text>
                      </b-tab> -->
                      <!-- <b-tab title="Write Review">
                        <b-card-text>
                          <form class="theme-form">
                            <div class="form-row">
                              <div class="col-md-12">
                                <div class="media">
                                  <label>Rating</label>
                                  <div class="media-body ml-3">
                                    <div class="rating three-star">
                                      <i class="fa fa-star"></i>
                                      <i class="fa fa-star"></i>
                                      <i class="fa fa-star"></i>
                                      <i class="fa fa-star"></i>
                                      <i class="fa fa-star"></i>
                                    </div>
                                  </div>
                                </div>
                              </div>
                              <div class="col-md-6">
                                <label for="name">Name</label>
                                <input
                                  type="text"
                                  class="form-control"
                                  id="name"
                                  placeholder="Enter Your name"
                                  required
                                />
                              </div>
                              <div class="col-md-6">
                                <label for="email">Email</label>
                                <input
                                  type="text"
                                  class="form-control"
                                  id="email"
                                  placeholder="Email"
                                  required
                                />
                              </div>
                              <div class="col-md-12">
                                <label for="review">Review Title</label>
                                <input
                                  type="text"
                                  class="form-control"
                                  id="review"
                                  placeholder="Enter your Review Subjects"
                                  required
                                />
                              </div>
                              <div class="col-md-12">
                                <label for="review">Review Title</label>
                                <textarea
                                  class="form-control"
                                  placeholder="Wrire Your Testimonial Here"
                                  id="exampleFormControlTextarea1"
                                  rows="6"
                                ></textarea>
                              </div>
                              <div class="col-md-12">
                                <button class="btn btn-solid" type="submit">Submit YOur Review</button>
                              </div>
                            </div>
                          </form>
                        </b-card-text>
                      </b-tab> -->
                    </b-tabs>
                  </div>
                </div>
              </section>
            </div>
            <div class="col-lg-3">
              <productSidebar />
            </div>  
          </div>
        </div>
      </div>
      <!-- <relatedProduct :productTYpe="productTYpe" :productId="productId" /> -->
      <b-modal id="modal-1" size="md" centered hide-footer>
        <template v-slot:modal-title>{{getDetail.name}}</template>
        <img src="../../../assets/images/size-chart.jpg" alt="size-chart" class="img-fluid" />
      </b-modal>
    </section>
    <Footer />
  </div>
</template>
<script>
import { mapState, mapGetters } from 'vuex'
import Header from '../../../components/header/header1'
import Footer from '../../../components/footer/footer1'
import Breadcrumbs from '../../../components/widgets/breadcrumbs'
import Timer from '../../../components/widgets/timer'
import productSidebar from '../../../components/widgets/product-sidebar'
import relatedProduct from '../../../components/widgets/related-products'
import Api from "~/utils/api"
export default {
  components: {
    Header,
    Footer,
    Breadcrumbs,
    Timer,
    productSidebar,
    relatedProduct
  },
  data() {
    return {
      productStock: 0,
      counter: 1,
      activeColor: '',
      selectedSize: '',
      qty: '',
      size: [],
      productTYpe: '',
      productId: '',
      swiperOption: {
        slidesPerView: 1,
        spaceBetween: 20,
        freeMode: true
      },
      swiperOption1: {
        slidesPerView: 3,
        spaceBetween: 30,
        freeMode: true,
        centeredSlides: false
      }
    }
  },
  computed: {
    ...mapState({
      currency: state => state.products.currency
    }),
    ...mapGetters({
      curr: 'products/changeCurrency',
      getDetail: 'products/getProductById'
    }),
    // getDetail: function () {
    //   return this.$store.getters['products/getProductById'](
    //     this.$route.params.id
    //   )
    // },
    swiper() {
      return this.$refs.mySwiper.swiper
    }
  },
  mounted() {
    this.getDataProduct();
    // For displaying default color and size on pageload
    // this.uniqColor = this.getDetail.variants[0].color
    
    // Active default color
    this.activeColor = this.uniqColor
    // this.changeSizeVariant(this.getDetail.variants[0].size)
    // related product type
    this.relatedProducts()
  },
  methods: {
    getDataProduct(){
      Api.getInstance().products.getData_item(this.$route.params.id).then((response) => {
        this.$store.dispatch("products/changeProduct", response.data);
        this.$store.dispatch('cart/changeProduct', response.data);
        // this.sizeVariant(response.data.size_kol[0].size)
        response.data.size_kol.filter((item)=>{
          this.size.push(item.size)  
        })
        this.changeSizeVariant(response.data.size_kol[0].size)
      }).catch((error) => {
        console.log("getDataProducts -> ", error)
      });
    },
    priceCurrency: function () {
      this.$store.dispatch('products/changeCurrency')
    },
    addToWishlist: function (product) {
      this.$store.dispatch('products/addToWishlist', product)
    },
    discountedPrice(product) {
      const price = product.price - (product.price * product.discount / 100)
      return price
    },
    // Related Products display
    relatedProducts() {
      this.productTYpe = this.getDetail.type
      this.productId = this.getDetail.id
    },
    // Display Unique Color
    Color(variants) {
      const uniqColor = []
      for (let i = 0; i < Object.keys(variants).length; i++) {
        if (uniqColor.indexOf(variants[i].color) === -1) {
          uniqColor.push({color: variants[i].color, id: variants[i].id})
        }
      }
      return uniqColor
    },
    // add to cart
    addToCart: function (product, qty) {
      product.quantity = qty || 1;
      product.stock = this.productStock;
      this.$store.dispatch('cart/addToCart', product)
    },
    buyNow: function (product, qty) {
      product.quantity = qty || 1
      this.$store.dispatch('cart/addToCart', product)
      this.$router.push('/page/account/checkout')
    },
    // Item Count
    increment() {
      if(this.counter < this.productStock){
        this.counter++
      }
    },
    decrement() {
      if (this.counter > 1) this.counter--
    },
    // Change size variant
    changeSizeVariant(variant) {
      this.counter = 1;
      this.getDetail.size_kol.filter((size_item)=>{
        if(size_item.size == variant){
          this.productStock = size_item.kol
        }
      })
      this.selectedSize = variant
    },
    getImgUrl(path) {
      return require('@/assets/images/' + path)
    },
    slideTo(id) {
      this.swiper.slideTo(id, 1000, false)
    },
    sizeVariant(id, slideId, color) {
      this.swiper.slideTo(slideId, 1000, false)
      this.size = []
      this.activeColor = color
      this.getDetail.variants.filter((item) => {
        if (id === item.image_id) {
          this.size.push(item.size)
        }
      })
    }
  }
}
</script>
<style>
.product-right .size-box ul li a {
  font-size: inherit !important
}
.form-control:disabled, .form-control[readonly]{
  background-color: inherit;
}
.product-right .product-icon .wishlist-btn i{
  border-left: 0px;
  padding-left: 0px;
  margin-left: 0px;
}
.product-right h4 span{
  text-transform: capitalize
}
</style>
