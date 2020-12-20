<template>
  <div>
      <Header />
      <Breadcrumbs title="Админ Панель" />
          <section class="section-b-space">
      <div class="container">
        <div class="row">
          <b-card no-body v-bind:class="'dashboardtab'">
            <AddCategory/>

            <AddProduct/>
          </b-card>
        </div>
      </div>
    </section>
      <Footer />

  </div>
</template>

<script>
import Header from '../../../components/header/header1';
import Footer from '../../../components/footer/footer1';
import Breadcrumbs from '../../../components/widgets/breadcrumbs';
import AddProduct from '../../../components/admin/addProduct';
import AddCategory from '../../../components/admin/addCategory';
import Api from "~/utils/api";
export default {
  data () {
    return {
      is_admin: false,
    }
  },
  components: {
    Header,
    Footer,
    Breadcrumbs,
    AddProduct,
    AddCategory
  },
  mounted(){
    this.check_is_admin();
  },
  methods: {  
    check_is_admin(){
      Api.getInstance().auth.check_is_admin().then((response) => {
              this.is_admin = true;
          })
          .catch((error) => {
              console.log(error)
              this.is_admin = false;
              this.$bvToast.toast("У вас нет доступа к данной странице.", {
                      title: `Ошибка аутентификации`,
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
.container .imgs_object{
    position: relative;
}

.container .imgs_object .delete_imgs{
    position: absolute;
    bottom: -10px;
    left: 50%;
    margin-right: -50%;
    transform: translate(-50%, -50%);
    color: red;
    cursor: pointer;
}
</style>