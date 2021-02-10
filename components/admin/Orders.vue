<template>
    <div>
        
        <b-card  header="Категории" >
            <b-overlay :show="!dataOrdersItems" rounded="sm">
                <div class="p-3">
                    <div class="d-flex  justify-content-end">
                        <input
                            v-model="filter__employee"
                            type="text"
                            id="filterOrders"
                            placeholder="Поиск.."
                        >
                    </div> 
                    <b-modal @hidden="resetModal()" scrollable hide-footer size="lg" v-model="changeStateModal">
                        <b-form @submit.prevent="eventOrders()">
                            <label class="mt-4" for="last_cat">Введите последнюю категории</label>
                            <div>
                                <input
                                v-if="dataOrdersItems" 
                                type="text"
                                class="form-control"
                                v-model="orderStatus"
                                id="last_cat"
                                placeholder="Введите категорию"
                                name="last_cat"
                                />
                            </div>

                            <!-- <b-form-select v-if="dataOrdersItems" v-model="orderStates" :options="orderOptions">
                                <template #first>
                                    <b-form-select-option :value="null" disabled>-- Выберите категорию --</b-form-select-option>
                                </template>
                            </b-form-select> -->

                            <!-- <b-button type="submit" class="mt-2">Создать</b-button> -->
                            <div style="border-top: 1px solid #ccc" class="w-100 py-4">
                                <!-- <b-button v-if="eventBtnCategory" type='submit' class="float-left">СОЗДАТЬ НОВУЮ КАТЕГОРИЮ</b-button> -->
                                <b-row class="float-left d-flex justify-content-between" >
                                    <b-button class="ml-3" type="submit">ИЗМЕНИТЬ СТАТУС</b-button>&nbsp;&nbsp;&nbsp;&nbsp;
                                </b-row>
                                <b-button class="float-right" @click="resetModal(), changeStateModal=!changeStateModal"> Отменить </b-button>
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
                        stacked 
                        responsive
                        class="pt-3"
                        :items="dataOrdersItems"
                        :fields="dataOrdersFields"
                    >
                        <template #empty="scope">
                            <div  class="d-flex justify-content-center w-100">
                                <h6>{{ scope.emptyText }}</h6>
                            </div>
                        </template>
                        <template #cell(items)="row">
                            <div v-for="(item, i) in row.item.items" :key="i" class="mt-2">
                                {{item.name}}: &nbsp;&nbsp; <span style="font-weight: bold;">{{item.size}}</span> &nbsp;&nbsp;  - &nbsp;&nbsp;  <span style="font-weight: bold;">{{item.kol}} </span>
                            </div>
                        </template>
                    </b-table>
                </div>
            </b-overlay>
        </b-card>
    </div>

</template>

<script>
import Api from "~/utils/api";
export default {
data () {
    return {
        // orderOptions: { 
        //     value: null,
        //     text: 'Please select an option' 
        // },  
        eventBtnCategory: true,
        show_overlay: false,
        filter__employee: null,
        changeStateModal: false,
        orderStatus: null,
        dataOrdersItems: null,
        dataOrdersFields: [
            {
                key: 'id',
                label: 'id-заказа',
            },
            {
                key: 'date',
                label: 'Дата',
            },
            {
                key: 'items',
                label: 'товары',
            },
            {
                key: 'user_info',
                label: 'Информация о клиенте',
            },
            {
                key: 'shipping_adress',
                label: 'Адрес доставки',
            },
            {
                key: 'shipping_type',
                label: 'Способ оплаты',
            },
            {
                key: 'subtotal',
                label: 'Итоговая сумма',
            },
            {
                key: 'state',
                label: 'Статус',
            }
            
        ],
    }
},
mounted(){
    this.getOrders();
},
methods: {
        // ИЗМЕНЕНИЕ ТОВАРА И ДОБАВЛЕНИЕ НОВОГО
    eventOrders(){
            // Api.getInstance().categories.changeCategory(this.category).then((response) => {
            //     this.$bvToast.toast('Категория успешно изменена.', {
            //         title: `Сообщение`,
            //         variant: "success",
            //         solid: true
            //     });
            //     setTimeout(()=>{
            //         this.resetModal()
            //         this.changeStateModal=false;
            //         window.location.reload(true);
            //     }, 1000)
            // })
            // .catch((error) => {
            //     console.log("changeProduct -> ", error)
            //     this.$bvToast.toast("Товар не был изменён.", {
            //         title: `Системная ошибка`,
            //         variant: "danger",
            //         solid: true,
            //     });
            // });
    },

    onRowProductSelected(picked){
        this.eventBtnCategory = false;
        this.changeStateModal = true;
        this.orderStatus = picked[0].state;
    },
    resetModal(){
        this.orderStatus = null
    },
    
    getOrders(){
      Api.getInstance().orders.getDataOrders().then((response) => {
        this.dataOrdersItems = response.data;
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