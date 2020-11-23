<template>
  <div>
    <Header />
    <Breadcrumbs title="регистрация" />
    <section class="register-page section-b-space">
      <div class="container">
        <div class="row">
          <div class="col-lg-12">
            <h3>{{title}}</h3>
            <div class="theme-card">
              <ValidationObserver v-slot="{ invalid }">
              <form class="theme-form" @submit.prevent="onSubmit">
                <div class="form-row">
                  <div class="col-md-6">
                    <label for="First name">Имя</label>
                    <ValidationProvider rules="required" v-slot="{ errors }" name="First name">
                    <input
                      type="text"
                      class="form-control"
                      id="First name"
                      v-model="fname"
                      placeholder="Введите ваше имя"
                      name="First name"
                    />
                        <span class="validate-error">{{ errors[0] }}</span>
                      </ValidationProvider>
                  </div>
                  <div class="col-md-6">
                    <label for="lname">Фамилия</label>
                    <ValidationProvider rules="required" v-slot="{ errors }" name="Last name">
                    <input
                      type="text"
                      class="form-control"
                      id="lname"
                      v-model="lname"
                      placeholder="Введите вашу фамилию"
                      name="lname"
                    />
                        <span class="validate-error">{{ errors[0] }}</span>
                      </ValidationProvider>
                  </div>
                </div>
                <div class="form-row">
                  <div class="col-md-6">
                    <label for="email">Email</label>
                    <ValidationProvider rules="required|email" v-slot="{ errors }" name="Email">
                  <input
                    type="email"
                    class="form-control"
                    id="email"
                    v-model="email"
                    placeholder="Введите ваш Email"
                    name="email"
                  />
                        <span class="validate-error">{{ errors[0] }}</span>
                      </ValidationProvider>
                  </div>
                  <div class="col-md-6">
                    <label for="password">Номер телефона</label>
                    <input
                      type="text"
                      class="form-control"
                      id="phone"
                      v-model="phone"
                      placeholder="Введите ваш номер телефона"
                      name="phone"
                    />
                  </div>
                </div>
                <div class="form-row">
                  <div class="col-md-6">
                    <label for="password">Пароль</label>
                    <ValidationProvider rules="required" v-slot="{ errors }" name="password">
                    <input
                      type="password"
                      class="form-control"
                      id="password"
                      v-model="password"
                      placeholder="Придумайте пароль"
                      name="password"
                    />
                        <span class="validate-error">{{ errors[0] }}</span>
                      </ValidationProvider>
                  </div>
                  <div class="col-md-6">
                    <label for="password">Повторите Пароль</label>
                    <input
                      type="password"
                      class="form-control"
                      id="password"
                      placeholder="Повторите пароль"
                      name="password"
                    />
                  </div>
                  <button
                  type="submit"
                  class="btn btn-solid mt-2"
                  :disabled="invalid"
                >регистрация</button>
                </div>
              </form>
              </ValidationObserver>
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
      title: 'создание аккаута',
      fname: null,
      lname: null,
      email: null,
      password: null,
      phone: null,
    }
  },
  methods: {
    onSubmit() {
        Api.getInstance()
        .auth.register(this.fname, this.lname, this.email, this.password, this.phone)
        .then((response) => {
          this.$bvToast.toast('Регистрация прошла успешна.', {
            title: `Сообщение`,
            variant: "success",
            solid: true
          });
          localStorage.setItem('email', this.email);
          setTimeout(()=>{this.$router.push('/page/account/check-code-active')}, 1500)
        })
        .catch((error) => {
          this.$bvToast.toast("Регистрация прошла безуспешно. Ведённая вами email почта уже существует!", {
            title: `Ошибка регистрации`,
            variant: "danger",
            solid: true,
          });
        });

    }
  }
}
</script>
