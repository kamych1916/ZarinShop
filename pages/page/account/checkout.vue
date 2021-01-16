<template>
  <div>
    <Header />
    <Breadcrumbs title="Checkout" />
    <section class="section-b-space" v-if="is_login">
      <div class="container">
        <div class="checkout-page">
          <div class="checkout-form">
            <ValidationObserver v-slot="{ invalid }">
            <form @submit.prevent="onPaymentComplete">
              <div class="row">
                <div class="col-lg-6 col-sm-12 col-xs-12">
                  <div class="checkout-title">
                    <h3>Платежные реквизиты</h3>
                  </div>
                  <div class="row check-out">
                    <div class="form-group col-md-6 col-sm-6 col-xs-12">
                      <div class="field-label">Имя</div>
                      <ValidationProvider rules="required" v-slot="{ errors }" name="First name">
                        <input type="text" v-model="user.firstName" name="First name"/>
                        <span class="validate-error">{{ errors[0] }}</span>
                      </ValidationProvider>
                    </div>
                    <div class="form-group col-md-6 col-sm-6 col-xs-12">
                      <div class="field-label">Фамилия</div>
                      <ValidationProvider rules="required" v-slot="{ errors }" name="Last name">
                        <input type="text" v-model="user.lastName" name="Last name" />
                        <span class="validate-error">{{ errors[0] }}</span>
                      </ValidationProvider>
                    </div>
                    <div class="form-group col-md-6 col-sm-6 col-xs-12">
                      <ValidationProvider rules="required" v-slot="{ errors }" name="Phone">
                        <div class="field-label">Номер телефона</div>
                        <input type="text" v-model="user.phone" name="Phone" />
                        <span class="validate-error">{{ errors[0] }}</span>
                      </ValidationProvider>
                    </div>
                    <div class="form-group col-md-6 col-sm-6 col-xs-12">
                      <div class="field-label">Email адрес</div>
                      <ValidationProvider rules="required|email" v-slot="{ errors }" name="Email">
                        <input type="text" v-model="user.email" name="Email Address" />
                        <span class="validate-error">{{ errors[0] }}</span>
                      </ValidationProvider>
                    </div>
                    <!-- <div class="form-group col-md-12 col-sm-12 col-xs-12">
                      <div class="field-label">Страна</div>
                      <select>
                        <option selected>Узбекистан</option>
                        <option>Россия</option>
                        <option>Украина</option>
                      </select>
                    </div> -->
                    <div class="form-group col-md-12 col-sm-12 col-xs-12">
                      <div class="field-label">Адрес</div>
                      <ValidationProvider rules="required" v-slot="{ errors }" name="Address">
                        <input type="text" v-model="user.address" name="Address" />
                        <span class="validate-error">{{ errors[0] }}</span>
                      </ValidationProvider>
                    </div>
                    <div class="form-group col-md-12 col-sm-12 col-xs-12">
                      <div class="field-label">Город</div>
                      <ValidationProvider rules="required" v-slot="{ errors }" name="City">
                        <input type="text" v-model="user.city" name="City" />
                        <span class="validate-error">{{ errors[0] }}</span>
                      </ValidationProvider>
                    </div>
                    <div class="form-group col-md-12 col-sm-6 col-xs-12">
                      <div class="field-label">Улица</div>
                      <ValidationProvider rules="required" v-slot="{ errors }" name="State">
                        <input type="text" v-model="user.state" name="State" />
                        <span class="validate-error">{{ errors[0] }}</span>
                      </ValidationProvider>
                    </div>
                    <div class="form-group col-md-12 col-sm-6 col-xs-12">
                      <div class="field-label">Почтовый индекс</div>
                      <ValidationProvider rules="required" v-slot="{ errors }" name="Postal Code">
                        <input type="text" v-model="user.pincode" name="Postal Code" />
                        <span class="validate-error">{{ errors[0] }}</span>
                      </ValidationProvider>
                    </div>
                  </div>
                </div>
                <div class="col-lg-6 col-sm-12 col-xs-12">
                  <div class="checkout-details">
                    <div class="order-box">
                      <div class="title-box">
                        <div>
                          Товары
                          <span>Стоимость</span>
                        </div>
                      </div>
                      <ul class="qty"  v-if="cart.length">
                        <li v-for="(item,index) in cart" :key="index">
                          {{ item.name }} <div style="color: #eac075; display: inline">x {{ item.kol }}</div>
                          <span>{{ (parseInt(discountedPrice(item) * item.kol)).toLocaleString('ru-RU')  }} сум.</span>
                        </li>
                      </ul>
                      <ul class="sub-total">
                        <li>
                          Общая стоимость
                          <span class="count">{{ (parseInt(cartTotal)).toLocaleString('ru-RU')  }} сум.</span>
                        </li>
                        <li>Способ доставки
                            <div class="shipping">
                                <!-- <div class="shopping-option">
                                    <input type="checkbox" name="free-shipping" id="free-shipping">
                                    <label for="free-shipping">Доставка</label>
                                </div>
                                <div class="shopping-option">
                                    <input type="checkbox" name="local-pickup" id="local-pickup">
                                    <label for="local-pickup">Самовывоз</label>
                                </div> -->
                                <b-form-group v-slot="{ Shipping }">
                                  <b-form-radio v-model="shipping" :aria-describedby="Shipping" name="shipping-delivery" value="delivery">
                                    Доставка
                                  </b-form-radio>
                                  <b-form-radio v-model="shipping" :aria-describedby="Shipping" name="shipping-pickup" value="pickup">
                                    Самовывоз
                                  </b-form-radio>
                                </b-form-group>
                            </div>
                        </li>
                      </ul>
                      <!-- <ul class="sub-total">
                        <li>
                          Total
                          <span class="count">{{ cartTotal * curr.curr | currency(curr.symbol) }}</span>
                        </li>
                      </ul> -->
                    </div>
                    <div class="payment-box">
                      <div class="upper-box">
                          <h5 class="pmnt-method">Выберите способ оплаты</h5>
                        <div class="payment-options" >
                          <b-form-group v-slot="{ Payment }">
                            <b-form-radio v-model="payment" :aria-describedby="Payment" name="payment-uzcard" value="uzcard">
                              UZCARD
                            </b-form-radio>
                            <b-form-radio v-model="payment" :aria-describedby="Payment" name="payment-humo" value="humo">
                              HUMO
                            </b-form-radio>
                          </b-form-group>
                          {{payment}}
                          <!-- <div class="mt-3">Selected: <strong>{{ payment }}</strong></div> -->
                        </div>
                      </div>
                      <!-- <div class="text-right">
                        <no-ssr>
                          
                        </no-ssr>
                        <button type="submit" @click="order()" v-if="cart.length && !payment" :disabled="invalid" class="btn-solid btn">Оплатить</button>
                      </div> -->
                      <div>
                        <form id="form-payme" method="POST" action="https://checkout.paycom.uz/">
                          <input type="hidden" name="merchant" value="60002db48c0dbba78b37128c">
                          <input type="hidden" name="account[order_id]" value="197">
                          <input type="hidden" name="amount" value="20000">
                          <input type="hidden" name="callback" value="https://mirllex.site/collection/12?uuid=234234234">
                          <input type="hidden" name="lang" value="ru">
                          <input type="hidden" name="button" data-type="svg" value="colored">
                          <div id="button-container"></div>
                        </form>
                      </div>
                      <div>
                        <button class="click_logo" type="submit" :disabled="invalid">
                          Оплатить через CLICK
                          <i></i>
                        </button>
                        <form id="click_form" action="https://my.click.uz/services/pay" method="get" target="_blank">
                          <input type="hidden" name="amount" value="1005" />
                          <input type="hidden" name="merchant_id" value="46"/>
                          <input type="hidden" name="merchant_user_id" value="4"/>
                          <input type="hidden" name="service_id" value="36"/>
                          <input type="hidden" name="transaction_param" value="user23151"/>
                          <input type="hidden" name="return_url" value="https://mirllex.site/collection/12?uuid=234234234"/>
                          <input type="hidden" name="card_type" value="uzcard"/>
                          <button type="submit" class="click_logo"><i></i>Оплатить через CLICK</button>
                        </form>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            </form>
            </ValidationObserver>
          </div>
        </div>
      </div>
    </section>
    <Footer />
  </div>
