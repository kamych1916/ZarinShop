<template>
  <div>
    <nuxt id="body-content"/>
    <layoutSetting/>
    <div class="tap-top top-cls" v-scroll-to="'#body-content'">
      <div>
          <i class="fa fa-angle-double-up"></i>
      </div>
    </div>
  </div>
</template>

<script>
import { localize } from 'vee-validate/dist/vee-validate.full.esm'
import layoutSetting from '../components/widgets/layout-setting'
import Api from "~/utils/api";
localize({
  en: {
    messages: {
      required: 'Данное поле должно быть заполнено',
      email: 'E-Mail некорректный'
    }
  }
});
export default {
  head() {
    return {
      title: 'Интернет-магазин домашнего текстиля - Zarin Shop | Ташкент'
    }
  },
  components: {
    layoutSetting
  },
  mounted() {
    this.$nextTick(() => {
      this.$nuxt.$loading.start()
      setTimeout(() => this.$nuxt.$loading.finish(), 3000)
    });
    // this.GetLanguage()
  },
  methods: {
    // GetLanguage(){
    //   // console.log(localStorage.getItem('lang_select'))
    //   if(localStorage.getItem('lang_select') != 'ru' & localStorage.getItem('lang_select') != 'uz'){
    //     Api.getInstance().lang.GetLanguage('ru').then((response) => {
    //       localStorage.setItem('lang_select', 'ru');
    //       this.$store.dispatch('lang/load_language', response.data)
    //     }).catch((error) => {
    //       console.log("GetLanguage -> ", error)
    //     });
    //   }        
    // }
  },
}
</script>
