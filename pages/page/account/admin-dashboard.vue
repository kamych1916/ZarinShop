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

             <b-card header="Товары">
                <b-button @click="AddProductModal =true">Добавить новый товар</b-button>
                <b-modal size="lg" v-model="AddProductModal" centered style="text-align: center;">
                  <template v-slot:modal-header>
                    <p></p>
                  </template>
                  <b-form @submit.prevent="send_new_category">

                    <div>
                      <input
                        v-if="New_Product" 
                        type="text"
                        class="form-control"
                        v-model="New_Product.name"
                        id="name_product"
                        placeholder="Введите наименование"
                        name="name_product"
                        required
                      />
                    </div>
                    <div>
                      <input
                        v-if="New_Product" 
                        type="text"
                        class="form-control"
                        v-model="New_Product.description"
                        id="description_product"
                        placeholder="Введите описание товара"
                        name="description_product"
                        required
                      />
                    </div>
                
                    <b-row class="pl-3">
                        <label for="load" class="text-light py-2 px-3 bg-dark">+ Добавить фото</label>
                        <input id="load" ref="file" @change="handleFileUpload()" type="file" name="photo" style="display: none;">
                    </b-row>
                    <b-row>
                        <b-overlay :show="show_overlay" rounded="sm">
                            <b-row  cols="3">
                                <b-col v-for="(file, i) in files" :key="i">
                                    <div class="imgs_object pb-4">
                                            <a :href="file.file_url" download class="pt-2">
                                                <img :src="file.file_url" width="100%" height="200">
                                            </a>
                                            <span @click="deleteFile(i)" class="delete_imgs">
                                                удалить
                                            </span>
                                    </div>
                                </b-col>
                            </b-row>
                        </b-overlay>
                    </b-row>
                    <!-- SIZES -->
                    <div class="pl-3">
                      <b-form-group label="Using sub-components:">
                        <b-form-checkbox-group id="checkbox-group-2" v-model="selected" name="flavour-2">
                          <b-row>
                            <div>
                              <b-form-checkbox value="S">S</b-form-checkbox>
                            </div>
                            <div>
                              <input
                                v-if="New_Product" 
                                type="number"
                                class="form-control"
                                v-model="New_Product.description"
                                id="description_product"
                                placeholder="Введите количество товара для размера S"
                                name="description_product"
                                required
                              />
                            </div>
                          </b-row>
                          <b-row>
                            <div>
                              <b-form-checkbox value="M">M</b-form-checkbox>
                            </div>
                            <div>
                              <input
                                v-if="New_Product" 
                                type="number"
                                class="form-control"
                                v-model="New_Product.description"
                                id="description_product"
                                placeholder="Введите количество товара для размера M"
                                name="description_product"
                                required
                              />
                            </div>
                          </b-row>
                          <b-row>
                            <div>
                              <b-form-checkbox value="L">L</b-form-checkbox>
                            </div>
                            <div>
                              <input
                                v-if="New_Product" 
                                type="number"
                                class="form-control"
                                v-model="New_Product.description"
                                id="description_product"
                                placeholder="Введите количество товара для размера L"
                                name="description_product"
                                required
                              />
                            </div>
                          </b-row>

                          <b-row>
                            <div>
                              <b-form-checkbox value="XL">XL</b-form-checkbox>
                            </div>
                            <div>
                              <input
                                v-if="New_Product" 
                                type="number"
                                class="form-control"
                                v-model="New_Product.description"
                                id="description_product"
                                placeholder="Введите количество товара для размера XL"
                                name="description_product"
                                required
                              />
                            </div>
                          </b-row>

                          <b-row>
                            <div>
                              <b-form-checkbox value="XXL">XXL</b-form-checkbox>
                            </div>
                            <div>
                              <input
                                v-if="New_Product" 
                                type="number"
                                class="form-control"
                                v-model="New_Product.description"
                                id="description_product"
                                placeholder="Введите количество товара для размера XXL"
                                name="description_product"
                                required
                              />
                            </div>
                          </b-row>

                          <b-row>
                            <div>
                              <b-form-checkbox value="E">Без размера</b-form-checkbox>
                            </div>
                            <div>
                                <input
                                  v-if="New_Product" 
                                  type="number"
                                  class="form-control"
                                  v-model="New_Product.description"
                                  id="description_product"
                                  placeholder="Введите количество товара"
                                  name="description_product"
                                  required
                                />
                              </div>
                          </b-row>
                        </b-form-checkbox-group>
                      </b-form-group>
                    </div>
                    <!-- COLORS -->
                    <b-row class="pl-3">
                      <b-form-group label="Radios using sub-components">
                        <b-form-radio-group id="radio-group-2" v-model="selected" name="radio-sub-component">
                          <b-form-radio value="">Toggle this custom radio</b-form-radio>
                          <b-form-radio value="second">Or toggle this other custom radio</b-form-radio>
                          <b-form-radio value="third" disabled>This one is Disabled</b-form-radio>
                          <b-form-radio :value="{ fourth: 4 }">This is the 4th radio</b-form-radio>
                        </b-form-radio-group>
                      </b-form-group>
                    </b-row>
                    <!-- PRICE -->
                    <b-row>
                      <div>
                        <input
                          v-if="New_Product" 
                          type="number"
                          class="form-control"
                          v-model="New_Product.price"
                          id="description_product"
                          placeholder="Введите описание товара"
                          name="description_product"
                          required
                        />
                      </div>
                    </b-row>

                    <!-- discount -->
                    <b-row>
                      <div>
                        <input
                          v-if="New_Product" 
                          type="number"
                          class="form-control"
                          v-model="New_Product.discount"
                          id="description_product"
                          placeholder="Введите описание товара"
                          name="description_product"
                          required
                        />
                      </div>
                    </b-row>

                    <!-- SPECIAL OFFER -->
                    <b-row>
                      <div>
                        <!-- chekbox где отправляется true или false -->
                      </div>
                    </b-row>

                    <!-- CATEGORIES -->
                    <b-row>
                      <div>
                        <!-- МЫ ДОЛЖНЫ ТУТ ВЫБРАТЬ КАТЕГОРИЮ (КАТЕГОРИИ БЕРУТСЯ ОТ АПИ) <b-form-select v-model="selected" :options="options"></b-form-select> -->
                      </div>
                    </b-row>

                    <!-- ВЫБРАТЬ К КАКОМУ ТОВАРУ СВЯЗАТЬ НОВЫЙ ТОВАР -->
                    <b-row>
                      <div>
                        <!-- ТАБЛИЦА, В КОТОРОЙ ПРИЛЕТАЮТ ТОВАРЫ, В ЗАИВИСИМОСТИ ОТ ВВЕДЕНЫХ ДАННЫХ В ИНПУТЕ NAME -->
                        <!-- ДАЛЕЕЕ МЫ ЧЕКБОКСОМ ВЫБИРАЕМ КОНКРЕТНЫЙ ТОРВА -->
                        <!-- ЕСЛИ ТАБЛИЦА ПУСТА, ТО ПОД КОНЕЦ ОТПРАВЛЯТЬ ПУСТОЙ СПИСОК  -->
                      </div>
                    </b-row>


                  </b-form>
                  <template v-slot:modal-footer>
                      <p></p>
                  </template>
                </b-modal>
                <b-table show-empty empty-text="Таблица пуста" thead-class=" wrap__clients__container__table__head" table-variant="light" selectable striped :fields="fields" :items="items" responsive>
                  <template #empty="scope">
                      <div  class="d-flex justify-content-center w-100">
                          <h6>{{ scope.emptyText }}</h6>
                      </div>
                  </template>
              </b-table>
             </b-card>
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

        AddProductModal: false,
        show_overlay: false,

        files: [],

        category: {
            main: null,
            subtype: null, 
            lasttype: null,
            image_url: null,
        },
        items: null,

        selected: [], // Must be an array reference!
        options: [
          { text: 'Orange', value: 'orange' },
          { text: 'Apple', value: 'apple' },
          { text: 'Pineapple', value: 'pineapple' },
          { text: 'Grape', value: 'grape' }
        ],  
        New_Product: {
          name: null,
          description: null,
          size_kol: null,
          // images: [], 
          // color: null,
          // price: null,
          // discount: null,
          // hit_sales: null,
          // special_offer: null,
        },



        fields: [
          {
              key: 'id',
              label: 'id',
              sortable: true
          },
          {
              key: 'name',
              label: 'Наименование',
              sortable: true
          },

          {
              key: 'description',
              label: 'Описание',
              sortable: true
          },

          // {
          //     key: 'size_kol',
          //     label: 'Количество по размерам',
          // },


          // {
          //     key: 'images',
          //     label: 'Изображения',
          // },
          {
              key: 'price',
              label: 'Цена',
          },
          {
              key: 'discount',
              label: 'Скидка',
          },
          {
              key: 'hit_sales',
              label: 'Горячая скидка',
          },
          {
              key: 'special_offer',
              label: 'Специальное предложение',
          },
          {
              key: 'color',
              label: 'Цвет',
          },
          // {
          //     key: 'categories',
          //     label: 'Категории',
          // },
          // {
          //     key: 'link_color',
          //     label: 'Ссылка на другой товар',
          // },
        ],
    }
  },
  components: {
    Header,
    Footer,
    Breadcrumbs
  },
  mounted(){
      this.check_is_admin();
      this.getDataProducts();
  },
  methods: {  
    
    getDataProducts(){
      Api.getInstance().products.getDataProducts().then((response) => {
          this.items = response.data;
      })
      .catch((error) => {
          console.log('getDataProducts -> ', error);
          this.$bvToast.toast("Товары не подгрузились.", {
              title: `Системная ошибка`,
              variant: "danger",
              solid: true,
          });
      });
    },
        handleFileUpload(){
            this.file = this.$refs.file.files[0];
            this.send_image()
        },
        send_image(){
            let formatData = new FormData();
            formatData.append('file', this.file) 
            Api.getInstance().auth.upload_file(formatData).then((response) => {
                this.files.push({file_url: response.data.file_url, file_name: response.data.file_name}); 
            })
            .catch((error) => {
                console.log("send_image -> ", error)
                this.$bvToast.toast("Изображение не загружено.", {
                    title: `Ошибка аутентификации`,
                    variant: "danger",
                    solid: true,
                });
                // setTimeout(()=>{this.$router.push('/')}, 1500)
            });
        },
        deleteFile(idImage){
          // console.log('idImage -> ', idImage)
          for(let idi in this.files){
            if(idi == idImage){
              Api.getInstance().products.deleteFile(this.files[idi].file_name).then((response) => {
                  this.$bvToast.toast("Файл был успешно удален от заявки!", {
                      title: `Сообщение:`,
                      variant: "success",
                      solid: true,
                  })    
                  this.files.splice(idi, 1);
              })
              .catch((error) => {
                  console.log('deleteFile-> ', error)
                  this.$bvToast.toast("Удаление прошло безуспешно.", {
                          title: 'Системная ошибка',
                      variant: "danger",
                      solid: true,
                  });
                  // setTimeout(()=>{this.$router.push('/')}, 1500)
              });
            }
          }
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