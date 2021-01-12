<template>
  <div>
    <Header />
    <Breadcrumbs title="Checkout" />
    <section class="section-b-space">
      <div class="container">
        <div class="checkout-page">
          <div class="checkout-form">
            <ValidationObserver v-slot="{ invalid }">
            <form @submit.prevent="onSubmit">
              <div class="row">
                <div class="col-lg-6 col-sm-12 col-xs-12">
                  <div class="checkout-title">
                    <h3>Billing Details</h3>
                  </div>
                  <div class="row check-out">
                    <div class="form-group col-md-6 col-sm-6 col-xs-12">
                      <div class="field-label">First Name</div>
                      <ValidationProvider rules="required" v-slot="{ errors }" name="First name">
                        <input type="text" v-model="user.firstName" name="First name"/>
                        <span class="validate-error">{{ errors[0] }}</span>
                      </ValidationProvider>
                    </div>
                    <div class="form-group col-md-6 col-sm-6 col-xs-12">
                      <div class="field-label">Last Name</div>
                      <ValidationProvider rules="required" v-slot="{ errors }" name="Last name">
                        <input type="text" v-model="user.lastName" name="Last name" />
                        <span class="validate-error">{{ errors[0] }}</span>
                      </ValidationProvider>
                    </div>
                    <div class="form-group col-md-6 col-sm-6 col-xs-12">
                      <ValidationProvider rules="required|digits:10" v-slot="{ errors }" name="phone Number">
                        <div class="field-label">Phone</div>
                        <input type="text" v-model="user.phone" name="Phone" />
                        <span class="validate-error">{{ errors[0] }}</span>
                      </ValidationProvider>
                    </div>
                    <div class="form-group col-md-6 col-sm-6 col-xs-12">
                      <div class="field-label">Email Address</div>
                      <ValidationProvider rules="required|email" v-slot="{ errors }" name="Email">
                        <input type="text" v-model="user.email" name="Email Address" />
                        <span class="validate-error">{{ errors[0] }}</span>
                      </ValidationProvider>
                    </div>
                    <div class="form-group col-md-12 col-sm-12 col-xs-12">
                      <div class="field-label">Country</div>
                      <select>
                        <option>India</option>
                        <option selected>South Africa</option>
                        <option>United State</option>
                        <option>Australia</option>
                      </select>
                    </div>
                    <div class="form-group col-md-12 col-sm-12 col-xs-12">
                      <div class="field-label">Address</div>
                      <ValidationProvider rules="required" v-slot="{ errors }" name="Address">
                        <input type="text" v-model="user.address" name="Address" />
                        <span class="validate-error">{{ errors[0] }}</span>
                      </ValidationProvider>
                    </div>
                    <div class="form-group col-md-12 col-sm-12 col-xs-12">
                      <div class="field-label">Town/City</div>
                      <ValidationProvider rules="required" v-slot="{ errors }" name="City">
                        <input type="text" v-model="user.city" name="City" />
                        <span class="validate-error">{{ errors[0] }}</span>
                      </ValidationProvider>
                    </div>
                    <div class="form-group col-md-12 col-sm-6 col-xs-12">
                      <div class="field-label">State / County</div>
                      <ValidationProvider rules="required" v-slot="{ errors }" name="State">
                        <input type="text" v-model="user.state" name="State" />
                        <span class="validate-error">{{ errors[0] }}</span>
                      </ValidationProvider>
                    </div>
                    <div class="form-group col-md-12 col-sm-6 col-xs-12">
                      <div class="field-label">Postal Code</div>
                      <ValidationProvider rules="required" v-slot="{ errors }" name="Postal Code">
                        <input type="text" v-model="user.pincode" name="Postal Code" />
                        <span class="validate-error">{{ errors[0] }}</span>
                      </ValidationProvider>
                    </div>
                    <div class="form-group col-lg-12 col-md-12 col-sm-12 col-xs-12">
                      <nuxt-link
                  :to="{ path: '/page/account/register'}"
                >Create an Account?</nuxt-link>
                    </div>
                  </div>
                </div>
                <div class="col-lg-6 col-sm-12 col-xs-12">
                  <div class="checkout-details">
                    <div class="order-box">
                      <div class="title-box">
                        <div>
                          Product
                          <span>Total</span>
                        </div>
                      </div>
                      <ul class="qty"  v-if="cart.length">
                        <li v-for="(item,index) in cart" :key="index">
                          {{ item.name | uppercase }} * {{ item.kol }}
                          <span>{{ (parseInt(discountedPrice(item) * item.kol)).toLocaleString('ru-RU')  }} сум.</span>
                        </li>
                      </ul>
                      <ul class="sub-total">
                        <li>
                          Subtotal
                          <span class="count">{{ cartTotal * curr.curr | currency(curr.symbol) }}</span>
                        </li>
                        <li>Shipping
                            <div class="shipping">
                                <div class="shopping-option">
                                    <input type="checkbox" name="free-shipping" id="free-shipping">
                                    <label for="free-shipping">Free Shipping</label>
                                </div>
                                <div class="shopping-option">
                                    <input type="checkbox" name="local-pickup" id="local-pickup">
                                    <label for="local-pickup">Local Pickup</label>
                                </div>
                            </div>
                        </li>
                      </ul>
                      <ul class="sub-total">
                        <li>
                          Total
                          <span class="count">{{ cartTotal * curr.curr | currency(curr.symbol) }}</span>
                        </li>
                      </ul>
                    </div>
                    <div class="payment-box">
                      <div class="upper-box">
                        <div class="payment-options">
                          <ul>
                            <li>
                              <div class="radio-option">
                                <input
                                  type="radio"
                                  name="payment-group"
                                  id="payment-1"
                                  checked="checked"
                                  v-model="payment"
                                  :value="false"
                                />
                                <label for="payment-1">
                                  Stripe
                                  <span
                                    class="small-text"
                                  >Please send a check to Store Name, Store Street, Store Town, Store State / County, Store Postcode.</span>
                                </label>
                              </div>
                            </li>
                            <li>
                              <div class="radio-option paypal">
                                <input type="radio" :value="true" v-model="payment" name="payment-group" id="payment-3" />
                                <label for="payment-3">
                                  PayPal
                                  <span class="image">
                                    <img src="../../../assets/images/paypal.png" alt />
                                  </span>
                                </label>
                              </div>
                            </li>
                          </ul>
                        </div>
                      </div>
                      <div class="text-right">
                            <no-ssr>
                                <paypal-checkout
                                  :amount=getamt()
                                  currency="USD"
                                  :client="paypal"
                                  :env="environment"
                                  :button-style="button_style"
                                  v-if="payment"
                                  v-on:payment-authorized="onPaymentComplete"
                                  v-on:payment-cancelled="onCancelled()">
                                </paypal-checkout>
                                </no-ssr>
                        <button type="submit" @click="order()" v-if="cart.length && !payment" :disabled="invalid" class="btn-solid btn">Place Order</button>
                      </div>
                      <div>
                        <form id="form-payme" method="POST" action="https://checkout.paycom.uz/">
                          <input type="hidden" name="merchant" value="587f72c72cac0d162c722ae2">
                          <input type="hidden" name="account[order_id]" value="197">
                          <input type="hidden" name="amount" value="500">
                          <input type="hidden" name="lang" value="ru">
                          <input type="hidden" name="button" data-type="svg" value="colored">
                          <div id="button-container"></div>
                        </form>
                      </div>
                      <div>
                        <form id="click_form" action="https://my.click.uz/services/pay" method="get" target="_blank">
                          <input type="hidden" name="amount" value="1000" />
                          <input type="hidden" name="merchant_id" value="46"/>
                          <input type="hidden" name="merchant_user_id" value="4"/>
                          <input type="hidden" name="service_id" value="36"/>
                          <input type="hidden" name="transaction_param" value="user23151"/>
                          <input type="hidden" name="return_url" value="сайт поставщика"/>
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
      isLogin: false,
      paypal: {
         sandbox: 'Your_Sendbox_Key'
      },
      payment: false,
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
    (window).Paycom.Button('#form-payme', '#button-container')
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
    getamt() {
      return this.cartTotal.toString()
    },
    onPaymentComplete: function (data) {
      this.$store.dispatch('products/createOrder', {
        product: this.cart,
        userDetail: this.user,
        token: data.orderID,
        amt: this.cartTotal
      })
      this.$router.push('/page/order-success')
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
</style>