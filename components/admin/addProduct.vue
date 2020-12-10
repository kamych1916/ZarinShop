<template>
    <b-card header="Товары" >
        <div class="wrap__products">       
            <b-button @click="AddProductModal=true; eventBtnProduct= true">Добавить новый товар</b-button>
            <b-modal @hidden="resetModal" scrollable hide-footer size="lg" v-model="AddProductModal">
                <b-form @submit.prevent="eventProduct()">
                    <div class="pt-2">
                        <span class="title_inputs">Введите наименование товара</span>
                        <b-row class="px-3 py-2">
                            <input
                            v-if="New_Product" 
                            type="text"
                            class="form-control"
                            v-model="New_Product.name"
                            id="name_product"
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
                                <b-table @row-selected="onRowlink_colorProducts($event)" :filter="New_Product.name" select-mode="single" show-empty empty-text="Таблица пуста" thead-class=" wrap__clients__container__table__head" table-variant="light" selectable striped :fields="dataLinksFields" :items="dataProductsItems" responsive>
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
                                        id="size_S"
                                        name="size_S"
                                        v-model="size_S"
                                        @change="sizeEvents(size_S, 1)"
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
                                        id="size_M"
                                        name="size_M"
                                        v-model="size_M"
                                        @change="sizeEvents(size_M, 2)"
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
                                        id="size_L"
                                        name="size_L"
                                        v-model="size_L"
                                        @change="sizeEvents(size_L, 3)"
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
                                        id="size_XL"
                                        name="size_XL"
                                        v-model="size_XL"
                                        @change="sizeEvents(size_XL, 4)"
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
                                        id="size_XXL"
                                        name="size_XXL"
                                        v-model="size_XXL"
                                        @change="sizeEvents(size_XXL, 5)"
                                    />
                                </b-col>
                            </b-row>
                            Введите количество товара, если у товара нет размера
                            <b-row class="d-flex align-items-center py-2">
                                <b-col>
                                    <input
                                        v-if="New_Product" 
                                        type="number"
                                        class="form-control"
                                        id="none_size"
                                        name="none_size"
                                        v-model="none_size"
                                        @change="sizeEvents(none_size, 6)"
                                    />
                                </b-col>
                            </b-row>
                    </div>

                    <!-- COLORS -->
                    <div class="pt-2">
                        <b-row class="px-3 py-2">
                            <span class="title_inputs">Выберете цвет товара</span>
                            <b-form-radio-group id="radio-group-2" v-if="New_Product" v-model="New_Product.color" name="radio-sub-component">
                                <b-form-radio value="#0000FF"><div style="width:30px; height:30px; border-radius: 30px; border: 1px solid #ccc; background-color: #0000FF"></div></b-form-radio>
                                <b-form-radio value="#008000"><div style="width:30px; height:30px; border-radius: 30px; border: 1px solid #ccc; background-color: #008000"></div></b-form-radio>
                                <b-form-radio value="#000000"><div style="width:30px; height:30px; border-radius: 30px; border: 1px solid #ccc; background-color: #000000"></div></b-form-radio>
                                <b-form-radio value="#FFFFFF"><div style="width:30px; height:30px; border-radius: 30px; border: 1px solid #ccc; background-color: #FFFFFF"></div></b-form-radio>
                                <b-form-radio value="#C0C0C0"><div style="width:30px; height:30px; border-radius: 30px; border: 1px solid #ccc; background-color: #C0C0C0"></div></b-form-radio>
                                <b-form-radio value="#FFFF00"><div style="width:30px; height:30px; border-radius: 30px; border: 1px solid #ccc; background-color: #FFFF00"></div></b-form-radio>
                                <b-form-radio value="#800080"><div style="width:30px; height:30px; border-radius: 30px; border: 1px solid #ccc; background-color: #800080"></div></b-form-radio>
                                <b-form-radio value="#FFA500"><div style="width:30px; height:30px; border-radius: 30px; border: 1px solid #ccc; background-color: #FFA500"></div></b-form-radio>
                                <b-form-radio value="#FFC0CB"><div style="width:30px; height:30px; border-radius: 30px; border: 1px solid #ccc; background-color: #FFC0CB"></div></b-form-radio>
                                <b-form-radio value="Нет Цвета">нет цвета</b-form-radio>
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
                                id="price_product"
                                name="price_product"
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
                                id="discount_product"
                                name="discount_product"
                                required
                            />
                        </b-row>
                    </div>

                    <!-- SPECIAL OFFER -->
                    <div class="pt-2">
                        <span class="title_inputs">Отметьте, если товар из спиацильных предложений</span>
                        <b-row class="px-3 py-2">
                            <!-- chekbox где отправляется true или false -->
                            <b-form-checkbox v-if="New_Product" v-model="New_Product.special_offer">Специальное предложение</b-form-checkbox>
                        </b-row>
                    </div>

                    <!-- Hit Sales -->
                    <div class="pt-2">
                        <span class="title_inputs">Отметьте, если товар с горчей скидкой</span>
                        <b-row class="px-3 py-2">
                            <!-- chekbox где отправляется true или false -->
                            <b-form-checkbox v-if="New_Product" v-model="New_Product.hit_sales">Горячая скидка</b-form-checkbox>
                        </b-row>
                    </div>

                    <!-- CATEGORIES МЫ ДОЛЖНЫ ТУТ ВЫБРАТЬ КАТЕГОРИЮ (КАТЕГОРИИ БЕРУТСЯ ОТ АПИ)  -->
                    <div class="pt-2">
                        <span class="title_inputs">Выберете категорию где будет лежать товар</span>
                        <b-row class="px-3 py-2">
                            <b-form-select v-if="New_Product" v-model="New_Product.categories" :options="categOptions">
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
                    <div style="border-top: 1px solid #ccc" class="w-100 py-4">
                        <b-button v-if="eventBtnProduct" type='submit' class="float-left">СОЗДАТЬ НОВЫЙ ТОВАР</b-button>
                        <b-row v-else class="float-left d-flex justify-content-between" >
                            <b-button type="submit">ИЗМЕНИТЬ ТОВАР</b-button>&nbsp;&nbsp;&nbsp;&nbsp;
                            <b-button @click="deleteProduct()" variant="danger">УДАЛИТЬ ТОВАР</b-button>                            
                        </b-row>
                        <b-button class="float-right" @click="closeModal()"> Отменить </b-button>
                    </div>
                </b-form>
            </b-modal>
            <!-- <b-table @row-selected="onRowlink_colorProducts($event)" :filter="New_Product.name" select-mode="single" show-empty empty-text="Таблица пуста" thead-class=" wrap__clients__container__table__head" table-variant="light" selectable striped :fields="dataLinksFields" :items="dataProductsItems" responsive> -->
            <b-table ref="allProducts" @row-selected="onRowProductSelected($event)" show-empty empty-text="Таблица пуста" thead-class=" wrap__clients__container__table__head" table-variant="light" selectable select-mode="single" striped :fields="dataProductsFields" :items="dataProductsItems" responsive>
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

