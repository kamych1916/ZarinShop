<template>
        <b-card header="Категоррии" class="mb-5">
            <div class="d-flex  justify-content-between">
                <b-button @click="AddCategoryModal=true; eventBtnCategory= true">Добавить новую категорию</b-button>
                <input
                    v-model="filter__employee"
                    type="text"
                    id="filterCategory"
                    placeholder="Поиск.."
                >
            </div> 
            <b-modal @hidden="resetModal" scrollable hide-footer size="lg" v-model="AddCategoryModal">
                <b-form @submit.prevent="send_new_category">
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

                    <b-button type="submit" class="mt-2">Создать</b-button>
                </b-form>
            </b-modal>
            <b-table 
                :filter="filter__employee" 
                ref="allProducts"
                @row-selected="onRowProductSelected($event)"
                show-empty empty-text="Таблица пуста"
                thead-class="wrap__clients__container__table__head"
                table-variant="light" selectable select-mode="single"
                striped
                responsive
                class="pt-3"
            >
                <template #empty="scope">
                    <div  class="d-flex justify-content-center w-100">
                        <h6>{{ scope.emptyText }}</h6>
                    </div>
                </template>
            </b-table>
        </b-card>


</template>

<script>
import Api from "~/utils/api";
export default {
data () {
    return {
        AddCategoryModal: false,
        eventBtnCategory: true,
        show_overlay: false,
        filter__employee: null,

        category: {
            main: null,
            subtype: null, 
            lasttype: null,
            image_url: null,
        },
        dataProductsItems: null,
        // dataProductsFields: [
        //     {
        //         key: 'id',
        //         label: 'id',
        //         sortable: true
        //     }
        // ],
    }
},
mounted(){
    this.getCategories()
},
methods: {
    getCategories(){
      Api.getInstance().categories.getCategories().then((response) => {
          this.dataProductsItems = response.data;
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
        Api.getInstance().auth.send_new_category(this.category).then((response) => {
            console.log('категория успешно создана')
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
    resetModal(){
        // this.New_Product = Store_New_Product;
        // this.files = [];
        // this.$refs.allProducts.clearSelected();
        // this.size_S = '';
        // this.size_M = '';
        // this.size_L = '';
        // this.size_XL = '';
        // this.size_XXL = '';
        // this.none_size = '';
    },
},

}
</script>

<style>

</style>