</template>
<script>

import { ValidationProvider, ValidationObserver } from 'vee-validate/dist/vee-validate.full.esm'
import { mapGetters } from 'vuex'
import Header from '../../../components/header/header1'
import Footer from '../../../components/footer/footer1'
import Breadcrumbs from '../../../components/widgets/breadcrumbs'
import Api from "~/utils/api";
export default {
  components: {
    Header,
    Footer,
    Breadcrumbs,
    ValidationProvider,
    ValidationObserver
  },
  computed: {
    ...mapGetters({
      cart: 'cart/cartItems',
      cartTotal: 'cart/cartTotalAmount',
      curr: 'products/changeCurrency'
    })
  },
  data() {
    return {
      user: {
        firstName: '',
        lastName: '',
        phone: '',
        email: '',
        address: '',
        city: '',
        state: '',
        pincode: ''
      },
      is_login: false,
      paypal: {
         sandbox: 'Your_Sendbox_Key'
      },
      payment: '',
      shipping: '',
      environment: 'sandbox',
      button_style: {
        label: 'checkout',
        size: 'medium', // small | medium | large | responsive
        shape: 'pill', // pill | rect
        color: 'blue' // gold | blue | silver | black
      },
      amtchar: ''
    }
  },
  mounted(){
    if(localStorage.getItem('cil')){
      this.is_login = true
    } else{
      this.is_login = false
      this.$router.push('/')
    }
    // (window).Paycom.Button('#form-payme', '#button-container');
  },
  methods: {
    discountedPrice(product) {
        const price = product.price - (product.price * product.discount / 100)
        return price
    },
    order() {
      this.isLogin = localStorage.getItem('userlogin')
      if (this.isLogin) {
        this.payWithStripe()
      } else {
        this.$router.replace('/page/account/login-firebase')
      }
    },
    payWithStripe() {
      const handler = (window).StripeCheckout.configure({
        key: 'PUBLISHBLE_KEY', // 'PUBLISHBLE_KEY'
        locale: 'auto',
        closed: function () {
          handler.close()
        },
        token: (token) => {
          this.$store.dispatch('products/createOrder', {
            product: this.cart,
            userDetail: this.user,
            token: token.id,
            amt: this.cartTotal
          })
          this.$router.push('/page/order-success')
        }
      })
      handler.open({
        name: 'Multikart ',
        description: 'Reach to your Dream',
        amount: this.cartTotal * 100
      })
    },
    onPaymentComplete: function (data) {
      // console.log(this.$store.state.cart.cart)
      // console.log(this.user)
      if(this.$store.state.cart.cart){
        let order = {
          list_items: this.$store.state.cart.cart,
          which_bank: 'click',
          cart_type: this.payment,
          client_info: [this.user],
          shipping_adress: this.shipping == 'pickup' ? 'Улица такаято зариншоповская' : (this.user.state + ' / '  + this.user.city + ' / ' + this.user.address + ' / ' + this.user.pincode), 
          subtotal: this.cartTotal,
          shipping_type: this.shipping,
          cart_type: this.payment
        }
        // console.log(order)
        // Api.getInstance().cart.onPaymentComplete(order).then((response) => {
          this.$store.dispatch('products/createOrder', {
            product: this.cart,
            userDetail: this.user,
            token: data.orderID,
            amt: this.cartTotal
          })
          this.$router.push('/page/order-success')
        // }).catch((error) => {
        //   console.log("addToCart -> ", error)
        // });
      }
      // this.$store.dispatch('products/createOrder', {
      //   product: this.cart,
      //   userDetail: this.user,
      //   token: data.orderID,
      //   amt: this.cartTotal
      // })
      // this.$router.push('/page/order-success')
    },
    onCancelled() {
      console.log('You cancelled a window')
    },
    onSubmit() {
      console.log('Form has been submitted!')
    }
  }
}
</script>
<style>
.click_logo {
padding:4px 10px;
cursor:pointer;
color: #fff;
line-height:190%;
font-size: 13px;
font-family: Arial;
font-weight: bold;
text-align: center;
border: 1px solid #037bc8;
text-shadow: 0px -1px 0px #037bc8;
border-radius: 4px;
background: #27a8e0;
background: url(data:image/svg+xml;base64,PD94bWwgdmVyc2lvbj0iMS4wIiA/Pgo8c3ZnIHhtbG5zPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyIgd2lkdGg9IjEwMCUiIGhlaWdodD0iMTAwJSIgdmlld0JveD0iMCAwIDEgMSIgcHJlc2VydmVBc3BlY3RSYXRpbz0ibm9uZSI+CiAgPGxpbmVhckdyYWRpZW50IGlkPSJncmFkLXVjZ2ctZ2VuZXJhdGVkIiBncmFkaWVudFVuaXRzPSJ1c2VyU3BhY2VPblVzZSIgeDE9IjAlIiB5MT0iMCUiIHgyPSIwJSIgeTI9IjEwMCUiPgogICAgPHN0b3Agb2Zmc2V0PSIwJSIgc3RvcC1jb2xvcj0iIzI3YThlMCIgc3RvcC1vcGFjaXR5PSIxIi8+CiAgICA8c3RvcCBvZmZzZXQ9IjEwMCUiIHN0b3AtY29sb3I9IiMxYzhlZDciIHN0b3Atb3BhY2l0eT0iMSIvPgogIDwvbGluZWFyR3JhZGllbnQ+CiAgPHJlY3QgeD0iMCIgeT0iMCIgd2lkdGg9IjEiIGhlaWdodD0iMSIgZmlsbD0idXJsKCNncmFkLXVjZ2ctZ2VuZXJhdGVkKSIgLz4KPC9zdmc+);
background: -webkit-gradient(linear, 0 0, 0 100%, from(#27a8e0), to(#1c8ed7));
background: -webkit-linear-gradient(#27a8e0 0%, #1c8ed7 100%);
background: -moz-linear-gradient(#27a8e0 0%, #1c8ed7 100%);
background: -o-linear-gradient(#27a8e0 0%, #1c8ed7 100%);
background: linear-gradient(#27a8e0 0%, #1c8ed7 100%);
box-shadow:  inset    0px 1px 0px   #45c4fc;
filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#27a8e0', endColorstr='#1c8ed7',GradientType=0 );
-webkit-box-shadow: inset 0px 1px 0px #45c4fc;
-moz-box-shadow: inset  0px 1px 0px  #45c4fc;
-webkit-border-radius:4px;
-moz-border-radius: 4px;
}
.click_logo i {
background: url(https://m.click.uz/static/img/logo.png) no-repeat top left;
width:30px;
height: 25px;
display: block;
float: left;
}
.pmnt-method{
    position: relative;
    display: inline-block;
    font-size: 16px;
    font-weight: 600;
    color: #333333;
    line-height: 20px;
    width: 100%;
}
</style>