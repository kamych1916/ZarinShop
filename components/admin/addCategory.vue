<template>
    <div>
        <b-button class="mb-5" @click="getCategories()" v-if="!show_cat">Отобразить категории товаров</b-button>
        
        <b-card v-if="show_cat" header="Категории" class="mb-5">
            <b-overlay :show="!dataCategoryItems" rounded="sm">
                <div class="d-flex  justify-content-between">
                    <b-button @click="AddCategoryModal=true; eventBtnCategory= true">Добавить новую категорию</b-button>
                    <input
                        v-model="filter__employee"
                        type="text"
                        id="filterCategory"
                        placeholder="Поиск.."
                    >
                </div> 
                <b-modal @hidden="resetModal()" scrollable hide-footer size="lg" v-model="AddCategoryModal">
                    <b-form @submit.prevent="eventCategory()">
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
                        <label class="mt-4" for="main_sub_cat">Введите под категории</label>
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
                        <label class="mt-4" for="last_cat">Введите последнюю категории</label>
                        <div>
                            <input
                            v-if="category" 
                            type="text"
                            class="form-control"
                            v-model="category.lasttype"
                            id="last_cat"
                            placeholder="Введите категорию"
                            name="last_cat"
                            />
                        </div>

                        <!-- <b-button type="submit" class="mt-2">Создать</b-button> -->
                        <div style="border-top: 1px solid #ccc" class="w-100 py-4">
                            <b-button v-if="eventBtnCategory" type='submit' class="float-left">СОЗДАТЬ НОВУЮ КАТЕГОРИЮ</b-button>
                            <b-row v-else class="float-left d-flex justify-content-between" >
                                <b-button class="ml-3" type="submit">ИЗМЕНИТЬ КАТЕГОРИЮ</b-button>&nbsp;&nbsp;&nbsp;&nbsp;
                                <b-button @click="deleteCategory()" variant="danger">УДАЛИТЬ КАТЕГОРИЮ</b-button>                            
                            </b-row>
                            <b-button class="float-right" @click="resetModal(), AddCategoryModal=!AddCategoryModal"> Отменить </b-button>
                        </div>
                    </b-form>
                </b-modal>
                <b-table 
                    :filter="filter__employee" 
                    ref="allProducts"
                    @row-selected="onRowProductSelected($event)"
                    show-empty empty-text="Таблица пуста"
                    thead-class="wrap__clients__container__table__head"
                    table-variant="light" 
                    selectable
                    select-mode="single"
                    striped
                    responsive
                    class="pt-3"
                    :items="dataCategoryItems"
                    :fields="dataCategoryFields"
                >
                    <template #empty="scope">
                        <div  class="d-flex justify-content-center w-100">
                            <h6>{{ scope.emptyText }}</h6>
                        </div>
                    </template>
                </b-table>
            </b-overlay>
        </b-card>
    </div>

</template>

<script>
import Api from "~/utils/api";
export default {
data () {
    return {
        show_cat: false,
        AddCategoryModal: false,
        eventBtnCategory: true,
        show_overlay: false,
        filter__employee: null,

        category: {
            id: null,
            main: null,
            subtype: null, 
            lasttype_uz: '',
        },
        dataCategoryItems: null,
        dataCategoryFields: [
            {
                key: 'id',
                label: 'id',
                sortable: true
            },
            {
                key: 'value',
                label: 'категории',
                sortable: true
            }
        ],
    }
},
mounted(){
},
methods: {
        // ИЗМЕНЕНИЕ ТОВАРА И ДОБАВЛЕНИЕ НОВОГО
    eventCategory(){
        if(this.eventBtnCategory){
            Api.getInstance().categories.send_new_category(this.category).then((response) => {
                this.$bvToast.toast('Категория успешно добавлена в базу данных.', {
                    title: `Сообщение`,
                    variant: "success",
                    solid: true
                })
                setTimeout(()=>{
                    this.resetModal();
                    this.AddCategoryModal=false;
                    window.location.reload(true)
                }, 1000)
            })
            .catch((error) => {
                this.$bvToast.toast("Категорию не удалось создать.", {
                    title: `Ошибка системы`,
                    variant: "danger",
                    solid: true,
                });
            });
        }else{
            Api.getInstance().categories.changeCategory(this.category).then((response) => {
                this.$bvToast.toast('Категория успешно изменена.', {
                    title: `Сообщение`,
                    variant: "success",
                    solid: true
                });
                setTimeout(()=>{
                    this.resetModal()
                    this.AddCategoryModal=false;
                    window.location.reload(true);
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
    },
    deleteCategory(){
        Api.getInstance().categories.deleteCategory(this.category.id).then((response) => {
            this.dataCategoryItems.splice(this.category.id, 1);
            this.$bvToast.toast("Категория был успешно удален из базы данных!", {
                title: `Сообщение:`,
                variant: "success",
                solid: true,
            })    
            this.AddCategoryModal=false; 
            this.resetModal();
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
    onRowProductSelected(picked){
        this.eventBtnCategory = false;
        if(picked[0]){
            console.log(picked[0])
            if(picked[0].value[0]){ this.category.main = picked[0].value[0] }
            if(picked[0].value[1]){ this.category.subtype = picked[0].value[1] }
            if(picked[0].value[2]){ this.category.lasttype = picked[0].value[2] }
        }
        this.AddCategoryModal = true;
        this.category.id = parseInt(picked[0].id)
    },
    resetModal(){
        this.category.main = null;
        this.category.subtype = null;
        this.category.lasttype = null;
    },
    
    getCategories(){
      Api.getInstance().products.getCategories().then((response) => {
          this.show_cat = true;
          this.dataCategoryItems = response.data;
          
      })
      .catch((error) => {
          console.log('getCategories -> ', error);
          this.$bvToast.toast("Категории не подгрузились.", {
              title: `Системная ошибка`,
              variant: "danger",
              solid: true,
          });
      });
    },
    send_new_category(){

    }
},

}
</script>

<style>

</style>