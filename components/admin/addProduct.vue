<template>
    <b-card header="Товары" >
        <div class="wrap__products">       
            <b-button @click="AddProductModal=true">Добавить новый товар</b-button>
            <b-modal size="lg" v-model="AddProductModal">
                <b-form @submit.prevent="send_new_category">
                    <div class="pt-2">
                        <span class="title_inputs">Введите наименование товара</span>
                        <b-row class="px-3 py-2">
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
                        </b-row>
                    </div>

                    <div class="pt-2">
                        <span class="title_inputs pt-2">Введите описание товара</span> 
                        <b-row class="px-3 py-2">
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
                        </b-row>
                    </div>
                    
                    <!-- ВЫБРАТЬ К КАКОМУ ТОВАРУ СВЯЗАТЬ НОВЫЙ ТОВАР -->
                    <div class="pt-2">
                        <b-row class="px-3 py-2">
                            <!-- ТАБЛИЦА, В КОТОРОЙ ПРИЛЕТАЮТ ТОВАРЫ, В ЗАИВИСИМОСТИ ОТ ВВЕДЕНЫХ ДАННЫХ В ИНПУТЕ NAME -->
                            <!-- ДАЛЕЕЕ МЫ ЧЕКБОКСОМ ВЫБИРАЕМ КОНКРЕТНЫЙ ТОРВА -->
                            <!-- ЕСЛИ ТАБЛИЦА ПУСТА, ТО ПОД КОНЕЦ ОТПРАВЛЯТЬ ПУСТОЙ СПИСОК  -->
                            <span class="title_inputs">Выберете такой же товар, который схож по характеристикам (если он имеется), чтобы связать цвета товара:</span>

                            <label @click="showProducts=!showProducts && New_Product.name!= ''" class="text-light my-2 py-2 px-3 bg-dark">Отобразить схожие товары</label>
                            <div v-if="showProducts">
                                <b-table @row-selected="onRowSelectedSameProducts($event)" :filter="New_Product.name" select-mode="single" show-empty empty-text="Таблица пуста" thead-class=" wrap__clients__container__table__head" table-variant="light" selectable striped :fields="dataLinksFields" :items="dataProductsItems" responsive>
                                    <template #empty="scope">
                                        <div  class="d-flex justify-content-center w-100">
                                            <h6>{{ scope.emptyText }}</h6>
                                        </div>
                                    </template>
                                    <template #cell(color)="row">
                                        <div :style="'width:30px; height:30px; border-radius: 30px; border: 1px solid #ccc; background-color:' +  row.item.color"></div>
                                    </template>
                                    <template #cell(selected)="{ rowSelected }">
                                        <template v-if="rowSelected">
                                            <span aria-hidden="true">&check;</span>
                                            <span class="sr-only">Selected</span>
                                        </template>
                                        <template v-else>
                                            <span aria-hidden="true">&nbsp;</span>
                                            <span class="sr-only">Not selected</span>
                                        </template>
                                    </template>
                                </b-table>
                            </div>
                        </b-row>
                    </div>
                    
                    <!-- SIZES -->
                    <div class="pt-2">
                        <div class="pb-2">
                            <span class="title_inputs">Выберете размер товара и его количество:</span>
                        </div>
                            Введите количество товара для размера S
                            <b-row class="d-flex align-items-center py-2">
                                <b-col>
                                    <input
                                        v-if="New_Product" 
                                        type="number"
                                        class="form-control"
                                        id="description_product"
                                        placeholder="Количество товара для размера S"
                                        name="description_product"
                                        @change="sizeEvents($event.target.value, 1)"
                                    />
                                </b-col>
                            </b-row>
                            Введите количество товара для размера M
                            <b-row class="d-flex align-items-center py-2">
                                <b-col>
                                    <input
                                        v-if="New_Product" 
                                        type="number"
                                        class="form-control"
                                        id="description_product"
                                        placeholder="Количество товара для размера M"
                                        name="description_product"
                                        @change="sizeEvents($event.target.value, 2)"
                                    />
                                </b-col>
                            </b-row>
                            Введите количество товара для размера L
                            <b-row class="d-flex align-items-center py-2">
                                <b-col>
                                    <input
                                        v-if="New_Product" 
                                        type="number"
                                        class="form-control"
                                        id="description_product"
                                        placeholder="Количество товара для размера L"
                                        name="description_product"
                                        @change="sizeEvents($event.target.value, 3)"
                                    />
                                </b-col>
                            </b-row>
                            Введите количество товара для размера XL
                            <b-row class="d-flex align-items-center py-2">
                                <b-col>
                                    <input
                                        v-if="New_Product" 
                                        type="number"
                                        class="form-control"
                                        id="description_product"
                                        placeholder="Количество товара для размера XL"
                                        name="description_product"
                                        @change="sizeEvents($event.target.value, 4)"
                                    />
                                </b-col>
                            </b-row>
                            Введите количество товара для размера XXL
                            <b-row class="d-flex align-items-center py-2">
                                <b-col>
                                    <input
                                        v-if="New_Product" 
                                        type="number"
                                        class="form-control"
                                        id="description_product"
                                        placeholder="Количество товара для размера XXL"
                                        name="description_product"
                                        @change="sizeEvents($event.target.value, 5)"
                                    />
                                </b-col>
                            </b-row>
                            Введите количество товара
                            <b-row class="d-flex align-items-center py-2">
                                <b-col>
                                    <input
                                        v-if="New_Product" 
                                        type="number"
                                        class="form-control"
                                        id="description_product"
                                        placeholder="Введите количество товара"
                                        name="description_product"
                                        @change="sizeEvents($event.target.value, 6)"
                                    />
                                </b-col>
                            </b-row>
                    </div>

                    <!-- COLORS -->
                    <div class="pt-2">
                        <b-row class="px-3 py-2">
                            <span class="title_inputs">Выберете цвет товара</span>
                            <b-form-radio-group id="radio-group-2" v-if="New_Product" v-model="New_Product.selectedColor" name="radio-sub-component">
                                <b-form-radio value="#0000FF"><div style="width:30px; height:30px; border-radius: 30px; border: 1px solid #ccc; background-color: #0000FF"></div></b-form-radio>
                                <b-form-radio value="#008000"><div style="width:30px; height:30px; border-radius: 30px; border: 1px solid #ccc; background-color: #008000"></div></b-form-radio>
                                <b-form-radio value="#000000"><div style="width:30px; height:30px; border-radius: 30px; border: 1px solid #ccc; background-color: #000000"></div></b-form-radio>
                                <b-form-radio value="#FFFFFF"><div style="width:30px; height:30px; border-radius: 30px; border: 1px solid #ccc; background-color: #FFFFFF"></div></b-form-radio>
                                <b-form-radio value="#C0C0C0"><div style="width:30px; height:30px; border-radius: 30px; border: 1px solid #ccc; background-color: #C0C0C0"></div></b-form-radio>
                                <b-form-radio value="#FFFF00"><div style="width:30px; height:30px; border-radius: 30px; border: 1px solid #ccc; background-color: #FFFF00"></div></b-form-radio>
                                <b-form-radio value="#800080"><div style="width:30px; height:30px; border-radius: 30px; border: 1px solid #ccc; background-color: #800080"></div></b-form-radio>
                                <b-form-radio value="#FFA500"><div style="width:30px; height:30px; border-radius: 30px; border: 1px solid #ccc; background-color: #FFA500"></div></b-form-radio>
                                <b-form-radio value="#FFC0CB"><div style="width:30px; height:30px; border-radius: 30px; border: 1px solid #ccc; background-color: #FFC0CB"></div></b-form-radio>
                                <b-form-radio value="None">нет цвета</b-form-radio>
                            </b-form-radio-group>
                        </b-row>
                    </div>

                    <!-- PRICE -->
                    <div class="pt-2">
                        <span class="title_inputs">Введите стоимость товара</span>
                        <b-row class="px-3 py-2">
                            <input
                                v-if="New_Product" 
                                type="number"
                                class="form-control"
                                v-model="New_Product.price"
                                id="description_product"
                                placeholder="Цена"
                                name="description_product"
                                required
                            />
                        </b-row>
                    </div>

                    <!-- discount -->
                    <div class="pt-2">
                        <span class="title_inputs">Введите скидку для товара (без процента, просто цифру)</span>
                        <b-row class="px-3 py-2">
                            <input
                                v-if="New_Product" 
                                type="number"
                                class="form-control"
                                v-model="New_Product.discount"
                                id="description_product"
                                placeholder="Скидка"
                                name="description_product"
                                required
                            />
                        </b-row>
                    </div>

                    <!-- SPECIAL OFFER -->
                    <div class="pt-2">
                        <span class="title_inputs">Отметьте, если товар из спиацильных предложений</span>
                        <b-row class="px-3 py-2">
                            <!-- chekbox где отправляется true или false -->
                            <b-form-checkbox v-if="New_Product" v-model="New_Product.specialOffer">Специальное предложение</b-form-checkbox>
                        </b-row>
                    </div>

                    <!-- Hit Sales -->
                    <div class="pt-2">
                        <span class="title_inputs">Отметьте, если товар с горчей скидкой</span>
                        <b-row class="px-3 py-2">
                            <!-- chekbox где отправляется true или false -->
                            <b-form-checkbox v-if="New_Product" v-model="New_Product.hitSales">Горячая скидка</b-form-checkbox>
                        </b-row>
                    </div>

                    <!-- CATEGORIES МЫ ДОЛЖНЫ ТУТ ВЫБРАТЬ КАТЕГОРИЮ (КАТЕГОРИИ БЕРУТСЯ ОТ АПИ)  -->
                    <div class="pt-2">
                        <span class="title_inputs">Выберете категорию где будет лежать товар</span>
                        <b-row class="px-3 py-2">
                            <b-form-select v-if="New_Product" v-model="New_Product.categOptionsSelected" :options="categOptions">
                                <template #first>
                                    <b-form-select-option :value="null" disabled>-- Выберите категорию --</b-form-select-option>
                                </template>
                            </b-form-select>
                        </b-row>
                    </div>

                    <div class="pt-2">
                        <span class="title_inputs">Загрузите изображения для товара</span>
                        <b-row class="px-3 py-2">
                            <label for="load" class="text-light py-2 px-3 bg-dark">+ Добавить фото</label>
                            <input id="load" ref="file" @change="handleFileUpload()" type="file" name="photo" style="display: none;">
                        </b-row>
                        <b-row class="px-3 py-2">
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
                    </div>
                </b-form>
                <template v-slot:modal-footer>
                    <b-button @click="sendNewProduct">sendNewProduct</b-button>
                </template>
            </b-modal>
            <b-table show-empty empty-text="Таблица пуста" thead-class=" wrap__clients__container__table__head" table-variant="light" selectable striped :fields="dataProductsFields" :items="dataProductsItems" responsive>
                <template #empty="scope">
                    <div  class="d-flex justify-content-center w-100">
                        <h6>{{ scope.emptyText }}</h6>
                    </div>
                </template>
                <template #cell(color)="row">
                    <div :style="'width:30px; height:30px; border-radius: 30px; border: 1px solid #ccc; background-color:' +  row.item.color"></div>
                </template>
            </b-table>
        </div>
    </b-card>
