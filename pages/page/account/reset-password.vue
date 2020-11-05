<template>
  <div>
    <Header />
    <Breadcrumbs title="Изменение пароля" />
    <section class="login-page section-b-space">
      <div class="container">
        <div class="row">
          <div class="col-lg-6  offset-lg-3">
            <h3>{{logintitle}}</h3>
            <div class="theme-card">
              <form class="theme-form" @submit.prevent="onSubmit">
                <div class="form-group">
                  <label for="password">Введите код указанный в вашей почте</label>
                    <input
                        type="text"
                        class="form-control"
                        v-model="code"
                        required
                    />
                </div>
                <div class="form-group">
                  <label for="password">Придумайте новый пароль</label>
                    <input
                        type="password"
                        class="form-control"
                        id="password"
                        v-model="password"
                        required
                    />
                </div>
                <div class="form-group">
                  <label for="password">Повторите новый пароль</label>
                    <input
                        type="password"
                        class="form-control"
                        id="password"
                        v-model="password_copy"
                        required
                    />
                </div>
                <button
                  type="submit"
                  class="btn btn-solid"
                >Изменить</button>
              </form>
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
      logintitle: 'Изменение пароля',
      forgottitle: false,
      email: null,
      code: null,
      password: null,
      password_copy: null,
    }
  },
  mounted() {
    console.log(this.$route.query.email)
  },
  methods: {
    onSubmit() {
      if(this.password != this.password_copy){
        this.$bvToast.toast("Пароли не совпадают, введите их заново.", {
            title: `Ошибка!`,
            variant: "danger",
            solid: true,
        });
      }else{
        Api.getInstance().auth.reset_password(this.code, this.password, this.$route.query.email).then((response) => {
          this.$bvToast.toast('Восстановление пароля прошла успешно.', {
            title: `Сообщение`,
            variant: "success",
            solid: true
          })
          setTimeout(()=>{this.$router.push('/page/account/login')}, 1500)
        })
        .catch((error) => {
          this.$bvToast.toast("Восстановление пароля прошло безуспешно.", {
            title: `Ошибка!`,
            variant: "danger",
            solid: true,
          });
        });
      }

    }
  }
}
</script>
