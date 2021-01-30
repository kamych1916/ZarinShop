<template>
  <div>
    <Header />
    <Breadcrumbs title="Мой аккаунт" />
    <b-overlay :show="!is_login" rounded="sm">
    <section class="section-b-space" v-if="is_login">
      <div class="container">
        <div class="row">
          <b-card no-body v-bind:class="'dashboardtab'">
            <b-tabs pills card vertical>
              <b-tab title="Информация об аккаунте" active>
                <b-card-text>
                  <div class="dashboard-right">
                    <div class="dashboard">
                      <div class="box-account box-info">
                        <div class="box-head">
                          <h2>Информация об аккаунте</h2>
                        </div>
                        <div class="row">
                          <div class="col">
                            <div class="box">
                              <div class="box-title">
                                <h3>Контактная информация</h3>
                                <!-- <a href="#">Edit</a> -->
                              </div>
                              <div class="box-content">
                                <h6 v-if="client_fullname">{{client_fullname}}</h6>
                                <h6 v-if="client_email">{{client_email}}</h6>
                                <h6>
                                  <a href="#">Изменение пароля</a>
                                </h6>
                              </div>
                            </div>
                          </div>
                          <!-- <div class="col-sm-6">
                            <div class="box">
                              <div class="box-title">
                                <h3>Новостная рассылка</h3>
                              </div>
                              <div class="box-content">
                                <form class="auth-form needs-validation" @submit.prevent="sendClientEmail()">
                                  <div class="form-group ">
                                    <input
                                      type="email"
                                      class="form-control"
                                      name="EMAIL"
                                      placeholder="Введите вашу почту.."
                                      required="required"
                                      v-model="ClientEmail"
                                    />
                                    <button type="submit" class="btn btn-solid" >подписаться</button>
                                  </div>
                                </form>
                              </div>
                            </div>
                          </div> -->
                        </div>
                      </div>
                    </div>
                  </div>
                </b-card-text>
              </b-tab>
              <b-tab v-if="is_admin" @click="$router.push('/page/account/admin-dashboard')" title="Админ панель"></b-tab>
              <b-tab title="Мои заказы">
                <b-card-text>
                  <div class="dashboard-right">
                    <div class="dashboard">
                      <div class="box-head pb-3" >
                        <h2>Мои заказы</h2>
                      </div>
                      <div class="box-account box-info" style="border-top: 1px solid #ccc">
                          <div class="box" v-if="orderData">
                            <div class="row mt-2 " v-for="(order, index) in orderData" :key="index">
                              <div class="ml-3 pb-2 w-100" style="border-bottom: 1px solid #ccc">
                                <h6>Номер:  &nbsp;<span style="color:#eac075">{{order.id}}</span></h6>
                                <h6>Дата: &nbsp;&nbsp;&nbsp;&nbsp;  <span style="color:#eac075">{{order.date}}</span></h6>
                                <h6>Сумма:  &nbsp;<span style="color:#eac075">{{order.subtotal}} сум.</span></h6>
                                <h6>Товары:</h6>
                                <div v-for="(orderItem, index) in order.items" :key="index">
                                  <h6 class="mt-3"><img class="img-fluid" width="50" :src="orderItem.images[0]" alt=""> {{orderItem.name.substring(0,15)+'....'}} / {{orderItem.price}} сум. / размер - {{orderItem.size}} / кол. - {{orderItem.kol}}</h6>
                                </div>
                              </div>
                            </div>
                        </div>
                      </div>
                    </div>
                  </div>
                </b-card-text>
              </b-tab>
              
              <b-tab @click="logout()" title="Выход"></b-tab>
            </b-tabs>
          </b-card>
        </div>
      </div>
    </section>
    </b-overlay>
    <Footer />
  </div>
</template>
<script>
import Header from '../../../components/header/header1'
import Footer from '../../../components/footer/footer1'
import Breadcrumbs from '../../../components/widgets/breadcrumbs'

import Api from "~/utils/api";
export default {
  data () {
    return {
      client_fullname: null,
      client_email: null,
      is_admin: null,
      is_login: false,
      orderData: null
    }
  },
  components: {
    Header,
    Footer,
    Breadcrumbs
  },
  mounted(){
    // if(!this.$store.state.auth.login_access){
    //   this.$router.push("/page/account/login")
    // }
    this.check_is_login();
    this.check_is_admin();
    this.getOrderData();
    this.client_fullname = localStorage.getItem('cfn');
    this.client_email = localStorage.getItem('ce');
  },
  methods:{
    getOrderData(){
      Api.getInstance().auth.getOrderData().then((response) => {
        this.orderData = response.data;
      }).catch((error) => {
        console.log('getOrderData -> ', error)
      });
    },
    check_is_admin(){
      Api.getInstance().auth.check_is_admin()
          .then((response) => {
            console.log(response.data)
            response.data === true ? this.is_admin = true : this.is_admin = false;
          })
          .catch((error) => {
              this.is_admin = false;
          });
    },
    check_is_login(){
      Api.getInstance().auth.is_login()          
          .then((response) => {
              this.is_login = true;
          })
          .catch((error) => {
              this.is_login = false;
              setTimeout(()=>{this.$router.push('/page/account/login')})
          });
    },
    logout(){
      Api.getInstance().auth.logout().then((response) => {
          localStorage.removeItem('cfn');
          localStorage.removeItem('ce');
          localStorage.removeItem('st');
          localStorage.removeItem('cil');
          this.$store.dispatch('cart/delete_cart');
          this.$bvToast.toast('Вы успешно вышли из системы.', {
              title: `Сообщение`,
              variant: "success",
              solid: true
          })
          setTimeout(()=>{this.$router.push('/page/account/login')}, 1000)
      })
      .catch((error) => {
          console.log(error)
          this.$bvToast.toast("Выход из системы не удался.", {
              title: `Ошибка системы`,
              variant: "danger",
              solid: true,
          });
          // setTimeout(()=>{this.$router.push('/')}, 1500)
      });
    }
  }
}
</script>
