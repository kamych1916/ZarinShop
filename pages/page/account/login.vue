<template>
  <div>
    <Header />
    <Breadcrumbs title="Авторизация" />
    <section class="login-page section-b-space">
      <div class="container">
        <div class="row">
          <div class="col-lg-6">
            <h3>{{logintitle}}</h3>
            <div class="theme-card">
              <ValidationObserver v-slot="{ invalid }">
              <form class="theme-form" @submit.prevent="onSubmit">
                <div class="form-group">
                  <label for="email">E-mail</label>
                  <ValidationProvider rules="required|email" v-slot="{ errors }" name="email">
                  <input
                    type="email"
                    class="form-control"
                    id="email"
                    v-model="email"
                    placeholder="E-mail"
                    name="email"
                  />
                        <span class="validate-error">{{ errors[0] }}</span>
                      </ValidationProvider>
                </div>
                <div class="form-group">
                  <label for="password">Пароль</label>
                  <ValidationProvider rules="required" v-slot="{ errors }" name="password">
                  <input
                    type="password"
                    class="form-control"
                    id="password"
                    v-model="password"
                    placeholder="Пароль"
                  />
                        <span class="validate-error">{{ errors[0] }}</span>
                      </ValidationProvider>
                </div>
                <button
                  type="submit"
                  class="btn btn-solid"
                  :disabled="invalid"
                >Войти</button>
                <button
                  type="submit"
                  class="btn btn-solid"
                  v-if="forgottitle"
                  @click="$router.push('/page/account/forget-password')"
                >Забыли пароль ?</button>
                
              </form>
              </ValidationObserver>
            </div>
          </div>
          <div class="col-lg-6 right-login">
            <h3>{{registertitle}}</h3>
            <div class="theme-card authentication-right">
              <h6 class="title-font">Создайте аккаут</h6>
              <p>Зарегистрируйте бесплатную учетную запись в нашем магазине. Регистрация проходит быстро и легко. Это позволяет вам делать заказы в нашем магазине. Чтобы начать покупки, нажмите «Зарегистрироваться».</p>
              <nuxt-link
                  :to="{ path: '/page/account/register'}"
                  class="btn btn-solid"
                >«Зарегистрироваться»</nuxt-link>
            </div>
          </div>
        </div>
      </div>
    </section>
    <Footer />
  </div>
</template>
<script>
import { ValidationProvider, ValidationObserver } from 'vee-validate/dist/vee-validate.full.esm'
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
  data() {
    return {
      logintitle: 'Авторизация',
      registertitle: 'Новый пользователь?',
      forgottitle: false,
      email: null,
      password: null,
    }
  },
  mounted() {
    
  },
  methods: {
    onSubmit() {
      Api.getInstance()
        .auth.login(this.email, this.password)
        .then((response) => {
          this.$bvToast.toast('Авторизация прошла успешна.', {
            title: `Сообщение`,
            variant: "success",
            solid: true
          })
          this.$store.dispatch("auth/load__login_access", response.data)
          console.log(this.$store.state.auth.login_access)
          setTimeout(()=>{this.$router.push('/page/account/dashboard')}, 1500)
        })
        .catch((error) => {
          this.$bvToast.toast("Аторизация прошла безуспешно.", {
            title: `Ошибка авторизации`,
            variant: "danger",
            solid: true,
          });
          this.forgottitle = true
        });
    }
  }
}
</script>
