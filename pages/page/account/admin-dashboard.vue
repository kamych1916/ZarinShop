<template>
  <div>
      <Header />
      <Breadcrumbs title="Админ Панель" />
          <section class="section-b-space">
      <div class="container">
        <div class="row">
          <b-card no-body v-bind:class="'dashboardtab'">
            <b-form @submit.prevent="send_new_category">
                <b-card header="Создание новой категории" class=" ">
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

                
                    <b-row class="pl-3">
                        <label for="load" class="text-light py-2 px-3 bg-dark">+ Добавить фото</label>
                        <input id="load" ref="file" @change="handleFileUpload()" type="file" name="photo" style="display: none;">
                    </b-row>
                        <b-row>
                            <img v-if="file" :src="category.image_url" alt="" width="180" height="150" class="pl-3 pt-2">
                        </b-row>
                <b-button type="submit">Создать</b-button>
                </b-card>


            </b-form>
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
        is_admin: false,
        file: null,

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
  },
  methods: {    
        handleFileUpload(){
            this.file = this.$refs.file.files[0];
            this.send_image()
        },
        send_image(){
            let formatData = new FormData();
            formatData.append('file', this.file) 

            Api.getInstance().auth.upload_file(formatData).then((response) => {
                this.category.image_url = 'http://zarinshop.site/img/' + response.data.filename 
            })
            .catch((error) => {
                this.$bvToast.toast("Изображение не загружено.", {
                        title: `Ошибка аутентификации`,
                    variant: "danger",
                    solid: true,
                });
                // setTimeout(()=>{this.$router.push('/')}, 1500)
            });
        },
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
        Api.getInstance()
            .auth.check_is_admin().then((response) => {
                this.is_admin = true
            })
            .catch((error) => {
                this.is_admin = false
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

</style>