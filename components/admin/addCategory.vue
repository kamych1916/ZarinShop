<template>
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

        <b-button type="submit" class="mt-2">Создать</b-button>
        </b-card>


    </b-form>
</template>

<script>
import Api from "~/utils/api";
export default {
data () {
    return {
        category: {
            main: null,
            subtype: null, 
            lasttype: null,
            image_url: null,
        },
    }
},
methods: {
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
},

}
</script>

<style>

</style>