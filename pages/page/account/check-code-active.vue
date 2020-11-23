<template>
  <div>
      <Header />
      <Breadcrumbs title="Админ Панель" />
    <section class="pwd-page section-b-space">
      <div class="container">
        <div class="row">
          <div class="col-lg-6 offset-lg-3">
            <h2>Введите код активации</h2>
            <h6>код активации был выслан вам на почту</h6>
            <form class="theme-form" @submit.prevent="send_activate_code">
              <div class="form-row">
                <div class="col-md-12">
                  <input
                    type="text"
                    class="form-control"
                    id="code"
                    v-model="code"
                    placeholder="Введите код активации"
                    name="code"
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
import Header from '../../../components/header/header1'
import Footer from '../../../components/footer/footer1'
import Breadcrumbs from '../../../components/widgets/breadcrumbs'
import Api from "~/utils/api";
export default {
  data () {
    return {
        is_admin: false,
        file: null,
        code: null,
        category: {
            main: null,
            subtype: null, 
            lasttype: null,
            image_url: null,
        }
    }
  },
  components: {
    Header,
    Footer,
    Breadcrumbs
  },
  mounted(){
    //   this.check_is_admin()
    if(localStorage.getItem('email') == null){
        setTimeout(()=>{this.$router.push('/page/account/register')})
    }
  },
  methods: {    
        send_activate_code(){
            let email = localStorage.getItem('email');
            console.log('email-> ', email);
            console.log('code-> ', this.code);
            Api.getInstance().auth.send_activate_code(this.code, email).then((response) => {
                this.$bvToast.toast('Процесс активации прошел успешно.', {
                    title: `Сообщение`,
                    variant: "success",
                    solid: true
                })
                setTimeout(()=>{this.$router.push('/page/account/login')}, 1500)
            })
            .catch((error) => {
                console.log(error)
                this.$bvToast.toast("Процесс активации невыполнено.", {
                        title: `Ошибка активации`,
                    variant: "danger",
                    solid: true,
                });
                // setTimeout(()=>{this.$router.push('/')}, 1500)
            });
            
        }

  }
}
</script>

<style>

</style>