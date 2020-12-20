<template>
  <div class="top-header">
    <div class="container">
      <div class="row">
        <div class="col-lg-6">
          <div class="header-contact">
            <ul>
              <li>Добро пожаловать в магазин Zarin Shop</li>
              <li>
                <i class="fa fa-phone" aria-hidden="true"></i>+998 (78) 150-00-02  
              </li>
            </ul>
          </div>
        </div>
        <div class="col-lg-6 text-right">
          <ul class="header-dropdown">
            <li class="mobile-wishlist">
              <nuxt-link :to="{ path: '/page/account/wishlist' }">
                <i class="fa fa-heart" aria-hidden="true"></i>
                <span style="color: #999999" >
                Избранное
                </span>  
              </nuxt-link>
            </li>
            <li class=" mobile-account" @click="auth()">
              <!-- <nuxt-link to="/page/account/login"> -->
                <i class="fa fa-user" aria-hidden="true"></i>
                <span style="color: #999999" >Мой аккаунт</span>  
              <!-- </nuxt-link> -->
            </li>
          </ul>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import firebase from 'firebase';
import UserAuth from '../../pages/page/account/auth/auth';
import Api from "~/utils/api";
export default {
  data() {
    return {
      isLogin: false
    }
  },
  created() {
    if (process.client) {
      this.isLogin = localStorage.getItem('userlogin')
    }
  },
  methods: {
    auth(){
      Api.getInstance().auth.is_login()
        .then((response) => {
          this.$router.push('/page/account/dashboard');
        })
        .catch((error) => {
          console.log('is_login-> ', error);
          this.$router.push('/page/account/login');
        });
    },
    // logout: function () {
    //   firebase.auth().signOut().then(() => {
    //     UserAuth.Logout()
    //     this.$router.replace('/page/account/login-firebase')
    //   })
    // }
  }
}
</script>
