<template>
  <div>
      <Header />
      <Breadcrumbs title="Админ Панель" />
          <section class="section-b-space">
      <div class="container">
        <div class="row">
          <b-card no-body v-bind:class="'dashboardtab'">
            <b-form @submit.prevent="send_new_category">
                <b-card header="Создание новой категории" class="mb-5">
                <label for="main_cat">Введите главную категории</label>
                <div>
                  <input
                    v-if="category" 
                    type="text"
                    class="form-control"
                    v-model="category.main"
                    id="main_cat"
                    placeholder="Введите категорию"
                    name="main_cat"
                    required
                  />
                </div>
                <label for="main_sub_cat">Введите под категории</label>
                <div>
                  <input
                    v-if="category" 
                    type="text"
                    class="form-control"
                    v-model="category.subtype"
                    id="sub_cat"
                    placeholder="Введите категорию"
                    name="sub_cat"
                    required
                  />
                </div>
                <label for="last_cat">Введите последнюю категории</label>
                <div>
                  <input
                    v-if="category" 
                    type="text"
                    class="form-control"
                    v-model="category.lasttype"
                    id="last_cat"
                    placeholder="Введите категорию"
                    name="last_cat"
                    required
                  />
                </div>

<!--                 
                    <b-row class="pl-3">
                        <label for="load" class="text-light py-2 px-3 bg-dark">+ Добавить фото</label>
                        <input id="load" ref="file" @change="handleFileUpload()" type="file" name="photo" style="display: none;">
                    </b-row>
                        <b-row>
                            <img v-if="file" :src="category.image_url" alt="" width="180" height="150" class="pl-3 pt-2">
                        </b-row> -->
                <b-button type="submit" class="mt-2">Создать</b-button>
                </b-card>


            </b-form>

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
import Api from "~/utils/api";
export default {
  data () {
    return {
      is_admin: false,
      category: {
          main: null,
          subtype: null, 
          lasttype: null,
          image_url: null,
      },
    }
  },
  components: {
    Header,
    Footer,
    Breadcrumbs,
    AddProduct
  },
  mounted(){
    this.check_is_admin();
  },
  methods: {  
    send_new_category(){
        Api.getInstance().auth.send_new_category(this.category).then((response) => {
            console.log('kek')
        })
        .catch((error) => {
            this.$bvToast.toast("Категорию не удалось загрузить.", {
                    title: `Ошибка аутентификации`,
                variant: "danger",
                solid: true,
            });
            // setTimeout(()=>{this.$router.push('/')}, 1500)
        });
        
    },
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