<template>
  <div>
    <Header />
    <Breadcrumbs title="Мой аккаунт" />
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
                          <div class="col-sm-6">
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
                          <div class="col-sm-6">
                            <div class="box">
                              <div class="box-title">
                                <h3>Новостная рассылка</h3>
                                <!-- <a href="#">Edit</a> -->
                              </div>
                              <div class="box-content">
                                <p>You are currently not subscribed to any newsletter.</p>
                              </div>
                            </div>
                          </div>
                        </div>
                        <!-- <div>
                          <div class="box">
                            <div class="box-title">
                              <h3>Address Book</h3>
                              <a href="#">Manage Addresses</a>
                            </div>
                            <div class="row">
                              <div class="col-sm-6">
                                <h6>Default Billing Address</h6>
                                <address>
                                  You have not set a default billing address.
                                  <br />
                                  <a href="#">Edit Address</a>
                                </address>
                              </div>
                              <div class="col-sm-6">
                                <h6>Default Shipping Address</h6>
                                <address>
                                  You have not set a default shipping address.
                                  <br />
                                  <a href="#">Edit Address</a>
                                </address>
                              </div>
                            </div>
                          </div>
                        </div> -->
                      </div>
                    </div>
                  </div>
                </b-card-text>
              </b-tab>
              <!-- <b-tab title="Address Book">
                <b-card-text>
                  <div class="dashboard-right">
                    <div class="dashboard">
                      <div class="page-title">
                        <h2>Address Book</h2>
                      </div>
                      <div class="welcome-msg">
                        <p>Hello, MARK JECNO !</p>
                        <p>From your Address book you have the ability to change or edit your shipping and billing address.</p>
                      </div>
                      <div class="box-account box-info">
                        <div class="box-head">
                          <h2>Address Information</h2>
                        </div>
                        <div>
                          <div class="box">
                            <div class="box-title">
                              <h3>Address Book</h3>
                              <a href="#">Manage Addresses</a>
                            </div>
                            <div class="row">
                              <div class="col-sm-6">
                                <h6>Default Billing Address</h6>
                                <address>
                                  You have not set a default billing address.
                                  <br />
                                  <a href="#">Edit Address</a>
                                </address>
                              </div>
                              <div class="col-sm-6">
                                <h6>Default Shipping Address</h6>
                                <address>
                                  You have not set a default shipping address.
                                  <br />
                                  <a href="#">Edit Address</a>
                                </address>
                              </div>
                            </div>
                          </div>
                        </div>
                      </div>
                    </div>
                  </div>
                </b-card-text>
              </b-tab> -->
              <b-tab @click="$router.push('/page/account/admin-dashboard')" title="Админ панель"></b-tab>
              <b-tab title="Мои заказы">
                <b-card-text>
                  <div class="dashboard-right">
                    <div class="dashboard">
                      <div class="page-title">
                        <h2>Мои заказы</h2>
                      </div>
                      <!-- <div class="welcome-msg">
                        <p>Hello, MARK JECNO !</p>
                        <p>From your Orders you have the ability to view your all orders and status of order.</p>
                      </div> -->
                      <div class="box-account box-info">
                        <!-- <div class="box-head">
                          <h2>Order Information</h2>
                        </div> -->
                        <div>
                          <div class="box">
                            <!-- <div class="box-title mb-3">
                              <h3>orders list</h3>
                              <p>Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s,</p>
                            </div> -->
                            <div class="row">
                              <div class="col-sm-6">
                                <h4>Order no: 2105</h4>
                                <h6>Slim Fit Cotton Shirt</h6>
                              </div>
                              <div class="col-sm-6">
                                <h4>Order no: 1032</h4>
                                <h6>Slim Fit Cotton Shirt</h6>
                              </div>
                            </div>
                          </div>
                        </div>
                        <div>
                          <div class="box mt-2">
                            <div class="row">
                              <div class="col-sm-6">
                                <h4>Order no: 2105</h4>
                                <h6>Slim Fit Cotton Shirt</h6>
                              </div>
                              <div class="col-sm-6">
                                <h4>Order no: 1032</h4>
                                <h6>Slim Fit Cotton Shirt</h6>
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
    this.client_fullname = localStorage.getItem('cfn');
    this.client_email = localStorage.getItem('ce');
  },
  methods:{
    check_is_admin(){
      Api.getInstance().auth.check_is_admin()
          .then((response) => {
              this.is_admin = true;
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
          localStorage.removeItem('st');
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
