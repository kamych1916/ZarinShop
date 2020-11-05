<template>
  <div>
    <Header />
    <Breadcrumbs title="Восстановление пароля" />
    <section class="pwd-page section-b-space">
      <div class="container">
        <div class="row">
          <div class="col-lg-6 offset-lg-3">
            <h2>{{title}}</h2>
            <h6>{{subtitle}}</h6>
            <form class="theme-form" @submit.prevent="checkForm">
              <div v-if="errors.length">
                <ul class="validation-error mb-3">
                  <li v-for="(error, index) in errors" :key="index">{{ error }}</li>
                </ul>
              </div>
              <div class="form-row">
                <div class="col-md-12">
                  <input
                    type="email"
                    class="form-control"
                    id="email"
                    v-model="email"
                    placeholder="Введите свой E-mail"
                    name="email"
                    required
                  />
                </div>
              </div>
              <button type="submit" class="btn btn-solid" >отправить</button>
            </form>
          </div>
        </div>
      </div>
    </section>
    <Footer />
  </div>
</template>
<script>
import Api from "~/utils/api";
import Header from '../../../components/header/header1'
import Footer from '../../../components/footer/footer1'
import Breadcrumbs from '../../../components/widgets/breadcrumbs'
export default {
  components: {
    Header,
    Footer,
    Breadcrumbs
  },
  data() {
    return {
      title: 'Забыли свой пароль?',
      subtitle: 'Мы отправим вам на указанную почту код, благодаря которому вы сможете восстановить пароль.', 
      errors: [],
      email: null
    }
  },
  methods: {
    checkForm: function (e) {
      this.errors = []
      if (!this.email) {
        this.errors.push('Необходимо ввести E-mail.')
      } else if (!this.validEmail(this.email)) {
        this.errors.push('Неверно введен E-email')
      }
      if (!this.errors.length){
        Api.getInstance().auth.forgot_password(this.email).then((response) => {
          this.$bvToast.toast('Мы отправили код на вашу почту.', {
            title: `Сообщение`,
            variant: "success",
            solid: true
          })
          setTimeout(()=>{this.$router.push(`/page/account/reset-password?email=${this.email}`)}, 1500)
        }).catch((error) => {
          this.$bvToast.toast("Данной почты не существует в базе данных.", {
            title: `Ошибка!`,
            variant: "danger",
            solid: true,
          });
          this.forgottitle = true
        });
        return true
      } 
    },
    validEmail: function (email) {
      const re = /^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/
      return re.test(email)
    }
  }
}
</script>