</template>

<script>
import Api from "~/utils/api";
export default {
  data () {
    return {
      AddProductModal: false,
      show_overlay: false,

      files: [],
      file: null,


      categOptionsSelected: [], // Must be an array reference!
      categOptions: [],  
      New_Product: {
        name: '',
        description: null,
        size_kol: null,
        selectedSame: [],
        selectedSize: null,
        selectedColor: 'Нет цвета',
        price: null,
        discount: null,
        specialOffer: false,
        hitSales: false,
        categOptionsSelected: [],
        size_kol: [
            {
                size: 'S',
                kol: 0
            },
            {
                size: 'M',
                kol: 0
            },
            {
                size: 'L',
                kol: 0
            },
            {
                size: 'XL',
                kol: 0
            },
            {
                size: 'XXL',
                kol: 0
            },
            {
                size: 'Нет размера',
                kol: 0
            }
        ]
      },

      showProducts: false,
      dataLinksItems: null,  
      dataLinksFields: [
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
        {
            key: 'price',
            label: 'Цена',
        },
        {
            key: 'discount',
            label: 'Скидка',
        },
        {
            key: 'color',
            label: 'Цвет',
        },
        {
            key: 'selected',
            label: 'Выбранный',
        },
      ],

      selected: null,

      dataProductsItems: null,
      dataProductsFields: [
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
    
mounted(){
    this.getDataProducts();
    this.getCategories();
},
methods:{
    // COMPONENT START
    getDataProducts(){
      Api.getInstance().products.getDataProducts().then((response) => {
          this.dataProductsItems = response.data;
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

    onRowSelectedSameProducts(picked){
        this.New_Product.selectedSame = picked.id;
    },
    sizeEvents(value, inpt){
        if(value === ''){ value = 0 }
        let StoreProduct = this.New_Product.size_kol;
        switch (inpt) {
            case 1:
                for(let s in StoreProduct){ if(StoreProduct[s].size === 'S'){ this.New_Product.size_kol[s].kol = value } };
                break;
            case 2:
                for(let s in StoreProduct){ if(StoreProduct[s].size === 'M'){ this.New_Product.size_kol[s].kol = value } };
                break;
            case 3:
                for(let s in StoreProduct){ if(StoreProduct[s].size === 'L'){ this.New_Product.size_kol[s].kol = value } };
                break;
            case 4:
                for(let s in StoreProduct){ if(StoreProduct[s].size === 'XL'){ this.New_Product.size_kol[s].kol = value } };
                break;
            case 5:
                for(let s in StoreProduct){ if(StoreProduct[s].size === 'XXL'){ this.New_Product.size_kol[s].kol = value } };
                break;
            case 6:
                for(let s in StoreProduct){ if(StoreProduct[s].size === 'Нет размера'){ this.New_Product.size_kol[s].kol = value } };
                break
        }
    },
    sendNewProduct(){
        let StoreProduct = this.New_Product.size_kol.filter(el=> el.kol !== 0);
        if(StoreProduct.length > 0){
            console.log(StoreProduct)  
        }
        // for(let s in this.New_Product.size_kol ){
        //     if(StoreProduct[s].kol == 0){
        //         StoreProduct.splice(s, 1)
        //     }
        // }
        // this.New_Product.size_kol = StoreProduct

        // Api.getInstance().products.sendNewProduct(formatData).then((response) => {
        //     this.files.push({file_url: response.data.file_url, file_name: response.data.file_name}); 
        // })
        // .catch((error) => {
        //     console.log("send_image -> ", error)
        //     this.$bvToast.toast("Изображение не загружено.", {
        //         title: `Ошибка аутентификации`,
        //         variant: "danger",
        //         solid: true,
        //     });
        //     // setTimeout(()=>{this.$router.push('/')}, 1500)
        // });
    },

    handleFileUpload(){
        this.file = this.$refs.file.files[0];
        this.send_image()
    },
    send_image(){
      let formatData = new FormData();
      formatData.append('file', this.file);
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

    getCategories(){
      Api.getInstance().products.getCategories().then((response) => {
          this.categOptions = response.data;
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
    // COMPONENT END
},
}
</script>

<style>
.modal-content{
    background-image: unset !important;
}
.title_inputs{
    color: #845600
}
</style>