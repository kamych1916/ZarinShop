<template>
  <div>
<Header />
  <!-- <section class="p-0" v-if="order==''">
      <div class="container">
        <div class="row">
          <div class="col-sm-12">
            <div class="error-section">
              <h1>404</h1>
              <h2>page not found</h2>
              <nuxt-link :to="{ path: '/'}" :class="'btn btn-solid'"> back to home</nuxt-link>
            </div>
          </div>
        </div>
      </div>
    </section> -->
    <!-- thank-you section start -->
    <section class="section-b-space light-layout">
      <div class="container">
        <div class="row">
          <div class="col-md-12">
            <div class="success-text">
              <i class="fa fa-check-circle" aria-hidden="true"></i>
              <h2>Заказ прошёл успешно</h2>
              <p>Благодарим вас за покупки в нашем интернет-магазине</p>
              <p>ID заказа: ..{{order.token}}</p>
            </div>
          </div>
        </div>
      </div>
    </section>
    <!-- Section ends -->
    <!-- order-detail section start -->
    <section class="section-b-space">
      <div class="container">
        <div class="row">
          <div class="col-lg-6">
            <div class="product-order">
              <h3>Детали вашего заказа</h3>
              <div class="row product-order-detail" v-for="(item,index) in order.product" :key="index">
                <div class="col-3">
                  <img :src="item.images[0]" alt class="img-fluid" />
                </div>
                <div class="col-3 order_detail">
                  <div>
                    <h4>Наименование</h4>
                    <h5>{{item.name}}</h5>
                  </div>
                </div>
                <div class="col-3 order_detail">
                  <div>
                    <h4>Количество</h4>
                    <h5>{{item.kol}}</h5>
                  </div>
                </div>
                <div class="col-3 order_detail">
                  <div>
                    <h4>Сумма</h4>
                    <!-- <h5>{{ (item.price * curr.curr) * item.kol | currency(curr.symbol) }}</h5> -->
                    <h5> {{ (parseInt(discountedPrice(item) * item.kol)).toLocaleString('ru-RU')  }} <small style="color: #aaaaaa; text-transform: initial">сум.</small></h5>
                  </div>
                </div>
              </div>
              <div class="total-sec">
                <ul>
                  <li>
                    Общая стоимость
                    <span>{{ (parseInt(cartTotal)).toLocaleString('ru-RU')  }} <small style="color: #aaaaaa; text-transform: initial">сум.</small></span>
                  </li>
                </ul>
              </div>
            </div>
          </div>
          <div class="col-lg-6">
            <div class="row order-success-sec">
              <div class="col-sm-6">
                <h4>Информация о заказе</h4>
                <ul class="order-detail">
                  <li>ID заказа: ..{{order.token}}</li>
                  <li>Дата: Январь .., 2021г</li>
                  <li>Сумма: {{ (parseInt(cartTotal)).toLocaleString('ru-RU') }}</li>
                </ul>
              </div>
              <div class="col-sm-6">
                <h4>Адрес доставки</h4>
                <ul class="order-detail">
                  <li>страна Узбекистан</li>
                  <li>город Ташкент.</li>
                  <li>улица ткакая то</li>
                  <li>индекс такой то</li>
                </ul>
              </div>
              <!-- <div class="col-sm-12 payment-mode">
                <h4>payment method</h4>
                <p>Pay on Delivery (Cash/Card). Cash on delivery (COD) available. Card/Net banking acceptance subject to device availability.</p>
              </div> -->
              <div class="col-md-12">
                <div class="delivery-sec">
                  <h3>Ожидаемая дата доставки</h3>
                  <h2>Январь .., 2021г</h2>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </section>
    <!-- Section ends -->
    <Footer />
  </div>
</template>
<script>
import { mapGetters } from 'vuex'
import Header from '../../components/header/header1'
import Footer from '../../components/footer/footer1'
export default {
  components: {
    Header,
    Footer
  },
  computed: {
    ...mapGetters({
      order: 'products/getOrder',
      cartTotal: 'cart/cartTotalAmount',
      curr: 'products/changeCurrency'
    })
  },
  methods: {
    discountedPrice(product) {
        const price = product.price - (product.price * product.discount / 100)
        return price
    }
    // getImgUrl(path) {
    //   return require('@/assets/images/' + path)
    // }
  }
}
</script>
<style >
.order-success-sec h4 {
    font-weight: 700;
    text-transform: inherit;
}
</style>