let Store_New_Product = {
    name: '',
    description: null,
    link_color: [],
    color: 'Нет цвета',
    price: null,
    discount: null,
    special_offer: false,
    hit_sales: false,
    categories: [],
    size_kol: [],
    images: [],
    name_images: []
}
export default {
  data () {
    return {
        AddProductModal: false,
        eventBtnProduct: true,
        show_overlay: false,

        files: [],
        file: null,

        size_S: null,
        size_M: null,
        size_L: null,
        size_XL: null,
        size_XXL: null,
        none_size: null,


        categOptions: [],  
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
        ],
        New_Product: {
            name: '',
            description: null,
            link_color: [],
            color: 'Нет цвета',
            price: null,
            discount: null,
            special_offer: false,
            hit_sales: false,
            categories: [],
            size_kol: [],
            images: [],
            name_images: []
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

            {
                key: 'size_kol',
                label: 'Количество по размерам',
            },


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

    onRowProductSelected(picked){
        if(picked[0]){
            this.eventBtnProduct = false;
            this.New_Product = picked[0];
            
            this.AddProductModal=true;
    
            this.New_Product.categories = picked[0].categories_value;
    
            // this.New_Product.link_color = picked[0].link_color[0].id;
            
            for(let img in picked[0].images){
                this.files.push({file_url: picked[0].images[img], file_name: picked[0].name_images[img]})
            }
            for(let product of this.New_Product.size_kol){
                switch(product.size){
                    case 'S': this.size_S = product.kol; break;
                    case 'M': this.size_M = product.kol; break;
                    case 'L': this.size_L = product.kol; break;
                    case 'XL': this.size_XL = product.kol; break;
                    case 'XXL': this.size_XXL = product.kol; break;
                    case 'Нет размера': this.none_size = product.kol; break;
                }
            }
            this.New_Product.id = parseInt(this.New_Product.id);
        }
    },
    
    resetModal(){
        this.New_Product = Store_New_Product;
        this.files = [];
        this.$refs.allProducts.clearSelected();
        this.size_S = '';
        this.size_M = '';
        this.size_L = '';
        this.size_XL = '';
        this.size_XXL = '';
        this.none_size = '';
    },
    onRowlink_colorProducts(picked){
        if(picked[0]){
            this.New_Product.link_color.push(parseInt(picked[0].id));
        }
    },

    sizeEvents(value, inpt){
        if(value === ''){ value = 0 }
        let StoreProduct = this.size_kol;
        if(inpt === 1){
            for(let s in StoreProduct){ if(StoreProduct[s].size === 'S'){ this.size_kol[s].kol = parseInt(value) } };     
        }else if(inpt === 2){
            for(let s in StoreProduct){ if(StoreProduct[s].size === 'M'){ this.size_kol[s].kol = parseInt(value) } };
        }else if(inpt === 3){
            for(let s in StoreProduct){ if(StoreProduct[s].size === 'L'){ this.size_kol[s].kol = parseInt(value) } };
        }else if(inpt === 4){
            for(let s in StoreProduct){ if(StoreProduct[s].size === 'XL'){ this.size_kol[s].kol = parseInt(value) } };
        }else if(inpt === 5){
            for(let s in StoreProduct){ if(StoreProduct[s].size === 'XXL'){ this.size_kol[s].kol = parseInt(value) } };
        }else if(inpt === 6){
            for(let s in StoreProduct){ if(StoreProduct[s].size === 'Нет размера'){ this.size_kol[s].kol = parseInt(value) } };
        }
    },
    
    // ИЗМЕНЕНИЕ ТОВАРА И ДОБАВЛЕНИЕ НОВОГО
    eventProduct(){
        // РАЗОБРАТЬСЯ С КОЛИЧЕСТВОМ РАЗМЕРОВ И ВЫХОДОМ ИЗ МОДАЛЬНОГО ОКНА
        let StoreSizeProduct = this.size_kol.filter(el=> el.kol !== 0);
        if(StoreSizeProduct.length > 0){
            let StoreNoneSizeProduct = StoreSizeProduct.filter(el=> el.size == 'Нет размера')
            if(StoreNoneSizeProduct[0]){
                if(StoreNoneSizeProduct[0].kol !== 0){
                    this.New_Product.size_kol = StoreNoneSizeProduct    
                }else{
                    alert('Введите пожалуйста количество товара')
                }
            }else this.New_Product.size_kol = StoreSizeProduct;

            if(this.eventBtnProduct){

                this.New_Product.discount = parseInt(this.New_Product.discount);
                this.New_Product.price = parseInt(this.New_Product.price);
                Api.getInstance().products.sendNewProduct(this.New_Product).then((response) => {
                    this.$bvToast.toast('Товар успешно добавлен в базу данных.', {
                        title: `Сообщение`,
                        variant: "success",
                        solid: true
                    })
                    setTimeout(()=>{
                        this.New_Product = Store_New_Product;
                        this.AddProductModal=false;
                        window.location.reload(true)
                    }, 1000)
                })
                .catch((error) => {
                    console.log("sendNewProduct -> ", error)
                    this.$bvToast.toast("Товар не добавлен в базу данных.", {
                        title: `Системная ошибка`,
                        variant: "danger",
                        solid: true,
                    });
                });
            
            }else{
                Api.getInstance().products.changeProduct(this.New_Product).then((response) => {
                    this.$bvToast.toast('Товар успешно изменён.', {
                        title: `Сообщение`,
                        variant: "success",
                        solid: true
                    });
                    setTimeout(()=>{
                        this.New_Product = Store_New_Product;
                        this.AddProductModal=false;
                        // window.location.reload(true);
                    }, 1000)
                })
                .catch((error) => {
                    console.log("changeProduct -> ", error)
                    this.$bvToast.toast("Товар не был изменён.", {
                        title: `Системная ошибка`,
                        variant: "danger",
                        solid: true,
                    });
                });
            }
        }
    },
    deleteProduct(){
        Api.getInstance().products.deleteProduct(this.New_Product.id).then((response) => {
            this.$bvToast.toast("Товар был успешно удален из базы данных!", {
                title: `Сообщение:`,
                variant: "success",
                solid: true,
            })    
            this.AddProductModal=false; 
            this.resetModal();
            this.dataProductsItems.splice(this.New_Product.id, 1);
        }).catch((error) => {
            console.log('deleteProduct-> ', error)
            this.$bvToast.toast("Удаление прошло безуспешно.", {
                title: 'Системная ошибка',
                variant: "danger",
                solid: true,
            });
            // setTimeout(()=>{this.$router.push('/')}, 1500)
        });
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
        this.New_Product.images.push(response.data.file_url);
        this.New_Product.name_images.push(response.data.file_name);
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